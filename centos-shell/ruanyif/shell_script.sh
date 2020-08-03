#脚本（script）就是包含一系列命令的一个文本文件。Shell 读取这个文件，依次执行里面的所有命令，就好像这些命令直接输入到命令行一样。所有能够在命令行完成的任务，都能够用脚本完成。

#脚本的好处是可以重复使用，也可以指定在特定场合自动调用，比如系统启动或关闭时自动执行脚本。

#1.Shebang 行
#脚本的第一行通常是指定解释器，即这个脚本必须通过什么解释器执行。这一行以#!字符开头，这个字符称为 Shebang，所以这一行就叫做 Shebang 行。
#   #!后面就是脚本解释器的位置，Bash 脚本的解释器一般是/bin/sh或/bin/bash。

#如果 Bash 解释器不放在目录/bin，脚本就无法执行了。为了保险，可以写成下面这样。
#   #!/usr/bin/env bash

#2.执行权限和路径
# 给所有用户执行权限
##$ chmod +x script.sh
# 给所有用户读权限和执行权限
##$ chmod +rx script.sh
# 或者
##$ chmod 755 script.sh
# 只给脚本拥有者读权限和执行权限
##$ chmod u+rx script.sh

#脚本的权限通常设为755（拥有者有所有权限，其他人有读和执行权限）或者700（只有拥有者可以执行）。

#####################################
#除了执行权限，脚本调用时，一般需要指定脚本的路径（比如path/script.sh）。如果将脚本放在环境变量$PATH指定的目录中，就不需要指定路径了。因为 Bash 会自动到这些目录中，寻找是否存在同名的可执行文件。

#建议在主目录新建一个~/bin子目录，专门存放可执行脚本，然后把~/bin加入$PATH。

#export PATH=$PATH:~/bin
#上面命令改变环境变量$PATH，将~/bin添加到$PATH的末尾。可以将这一行加到~/.bashrc文件里面，然后重新加载一次.bashrc，这个配置就可以生效了。

#$ source ~/.bashrc
#以后不管在什么目录，直接输入脚本文件名，脚本就会执行。

#$ script.sh
#上面命令没有指定脚本路径，因为script.sh在$PATH指定的目录中。
######################################

#3.env 命令
#env命令总是指向/usr/bin/env文件，或者说，这个二进制文件总是在目录/usr/bin。
#  #!/usr/bin/env NAME这个语法的意思是，让 Shell 查找$PATH环境变量里面第一个匹配的NAME。如果你不知道某个命令的具体路径，或者希望兼容其他用户的机器，这样的写法就很有用。
#/usr/bin/env bash的意思就是，返回bash可执行文件的位置，前提是bash的路径是在$PATH里面。其他脚本文件也可以使用这个命令。比如 Node.js 脚本的 Shebang 行，可以写成下面这样。
###!/usr/bin/env node
#env命令的参数如下:
#-i, --ignore-environment：不带环境变量启动。
#-u, --unset=NAME：从环境变量中删除一个变量。
#--help：显示帮助。
#--version：输出版本信息。

#下面是一个例子，新建一个不带任何环境变量的 Shell。
#$ env -i /bin/sh

#4.注释
#Bash 脚本中，#表示注释，可以放在行首，也可以放在行尾

#5.脚本参数
#调用脚本的时候，脚本文件名后面可以带有参数。
##$ script.sh word1 word2 word3
##脚本文件内部，可以使用特殊变量，引用这些参数。
# $0：脚本文件名，即script.sh。
# $1~$9：对应脚本的第一个参数到第九个参数。
# $#：参数的总数。
# $@：全部的参数，参数之间使用空格分隔。
# $*：全部的参数，参数之间使用变量$IFS值的第一个字符分隔，默认为空格，但是可以自定义。
#如果脚本的参数多于9个，那么第10个参数可以用${10}的形式引用，以此类推。
#注意，如果命令是command -o foo bar，那么-o是$1，foo是$2，bar是$3。

# #!/bin/bash
# script.sh

#echo "全部参数：" $@
#echo "命令行参数数量：" $#
#echo '$0 = ' $0
#echo '$1 = ' $1
#echo '$2 = ' $2
#echo '$3 = ' $3

# $ ./script.sh a b c
#全部参数：a b c
#命令行参数数量：3
# $0 =  script.sh
# $1 =  a
# $2 =  b
# $3 =  c

#用户可以输入任意数量的参数，利用for循环，可以读取每一个参数。
#  #!/bin/bash
#for i in "$@"; do
#  echo $i
#done

#如果多个参数放在双引号里面，视为一个参数。
#$ ./script.sh "a b"

#6.shift 命令
#shift命令可以改变脚本参数，每次执行都会移除脚本当前的第一个参数（$1），使得后面的参数向前一位，即$2变成$1、$3变成$2、$4变成$3，以此类推。
##########################
#  #!/bin/bash
#echo "一共输入了 $# 个参数"
#while [ "$1" != "" ]; do
#  echo "剩下 $# 个参数"
#  echo "参数：$1"
#  shift
#done
##########################
##shift命令可以接受一个整数作为参数，指定所要移除的参数个数，默认为1。

