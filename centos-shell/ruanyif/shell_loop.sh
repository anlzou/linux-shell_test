#循环
#1.while 循环
#while循环有一个判断条件，只要符合条件，就不断循环执行指定的语句。
############
#while condition; do
#  commands
#done
############
##上面代码中，只要满足条件condition，就会执行命令commands。然后，再次判断是否满足条件condition，只要满足，就会一直执行下去。只有不满足条件，才会退出循环。

#循环条件condition可以使用test命令，跟if结构的判断条件写法一致。
########
# #!/bin/bash

#number=0
#while [ "$number" -lt 10 ]; do
#  echo "Number = $number"
#  number=$((number + 1))
#done
########
##上面例子中，只要变量$number小于10，就会不断加1，直到$number等于10，然后退出循环。

##关键字do可以跟while不在同一行，这时两者之间不需要使用分号分隔。
#####
#while true
#do
#  echo 'Hi, while looping ...';
#done
#####
##上面的例子会无限循环，可以按下 Ctrl + c 停止。

#while循环写成一行，也是可以的。
#$ while true; do echo 'Hi, while looping ...'; done
##上面例子中，判断条件是echo 'ECHO'。由于这个命令总是执行成功，所以上面命令会产生无限循环。

#while的条件部分可以执行任意数量的命令，但是执行结果的真伪只看最后一个命令的执行结果。
#$ while true; false; do echo 'Hi, looping ...'; done
##上面代码运行后，不会有任何输出，因为while的最后一个命令是false。

#2.until 循环
#until循环与while循环恰好相反，只要不符合判断条件（判断条件失败），就不断循环执行指定的语句。一旦符合判断条件，就退出循环。
#until的条件部分也可以是一个命令，表示在这个命令执行成功之前，不断重复尝试。
######
#until cp $1 $2; do
#  echo 'Attempt to copy failed. waiting...'
#  sleep 5
#done
######
##上面例子表示，只要cp $1 $2这个命令执行不成功，就5秒钟后再尝试一次，直到成功为止。

#until循环都可以转为while循环，只要把条件设为否定即可。
#一般来说，until用得比较少，完全可以统一都使用while。

#3.for...in 循环
#for...in循环用于遍历列表的每一项。
#######
#for variable in list
#do
#  commands
#done
#######
##上面语法中，for循环会依次从list列表中取出一项，作为变量variable，然后在循环体中进行处理。

#关键词do可以跟for写在同一行，两者使用分号分隔。
########
##!/bin/bash

#for i in word1 word2 word3; do
#  echo $i
#done
########
##上面例子中，word1 word2 word3是一个包含三个单词的列表，变量i依次等于word1、word2、word3，命令echo $i则会相应地执行三次。

#列表可以由通配符产生。
#####
#for i in *.png; do
#  ls -l $i
#done
#####
##上面例子中，*.png会替换成当前目录中所有 PNG 图片文件，变量i会依次等于每一个文件。

#列表也可以通过子命令产生。
#######
# #!/bin/bash

#count=0
#for i in $(cat ~/.bash_profile); do
#  count=$((count + 1))
#  echo "Word $count ($i) contains $(echo -n $i | wc -c) characters"
#done
#######
##上面例子中，cat ~/.bash_profile命令会输出~/.bash_profile文件的内容，然后通过遍历每一个词，计算该文件一共包含多少个词，以及每个词有多少个字符。

#in list的部分可以省略，这时list默认等于脚本的所有参数$@。但是，为了可读性，最好还是不要省略，参考下面的例子。
################
#for filename; do
#  echo "$filename"
#done

# 等同于

#for filename in "$@" ; do
#  echo "$filename"
#done
################
##在函数体中也是一样的，for...in循环省略in list的部分，则list默认等于函数的所有参数。

#4.for 循环
#for循环还支持 C 语言的循环语法。
######
#for (( expression1; expression2; expression3 )); do
#  commands
#done
######
##注意，循环条件放在双重圆括号之中。另外，圆括号之中使用变量，不必加上美元符号$。

#它等同于下面的while循环。
###########
#(( expression1 ))
#while (( expression2 )); do
#  commands
#  (( expression3 ))
#done
###########

#for条件部分的三个语句，都可以省略。
#######
#for ((;;))
#do
#  read var
#  if [ "$var" = "." ]; then
#    break
#  fi
#done
##上面脚本会反复读取命令行输入，直到用户输入了一个点（.）为止，才会跳出循环。

#5.break，continue
#Bash 提供了两个内部命令break和continue，用来在循环内部跳出循环。
#break命令立即终止循环，程序继续执行循环块之后的语句，即不再执行剩下的循环。

#6.select 结构
#select结构主要用来生成简单的菜单。它的语法与for...in循环基本一致。
#####
#select name
#[in list]
#do
#  commands
#done
#####
#Bash 会对select依次进行下面的处理。
##1.select生成一个菜单，内容是列表list的每一项，并且每一项前面还有一个数字编号。
##2.Bash 提示用户选择一项，输入它的编号。
##3.用户输入以后，Bash 会将该项的内容存在变量name，该项的编号存入环境变量REPLY。如果用户没有输入，就按回车键，Bash 会重新输出菜单，让用户选择。
##4.执行命令体commands。
##5.执行结束后，回到第一步，重复这个过程。

#下面是一个例子。
####
# #!/bin/bash
# select.sh
#select brand in Samsung Sony iphone symphony Walton
#do
#  echo "You have chosen $brand"
#done
####
##执行上面的脚本，Bash 会输出一个品牌的列表，让用户选择。
######
#$ ./select.sh
#1) Samsung
#2) Sony
#3) iphone
#4) symphony
#5) Walton
#?
######
##如果用户没有输入编号，直接按回车键。Bash 就会重新输出一遍这个菜单，直到用户按下Ctrl + c，退出执行。

#select可以与case结合，针对不同项，执行不同的命令。
####
# #!/bin/bash

#echo "Which Operating System do you like?"
#select os in Ubuntu LinuxMint Windows8 Windows7 WindowsXP
#do
#  case $os in
#    "Ubuntu"|"LinuxMint")
#      echo "I also use $os."
#    ;;
#    "Windows8" | "Windows10" | "WindowsXP")
#      echo "Why don't you try Linux?"
#    ;;
#    *)
#      echo "Invalid entry."
#      break
#    ;;
#  esac
#done
####
##上面例子中，case针对用户选择的不同项，执行不同的命令。
