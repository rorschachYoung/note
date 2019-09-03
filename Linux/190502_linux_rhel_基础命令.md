# linux基础命令
## 一、bash脚本
一般linux命令有三个组成部分，1命令，2参数，3对象。  
命令就是你要执行的功能，如systemctl ls等。  
参数，分为长短格式，短格式就是 -字母，-a -l -s 等，为简写形式  
长格式就是  -单词   -all -list 等，为单词全拼。 
短格式之间可以简写 如 -a -l  =>   -al,只有短格式可以合并，其他形式不可    
当然这只是普遍情况下是这样规划命令参数的，也有例外。
**TTY**指的是命令终端，你开了几个命令行窗口tab就是几个，
**pts**指的是命令终端tab
## 二、进程5种状态
```bash
    R   #正在进行服务              # running
    S   #暂停 等待 服务            # sleep
    D   #不响应系统，或在为用户服务 
        #D类似windows的窗口无响应
    Z   #僵尸进程不受系统控制       #zombie
        #不会为用户提供服务
    T   #停止为用户服务      

    #运行级别       
    0  #关机(危害度等于 rm -rf /)
    1  #单用户模式(root密码忘记可以用这个方式更好找回)
    2  #没有NFS的多用户模式
    3  #命令行模式 文本模式(企业服务器运行状态)
    4  #未使用
    5  #图形化模式 桌面模式 
    6  #重启 同1
    查看运行级别命令 runlevel 或者 who -r
    systemctl  get-default 查看运行级别 => mutli-user.target
    systemctl  set-default graphical.target  设置运行级别为图形
    systemctl  set-default poweroff.target  设置运行级别0,即关机

```
### systemctl 命令
```bash 
    systemctl restart  [task]  重启服务
    systemctl start  [task]    开启服务
    systemctl stop   [task]    关闭服务
    systemctl enable   [task]    加入开机启动项
    systemctl disable   [task]    取消开机启动项
    systemctl status   [task]    查看服务状态
```


## 三、简单命令
### 1、reboot poweroff
reboot 重启，poweroff关机(关闭电源)
halt 关机 无法取消

shutdown -h 10  -h=>halt 10分钟关机
shutdown -h now 立刻关机
shutdown -h 0  立刻关机

shutdown -c  取消关机

shutdown -r  -r=>reboot 10分钟重启
### 2、echo
```bash
    echo  1      # printf 1
    echo  abc    # printf abc
    echo  $SHELL  # /bin/bash 输出shell环境变量地址
    echo  \$      # $转义
    echo  "shell is $SHELL" #shell is /bin/bash 
    echo  '$SHELL'  # $SHELL 
    #注意 '  单引号表示全局转义 整个 '的内容都会转义

    #注意
    #首先添加一个变量   
    command=`uptime` #用模板字符串放入命令
    echo $command  # 模板字符创的命令就会被执行
    unset command
```
### 3、date
```bash
    date  # Thu May  2 18:05:11 CST 2019
    date +%Y+%m+%d+%H+%M+%S   #2019+05+02+18+07+28
    date '+%Y+%m+%d+%H+%M+%S'   #2019+05+02+18+07+28
    date "+%Y+%m+%d+%H+%M+%S"   #2019+05+02+18+07+28
  X date +%Y-%m-%d %H:%M:%S 中间有空格就是两条命令 需要连起来或者“”


``` 
### 4、wget
```bash 
    wget https://www.baidu.com/a.txt #下载文件保存到当前目录
```

### 5、ls
```bash
    ls     #列出文件列表
    ls -a  列出所有
    ls -l  long 列出所有详细信息
    ls -h  按照文件大小显示 kb Mb Gb
```
### 6、ps
```bash
    ps #列出进程信息
    ps -a # 列出所有进程
    ps -u # 列出进程详细信息
    ps -x # 包括系统启动的进程
    ps -axu #列出所有进程的详细信息
```
### 7、top
  top跟ps的区别: top显示的是动态列表，top显示部分常用的进程，类似windows的任务管理器
```bash
:<<!comment
    [root@localhost Desktop]# top

    top - 18:27:34 up 55 min,  2 users,  load average: 0.00, 0.01, 0.05
    Tasks: 519 total,   1 running, 518 sleeping,   0 stopped,   0 zombie
    %Cpu(s):  7.3 us,  0.9 sy,  0.0 ni, 91.8 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
    KiB Mem:   2035648 total,   915860 used,  1119788 free,      896 buffers
    KiB Swap:  2097148 total,        0 used,  2097148 free.   258628 cached Mem  
    PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND  
    2345 root      20   0 1726508 282764  38316 R  53.4 13.9   4:56.04 gnome-she+       
!comment
#解释对上面的输入

top #表示命令  

18:27:34 #表示当前时间  

up 55 min #开机55分钟  

2 users #表示开启的bash窗口，当打开1个窗口，起始就是2users，2个窗口就是 +1 => 3 users  

load average: 0.00, 0.01, 0.05 #表示系统负载状况，数值最小0，越小越好，1表示满队列运行，
                               #5行业称为睡不着觉，可能会系统崩溃，数字从右往左看
            #0.00  第一段 表示1分钟系统负载0.00  #最新
            #0.01  第二段 表示5分钟系统负载0.01  #5分钟前到现在
            #0.05 第三段  表示15分钟系统负载0.05 #15分钟前到现在  

Tasks: 519 total,   1 running, 
518 sleeping,   0 stopped,   0 zombie 
            #总共519个进程，1个运行，519个沉睡，0个暂停服务，0个僵尸进程  

%Cpu(s):  7.3 us,  0.9 sy,  0.0 ni, 91.8 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
          #7.3 us  表示cpu使用%比
          #91.8 id  cou控显率  

KiB Mem:   2035648 total,   915860 used,  1119788 free,      896 buffers
         #2035648 total  2035648 kb 内存
         #915860 used   915860kb 内存使用
         #1119788 free   1119788 内存空闲
         #896 buffers   cpu跟内存，内存跟硬盘交互数据的量，用于调优  

KiB Swap:  2097148 total, 0 used,  2097148 free.   258628 cached Mem
       #交换分区临时充当内存的资源  

PID USER      PR  NI    VIRT    RES    SHR   S    %CPU %MEM     TIME+    COMMAND  
2345 root     20  0    1726508 282764  38316  R   53.4 13.9     4:56.04  gnome-she+ status
#类似于windows任务管理器
# PID 进程id
# USER  进程发起者
# PR  NI 表示进程优先级，数值越低，优先级越高
# VIRT
# RES
# SHR 
# S  表示status进程状态， RSDZT
# %CPU  表示使用的cpu率
# %MEM  表示使用的mem率
# TIME+ 进程开启时间
# COMMAND  进程命令名称
```
### 8、pidof 
```bash
    pidof sshd #1620 显示具体进程id
```
### 9、kill  killall
```bash
    # kill + pid   killall + commond  
    kill 1620 # 关闭sshd进程
    #有些服务高并发有多个进程，这是需要killall服务
    killall sshd #关闭全部sshd进程
    stystmctl restart sshd
```

