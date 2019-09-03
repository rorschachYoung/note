# 基础命令
## 1. 重定向 > 2> >> 2>>
输出重定向 分为两种,一种是标准 ,例如 ls -l a.txt 或者 echo aaaaa > a.txt   
会显示目录下的a.txt文件  
并且将显示信息输出到tty ,如果使用 > ,  $ls -l a.txt > command.log 则表示将信息输出到文件中
```bash
    ls -l a.txt >  command.log 将正确信息输出到comman.log 中  
    ls -l b.txt 2>  command.log 因为是错误输出 则无法用 > 输出,必须使用 2> 来输出  
    > 跟 2> 都表示输出(清空覆盖)  
    >> 2>> 表示追加 append  

    特殊 :  &> 不论是错误还是标准输出  都写入到指定文件  

    wc -l <  a.txt 将a.txt输出到 wc -l 显示文件有多少行  
```
## 2. 管道符 | 
表示将上一个命令的输出结果输入到下一个命令
```bash
    grep /bin/bash /etc/passwd | wc -l 
    # 首先是 在/etc/passwd 目录下查找带有 /bin/bash 的行  然后输出到 wc -l  
    # wc -l 统计有多少行
    ls /etc  | wc -l 
    # ls /etc 是列出该目录有多少文件信息  然后将结构输入到 wc -l 统计行数

    echo 12345 | passwd --stdin root 
    # passwd  --stdin root  将输出流 作为值  给 root 重新设置密码
```

## 3.环境变量
```bash
    echo $SHELL # /bin/bash
    echo $HISTSIZE # 500  history历史记录条数
    echo $LANG  # en_US.UT-8
    echo $RANDOM # 输出随机数字

    
```

## 4.whereis 
whereis ls #/bin/bash/ls ..

## 5.环境变量的权限切换
```
#  workspace=/xxx/x/x/xxx 为了方便设置一个工作文件夹的环境变量  
#  echo $workspace  /xxx/x/x/xxx  
#  cd $workspace    
#  su test 切换到test用户  
$  echo $workspace  此时环境变量为空  
所以需要设置全局变量提升  
$  exit 退出用户切换  
#  export workspace  全局变量提升  
#  su test   
$  cd workspace 进入工作目录  

注意 : 以上操作只在 当前运行状态下生效,关机后无效,  
环境变量的永久生效配置需要修改 /etc/profile 然后 source /etc/profile  

```


## vim介绍
vim 有三个模式 ,1 命令模式 2 编辑模式  3 末行模式    
vim a.txt 进入命令模式,此时可以用上下左右移动光标  
敲击 a i o 进入编辑模式  
1.敲击 a   当前光标后移,进入编辑模式. 也就是在光标的下一个位置进入编辑模式    
2.敲击 i   当前光标位置进行编辑  
3.敲击 o   当前光标进入新开下一行,进入编辑模式  
进入编辑模式后   
可以按esc 进入末行模式  
:set nu    输入:set no 设置显示行号
:set nonu  输入:set nonu 设置取消显示行号
:wq!  输入:wq! 表示强制!写入write退出quit   
HJKL 左上下右
## vim快捷键
vim a.txt 进入命令模式
yy  表示  复制
dd  表示  剪切/删除 
p   表示  粘贴
u   表示  撤销一次操作
g   表示  go迅速定位文件顶部
G   表示  go(反)迅速定位到文件尾部
3gg 表示  去第3行
3G  表示  去第3行
:3  表示  去第3行
都是行操作
3dd 表示剪切3行,可取 n
HJKL 左上下右
shift,^    行首
shift,$   行尾
shift,%   本行括号之间跳转
ctrl+b   back向上翻页
ctrl+f   forward向下翻页
H     header快速定位顶部
M     middle快速定位中间
L     low快速定位尾部
[     向上跳到段落

]     向下跳到段落