shell就是外壳，操作系统的编程交互接口就是shell系统。shell系统能识别shell脚本。

所以实际上shell脚本就是为了操作操作系统而生的。

shell是一个用 C 语言编写的程序，用户通过这个界面访问操作系统内核的服务。

操作系统需要的操作有这些，

1 基础编程语法：变量，判断，循环，函数，命令的顺序执行

2 文本处理，我们经常使用的grep，awk，cut，sort，tr之类的

3 文件操作，读写文件，文件测试，find文件，tar压缩文件，日志分析和提取

4 流程控制 除了简单的if，for之外，还有case，while util，exit状态码

5 输入输出控制 操作系统的输入输出系统也有很多操作的需要。标准输入输出，流重定向

6 脚本调试 语法

7 函数与模块化 

8 定时任务

9 网络与API交互 使用`curl`/`wget`调用 API 接口、下载远程数据

10 安全与权限 操作系统的安全和权限非常的重要

# bug手册

1 如果出现莫名的\342\200\252\342\200\252之类的错误提示，那么很可能是赋值粘贴的时候粘贴进去了无法某些空白字符。你需要手敲。

# 快速开始

我们的目标是：写一个 命令行输入关键词 到我的密码文件输出提示信息的程序。

```shell
#！/bin/bash
echo "please input key words: "
```

1 必要的蟹棒，#!在第一行开头的位置，告诉操作系统这个脚本文件的执行程序的地址。

要运行shell脚本有两种方式

- 1作为操作系统的可执行程序运行

  假如上面的脚本文件叫做test.sh，在设置了可执行权限之后。在终端命令窗口中，执行 ./test.sh 即可。

> 一定要写成 ./test.sh，而不是 **test.sh**，运行其它二进制的程序也一样，直接写 test.sh，linux 系统会去 PATH 里寻找有没有叫 test.sh 的，而只有 /bin, /sbin, /usr/bin，/usr/sbin 等在 PATH 里，你的当前目录通常不在 PATH 里，所以写成 test.sh 是会找不到命令的，要用 ./test.sh 告诉系统说，就在当前目录找。

  操作系统会根据蟹棒后面的路径寻找执行的

- 2作为bash程序的解释器参数执行

  这种方式运行的脚本，不需要在第一行指定解释器信息，写了也没用。

## 设置注释

```shell
#！/bin/bash

# 井号开头就是单行注释，多行注释需要借助 << 符号的功能
<<'COMMENT'
多行注释内容
COMMENT

echo "please input key words: "
```

## 设置变量

变量分为赋值和读取两种。

shell中的变量非常纯粹，默认就是字符串类型，可以存储万物。当你试图用这个变量做+-等操作，或者特殊类型的操作，shell会自动将变量转换成对应的类型进行操作。

纯粹的存储功能，还可以搭配其他的功能组成完备的存储功能。例如只读，删除，类型限制

**赋值变量**的时候只需要给一个名字和=即可

需要注意

- **避免使用特殊符号：** 尽量避免在变量名中使用特殊符号，因为它们可能与 Shell 的语法产生冲突。
- **避免使用空格：** 变量名中不应该包含空格，因为空格通常用于分隔命令和参数。

```shell
#！/bin/bash

# 井号开头就是单行注释，多行注需要借助 << 符号的功能
<<'COMMENT'
多行注释内容
COMMENT

# 设置密码提示文件地址 
# (这里不使用~，因为~通常是解释命令的时候才动态拓展~的，在脚本中最好使用$HOME)
passwordFilePath=‪${HOME}/syncthing/wainyz/private/.password.txt
```

**读取变量**的时候需要加上\$

变量名外面的花括号是可选的，加不加都行，加花括号是为了帮助解释器识别变量的边界

**在双引号中也能检测到变量，而单引号就不行了。**

```shell
#！/bin/bash

# 井号开头就是单行注释，多行注释需要借助 << 符号的功能
<<'COMMENT'
多行注释内容
COMMENT

# 设置密码提示文件地址 
# (这里不使用~，因为~通常是解释命令的时候才动态拓展~的，在脚本中最好使用$HOME)
passwordFilePath=‪${HOME}/syncthing/wainyz/private/.password.txt
echo "default passwordFilePath: $passwordFilePath"
```

