## C++ define
-  `#define`是一条预处理指令，用于定义一个预处理变量。
-  `#endif`是一条预处理指令，用于结束一个#ifdef或#ifndef区域。
-  `#ifdef`是一条预处理指令，用于判断给定的变量是否已经定义。
-  `#ifndef`是一条预处理指令，用于判断给定的变量是否尚未定义。

## 输出格式

-   `%d`整形（十进制），`%ld`长整型，`%lld`；
-   （`%6d`表示宽度为6，默认右对齐；`%-6d`表示宽度为6，左对齐；`%06`表示宽度为6，默认右对齐，空位用0补齐；其它的类似）
-   `%o`八进制形式输出整数；
-   `%x`十六进制形式输出整数；
-   `%u`输出无符号整数（十进制）；
-   `%c`输出一个字符；
-   `%s`输出一个字符串；
-   `%f`输出实数，（输入的时候float实数用%f，double实数用%lf）`%m.nf`中m表示共占m位（小数点算一位），n表示小数点后保留n位小数；
-   `%e（或%E）`以指数形式输出实数；
-   `%p` 以十六进制输出指针、地址；
-   `%g` 表示输出`%f%e`中较短的宽度输出实数，在指数小于-4或大于等于精度时使用%e。

## assert 
```cpp
assert(expr)
```
首先对expr求值，如果表达式为假（即0），assert输出信息并终止程序的执行。如果表达式为真（即非0），assert什么也不做。

## template

在模板定义时的class和typename是没有区别的，因为最初发明模板时决定使用class以减少一个关键字，但后来发现还是不得不加上typename关键字。所以，模板定义时class和typename是一样的。class可以用来定义类，也可用作模板参数类型，而typename只能用作参数类型。

```cpp
template<class T> class Widget; // uses "class"
template<typename T> class Widget; // uses "typename"
```