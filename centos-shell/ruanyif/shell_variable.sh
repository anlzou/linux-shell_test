#环境变量是 Bash 环境自带的变量，进入 Shell 时已经定义好了，可以直接使用。它们通常是系统定义好的，也可以由用户从父 Shell 传入子 Shell。
#env命令或printenv命令，可以显示所有环境变量。

#下面是一些常见的环境变量。
#BASHPID：Bash 进程的进程 ID。
#BASHOPTS：当前 Shell 的参数，可以用shopt命令修改。
#DISPLAY：图形环境的显示器名字，通常是:0，表示 X Server 的第一个显示器。
#EDITOR：默认的文本编辑器。
#HOME：用户的主目录。
#HOST：当前主机的名称。
#IFS：词与词之间的分隔符，默认为空格。
#LANG：字符集以及语言编码，比如zh_CN.UTF-8。
#PATH：由冒号分开的目录列表，当输入可执行程序名后，会搜索这个目录列表。
#PS1：Shell 提示符。
#PS2： 输入多行命令时，次要的 Shell 提示符。
#PWD：当前工作目录。
#RANDOM：返回一个0到32767之间的随机数。
#SHELL：Shell 的名字。
#SHELLOPTS：启动当前 Shell 的set命令的参数，参见《set 命令》一章。
#TERM：终端类型名，即终端仿真器所用的协议。
#UID：当前用户的 ID 编号。
#USER：当前用户的用户名。

#很多环境变量很少发生变化，而且是只读的，可以视为常量。由于它们的变量名全部都是大写，所以传统上，如果用户要自己定义一个常量，也会使用全部大写的变量名。
#注意，Bash 变量名区分大小写，HOME和home是两个不同的变量。
#查看单个环境变量的值，可以使用printenv命令或echo命令。
#printenv PATH
# 或者
#echo $PATH

#自定义变量是用户在当前 Shell 里面自己定义的变量，必须先定义后使用，而且仅在当前 Shell 可用。一旦退出当前 Shell，该变量就不存在了。
#set命令可以显示所有变量（包括环境变量和自定义变量），以及所有的 Bash 函数。
#set

#2.创建变量
#用户创建变量的时候，变量名必须遵守下面的规则。
#1.字母、数字和下划线字符组成。
#2.第一个字符必须是一个字母或一个下划线，不能是数字。
#3.不允许出现空格和标点符号。

#变量声明的语法如下。
#variable=value
##上面命令中，等号左边是变量名，右边是变量。注意，等号两边不能有空格
##如果变量的值包含空格，则必须将值放在引号中。

##Bash 没有数据类型的概念，所有的变量值都是字符串。

#下面是一些自定义变量的例子:
#a=z                     # 变量 a 赋值为字符串 z
#b="a string"            # 变量值包含空格，就必须放在引号里面
#c="a string and $b"     # 变量值可以引用其他变量的值
#d="\t\ta string\n"      # 变量值可以使用转义字符
#e=$(ls -l foo.txt)      # 变量值可以是命令的执行结果
#f=$((5 * 7))            # 变量值可以是数学运算的结果

##变量可以重复赋值，后面的赋值会覆盖前面的赋值。

#3.读取变量
#读取变量的时候，直接在变量名前加上$就可以了
#a=anlzou
#b=$a
#echo $b
##anlzou

#如果变量的值本身也是变量，可以使用${!varname}的语法，读取最终的值。
#user=USER
#echo ${!user}
##root

#读取变量的时候，变量名也可以使用花括号{}包围，比如$a也可以写成${a}。这种写法可以用于变量名与其他字符连用的情况。
#a=foo
#echo ${a}_file
##foo_file

#4.删除变量
#unset命令用来删除一个变量。
#unset NAME

#这个命令不是很有用。因为不存在的 Bash 变量一律等于空字符串，所以即使unset命令删除了变量，还是可以读取这个变量，值为空字符串。
#所以，删除一个变量，也可以将这个变量设成空字符串。
#foo=''
#or
#foo=

#5.输出变量，export 命令
#用户创建的变量仅可用于当前 Shell，子 Shell 默认读取不到父 Shell 定义的变量。为了把变量传递给子 Shell，需要使用export命令。这样输出的变量，对于子 Shell 来说就是环境变量。
#export命令用来向子 Shell 输出变量
#NAME=foo
#export NAME
#or
#export NAME=value
##上面命令执行后，当前 Shell 及随后新建的子 Shell，都可以读取变量$NAME。
##子 Shell 如果修改继承的变量，不会影响父 Shell。
# 输出变量 $foo
# export foo=bar

