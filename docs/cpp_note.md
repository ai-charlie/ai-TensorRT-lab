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