#7.getopts 命令
#getopts命令用在脚本内部，可以解析复杂的脚本命令行参数，通常与while循环一起使用，取出脚本所有的带有前置连词线（-）的参数。
##getopts optstring name
##它带有两个参数。第一个参数optstring是字符串，给出脚本所有的连词线参数。比如，某个脚本可以有三个配置项参数-l、-h、-a，其中只有-a可以带有参数值，而-l和-h是开关参数，那么getopts的第一个参数写成lha:，顺序不重要。注意，a后面有一个冒号，表示该参数带有参数值，getopts规定带有参数值的配置项参数，后面必须带有一个冒号（:）。getopts的第二个参数name是一个变量名，用来保存当前取到的配置项参数，即l、h或a。
#下面是一个例子。
####################
#while getopts 'lha:' OPTION; do
#  case "$OPTION" in
#    l)
#      echo "linuxconfig"
#      ;;
#
#    h)
#      echo "h stands for h"
#      ;;
#
#    a)
#      avalue="$OPTARG"
#      echo "The value provided is $OPTARG"
#      ;;
#    ?)
#      echo "script usage: $(basename $0) [-l] [-h] [-a somevalue]" >&2
#      exit 1
#      ;;
#  esac
#done
#shift "$(($OPTIND - 1))"
####################
##上面例子中，while循环不断执行getopts 'lha:' OPTION命令，每次执行就会读取一个连词线参数（以及对应的参数值），然后进入循环体。变量OPTION保存的是，当前处理的那一个连词线参数（即l、h或a）。如果用户输入了没有指定的参数（比如-x），那么OPTION等于?。循环体内使用case判断，处理这四种不同的情况。
##如果某个连词线参数带有参数值，比如-a foo，那么处理a参数的时候，环境变量$OPTARG保存的就是参数值。
##注意，只要遇到不带连词线的参数，getopts就会执行失败，从而退出while循环。比如，getopts可以解析command -l foo，但不可以解析command foo -l。另外，多个连词线参数写在一起的形式，比如command -lh，getopts也可以正确处理。
##变量$OPTIND在getopts开始执行前是1，然后每次执行就会加1。等到退出while循环，就意味着连词线参数全部处理完毕。这时，$OPTIND - 1就是已经处理的连词线参数个数，使用shift命令将这些参数移除，保证后面的代码可以用$1、$2等处理命令的主参数。

#8.配置项参数终止符 --
#变量当作命令的参数时，有时希望指定变量只能作为实体参数，不能当作配置项参数，这时可以使用配置项参数终止符--。
#--强制变量$myPath只能当作实体参数（即路径名）解释。
#如果变量不是路径名，就会报错。
#$ myPath="-l"
#$ ls -- $myPath
##ls: 无法访问'-l': 没有那个文件或目录

#9.exit 命令
#exit命令用于终止当前脚本的执行，并向 Shell 返回一个退出值，作为整个脚本的退出状态。
#exit命令后面可以跟参数，该参数就是退出状态。
#退出时，脚本会返回一个退出值。脚本的退出值，0表示正常，1表示发生错误，2表示用法不对，126表示不是可执行脚本，127表示命令没有发现。如果脚本被信号N终止，则退出值为128 + N。简单来说，只要退出值非0，就认为执行出错。
#exit与return命令的差别是，return命令是函数的退出，并返回一个值给调用者，脚本依然执行。exit是整个脚本的退出，如果在函数之中调用exit，则退出函数，并终止脚本执行。

#10.命令执行结果
#命令执行结束后，会有一个返回值。0表示执行成功，非0（通常是1）表示执行失败。环境变量$?可以读取前一个命令的返回值。

# 第一步执行成功，才会执行第二步
##cd $some_directory && rm *
# 第一步执行失败，才会执行第二步
##cd $some_directory || exit 1

#11.source 命令
#source命令用于执行一个脚本，通常用于重新加载一个配置文件。
#$ source .bashrc
#source命令最大的特点是在当前 Shell 执行脚本，不像直接执行脚本时，会新建一个子 Shell。所以，source命令执行脚本时，不需要export变量。

#source命令的另一个用途，是在脚本内部加载外部库。
############
#!/bin/bash
#source ./lib.sh
#function_from_lib
############
#上面脚本在内部使用source命令加载了一个外部库，然后就可以在脚本里面，使用这个外部库定义的函数。

#source有一个简写形式，可以使用一个点（.）来表示。
#. .bashrc

#12.别名，alias 命令
#alias命令用来为一个命令指定别名，这样更便于记忆。下面是alias的格式。
#alias NAME=DEFINITION

#上面命令中，NAME是别名的名称，DEFINITION是别名对应的原始命令。注意，等号两侧不能有空格，否则会报错。

#一个常见的例子是为grep命令起一个search的别名。
#alias search=grep

#alias也可以用来为长命令指定一个更短的别名。下面是通过别名定义一个today的命令。
#$ alias today='date +"%A, %B %-d, %Y"'
#$ today
##星期一, 一月 6, 2020

#有时为了防止误删除文件，可以指定rm命令的别名。
#$ alias rm='rm -i'
#上面命令指定rm命令是rm -i，每次删除文件之前，都会让用户确认。

#alias定义的别名也可以接受参数，参数会直接传入原始命令。
#$ alias echo='echo It says: '
#$ echo hello world
##It says: hello world
#上面例子中，别名定义了echo命令的前两个参数，等同于修改了echo命令的默认行为。

#直接调用alias命令，可以显示所有别名。
#$ alias

#unalias命令可以解除别名。
#$ unalias lt
