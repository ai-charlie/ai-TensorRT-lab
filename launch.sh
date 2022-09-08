#!/usr/bin/env bash

# arg_tag=nvidia/cuda:11.4.0-cudnn8-devel-ubuntu18.04 
arg_tag=nvcr.io/nvidia/pytorch:21.10-py3
# arg_tag=nvcr.io/nvidia/pytorch:21.10-py3
# arg_tag=nvidia/cuda:10.2-cudnn8-devel-ubuntu18.04   
# arg_tag=tensorrt:trt8.4.1-cu10.2-cudnn8-ubuntu1804-py36-torch-tf2
# arg_tag=tensorrt:trt8.4.1-cu10.2-cudnn8-ubuntu1804-py36
# arg_tag=tensorrt:trt8.4.1-cu11.4.2-cudnn8-ubuntu1804-py36-torch-tf2
arg_gpus=all
arg_jupyter=0
arg_help=0

while [[ "$#" -gt 0 ]]; do case $1 in
  --tag) arg_tag="$2"; shift;;
  --gpus) arg_gpus="$2"; shift;;
  --jupyter) arg_jupyter="$2"; shift;;
  -h|--help) arg_help=1;;
  *) echo "Unknown parameter passed: $1"; echo "For help type: $0 --help"; exit 1;
esac; shift; done

if [ "$arg_help" -eq "1" ]; then
    echo "Usage: $0 [options]"
    echo " --help or -h         : Print this help menu."
    echo " --tag     <imagetag> : Image name for generated container."
    echo " --gpus    <number>   : Number of GPUs visible in container. Set 'none' to disable, and 'all' to make all visible."
    echo " --jupyter <port>     : Launch Jupyter notebook using the specified port number."
    exit;
fi

extra_args=""
if [ "$arg_gpus" != "none" ]; then
    extra_args="$extra_args --gpus $arg_gpus"
fi

if [ "$arg_jupyter" -ne "0" ]; then
    extra_args+=" -p $arg_jupyter:$arg_jupyter"
fi

docker_args="$extra_args --shm-size=8gb --ipc=host --ulimit memlock=-1 --ulimit stack=67108864 -v ${PWD}:/workspace/code/ --rm -it $arg_tag"

if [ "$arg_jupyter" -ne "0" ]; then
    docker_args+=" jupyter-lab --port=$arg_jupyter --no-browser --ip 0.0.0.0 --allow-root"
fi

echo "Launching container:"
echo "> docker run $docker_args"
docker run $docker_args
