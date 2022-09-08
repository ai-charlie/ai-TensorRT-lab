# lab1-yolov7x


## SOURCES

```
git clone https://github.com/WongKinYiu/yolov7.git
```

## env build
```
pip install pandas seaborn coremltools onnx-simplifier onnx-runtime onnx_graphsurgeon
```


## Export

**Pytorch to CoreML (and inference on MacOS/iOS)** 

**Pytorch to ONNX with NMS (and inference)** 
```bash
python ./yolov7/export.py --weights yolov7x.pt --grid --end2end --simplify \
        --topk-all 100 --iou-thres 0.65 --conf-thres 0.35 --img-size 640 640 --max-wh 640
```

**Pytorch to TensorRT with NMS (and inference)** 

```bash
wget https://github.com/WongKinYiu/yolov7/releases/download/v0.1/yolov7x.pt
python export.py --weights ./yolov7x.pt --grid --end2end --simplify --topk-all 100 --iou-thres 0.65 --conf-thres 0.35 --img-size 640 640
git clone https://github.com/Linaom1214/tensorrt-python.git
python ./tensorrt-python/export.py -o yolov7x.onnx -e yolov7x-nms.trt -p fp16
```

**Pytorch to TensorRT another way** 

```bash

wget https://github.com/WongKinYiu/yolov7/releases/download/v0.1/yolov7x.pt
python export.py --weights yolov7x.pt --grid --include-nms
git clone https://github.com/Linaom1214/tensorrt-python.git
python ./tensorrt-python/export.py -o yolov7x.onnx -e yolov7x-nms.trt -p fp16
```


### Or use trtexec to convert ONNX to TensorRT engine
```bash
/usr/src/tensorrt/bin/trtexec --onnx=yolov7x.onnx --saveEngine=yolov7x-nms.trt --int8 --verbose=True
```

</details>

Tested with env: TensorRT-lab/envs/env1-pytorch-21.10