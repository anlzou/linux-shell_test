#条件判断
#1.if 结构
#if是最常用的条件判断结构，只有符合给定条件时，才会执行指定的命令。它的语法如下。
######
#if commands; then
#  commands
#[elif commands; then
#  commands...]
#[else
#  commands]
#fi
######
##这个命令分成三个部分：if、elif和else。其中，后两个部分是可选的。
##if关键字后面是主要的判断条件，elif用来添加在主条件不成立时的其他判断条件，else则是所有条件都不成立时要执行的部分。

#######
#if test $USER = "foo"; then
#  echo "Hello foo."
#else
#  echo "You are not foo."
#fi
#######
##上面的例子中，判断条件是环境变量$USER是否等于foo，如果等于就输出Hello foo.，否则输出其他内容。

##if和then写在同一行时，需要分号分隔。分号是 Bash 的命令分隔符。它们也可以写成两行，这时不需要分号。
#######
#if true
#then
#  echo 'hello world'
#fi
#
#if false
#then
#  echo 'it is false' # 本行不会执行
#fi
#######

#除了多行的写法，if结构也可以写成单行。
#######
#$ if true; then echo 'hello world'; fi
#hello world
#$ if false; then echo "It's true."; fi
#######

#注意，if关键字后面也可以是一条命令，该条命令执行成功（返回值0），就意味着判断条件成立。
########
#$ if echo 'hi'; then echo 'hello world'; fi
#hi
#hello world
########
##上面命令中，if后面是一条命令echo 'hi'。该命令会执行，如果返回值是0，则执行then的部分。

#if后面可以跟任意数量的命令。这时，所有命令都会执行，但是判断真伪只看最后一个命令，即使前面所有命令都失败，只要最后一个命令返回0，就会执行then的部分。
##$ if false; true; then echo 'hello world'; fi
###hello world
##上面例子中，if后面有两条命令（false;true;），第二条命令（true）决定了then的部分是否会执行。

#elif部分可以有多个。
############
#  #!/bin/bash

#echo -n "输入一个1到3之间的数字（包含两端）> "
#read character
#if [ "$character" = "1" ]; then
#    echo 1
#elif [ "$character" = "2" ]; then
#    echo 2
#elif [ "$character" = "3" ]; then
#    echo 3
#else
#    echo 输入不符合要求
#fi
############

#2.test 命令
#if结构的判断条件，一般使用test命令，有三种形式。
############
# 写法一
#test expression

# 写法二
#[ expression ]


# 写法三
#[[ expression ]]
############
##上面三种形式是等价的，但是第三种形式还支持正则判断，前两种不支持。
##上面的expression是一个表达式。这个表达式为真，test命令执行成功（返回值为0）；表达式为伪，test命令执行失败（返回值为1）。注意，第二种和第三种写法，[和]与内部的表达式之间必须有空格。
######
#$ test -f /etc/hosts
#$ echo $?
#0

#$ [ -f /etc/hosts ]
#$  echo $?
#0
######
##上面的例子中，test命令采用两种写法，判断/etc/hosts文件是否存在，这两种写法是等价的。命令执行后，返回值为0，表示该文件确实存在。
##实际上，[这个字符是test命令的一种简写形式，可以看作是一个独立的命令，这解释了为什么它后面必须有空格。

#下面把test命令的三种形式，用在if结构中，判断一个文件是否存在。
#########
# 写法一
#if test -e /tmp/foo.txt ; then
#  echo "Found foo.txt"
#fi

# 写法二
#if [ -e /tmp/foo.txt ] ; then
#  echo "Found foo.txt"
#fi

# 写法三
#if [[ -e /tmp/foo.txt ]] ; then
#  echo "Found foo.txt"
#fi
#########

#3.判断表达式
#if关键字后面，跟的是一个命令。这个命令可以是test命令，也可以是其他命令。命令的返回值为0表示判断成立，否则表示不成立。因为这些命令主要是为了得到返回值，所以可以视为表达式。
#常用的判断表达式有下面这些。

