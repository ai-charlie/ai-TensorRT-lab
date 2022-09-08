# Build envirnment in container

## 查看适配tensorrt的cuda版本

https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/

```bash
git clone https://github.com/ai-charlie/TensorRT-lab

cd TensorRT-lab/envs/env4-trt8.4.3-shell

docker pull cuda10.2-cudnn8-devel-ubuntu18.04

docker run  --gpus all -p 8889:8889 --shm-size=8gb --ipc=host --ulimit memlock=-1 --ulimit stack=67108864 -v /home/zhanglq/workspace/code/docker:/workspace/code --rm -it cuda10.2-cudnn8-devel-ubuntu18.04 

bash build_in_container.sh

jupyter-lab --port=8889 --no-browser --ip 0.0.0.0 --allow-root 
```