我们可以将变量设置为只读,这样等我们试图修改变量的值的时候就会提示错误

```shell
#！/bin/bash

# 井号开头就是单行注释，多行注释需要借助 << 符号的功能
<<'COMMENT'
多行注释内容
COMMENT

# 设置密码提示文件地址 
# (这里不使用~，因为~通常是解释命令的时候才动态拓展~的，在脚本中最好使用$HOME)
passwordFilePath=‪${HOME}/syncthing/wainyz/private/.password.txt
echo "default passwordFilePath: $passwordFilePath"
readonly passwordFilePath
```

在shell中因为作用域不区分的原因，变量太多会污染作用域。所以需要使用删除标量的操作

 unset 变量名

但是readonly只读变量不能被删除

我们可以使用read来获取用户实时输入

```shell
#！/bin/bash

# 井号开头就是单行注释，多行注释需要借助 << 符号的功能
<<'COMMENT'
多行注释内容
COMMENT

# 设置密码提示文件地址 
# (这里不使用~，因为~通常是解释命令的时候才动态拓展~的，在脚本中最好使用$HOME)
passwordFilePath=‪${HOME}/syncthing/wainyz/private/.password.txt
echo "default passwordFilePath: $passwordFilePath"
readonly passwordFilePath

echo "please input key words (Ctrl+c to abort): "
read keyword
```

## 条件表达式

我们需要设计一个循环判断用户的输入，来确定用户是否想要退出。

shell脚本的判断或者说条件语句的格式都是

if [ 条件表达式 ]; then

 具体的内容

if

或者循环

while [ 条件 ];do

 具体内容

done

**<mark>注意中括号中间的空格是必须的！</mark>**

这里需要研究条件表达式

条件表达式不会直接返回布尔值，如果我们想保留条件表达式的结果，需要借助if 判断语句，将变量赋值为字符串或者整形，然后再通过if判断语句还原。

## while循环

while循环和if判断语句很像，就只有then fi与do done的区别。

```shell
#！/bin/bash

# 井号开头就是单行注释，多行注释需要借助 << 符号的功能
<<'COMMENT'
多行注释内容
COMMENT

# 设置密码提示文件地址 
# (这里不使用~，因为~通常是解释命令的时候才动态拓展~的，在脚本中最好使用$HOME)
passwordFilePath=‪${HOME}/syncthing/wainyz/private/.password.txt
echo "default passwordFilePath: $passwordFilePath"
readonly passwordFilePath

echo "please input key words (Ctrl+c to abort): "
read keyword
# 获取字符串变量的长度，就是${#变量名}
while [ ${#keyword} -gt 0 ]; do
 # 循环内容
done
```

然后我们需要在循环内容中做到下面的事情：

1 从目标文件中搜索到指定的关键词并显示关键词所在行以及下三行（也就是四行的信息）

这里需要使用文件搜索功能（这里需要注意，脚本语言与编程语言的区别就是脚本语言有很多直接可以用的高级功能，但是编程粒度没有编程语言这么细）

## 文件搜索

文件搜索主要使用grep命令

```shell
# 搜索并实现对应的文件行
grep <关键词> <文件路径>
# 忽略大小写
grep -i <关键词> <文件路径>
# 实现行号
grep -n <关键词> <文件路径>
# 额外显示关键词后的几行
grep -A <more> <关键词> <文件路径>
```

所以我们的程序最终就是这样

```shell
#！/bin/bash

# 井号开头就是单行注释，多行注释需要借助 << 符号的功能
<<'COMMENT'
 总结：
  1 #！，注释，多行注释
  2 简单变量声明与使用，只读变量，双引号，输入read，输出echo
  3 if与while，字符串的长度
  4 grep搜索文件
COMMENT

# 设置密码提示文件地址
passwordFilePath=${HOME}/syncthing/wainyz/private/.password.txt
echo "default passwordFilePath: $passwordFilePath"
readonly passwordFilePath

echo "please input key words: "
read keyword
# 获取字符串变量的长度，就是${#变量名}
while [ ${#keyword} -gt 0 ]; do
    echo '----------search results begin----------'
    # 搜索,额外显示关键词后的3行
    grep -A 3 $keyword $passwordFilePath
    echo '==========search results end============='
    echo "please input keywords: "
    read keyword
done
```