#3.1文件判断 
#以下表达式用来判断文件状态：
# [ -a file ]：如果 file 存在，则为true。
# [ -b file ]：如果 file 存在并且是一个块（设备）文件，则为true。
# [ -c file ]：如果 file 存在并且是一个字符（设备）文件，则为true。
# [ -d file ]：如果 file 存在并且是一个目录，则为true。
# [ -e file ]：如果 file 存在，则为true。
# [ -f file ]：如果 file 存在并且是一个普通文件，则为true。
# [ -g file ]：如果 file 存在并且设置了组 ID，则为true。
# [ -G file ]：如果 file 存在并且属于有效的组 ID，则为true。
# [ -h file ]：如果 file 存在并且是符号链接，则为true。
# [ -k file ]：如果 file 存在并且设置了它的“sticky bit”，则为true。
# [ -L file ]：如果 file 存在并且是一个符号链接，则为true。
# [ -N file ]：如果 file 存在并且自上次读取后已被修改，则为true。
# [ -O file ]：如果 file 存在并且属于有效的用户 ID，则为true。
# [ -p file ]：如果 file 存在并且是一个命名管道，则为true。
# [ -r file ]：如果 file 存在并且可读（当前用户有可读权限），则为true。
# [ -s file ]：如果 file 存在且其长度大于零，则为true。
# [ -S file ]：如果 file 存在且是一个网络 socket，则为true。
# [ -t fd ]：如果 fd 是一个文件描述符，并且重定向到终端，则为true。 这可以用来判断是否重定向了标准输入／输出错误。
# [ -u file ]：如果 file 存在并且设置了 setuid 位，则为true。
# [ -w file ]：如果 file 存在并且可写（当前用户拥有可写权限），则为true。
# [ -x file ]：如果 file 存在并且可执行（有效用户有执行／搜索权限），则为true。
# [ file1 -nt file2 ]：如果 FILE1 比 FILE2 的更新时间最近，或者 FILE1 存在而 FILE2 不存在，则为true。
# [ file1 -ot file2 ]：如果 FILE1 比 FILE2 的更新时间更旧，或者 FILE2 存在而 FILE1 不存在，则为true。
# [ FILE1 -ef FILE2 ]：如果 FILE1 和 FILE2 引用相同的设备和 inode 编号，则为true。

##$FILE要放在双引号之中。这样可以防止$FILE为空，因为这时[ -e ]会判断为真。而放在双引号之中，返回的就总是一个空字符串，[ -e "" ]会判断为伪。

#3.2字符串判断
#以下表达式用来判断字符串。
# [ string ]：如果string不为空（长度大于0），则判断为真。
# [ -n string ]：如果字符串string的长度大于零，则判断为真。
# [ -z string ]：如果字符串string的长度为零，则判断为真。
# [ string1 = string2 ]：如果string1和string2相同，则判断为真。
# [ string1 == string2 ] 等同于[ string1 = string2 ]。
# [ string1 != string2 ]：如果string1和string2不相同，则判断为真。
# [ string1 '>' string2 ]：如果按照字典顺序string1排列在string2之后，则判断为真。
# [ string1 '<' string2 ]：如果按照字典顺序string1排列在string2之前，则判断为真。
##注意，test命令内部的>和<，必须用引号引起来（或者是用反斜杠转义）。否则，它们会被 shell 解释为重定向操作符。

#示例：
##########
#  #!/bin/bash

#ANSWER=maybe

#if [ -z "$ANSWER" ]; then
#  echo "There is no answer." >&2
#  exit 1
#fi
#if [ "$ANSWER" = "yes" ]; then
#  echo "The answer is YES."
#elif [ "$ANSWER" = "no" ]; then
#  echo "The answer is NO."
#elif [ "$ANSWER" = "maybe" ]; then
#  echo "The answer is MAYBE."
#else
#  echo "The answer is UNKNOWN."
#fi
##########
##上面代码中，首先确定$ANSWER字符串是否为空。如果为空，就终止脚本，并把退出状态设为1。注意，这里的echo命令把错误信息There is no answer.重定向到标准错误，这是处理错误信息的常用方法。如果$ANSWER字符串不为空，就判断它的值是否等于yes、no或者maybe。
##注意，字符串判断时，变量要放在双引号之中，比如[ -n "$COUNT" ]，否则变量替换成字符串以后，test命令可能会报错，提示参数过多。另外，如果不放在双引号之中，变量为空时，命令会变成[ -n ]，这时会判断为真。如果放在双引号之中，[ -n "" ]就判断为伪。

