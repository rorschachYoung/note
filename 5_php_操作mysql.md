#php操作mysql
#### phpinfo
>+ phpinfo() 返回php相关信息
#### mysqli_connect mysqli_close mysql _query
```php
//php7
// 返回一个对象通道标识,mysqli_connect
$link = mysqli_connect('localhost','root','12345','test')
//设置字符集,mysqli_query
mysqli_query($link,'set names utf8')//第二个参数为sql语句
$sql = " insert into user(uid,name,age) values (1,'xx',18)";
$res = mysqli_query($link,$sql)
var_dump($res);//true


$name = 'xx';
$age = 20
$sql2 = "updata user set name='$name',age=$age where uid = 1"
$res2 = mysqli_query($link,$sql2)
//增删改===> return Boolean
var_dump($res2);//true


$sql3 = "select * from user"
$res3 = mysqli_query($link,$sql3);
//show select  describe explain  ====>return Object
var_dump($res3) //object
mysqli_close()
```
```php
//php5.x
//返回一个resource通道标识，mysql_connect()
$link = mysql_connect('localhost','root','12345')
//选择数据库
mysql_query($link,'use test')
//设置字符集，mysql_query
mysql_query($link,'set names utf8')
```
#### mysqli_fetch_xxxx函数
```php

$link = mysqli_connect('localhost','root','12345','test')
mysqli_query($link,'set names utf8')
$sql = "select * from user";
$res = mysqli_query($link,$sql)//返回一个mysql_result
//mysql_fetch_assoc函数每用一次指针指向下一个值，
//下一次调用该函数操作$res会返回下一个值
$arr=mysqli_fetch_assoc($res)//获取res里第一项，返回[关联数组]，指针后移
//返回关联数组或索引数组或二者，指针后移
$arr=mysqli_fetch_array($res)
//返回索引数组，指着后移
$arr=mysqli_fetch_row($res)
//这三个函数操作同一个$res，指针也使用同一个，只是返回的数据格式略有不同
//$arr =>         uid => 1          0 => 2         0 => 3
//               age =>  18        1 => 19        uid => 3
//               name => 'xxx'     3 => 'yyy'     1 => 20
//                                                age => 20
//                                                3 => 'zzz'
//                                                name => 'xxx'
//           assoc=>关联数组      row=>索引数组    array=>返回两种数组
mysqli_close()
```
#### 用while遍历，mysqli_error,exit,mysqli_inert_id,mysqli_affected_rows
```php
$link = mysqli_connect('localhost','root','12345','test')
mysqli_query($link,'set names utf8')
$sql = "select * from user";
$res = mysqli_query($link,$sql);
$data = array();
//判断是否执行成功，成果返回mysqli_result结果，失败返回boolean
if(!$res){
    //返回值$res是fasle进入判断
    //输出mysql错误信息,不输出php之类错误
    mysqli_error($link);
    //解释执行sql
    exit()
}
//返回最近执行的sql语句的 主键
echo mysqli_insert_id($link)
//返回最近执行的sql语句的 影响行数
echo mysqli_affected_rows($link)

while($arr = mysqli_fetch_assoc($res)){
    //会生成二维索引数组，0,1,2,3,4....
    $data[] = $arr
    print_r($arr)
}
mysqli_close()
```

## php输出
+ var_dump 一般输出boolean
+ print_r 一般输出对象数组
+ echo 一般输出字符
## php报错
+ notice 注意
+ warning 警告
+ fatal error 致命报错
+ deprecated 不推荐
## 屏蔽报错
```php
error_reporting(E_ALL ^ E_DEPRECATED) //^异或
```
