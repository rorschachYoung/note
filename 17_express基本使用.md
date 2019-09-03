## Express 基本使用
#### 1、基本使用
```js
    const express = require('express')
    let app = new express();
    app.get('./',(req,res)=>{
        res.end('我是express创建的实例')
    })
    app.post('./',(req,res)=>{
        res.end('我也是')
    })
    app.listen(8888,()=>{console.log('port on 8888')})
```
#### 2、express内置路由使用
```js
    //router.js
    let router = express.router();
    router.get('./',(req,res)=>{
        res.end('我是express创建的实例')
    })
    //可以链式调用
    .post('./',(req,res)=>{
        res.end('我也是')
    })

    router.get('/index.html',(req,res)=>{
        res.end('我也是')
    })
    module.exports = router;

    //app.js
    let app =new express();
    app.use(require('./router.js'))//app.use(router)
    app.listen(8888,()=>{console.log('port on 8888')})
```
#### 3、express-static静态资源处理
```js
    const express = require('express')；
    let app  = new express();
    app.use(express.static('public'))//静态化public文件夹下的静态文件
    //可以通过http://localhost:8888/img/1.jpg  =>服务器目录/public/img/1.jpg
```
#### 4、express-art-template模板引擎使用
 ```js
    const art = require('express-art-template')
    const express = require('express')
    let app = new express();
    aap.engine('html',art)//html=>extension扩展名 art=>模板引擎
    app.set('view options', {
        debug: process.env.NODE_ENV !== 'production'
    });
    //使用方式
    app.get('/',(req,res)=>{
        //res.render取代了res.end，其内部会end
        //res.render('filepath')默认会去/views/下面查找静态文件
        res.render('./index.html',{/* data对象*/})
     
    })
 ```
 #### 5、express封装的req对象