#3.3整数判断
#下面的表达式用于判断整数。
# [ integer1 -eq integer2 ]：如果integer1等于integer2，则为true。
# [ integer1 -ne integer2 ]：如果integer1不等于integer2，则为true。
# [ integer1 -le integer2 ]：如果integer1小于或等于integer2，则为true。
# [ integer1 -lt integer2 ]：如果integer1小于integer2，则为true。
# [ integer1 -ge integer2 ]：如果integer1大于或等于integer2，则为true。
# [ integer1 -gt integer2 ]：如果integer1大于integer2，则为true。
#########
#  #!/bin/bash

#INT=-5

#if [ -z "$INT" ]; then
#  echo "INT is empty." >&2
#  exit 1
#fi
#if [ $INT -eq 0 ]; then
#  echo "INT is zero."
#else
#  if [ $INT -lt 0 ]; then
#    echo "INT is negative."
#  else
#    echo "INT is positive."
#  fi
#  if [ $((INT % 2)) -eq 0 ]; then
#    echo "INT is even."
#  else
#    echo "INT is odd."
#  fi
#fi
#########
##上面例子中，先判断变量$INT是否为空，然后判断是否为0，接着判断正负，最后通过求余数判断奇偶。

#3.4正则判断
#[[ expression ]]这种判断形式，支持正则表达式。
#[[ string1 =~ regex ]]
##上面的语法中，regex是一个正则表示式，=~是正则比较运算符。

#下面是一个例子。
#######
#  #!/bin/bash

#INT=-5

#if [[ "$INT" =~ ^-?[0-9]+$ ]]; then
#  echo "INT is an integer."
#  exit 0
#else
#  echo "INT is not an integer." >&2
#  exit 1
#fi
#######
##上面代码中，先判断变量INT的字符串形式，是否满足^-?[0-9]+$的正则模式，如果满足就表明它是一个整数。

#3.5test 判断的逻辑运算
#通过逻辑运算，可以把多个test判断表达式结合起来，创造更复杂的判断。三种逻辑运算AND，OR，和NOT，都有自己的专用符号。
# AND运算：符号&&，也可使用参数-a。
# OR运算：符号||，也可使用参数-o。
# NOT运算：符号!。

#下面是一个AND的例子，判断整数是否在某个范围之内。
##########
#  #!/bin/bash

#MIN_VAL=1
#MAX_VAL=100

#INT=50

#if [[ "$INT" =~ ^-?[0-9]+$ ]]; then
#  if [[ $INT -ge $MIN_VAL && $INT -le $MAX_VAL ]]; then
#    echo "$INT is within $MIN_VAL to $MAX_VAL."
#  else
#    echo "$INT is out of range."
#  fi
#else
#  echo "INT is not an integer." >&2
#  exit 1
#fi
##########
#上面例子中，&&用来连接两个判断条件：大于等于$MIN_VAL，并且小于等于$MAX_VAL。

#使用否定操作符!时，最好用圆括号确定转义的范围。
#############
#if [ ! \( $INT -ge $MIN_VAL -a $INT -le $MAX_VAL \) ]; then
#    echo "$INT is outside $MIN_VAL to $MAX_VAL."
#else
#    echo "$INT is in range."
#fi
#############
##上面例子中，test命令内部使用的圆括号，必须使用引号或者转义，否则会被 Bash 解释。

#3.6算术判断
#Bash 还提供了((...))作为算术条件，进行算术运算的判断。
#如果算术计算的结果是非零值，则表示判断成立。这一点跟命令的返回值正好相反，需要小心。

#3.7普通命令的逻辑运算
#如果if结构使用的不是test命令，而是普通命令，比如上一节的((...))算术运算，或者test命令与普通命令混用，那么可以使用 Bash 的命令控制操作符&&（AND）和||（OR），进行多个命令的逻辑运算。
#$ command1 && command2
#$ command1 || command2

#创建一个名为temp的目录，执行成功后，才会执行第二个命令，进入这个目录。
#$ mkdir temp && cd temp

#测试目录temp是否存在，如果不存在，就会执行第二个命令，创建这个目录。这种写法非常有助于在脚本中处理错误。
#$ [ -d temp ] || mkdir temp

