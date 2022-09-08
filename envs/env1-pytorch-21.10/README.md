# Build envs

base docker images `nvcr.io/nvidia/pytorch:21.10-py3` 要求NVIDIA Driver release 470 or later.

base python in `requirements.txt`

```
    Ubuntu 20.04 including Python 3.8 environment
    NVIDIA CUDA 11.4.2 with cuBLAS 11.6.5.2
    NVIDIA cuDNN 8.2.4.15
    NVIDIA NCCL 2.11.4 (optimized for NVLink™)
    rdma-core 36.0
    OpenMPI 4.1.2a1
    OpenUCX 1.11.0rc1
    GDRCopy 2.3
    NVIDIA HPC-X 2.9
    Nsight Systems 2021.3.2.4
    TensorRT 8.0.3.4 for x64 Linux
    TensorRT 8.0.2.2 for ARM SBSA Linux
    SHARP 2.5
    APEX
    Nsight Compute 2021.2.2.0
    Nsight Systems 2021.3.2.4
    TensorBoard 2.6.0
    DALI 1.6
    MAGMA 2.5.2
    DLProf 1.6.0
    Jupyter and JupyterLab:
        Jupyter Client 6.0.0
        Jupyter Core 4.6.1
        Jupyter Notebook 6.0.3
        JupyterLab 2.3.2
        JupyterLab Server 1.0.6
        Jupyter-TensorBoard
```

### Build
```bash
docker pull nvcr.io/nvidia/pytorch:21.10-py3
```
**可选**
从docker文件夹下的Dockerfile构建镜像，基础镜像也是`nvcr.io/nvidia/pytorch:21.10-py3`
*Run command in bash*
```bash
docker build . -t nvcr.io/nvidia/pytorch:21.10-py3-tf2
```
*or use `build.sh` *
```bash
cd /workspace/TensorRT-lab/envs/env1-pytorch-21.10
bash build.sh
```

### launch
use launch.sh
```bash
cd /workspace/TensorRT-lab/
bash launch.sh
```

**docker run**
```bash
docker run  --gpus all -p 8889:8889 --shm-size=8gb --ipc=host --ulimit memlock=-1 --ulimit stack=67108864 -v /home/zhanglq/workspace/code/docker:/workspace/code --rm -it nvcr.io/nvidia/pytorch:21.10-py3 jupyter-lab --port=8889 --no-browser --ip 0.0.0.0 --allow-root 
```
or 
```bash
 docker run  --gpus all -p 8889:8889 --shm-size=8gb --ipc=host --ulimit memlock=-1 --ulimit stack=67108864 -v /home/zhanglq/workspace/code/docker:/workspace/code --rm -it nvcr.io/nvidia/pytorch:21.10-py3-tf2 jupyter-lab --port=8889 --no-browser --ip 0.0.0.0 --allow-root
```


### 运行TensorRT8样例
+ 采用 TensorRT8 + Explicit batch 模式 + Dynamic Shape 模式 + BuilderConfig API + cuda-python 库的 Driver API / Runtime API 双版本
+ 运行方法
```shell
cd ./TensorRT8
make test
```
+ 参考输出结果，见 ./trt-samples-for-hackathon-cn/cookbook/01-SimpleDemo/TensorRT8/result.log