# 新建子 Shell
# bash

# 读取 $foo
# echo $foo
##bar

# 修改继承的变量
# foo=baz

# 退出子 Shell
## exit

# 读取 $foo
# echo $foo
##bar

#6.特殊变量
#Bash 提供一些特殊变量。这些变量的值由 Shell 提供，用户不能进行赋值。
#(1)$?为上一个命令的退出码，用来判断上一个命令是否执行成功。返回值是0，表示上一个命令执行成功；如果是非零，上一个命令执行失败。
#echo $?

#(2)$$为当前 Shell 的进程 ID。
#echo $$
#这个特殊变量可以用来命名临时文件。
#LOGFILE=/tmp/output_log.$$

#(3)$_为上一个命令的最后一个参数。
#grep dictionary /usr/share/dict/words
##dictionary
#echo $_
##/usr/share/dict/words

#(4)$!为最近一个后台执行的异步命令的进程 ID。
#firefox &
##[1] 11064
#echo $!
##11064

#(5)$0为当前 Shell 的名称（在命令行直接执行时）或者脚本名（在脚本中执行时）。
#echo $0
##bash

#(6)$-为当前 Shell 的启动参数。
#echo $-
##himBH

#(7)$@和$#表示脚本的参数数量

#7.变量的默认值
#Bash 提供四个特殊语法，跟变量的默认值有关，目的是保证变量不为空。
#（1）
#${varname:-word}
#上面语法的含义是，如果变量varname存在且不为空，则返回它的值，否则返回word。它的目的是返回一个默认值，比如${count:-0}表示变量count不存在时返回0。
#（2）
#${varname:=word}
#上面语法的含义是，如果变量varname存在且不为空，则返回它的值，否则将它设为word，并且返回word。它的目的是设置变量的默认值，比如${count:=0}表示变量count不存在时返回0，且将count设为0。
#（3）
#${varname:+word}
#上面语法的含义是，如果变量名存在且不为空，则返回word，否则返回空值。它的目的是测试变量是否存在，比如${count:+1}表示变量count存在时返回1（表示true），否则返回空值。
#（4）
#${varname:?message}
#上面语法的含义是，如果变量varname存在且不为空，则返回它的值，否则打印出varname: message，并中断脚本的执行。如果省略了message，则输出默认的信息“parameter null or not set.”。它的目的是防止变量未定义，比如${count:?"undefined!"}表示变量count未定义时就中断执行，抛出错误，返回给定的报错信息undefined!。

#上面四种语法如果用在脚本中，变量名的部分可以用到数字1到9，表示脚本的参数。
#filename=${1:?"filename missing."}
#上面代码出现在脚本中，1表示脚本的第一个参数。如果该参数不存在，就退出脚本并报错。

#8.declare 命令
#declare命令可以声明一些特殊类型的变量，为变量设置一些限制，比如声明只读类型的变量和整数类型的变量。
#declare OPTION VARIABLE=value

#declare命令的主要参数（OPTION）如下:
#-a：声明数组变量。
#-f：输出所有函数定义。
#-F：输出所有函数名。
#-i：声明整数变量。
#-l：声明变量为小写字母。
#-p：查看变量信息。
#-r：声明只读变量。
#-u：声明变量为大写字母。
#-x：该变量输出为环境变量。
##declare命令如果用在函数中，声明的变量只在函数内部有效，等同于local命令。

#不带任何参数时，declare命令输出当前环境的所有变量，包括函数在内，等同于不带有任何参数的set命令。
##详情：https://wangdoc.com/bash/variable.html#declare-%E5%91%BD%E4%BB%A4

#9.readonly 命令
#readonly命令等同于declare -r，用来声明只读变量，不能改变变量值，也不能unset变量。
#readonly命令有三个参数:
#-f：声明的变量为函数名。
#-p：打印出所有的只读变量。
#-a：声明的变量为数组。

#10.let 命令
#let命令声明变量时，可以直接执行算术表达式。

#let命令的参数表达式如果包含空格，就需要使用引号。
#let可以同时对多个变量赋值，赋值表达式之间使用空格分隔。
#let foo=1+2
#let "v1 = 1" "v2 = v1++"