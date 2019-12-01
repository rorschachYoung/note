
## Node连接mysql
安装mysql模块
> npm i mysql 
```js
const mysql = require('mysql')
const xss = require('xss')
let conn = mysql.createConnection({
    host:'localhost',
    user:'root',
    password:'12345',
    database:'test',
})
conn.connect((err,result)=>{
    let username = mysql.escape(username) /* 通过mysql提供的escape来对sql注入进行防范 */
    let title = xss(title) /* 防止xss跨域脚本攻击,对要插入数据库的内容进行转义 */
    conn.query(`select * from user where uername = ${username}`,(err,data)=>{
        console.log(err,data)
    })
    let data = { age : 12 , username: 'hehe' }
    /* ? 可以传对象 {} ,mysql包内部会处理 */
    conn.query(`upate user set ?`,[data],(err,data)=>{
        console.log(err,data)
    })
})
const mysql = require('mysql');
const pool  = mysql.createPool({
  connectionLimit : require('os').cpus().length,
  host            : 'localhost',
  user            : 'root',
  password        : '12345',
  database        : 'node_music'
});
let  query = function(sql,params){
    return new Promise(function(resolve,reject){
        pool.getConnection(function(err, connection) {
            if (err)reject(err);
            connection.query(sql, params,function (error, results, fields) {
              connection.release();
              if (error)reject(error);
              resolve(results,fields)
            });
        })
    })
}
conn.end() // 关闭连接，有回调
conn.destory() // 直接关闭连接，跟tcp链接

```
```JS
const mysql = require('mysql2')
let conn = mysql.createConnection({
    host:'localhost',
    user:'root',
    password:'12345',
    database:'test',
})
conn.connect((err,result)=>{
    conn.query('select * from user',(err,data)=>{
        console.log(err,data)
    })
})
``` 

```js
const mysql = require('mysql2/promise'); /*mysql2/promise.js*/
// const mysql = require('mysql2')   /*mysql2/index.js*/
(async function(){
    const connect =  await mysql.createConnection({
        host:'127.0.0.1',
        user:'root',
        password:'12345',
        database:'test',
    })
    let data = await connect.query('select * from user')
    console.log(data[0])
})();

```