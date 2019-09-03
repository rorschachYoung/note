# mysql通过xampp或者wamp安装
## 连接mysql
#### 通过cmd连接
1. mysql -h [localhost] -P [3306] -u [root] -p [12345] 
2. -h接ip主机地址 -P表示端口号 -u -p表示用户名密码  
3. 简写 mysql -u root -p //xampp环境下没有密码  
4. mysql命令需要在mysql/bin目录下执行或者配置环境变量  
#### mysql基本查看命令
1. show databases 查看数据库  
2. use [databaseName]  进入[databaseName]数据库  
3. show tables 查看表  
4. select * from [tableName] 查看[tableName]表数据  
#### 修改phpMyAdmin和mysql密码
1. 通过phpMyAdmin页面修改mysql密码  
2. 需要修改配置文件config.inc.php，才可以通过phpMyAdmin的index页面输入密码登录   
3. 修改$cfg['Server'][$i]['auth_type'] = 'cookie'  || 原值为'config'  
#### 建表语句
```mysql
create table comment(
    id int primary key auto_increment,
    name char(20),
    pubtime datatime,
    content varchar(200)
)charset utf8
```
#### desc [tableName]
>+ desc user 查看表字段
#### insert
>+ 首先进入数据库，show databases,然后desc [user] 查看user表结构(表列字段)
>+ insert into user (uid,name,age) values (1,'zs',23)
>+ select * from user 查看表数据
>+ insert into user (name,age) values ('ls',19)因为uid自增长，可以不写
>+ insert into user values (5 ,'xx',22) 可以
>+ insert into user values ('ss', 22)  不可以，即使uid自增，k-v也要对应上
>+ insert into user values (5 ,'xx',22),(6,'ss',11) 插入多条
#### update 
>+ update user set name='sb' where uid=8  修改uid=8的name字段值为'sb'
>+ update user set  name='sb',age=29 where uid=8 修改多个字段值
>+ update user set name = 'sb' 没有where限制语句，就会把整张表全部name字段值改为'sb'
#### delete 
>+ delete from user where uid =1 
#### select 
>+ select * from user where uid = 1
>+ select uid,age,name from user 
>+ select uid,age,name from user where uid <= 5
>+ select uid,age,name from user where uid <= 5
>+ select uid,age,name from user where uid like "%1%"  %表示匹配任意个字符
#### 语句
where可用的运算符  + - * / % > >= <= = += !=   and  or not

between 13 and 16

in (1,3,5) 符合其中一个 

like "%1_"  %代表任意个任意字符  _代表一个任意字符

group by 分组

select age from student group by age 
显示所有出现的年龄信息
select age,count(*) as count from student group by age 
显示所有出现的年龄信息,并统计改年龄有多少数量
除了count函数还有avg() max() min() sum()

having 是删选group by之后的数据

order by  age      默认正序
order by  age asc  正序排列
order by  age desc 倒序排列

limit startnum  count  startnum 起始数据 count 数据条

#### 多表联合查询
select * from tablea as a join tableb as b on a.name = b.name

#### 左右连接
左链接查询表示以左表为主,连接上右表跟左表相同值得部分,如右表没有左表的值怎补齐null
select * from tablea as a join tableb as b on a.name = b.name
多表查询后会有相同的字段,可以通过左,右连接左右 来选用表的字段
或者从夺标查询的结果直接选取左右表的字段这样 也是一种方法
select a.name,a.age from tablea as a join tableb as b on a.name = b.name