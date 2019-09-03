# linux 基础命令
## 1.ifconfig
windows下面叫ipconfig，linux下面是interface config  
```bash  
[root@localhost Desktop]# ifconfig
eno16777728: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500  
        ether 00:0c:29:b1:b4:f3  txqueuelen 1000  (Ethernet)  
        RX packets 15  bytes 3462 (3.3 KiB)  
        RX errors 0  dropped 0  overruns 0  frame 0  
        TX packets 0  bytes 0 (0.0 B)  
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0  

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 0  (Local Loopback)
        RX packets 1154  bytes 98060 (95.7 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 1154  bytes 98060 (95.7 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0  
  
eno16777728 : 网卡名称  
inet 127.0.0.1 : ip 地址  
netmask 255.0.0.0 : 子网掩码   
ether 00:0c:29:b1:b4:f3 : mac地址  
RX packets 15  bytes 3462 (3.3 KiB)   收到的数据包 15个  大小3462 b  
TX packets 1154  bytes 98060 (95.7 KiB)  发送数据包1154个 大小98060 b  
lo 网卡的回环
```
## 2.uname
```js  
uname -m 显示机器的处理器架构(2)   
uname -r 显示正在使用的内核版本   

[root@localhost Desktop]# uname   
Linux  
[root@localhost Desktop]# uname -a   
Linux localhost.localdomain 3.10.0-123.el7.x86_64 #1 SMP Mon May 5 11:16:57 EDT 2014 x86_64 x86_64 x86_64 GNU/Linux  
 
linux : 内核  
localhost.localdomain ：主机名称  
3.10.0-123.el7.x86_64 #1 ：内核版本  
x86_64 x86_64 x86_64  : 64位系统  
GNU/Linux       ：开源项目GUN/Linux  


```
## 3.hostname
```
[root@localhost Desktop]# hostname   
localhost.localdomain   
 
localhost.localdomain ：主机名称,同上面2 uname的信息  
```
## 4.uptime  
查看系统负载情况，是top命令的第一行  
[root@localhost Desktop]# uptime  
 14:31:42 up  8:50,  2 users,  load average: 0.10, 0.12, 0.08  

14:31:42 #表示系统当前时间   

up 8:50 #开机8分钟 50s   

2 users #表示开启的bash窗口，当打开1个窗口，起始就是2users，2个窗口就是 +1 => 3 users    

load average: 0.00, 0.01, 0.05 #表示系统负载状况，数值最小0，越小越好，1表示满队列运行，  
                               #5行业称为睡不着觉，可能会系统崩溃，数字从右往左看  
            #0.00  第一段 表示1分钟系统负载0.00  #最新  
            #0.01  第二段 表示5分钟系统负载0.01  #5分钟前到现在  
            #0.05 第三段  表示15分钟系统负载0.05 #15分钟前到现在    

## 5.who last history   ！
who表示当前用户是谁  
[root@localhost Desktop]# who  
root     :0           2019-05-02 17:33 (:0)  
root     pts/0        2019-05-02 17:33 (:0)  

last表示的登录记录  

history表示输入过得命令历史  
1 who   
2 last  
3 history  
4 systemctl restart network  

！序号
!4 表示 执行history 的 systemctl restart network  

## 6.sosreport
求救报告 他会收集系统信息，生成压缩包   
## 7.cd pwd ls tree
cd 进入目录，change directory  
pwd 查看当前目录名称 pirnt working directory  
ls 列出当前目录文件和目录 ls -d 目录 ，ls -a 全部 ，ls -l long长格式信息  
tree / 树形目录   
tree -L 1 / 树一层-L level    
tree -d / 只显示目录     
        

cd ~ 个人中心目录 cd - 去上一次目录  

## 8.cat more head tail less
cat /proc/cpuinfo 显示CPU info的信息  
cat /proc/interrupts 显示中断  
cat /proc/meminfo 校验内存使用  
cat /proc/swaps 显示哪些swap被使用  
cat /proc/version 显示内核的版本   
cat /proc/net/dev 显示网络适配器及统计  
cat /proc/mounts 显示已加载的文件系统  
推荐cat查看小文件，  
推荐more 看大文件  
head -n 5 anaconda-ks.cfg 查看anaconda-ks.cfg前 5 行  
head -5 anaconda-ks.cfg  查看前5行  

tail -n 5 anaconda-ks.cfg  查看后5行  
tail -5 anaconda-ks.cfg  查看后5行  

