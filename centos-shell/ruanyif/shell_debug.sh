#脚本除错
#1.常见错误
#编写 Shell 脚本的时候，一定要考虑到命令失败的情况，否则很容易出错。
###
# #! /bin/bash

#dir_name=/path/not/exist

#cd $dir_name
#rm *
###
##上面脚本中，如果目录$dir_name不存在，cd $dir_name命令就会执行失败。这时，就不会改变当前目录，脚本会继续执行下去，导致rm *命令删光当前目录的文件。

#如果改成下面的样子，也会有问题。
#cd $dir_name && rm *
##上面脚本中，只有cd $dir_name执行成功，才会执行rm *。但是，如果变量$dir_name为空，cd就会进入用户主目录，从而删光用户主目录的文件。

#下面的写法才是正确的。
#[[ -d $dir_name ]] && cd $dir_name && rm *
##上面代码中，先判断目录$dir_name是否存在，然后才执行其他操作。

#如果不放心删除什么文件，可以先打印出来看一下。
#[[ -d $dir_name ]] && cd $dir_name && echo rm *
#上面命令中，echo rm *不会删除文件，只会打印出来要删除的文件。

#2.bash的-x参数
#bash的-x参数可以在执行每一行命令之前，打印该命令。这样就不用自己输出执行的命令，一旦出错，比较容易追查。

#下面是一个脚本script.sh。
# script.sh
#echo hello world

#加上-x参数，执行每条命令之前，都会显示该命令。
###
#$ bash -x script.sh
#+ echo hello world
#hello world
###
##上面例子中，行首为+的行，显示该行是所要执行的命令，下一行才是该命令的执行结果。

#下面再看一个-x写在脚本内部的例子。
####
# #! /bin/bash -x
# trouble: script to demonstrate common errors

#number=1
#if [ $number = 1 ]; then
#  echo "Number is equal to 1."
#else
#  echo "Number is not equal to 1."
#fi
####
##上面的脚本执行之后，会输出每一行命令。
###
#$ trouble
#+ number=1
#+ '[' 1 = 1 ']'
#+ echo 'Number is equal to 1.'
#Number is equal to 1.
###
##输出的命令之前的+号，是由系统变量PS4决定，可以修改这个变量。
####
#$ export PS4='$LINENO + '
#$ trouble
#5 + number=1
#7 + '[' 1 = 1 ']'
#8 + echo 'Number is equal to 1.'
#Number is equal to 1.
####
##另外，set命令也可以设置 Shell 的行为参数，有利于脚本除错

#3.环境变量
#有一些环境变量常用于除错。
#3.1LINENO
#变量LINENO返回它在脚本里面的行号。
###
# #!/bin/bash

#echo "This is line $LINENO"
###

#执行上面的脚本test.sh，$LINENO会返回3。
#$ ./test.sh
#This is line 3

#3.2FUNCNAME
#变量FUNCNAME返回一个数组，内容是当前的函数调用堆栈。该数组的0号成员是当前调用的函数，1号成员是调用当前函数的函数，以此类推。

#3.3BASH_SOURCE
#变量BASH_SOURCE返回一个数组，内容是当前的脚本调用堆栈。该数组的0号成员是当前执行的脚本，1号成员是调用当前脚本的脚本，以此类推，跟变量FUNCNAME是一一对应关系。

#3.4BASH_LINENO
#变量BASH_LINENO返回一个数组，内容是每一轮调用对应的行号。
#${BASH_LINENO[$i]}跟${FUNCNAME[$i]}是一一对应关系，表示${FUNCNAME[$i]}在调用它的脚本文件${BASH_SOURCE[$i+1]}里面的行号。

#下面有两个子脚本lib1.sh和lib2.sh。
####
# lib1.sh
#function func1()
#{
#  echo "func1: BASH_LINENO is ${BASH_LINENO[0]}"
#  echo "func1: FUNCNAME is ${FUNCNAME[0]}"
#  echo "func1: BASH_SOURCE is ${BASH_SOURCE[1]}"

#  func2
#}
####
###
# lib2.sh
#function func2()
#{
#  echo "func2: BASH_LINENO is ${BASH_LINENO[0]}"
#  echo "func2: FUNCNAME is ${FUNCNAME[0]}"
#  echo "func2: BASH_SOURCE is ${BASH_SOURCE[1]}"
#}
###
##然后，主脚本main.sh调用上面两个子脚本。
####
# #!/bin/bash
# main.sh

#source lib1.sh
#source lib2.sh

#func1
####

#执行主脚本main.sh，会得到下面的结果。
###
#$ ./main.sh
#func1: BASH_LINENO is 7
#func1: FUNCNAME is func1
#func1: BASH_SOURCE is main.sh
#func2: BASH_LINENO is 8
#func2: FUNCNAME is func2
#func2: BASH_SOURCE is lib1.sh
###
##上面例子中，函数func1是在main.sh的第7行调用，函数func2是在lib1.sh的第8行调用的。
