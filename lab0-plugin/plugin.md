# TensorRT Plugin
+ [TensorRT教程-TRT8.2.3-V1.1.pdf](https://github.com/NVIDIA/trt-samples-for-hackathon-cn/blob/master/cookbook/50-Resource/TensorRT%E6%95%99%E7%A8%8B-TRT8.2.3-V1.1.pdf) p80

## Plugin 简介
- 功能
  -  以 `.so` 的形式插入到网络中实现某些算子
  -  实现 TensorRT 不原生支持的层或结构
  -  替换性能不足的层或结构
  -  手动合并 TensorRT 没有自动融合的层或结构
- 限制条件
  -  自己实现 CUDA C++ kernel，为结果精度和性能负责
  -  Plugin 与其他 Layer 之间无法 fusing
  -  可能在 Plugin 节点前后插入 reformatting 节点，增加开销
- 建议
  -  先尝试原生 Layer 的组合保证计算正确性
  -  尝试 TensorRT 自带的 Plugin 是否满足要求
  -  还是不满意，自己写！
- TensorRT 自带的 Plugin 及使用说明
  -  https://github.com/NVIDIA/TensorRT/tree/main/plugin

## Plugin 关键问题
- 怎么从头开始实现一个 Plugin？               要写哪些类和函数
- 怎么把 Plugin 接到 TensorRT 网络中去？      要怎么包装 kernel 以便 TensorRT 识别
- TensorRT 怎么参与 Plugin 的资源管理？       两者之间要交换些什么信息
- Plugin 能不能序列化到 `.plan` 中去？
- Plugin 有些什么扩展性？                     FP16/INT8，Dynamic Shape，data-dependent-shape，…
- Plugin 与原生 Layer 相比性能怎么样？


## Plugin 的类型
- ~~IPluginV1~~
- `IPluginV2` （支持单一 input / output 格式）
- `IPluginV2Ext` （支持单一 input 格式和混合 output 格式）
- `IPluginV2IOExt` （支持混合 input / output 格式，Implicit Batch 模式)
- `IPluginV2DynamicExt` （支持混合 input / output 格式，Dynamic Shape 模式)

**范例代码**
  -  `05-Plugin/usePluginV2IOExt` 和 `05-Plugin/usePluginV2DynamicExt`，使用两种类实现同一个 Plugin，并搭建网络进行推理