tail -f /var/log/messages 实时查看文件(一直刷新文件)  

less filename 一页一页查看文件内容     
下一页: 空格 或者 f  
上一页  b  
退出q  
## 9.wc
统计文件的 行数，单词数，字节数  
wc -l anaconda-ks.cfg  行数 46   
wc -w anaconda-ks.cfg  单词数 99    
wc -c anaconda-ks.cfg  字节数  1044  

## 10.stat
[root@localhost ~]# stat anaconda-ks.cfg   
  File: ‘anaconda-ks.cfg’  
  Size: 1044      	Blocks: 8          IO Block: 4096   regular file  
Device: fd00h/64768d	Inode: 68432300    Links: 1  
Access: (0600/-rw-------)  Uid: (    0/    root)   Gid: (    0/    root)  
Context: system_u:object_r:admin_home_t:s0  
Access: 2019-05-07 16:00:31.718626724 +0800  
Modify: 2019-05-02 16:32:19.039967155 +0800  
Change: 2019-05-02 16:32:19.039967155 +0800  
 Birth: -  
 
Access: 最后一次访问内容的时间  
Modify：最后一次修改文件内容的时间  
change：最后一次修改属性和权限信息的时间  

## 11.cut
cut -d : -f 1 /etc/passwd    
-d 指定间隔符  ： 表示根据 字符： 来截取  
-f 指定提取出来的列数  
 
## 12.diff
--brief 长格式  
diff --brief  a.txt b.txt  
比较 a b 文件是否是不一样的  
diff -c  a.txt b.txt  
输出文件ab 的不同处  

## 13.touch mkdir cp mv rm
touch newfile : 新建 newfill文本文件,如果是已经存在的文件,则是修改创建日期等属性,而不会改变内容  
touch {1..5}.txt 生成1.txt 2.txt 3.txt 4.tXt 5.tXt  
touch -d  20:00 newfile  
修改 Modify时间，stat可以查看Access，Modify,Change,  

mkdir 新建目录   
mkdir -p a/b/c  创建嵌套目录  

cp a b 复制文件a 到文件b  
cp -r Deektop/  dir/    
-r递归复制目录到 dir  
-p 保持文件属性，权限时间   
-d 如果是连接怎么复制连接本身  
-a = -dpr 保持文件属性 递归和链接  
-v view显示复制信息

mv  dir/  newdir  
剪切目录到 newdir  
也可以当做重命名操作  
mv -t /opt a.txt   -t反着操作 把a.txt 剪切到 /opt  

rm newfile 删除文件  
rm -f newfile --force 强制删除文件  
rm -r -f dir  rm -rf   
强制递归删除 dir目录  
## 14.dd
dd if=anaconda-ks.cfg of=newfile.cfg  bs=30  count=1  
if=> input file  
of=> ouput file   
表示 io file  
bs 表示一次取出来的字节大小 单位是byte  
count 表示取出来多少次  
## 15.file 
查看文件目file录信息  
file anaconda-ks.cfg   
anaconda-ks.cfg : ASCII text  
file Desktop/   
Desktop/ ： directory  
    

## 16.tar 
 czvf cjvf  
1 c ： 打包  
2 z ： gzip压缩格式   .tar.gz  
  l ： bzip2压缩格式  .tar.bz2  
tip: z 表示 zip 格式，l 表示 rar 格式  
3 v ： 显示打包跟压缩的过程  
4 f :  压缩包名称  
-C  大写 C是解压到指定目录  
打包压缩 tar czvf newzip.tar.gz  /etc   

解压缩 tar xzvf newzip.tar.gz /newdir  

tar -t  newzip.tar.gz  不会解压，查看压缩包里面的文件  

## 17.grep 
前文的cut是按列 ，grep是按行  
grep config anaconda-ks.cfg   
显示 文件中包含config的行  
grep -n config anaconda-ks.cfg   
显示 文件中包含config的行 并显示行号  
grep -v config anaconda-ks.cfg 
反选不包含config的内容
-i 忽略大小写

## 18.find  
  -name 指定搜索的名称  
  -user 指定用户，搜索该用户的所有文件  
 
find / -name fstab  
查询  根目录下  的所有包含fstab的文件(目录是特殊文件)  
/etc/fstab  
/root/etc/fastab  

find / -user root  
查询  根目录下 所有属于root的文件  
tip:  搜索proc目录会报错  

find / -size +4k  , find / -szie  -5m 
根据大小     大于4k              小于5m

find / -perm  0777  根据权限搜索  permission