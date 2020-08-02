# [Linux中.swp 文件的产生与解决方法](https://blog.csdn.net/qq_42200183/article/details/81531422)

.swp的产生
1.当你用多个程序编辑同一个文件时
#解决方法：
     选择readonly

2.非常规退出时
     当强行关闭vi时，比如电源突然断掉或者你使用了Ctrl+ZZ，vi自动生成一个.swp文件，下次再编辑时就会出现一些提示。
#解决方法：
      如果你正常退出，那么这个这个swp文件将会自动删除(vim编辑器要正常退出可以使用Shift-ZZ)。

用
```vi -r xxx.c```
来恢复文件，然后用

```rm -rf xxx.swp```
删除swp文件，不然每一次编辑时总是有这个提示。
