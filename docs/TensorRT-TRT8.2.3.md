# TensorRT
## 简介
- 用于高效实现已训练好的深度学习模型的`推理过程`的SDK
- 内含`推理优化器`和运行时环境
- 模型`高吞吐量`和`低延时`运行
- C++和python 的api

### TensorRT做的工作

*构建期*
- 模型解析、建立:加载onnx等其他格式的模型，使用原生API搭建模型
- 计算图优化：横向层融合（CONV），纵向层融合
- 节点消除：去除无用层，节点变化
- 多精度支持：FP32，FP16，INT8，TF32
- 优选kernel、format：硬件优化
- 导入plugin：实现自定义操作
- 显存优化：显存池复用

*运行时*
- 运行时环境：对象生命期管理，内存显存管理，异常处理
- 序列化反序列化：推理引擎保存为文件或从文件中加载

## TensorRT 基本流程
### 范例代码
https://github.com/NVIDIA/trt-samples-for-hackathon-cn/tree/master/cookbook//01-SimpleDemo/TensorRT8

### 构建
- 建立Builder（引擎构建器）
- 创建Network（计算图内容）
- 生成SerialzedNetwork（网络的TRT内部表示）

### 运行
- 建立Engine 和 Context
- Buffer相关准备（Host端 + Device端 + 拷贝操作）
- 执行推理(Execute)


## Workflow
### 使用框架自带TRT接口（TF-TRT，Torch-TensorRT）
- 简单灵活，部署仍在原框架中，无需书写Plugin

### 【We Used】使用Parser（TF/Torch/... -> Onnx -> TensorRT ）
- 流程成熟，Onnx通用性好，方便网络调整，兼顾效率性能。

### 使用TensorRT原生API搭建网络
- 性能最优，精细网络控制，兼容性最好
- 复杂度最高
- 推荐：
  1. [tensorrtx](https://github.com/wang-xinyu/tensorrtx)
  2. https://github.com/NVIDIA/trt-samples-for-hackathon-cn/tree/master/cookbook/03-APIModel
    - 


## 开发辅助工具
- netron
  > 使用netron工具查看网络架构以及网络的输入输出形状，在线的netron网址如下：
    ```
    https://netron.app/
    ```
- 

- onnx-graphsurgeon


## 插件编写

## TensorRT 高级
