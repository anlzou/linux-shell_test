#1.字符串的长度
#${#varname}
#大括号{}是必需的，否则 Bash 会将$#理解成脚本的参数个数，将变量名理解成文本。
#myPath=/home/cam/book/long.file.name
# echo ${#myPath}
##29

#2.子字符串
#返回变量$varname的子字符串，从位置offset开始（从0开始计算），长度为length。
#${varname:offset:length}
#count=frogfootman
# echo ${count:4:4}
##foot

##如果省略length，则从位置offset开始，一直返回到字符串的结尾。
##如果offset为负值，表示从字符串的末尾开始算起。注意，负数前面必须有一个空格， 以防止与${variable:-word}的变量的设置默认值语法混淆。这时，如果还指定length，则length不能小于零。
#foo="This string is long."
# echo ${foo: -5}
##long.
# echo ${foo: -5:2}
##lo

#3.搜索和替换
#Bash 提供字符串搜索和替换的多种方法。
#（1）字符串头部的模式匹配
#以下两种语法可以检查字符串开头，是否匹配给定的模式。如果匹配成功，就删除匹配的部分，返回剩下的部分。原始变量不会发生变化。
################################################
# 如果 pattern 匹配变量 variable 的开头，
# 删除最短匹配（非贪婪匹配）的部分，返回剩余部分
#${variable#pattern}

# 如果 pattern 匹配变量 variable 的开头，
# 删除最长匹配（贪婪匹配）的部分，返回剩余部分
#${variable##pattern}
#################################################
#上面两种语法会删除变量字符串开头的匹配部分（将其替换为空），返回剩下的部分。区别是一个是最短匹配（又称非贪婪匹配），另一个是最长匹配（又称贪婪匹配）。
#匹配模式pattern可以使用*、?、[]等通配符。

#myPath=/home/cam/book/long.file.name
# echo ${myPath#/*/}
##cam/book/long.file.name
# echo ${myPath##*/}
##long.file.name

#$ phone="555-456-1414"
#$ echo ${phone#*-}
##456-1414
#$ echo ${phone##*-}
##1414

##如果匹配不成功，则返回原始字符串。
#如果要将头部匹配的部分，替换成其他内容，采用下面的写法。
# 模式必须出现在字符串的开头
#${variable/#pattern/string}

# 示例
#$ foo=JPG.JPG
#$ echo ${foo/#JPG/jpg}
##jpg.JPG

#（2）字符串尾部的模式匹配。
#以下两种语法可以检查字符串结尾，是否匹配给定的模式。如果匹配成功，就删除匹配的部分，返回剩下的部分。原始变量不会发生变化。

# 如果 pattern 匹配变量 variable 的结尾，
# 删除最短匹配（非贪婪匹配）的部分，返回剩余部分
#${variable%pattern}

# 如果 pattern 匹配变量 variable 的结尾，
# 删除最长匹配（贪婪匹配）的部分，返回剩余部分
#${variable%%pattern}
#上面两种语法会删除变量字符串结尾的匹配部分（将其替换为空），返回剩下的部分。区别是一个是最短匹配（又称非贪婪匹配），另一个是最长匹配（又称贪婪匹配）。

#$ path=/home/cam/book/long.file.name
#$ echo ${path%.*}
##/home/cam/book/long.file
#$ echo ${path%%.*}
##/home/cam/book/long

#下面写法可以删除路径的文件名部分，只留下目录部分
#path=/home/cam/book/long.file.name
#$ echo ${path%/*}
##/home/cam/book

#下面的写法可以替换文件的后缀名。
#$ file=foo.png
#$ echo ${file%.png}.jpg
##foo.jpg

#（3）任意位置的模式匹配。
#以下两种语法可以检查字符串内部，是否匹配给定的模式。如果匹配成功，就删除匹配的部分，换成其他的字符串返回。原始变量不会发生变化。
# 如果 pattern 匹配变量 variable 的一部分，
# 最长匹配（贪婪匹配）的那部分被 string 替换，但仅替换第一个匹配
#${variable/pattern/string}
# 如果 pattern 匹配变量 variable 的一部分，
# 最长匹配（贪婪匹配）的那部分被 string 替换，所有匹配都替换
#${variable//pattern/string}
#上面两种语法都是最长匹配（贪婪匹配）下的替换，区别是前一个语法仅仅替换第一个匹配，后一个语法替换所有匹配。

##$ path=/home/cam/foo/foo.name
#$ echo ${path/foo/bar}
##/home/cam/bar/foo.name
#$ echo ${path//foo/bar}
##/home/cam/bar/bar.name

#下面的例子将分隔符从:换成换行符。
#$ echo -e ${PATH//:/'\n'}
##/usr/local/bin
##/usr/bin
##/bin
##...
#上面例子中，echo命令的-e参数，表示将替换后的字符串的\n字符，解释为换行符。

#模式部分可以使用通配符。
#$ phone="555-456-1414"
#$ echo ${phone/5?4/-}
##55-56-1414

#如果省略了string部分，那么就相当于匹配的部分替换成空字符串，即删除匹配的部分。
#$ path=/home/cam/foo/foo.name
#$ echo ${path/.*/}
##/home/cam/foo/foo

#前面提到过，这个语法还有两种扩展形式。
# 模式必须出现在字符串的开头
#${variable/#pattern/string}
# 模式必须出现在字符串的结尾
#${variable/%pattern/string}

#4.改变大小写
#下面的语法可以改变变量的大小写。
#$ foo=heLLo
#$ echo ${foo^^}
##HELLO
#$ echo ${foo,,}
##hello
