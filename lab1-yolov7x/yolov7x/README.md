## With NMS Plugin

**Edit code for your model**

```c++
auto in_dims = engine->getBindingDimensions(engine->getBindingIndex("image_arrays"));
```
**run**

```shell
mkdir build &&cd build
cmake ..
make
./yolo -model_path  engine   -image_path xxx.jpg
```