#如果temp子目录不存在，脚本会终止，并且返回值为1。
#[ ! -d temp ] && exit 1

#下面就是if与&&结合使用的写法
#########
#if [ condition ] && [ condition ]; then
#  command
#fi
#########

#下面是一个示例。
#########
#  #! /bin/bash

#filename=$1
#word1=$2
#word2=$3

#if grep $word1 $filename && grep $word2 $filename
#then
#  echo "$word1 and $word2 are both in $filename."
#fi
#########
##上面的例子只有在指定文件里面，同时存在搜索词word1和word2，就会执行if的命令部分。

#4.case 结构
#case结构用于多值判断，可以为每个值指定对应的命令，跟包含多个elif的if结构等价，但是语义更好。它的语法如下。
#############
#case expression in
#  pattern )
#    commands ;;
#  pattern )
#    commands ;;
#  ...
#esac
#############
##上面代码中，expression是一个表达式，pattern是表达式的值或者一个模式，可以有多条，用来匹配多个值，每条以两个分号（;）结尾。
#############
#  #!/bin/bash

#echo -n "输入一个1到3之间的数字（包含两端）> "
#read character
#case $character in
#  1 ) echo 1
#    ;;
#  2 ) echo 2
#    ;;
#  3 ) echo 3
#    ;;
#  * ) echo 输入不符合要求
#esac
##############
##上面例子中，最后一条匹配语句的模式是*，这个通配符可以匹配其他字符和没有输入字符的情况，类似if的else部分。

#下面是另一个例子。
#########
#  #!/bin/bash

#OS=$(uname -s)

#case "$OS" in
#  FreeBSD) echo "This is FreeBSD" ;;
#  Darwin) echo "This is Mac OSX" ;;
#  AIX) echo "This is AIX" ;;
#  Minix) echo "This is Minix" ;;
#  Linux) echo "This is Linux" ;;
#  *) echo "Failed to identify this OS" ;;
#esac
#########
#上面的例子判断当前是什么操作系统。

#case的匹配模式可以使用各种通配符，下面是一些例子。
# a)：匹配a。
# a|b)：匹配a或b。
# [[:alpha:]])：匹配单个字母。
# ???)：匹配3个字符的单词。
# *.txt)：匹配.txt结尾。
# *)：匹配任意输入，通过作为case结构的最后一个模式。

###########
#  #!/bin/bash

#echo -n "输入一个字母或数字 > "
#read character
#case $character in
#  [[:lower:]] | [[:upper:]] ) echo "输入了字母 $character"
#			       ;;
#  [0-9] )                     echo "输入了数字 $character"
#			       ;;
#  * )                         echo "输入不符合要求"
#esac
###########
##上面例子中，使用通配符[[:lower:]] | [[:upper:]]匹配字母，[0-9]匹配数字。

##Bash 4.0之前，case结构只能匹配一个条件，然后就会退出case结构。Bash 4.0之后，允许匹配多个条件，这时可以用;;&终止每个条件块。
###########
#  #!/bin/bash
# test.sh

#read -n 1 -p "Type a character > "
#echo
#case $REPLY in
#  [[:upper:]])    echo "'$REPLY' is upper case." ;;&
#  [[:lower:]])    echo "'$REPLY' is lower case." ;;&
#  [[:alpha:]])    echo "'$REPLY' is alphabetic." ;;&
#  [[:digit:]])    echo "'$REPLY' is a digit." ;;&
#  [[:graph:]])    echo "'$REPLY' is a visible character." ;;&
#  [[:punct:]])    echo "'$REPLY' is a punctuation symbol." ;;&
#  [[:space:]])    echo "'$REPLY' is a whitespace character." ;;&
#  [[:xdigit:]])   echo "'$REPLY' is a hexadecimal digit." ;;&
#esac
############
##执行上面的脚本，会得到下面的结果。
#########
#$ test.sh
#Type a character > a
#'a' is lower case.
#'a' is alphabetic.
#'a' is a visible character.
#'a' is a hexadecimal digit.
#########
##可以看到条件语句结尾添加了;;&以后，在匹配一个条件之后，并没有退出case结构，而是继续判断下一个条件。
