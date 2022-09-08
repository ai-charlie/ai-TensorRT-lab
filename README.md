# TensorRT-lab
This repository is [TensorRT](https://github.com/NVIDIA/TensorRT) learning practice collection.

The repository and code work here doesn't finish and work well yet!

## bash
+ some shell of data processing
  + `get_coco.sh` & `unzip.sh` is use to download coco dataset and unzip it. 
  + `get_coco.sh` should specify the data storage path to unzip the datasets
  + if the `.zip` dataset doesn't unzip or something wrong, run `bash unzip.sh` to unzip dataset again.

## data 
+ path of data
  + include coco

## docs
+ include the official git respository: `NVIDIA/TensorRT`, `pytorch/TensorRT`, `NVIDIA/trt-samples-for-hackathon-cn`

## envs
+ envirnments building doc of trt

## lab1-yolov7x
+ A best practice of TensorRT: transform yolov7 model form `pytorch`, workflow: pt -> onnx -> tensorrt engine(.trt,.plan) -> inference

## tools
some useful tools when program TensorRT
