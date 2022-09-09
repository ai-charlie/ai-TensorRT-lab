# Tools
trtexec，onnx-graphsurgeon 和 plugin 都是使用 parser 的必备知识


## trtexec
TensorRT 命令行工具，主要的 End2End 性能测试工具，和tensorrt一起安装，默认路径为tensorrt-XX/bin/trtexec

**功能**
-  由 .onnx 模型文件生成 TensorRT 引擎并序列化为 .plan
-  查看 .onnx 或 .plan 文件的网络逐层信息
-  模型性能测试（测试TensorRT 引擎基于随机输入或给定输入下的性能）
  

**范例代码**
-  08-Tool/trtexec，运行 ./command.sh


## netron
[netron website](https://netron.app) 网络可视化

## onnx-graphsurgeon
`onnx`计算图编辑

**需要手工修改网络的情形？**
- 冗余节点
- 阻碍 TensorRT 融合的节点组合
- 可以手工模块化的节点
- 更多范例：10-BestPractice（以后陆续更新）

**功能**
- 修改计算图：图属性 / 节点 / 张量 / 节点和张量的连接 / 权重
- 修改子图：添加 / 删除 / 替换 / 隔离
- 优化计算图：常量折叠 / 拓扑排序 / 去除无用层
- 功能和 API 上有别于 onnx 库


**下载和参考文档**
- pip install nvidia-pyindex onnx-graphsurgeon
- https://github.com/NVIDIA/TensorRT/tree/master/tools/onnx-graphsurgeon/examples
- https://docs.nvidia.com/deeplearning/tensorrt/onnx-graphsurgeon/docs/index.html

08-Tool/OnnxGraphSurgeon，运行 test.sh
-  共有 9 个例子，包含创建模型、隔离子图、替换节点、常量折叠、删除节点、shape 操作

## onnx
-  简介 https://onnx.ai/
-  Open Neural Network Exchange，针对机器学习所设计的开放式的文件格式
-  用于存储训练好的模型，使得不同框架可以采用相同格式存储模型数据并交互
-  TensorFlow / pyTorch 模型转 TensorRT 的中间表示
-  当前 TensoRT 导入模型的主要途径

## onnxruntime
-  简介 https://onnxruntime.ai/
-  利用 onnx 格式模型进行推理计算的框架
-  兼容多硬件、多操作系统，支持多深度学习框架
-  可用于检查 TensorFlow / Torch 模型导出到 Onnx 的正确性

## polygraphy
结果验证与定位，图优化

深度学习模型调试器，包含 python API 和命令行工具（这里只介绍命令行）

**功能：**
-  使用多种后端运行推理计算，包括 TensorRT，onnxruntime，TensorFlow
-  比较不同后端的逐层计算结果
-  由模型文件生成 TensorRT 引擎并序列化为 .plan
-  查看模型网络的逐层信息
-  修改 Onnx 模型，如提取子图，计算图化简
-  分析 Onnx 转 TensorRT 失败原因，将原计算图中可以 / 不可以转 TensorRT 的子图分割保存
-  隔离 TensorRT 中的错误 tactic
- 下载和参考文档：
-  pip install polygraphy
-  https://docs.nvidia.com/deeplearning/tensorrt/polygraphy/docs/index.html
-  https://www.nvidia.com/en-us/on-demand/session/gtcspring21-s31695/（onnx-graphsurgeon 和 polygraphy 的一个视频教程）

**RUN 模式**
- 范例代码 `08-Tool/polygraphy/runExample`，运行 `./command.sh`
  -  首先生成一个 .onnx 文件（同前面基于 MNIST 的模型）
  -  其次使用 polygraphy 生成一个 FP16 的 TRT 引擎，并对比使用 onnxruntime 和 TensorRT 的计算结果
  -  然后使用 polygraphy 生成一个 FP32 的 TRT 引擎，将网络中所有层都标记为输出，并对比使用 onnxruntime 和 TensorRT 的计算结果（`逐层结果对比`）
  -  最后（右图中没有）使用 polygraphy 生成一个“用于生成 FP32 的 TRT 引擎”的 python 脚本，可用于理解 polygraphy 的 API 和原理，这里不展开

## Nsight Systems （在图形化系统中使用）
**性能分析，性能调试器**
  -  随 CUDA 安装或独立安装，位于 /usr/local/cuda/bin/ 下的 nsys 和 nsys-ui
  -  替代旧工具 nvprof 和 nvvp
  -  首先命令行运行 nsys profile XXX，获得 .qdrep 或 .qdrep-nsys 文件
  -  然后打开 nsys-ui，将上述文件拖入即可观察 timeline
  
**建议**
  -  只计量运行阶段，而不分析构建期
  -  构建期打开 profiling 以便获得关于 Layer 的更多信息
  -  builder_config.profilling_verbosity = trt.ProfilingVerbosity.DETAILED
  -  范例代码 09-Advance\ProfilingVerbosity
  -  可以搭配 trtexec 使用：
    ```bash
    nsys profile -o myProfile trtexec --loadEngine=model.plan --warmUp=0 --duration=0 --iterations=50
    ```
  -  也可以配合自己的 script 使用：nsys profile -o myProfile python myScript.py
  -  务必将 nsys 更新到最新版，nsys 不能前向兼容

