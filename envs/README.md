# Build Environment from Docker

For Linux platforms, we recommend that you generate a docker container for building TensorRT OSS as described below. For native builds, on Windows for example, please install the [prerequisite](#prerequisites) *System Packages*.

* [CUDA](https://developer.nvidia.com/cuda-toolkit)
  * Recommended versions:
  * cuda-11.6.x + cuDNN-8.4
  * cuda-10.2 + cuDNN-8.4
  * 
1. ### nvcr.io/nvidia/pytorch:21.10-py3
   - tensorrt 8.0
   - python 3.8
   - ubuntu20.04
```bash
cd TensorRT-lab/envs/env1-pytorch-21.10
bash build.sh --tag nvcr.io/nvidia/pytorch:21.10-py3-tf2
```

2. ### nvidia/cuda:10.2-cudnn8-devel-ubuntu18.04
   - tensorrt 8.4.3
   - python 3.6
```bash
cd TensorRT-lab/envs/env2-trt8.4.3
bash build.sh --tag nvidia/cuda:cuda10.2-cudnn8-devel-ubuntu18.04-trt8.2.5
```

3. ### nvidia/cuda:11.4.2-cudnn8-devel-ubuntu20.04
   - tensorrt 8.4.3
   - python 3.8
```bash
cd TensorRT-lab/envs/env2-trt8.4.3
bash build.sh--tag nvidia/cuda:cuda11.4.2-cudnn8-devel-ubuntu20.04-trt8.4.3
```

#### Launch the TensorRT-OSS build container.
**Example: Ubuntu 20.04 build container**
```bash
./docker/launch.sh --tag tensorrt-ubuntu20.04-cuda11.6 --gpus all
```
> NOTE:
1. Use the `--tag` corresponding to build container generated in Step 1.
2. [NVIDIA Container Toolkit](#prerequisites) is required for GPU access (running TensorRT applications) inside the build container.
3. `sudo` password for Ubuntu build containers is 'nvidia'.
4. Specify port number using `--jupyter <port>` for launching Jupyter notebooks.

## Building TensorRT-OSS
* Generate Makefiles or VS project (Windows) and build.

    **Example: Linux (x86-64) build with default cuda-11.6.2**
	```bash
	cd $TRT_OSSPATH
	mkdir -p build && cd build
	cmake .. -DTRT_LIB_DIR=$TRT_LIBPATH -DTRT_OUT_DIR=`pwd`/out
	make -j$(nproc)
	```

    > NOTE: On CentOS7, the default g++ version does not support C++14. For native builds (not using the CentOS7 build container), first install devtoolset-8 to obtain the updated g++ toolchain as follows:
    ```bash
    yum -y install centos-release-scl
    yum-config-manager --enable rhel-server-rhscl-7-rpms
    yum -y install devtoolset-8
    export PATH="/opt/rh/devtoolset-8/root/bin:${PATH}
    ```

    **Example: Linux (aarch64) build with default cuda-11.6.2**
	```bash
	cd $TRT_OSSPATH
	mkdir -p build && cd build
	cmake .. -DTRT_LIB_DIR=$TRT_LIBPATH -DTRT_OUT_DIR=`pwd`/out -DCMAKE_TOOLCHAIN_FILE=$TRT_OSSPATH/cmake/toolchains/cmake_aarch64-native.toolchain
	make -j$(nproc)
	```

    **Example: Native build on Jetson (aarch64) with cuda-11.4**
    ```bash
    cd $TRT_OSSPATH
    mkdir -p build && cd build
    cmake .. -DTRT_LIB_DIR=$TRT_LIBPATH -DTRT_OUT_DIR=`pwd`/out -DTRT_PLATFORM_ID=aarch64 -DCUDA_VERSION=11.4
    CC=/usr/bin/gcc make -j$(nproc)
    ```
    > NOTE: C compiler must be explicitly specified via `CC=` for native `aarch64` builds of protobuf.

    **Example: Ubuntu 20.04 Cross-Compile for Jetson (aarch64) with cuda-11.4 (JetPack)**
	```bash
	cd $TRT_OSSPATH
	mkdir -p build && cd build
	cmake .. -DCMAKE_TOOLCHAIN_FILE=$TRT_OSSPATH/cmake/toolchains/cmake_aarch64.toolchain -DCUDA_VERSION=11.4 -DCUDNN_LIB=/pdk_files/cudnn/usr/lib/aarch64-linux-gnu/libcudnn.so -DCUBLAS_LIB=/usr/local/cuda-11.4/targets/aarch64-linux/lib/stubs/libcublas.so -DCUBLASLT_LIB=/usr/local/cuda-11.4/targets/aarch64-linux/lib/stubs/libcublasLt.so

	make -j$(nproc)
	```
    > NOTE: The latest JetPack SDK v5.0 only supports TensorRT 8.4.0.

    **Example: Windows (x86-64) build in Powershell**
	```powershell
	cd $Env:TRT_OSSPATH
	mkdir -p build ; cd build
	cmake .. -DTRT_LIB_DIR=$Env:TRT_LIBPATH -DTRT_OUT_DIR='$(Get-Location)\out' -DCMAKE_TOOLCHAIN_FILE=..\cmake\toolchains\cmake_x64_win.toolchain
	msbuild ALL_BUILD.vcxproj
	```
	> NOTE:
	1. The default CUDA version used by CMake is 11.6.2. To override this, for example to 10.2, append `-DCUDA_VERSION=10.2` to the cmake command.
	2. If samples fail to link on CentOS7, create this symbolic link: `ln -s $TRT_OUT_DIR/libnvinfer_plugin.so $TRT_OUT_DIR/libnvinfer_plugin.so.8`
* Required CMake build arguments are:
	- `TRT_LIB_DIR`: Path to the TensorRT installation directory containing libraries.
	- `TRT_OUT_DIR`: Output directory where generated build artifacts will be copied.
* Optional CMake build arguments:
	- `CMAKE_BUILD_TYPE`: Specify if binaries generated are for release or debug (contain debug symbols). Values consists of [`Release`] | `Debug`
	- `CUDA_VERISON`: The version of CUDA to target, for example [`11.6.2`].
	- `CUDNN_VERSION`: The version of cuDNN to target, for example [`8.4`].
	- `PROTOBUF_VERSION`:  The version of Protobuf to use, for example [`3.0.0`]. Note: Changing this will not configure CMake to use a system version of Protobuf, it will configure CMake to download and try building that version.
	- `CMAKE_TOOLCHAIN_FILE`: The path to a toolchain file for cross compilation.
	- `BUILD_PARSERS`: Specify if the parsers should be built, for example [`ON`] | `OFF`.  If turned OFF, CMake will try to find precompiled versions of the parser libraries to use in compiling samples. First in `${TRT_LIB_DIR}`, then on the system. If the build type is Debug, then it will prefer debug builds of the libraries before release versions if available.
	- `BUILD_PLUGINS`: Specify if the plugins should be built, for example [`ON`] | `OFF`. If turned OFF, CMake will try to find a precompiled version of the plugin library to use in compiling samples. First in `${TRT_LIB_DIR}`, then on the system. If the build type is Debug, then it will prefer debug builds of the libraries before release versions if available.
	- `BUILD_SAMPLES`: Specify if the samples should be built, for example [`ON`] | `OFF`.
	- `GPU_ARCHS`: GPU (SM) architectures to target. By default we generate CUDA code for all major SMs. Specific SM versions can be specified here as a quoted space-separated list to reduce compilation time and binary size. Table of compute capabilities of NVIDIA GPUs can be found [here](https://developer.nvidia.com/cuda-gpus). Examples:
        - NVidia A100: `-DGPU_ARCHS="80"`
        - Tesla T4, GeForce RTX 2080: `-DGPU_ARCHS="75"`
        - Titan V, Tesla V100: `-DGPU_ARCHS="70"`
        - Multiple SMs: `-DGPU_ARCHS="80 75"`
	- `TRT_PLATFORM_ID`: Bare-metal build (unlike containerized cross-compilation) on non Linux/x86 platforms must explicitly specify the target platform. Currently supported options: `x86_64` (default), `aarch64`

# References

## TensorRT Resources

* [TensorRT Developer Home](https://developer.nvidia.com/tensorrt)
* [TensorRT QuickStart Guide](https://docs.nvidia.com/deeplearning/tensorrt/quick-start-guide/index.html)
* [TensorRT Developer Guide](https://docs.nvidia.com/deeplearning/tensorrt/developer-guide/index.html)
* [TensorRT Sample Support Guide](https://docs.nvidia.com/deeplearning/tensorrt/sample-support-guide/index.html)
* [TensorRT ONNX Tools](https://docs.nvidia.com/deeplearning/tensorrt/index.html#tools)
* [TensorRT Discussion Forums](https://devtalk.nvidia.com/default/board/304/tensorrt/)
* [TensorRT Release Notes](https://docs.nvidia.com/deeplearning/tensorrt/release-notes/index.html)

## Known Issues

* Please refer to [TensorRT 8.4 Release Notes](https://docs.nvidia.com/deeplearning/tensorrt/release-notes/tensorrt-8.html#tensorrt-8)


## Prerequisites
To build the TensorRT-OSS components, you will first need the following software packages.

**TensorRT GA build**
* [TensorRT](https://developer.nvidia.com/nvidia-tensorrt-download) v8.4.3.1

**System Packages**
* [CUDA](https://developer.nvidia.com/cuda-toolkit)
  * Recommended versions:
  * cuda-11.6.x + cuDNN-8.4
  * cuda-10.2 + cuDNN-8.4
* [GNU make](https://ftp.gnu.org/gnu/make/) >= v4.1
* [cmake](https://github.com/Kitware/CMake/releases) >= v3.13
* [python](<https://www.python.org/downloads/>) >= v3.6.9
* [pip](https://pypi.org/project/pip/#history) >= v19.0
* Essential utilities
  * [git](https://git-scm.com/downloads), [pkg-config](https://www.freedesktop.org/wiki/Software/pkg-config/), [wget](https://www.gnu.org/software/wget/faq.html#download)

**Optional Packages**
* Containerized build
  * [Docker](https://docs.docker.com/install/) >= 19.03
  * [NVIDIA Container Toolkit](https://github.com/NVIDIA/nvidia-docker)
* Toolchains and SDKs
  * (Cross compilation for Jetson platform) [NVIDIA JetPack](https://developer.nvidia.com/embedded/jetpack) >= 5.0 (current support only for TensorRT 8.4.0)
  * (For Windows builds) [Visual Studio](https://visualstudio.microsoft.com/vs/older-downloads/) 2017 Community or Enterprise edition
  * (Cross compilation for QNX platform) [QNX Toolchain](https://blackberry.qnx.com/en)
* PyPI packages (for demo applications/tests)
  * [onnx](https://pypi.org/project/onnx/) 1.9.0
  * [onnxruntime](https://pypi.org/project/onnxruntime/) 1.8.0
  * [tensorflow-gpu](https://pypi.org/project/tensorflow/) >= 2.5.1
  * [Pillow](https://pypi.org/project/Pillow/) >= 9.0.1
  * [pycuda](https://pypi.org/project/pycuda/) < 2021.1
  * [numpy](https://pypi.org/project/numpy/)
  * [pytest](https://pypi.org/project/pytest/)
* Code formatting tools (for contributors)
  * [Clang-format](https://clang.llvm.org/docs/ClangFormat.html)
  * [Git-clang-format](https://github.com/llvm-mirror/clang/blob/master/tools/clang-format/git-clang-format)

  > NOTE: [onnx-tensorrt](https://github.com/onnx/onnx-tensorrt), [cub](http://nvlabs.github.io/cub/), and [protobuf](https://github.com/protocolbuffers/protobuf.git) packages are downloaded along with TensorRT OSS, and not required to be installed.



## Some useful cmds
use https://pypi.douban.com/simple/ to download file
```bash
pip3 config set global.index-url https://pypi.douban.com/simple/
```

build image from `Dockerfile`
```bash
docker build . -t nvcr.io/nvidia/pytorch:21.10-py3-tf2
```

run a temp container with jupyter 
```bash
docker run  --gpus all -p 8889:8889 --shm-size=8gb --ipc=host --ulimit memlock=-1 --ulimit stack=67108864 -v /home/zhanglq/workspace/code/docker:/workspace/code --rm -it nvcr.io/nvidia/pytorch:21.10-py3 jupyter-lab --port=8889 --no-browser --ip 0.0.0.0 --allow-root 
```

run jupyter-lab
```bash
jupyter-lab --port=80 --no-browser --ip 0.0.0.0 --allow-root 
```