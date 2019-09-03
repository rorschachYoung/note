# MongoDB

## 1.安装mongodb 
### 1.1 wget安装(源太慢了,不推荐)  
首先进入/usr/local/src目录   
>wget https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-rhel70-4.0.0.tgz  
然后解压    
>tar -zxvf mongodb-linux-x86_64-rhel70-4.0.0.tgz  
修改文件命名  
> mv mongodb-linux-x86_64-rhel70-4.0.0 mongodb 实际上做了一个拷贝剪切重命名操作  
创建日志目录和数据文件目录    
>cd /usr/local/src/mongodb/  
>mkdir -p data/logs  
>mkdir -p data/db 
### 1.2 yum安装
配置 mongodb repo
> cd /etc/yum.repos.d   
> vim mongodb-org-4.0.repo   
```bash
[mongodb-org-4.0]
name=MongoDB Repository
baseurl=http://mirrors.aliyun.com/mongodb/yum/redhat/7Server/mongodb-org/4.0/x86_64/
gpgcheck=0
enabled=1 
```
然后安装mongodb
>yum install -y mongodb-org
### 1.3 配置
>vim /etc/mongodb.conf
```bash
net:
    port:27017
    bindIp:0.0.0.1 #ipv6
```
### 1.4 设置开机启动
 systemctl enable mongod
 systemctl start mongod

## 2.MongoDB基本操作api
### 2.1 命令行数据库命令
可以在linux下直接运行mongodb的命令 mongod进入mongoDB的操作命令行,但我这边报了端口自被mongodb进程占用的错误,暂时还不知道怎么解决,但是输入mongo就可以进入mongodb的操作  
> mongo    √
> mongod 
这两条命令看情况使用吧,我这边是因为端口被mongod进程占用,可能在windows下就不会出现这个问题了  
1 db.stats() 展示数据库的基本信息  
2 show dbs   展示有哪些数据库  
3 use test   使用test名的数据库,进入数据库  
4 db         表示当前使用的是哪个数据库  
5 show collections 展示当前数据库有哪些集合(表)  
6 show tables      展示当前数据库有哪些集合(表)  
### 2.2 CRUD语句 
查询语句 
1 db.students.find({})  查询当前数据库下的students表的所有数据  
2 db.students.find({}).pretty()  json化展示查询结果   
3 db.students.find({}).skip(5).limit(5) 跳过5条限制结果数量为5条,分页语句
4 db.students.find({}).sort({_id:1})  根据_id属性进行排序 1 升序 -1 降序
5 db.students.find({$and:[{name:'hehe'},{isAdult:true}]})  And 查询条件  表示与&&
6 db.students.find({$or:[{name:'hehe'},{isAdult:true}]})   Or 查询条件   表示或||
添加语句
1 db.students.insert({name:'hehe',age:12})  当天数据库students表添加一条记录   
2 db.students.insert([{name:'hehe',age:12},{name:'hehe',age:12}])  参数可以是数组    
修改语句
1 db.students.update({age:17}.{$set:{age:18,isAdult:true})  将年龄是17岁的修改为18岁并添加字段标记成年  
删除语句   
1 db.students.remove({name:'hehe',age:12})  删除name等于hehe且age:12的记录  
### 2.3 表操作api
添加表(集合)  
db.createCollection('aaa')  当前数据库下添加aaa表(集合)  
删除表(集合)  
db.aaa.drop()               当前数据库下删除aaa表(集合)  

## 3.Node中连接mongodb
### 3.1 连接
安装mongodb连接模块
>npm i mongodb 
```js
    let mongodb = requrie('mongodb')
    /* 连接本地127.0.0.1:27017下面的test数据库 */
    let mongodbClient = mongodb.MongoClient.connect('mongodb://127.0.0.1:27017/test',(err,db)=>{
        if(err){
            console.log(err)
        }else{
            console.log('链接数据库成功',db)
        }
        db.close() //数据库连接未关闭之前 nodejs一直运行
    })
```
### 3.1 curd
```js
    let mongodb = requrie('mongodb')
    /* 连接本地127.0.0.1:27017下面的test数据库 */
    let mongodbClient = mongodb.MongoClient.connect('mongodb://127.0.0.1:27017/test',(err,db)=>{
        if(err){
            console.log(err)
        }else{
            console.log('链接数据库成功',db)
        }
        /* 选择数据库 */
        let testDB = db.db('test');
        /* curd */
        testDB.collection('students').find({age:{$gte:18}/* 查找大于等于18岁的 */},(err,result)=>{
            if(err){
                return console.log(err)
            }else{
                console.log(result)
            }
        })
        testDB.collection('students').insert({name:'hehe',age:12}/*插入一条数据*/},(err,result)=>{
            if(err){
                return console.log(err)
            }else{
                console.log(result)
            }
        })
        testDB.collection('students').update({name:'hehe'},{$set:{age:18}}},(err,result)=>{
            if(err){
                return console.log(err)
            }else{
                console.log(result)
            }
        })
        testDB.collection('students').remove({name:'hehe',age:12}},(err,result)=>{
            if(err){
                return console.log(err)
            }else{
                console.log(result)
            }
        })
        db.close() //数据库连接未关闭之前 nodejs一直运行
    })
```


