## 服务器对象http.createServer()
```js
    //简写
    http.createServer((req,res)=>{
        res.end('666')
    }).listen(8888)

    //import http module
    const http =require('http');
    //start a server 
    let server = http.createServer();
    //server bind a request enevt,response end with '草泥马'
    server.on('request',(req,res)=>{
        console.log(req.headers);//请求头
        console.log(req.url);    //请求行
        console.log(req.method); //请求行
        // req.on('data',(data)=>{  //请求体
        //     console.log(data.toString());           
        // })
        res.setHeader('a','a')//可多次写头
        res.setHeader('b','b')//可多次写头
        //一次性写头一定写在多次后面
        // res.writeHead(200,{'a':'22','b':'b'})
        res.writeHead(200,{'content-type':"text/html;charset=utf-8"})
        //写体
        res.write('我是body')
        res.write('草泥马')
        res.end('草泥马')
    })
    let port = 8888;
    //listen port 8888
    server.listen(port,()=>{
        console.log(`服务器启动在${port}端口`);

})
```
#### 长状态连接demo
```js
let http = require('http');
let fs= require('fs')
http.createServer((req,res)=>{
    if(req.url==='/'){
       
        fs.readFile('./1.html',(err,data)=>{
            res.writeHead(200,{
                'content-type':'text/html;charset=utf-8'
            })
            res.end(data)
        })
    }else if(req.url==="/test" && req.method==="GET"){
        //通过write不停地写到浏览器保持状态链接，长连接
        res.writeHead(200,{"content-type":"application/octet-stream"})
        setInterval(() => {
            res.write(''+Date.now())
        }, 1000);
        // res.end('get /test')
    }
}).listen(8888,console.log('8888'))
```
#### 客户端原生xhr接收
```js
btn.onclick= function(){
             
            var xhr = new XMLHttpRequest();
            xhr.open('get','/test');
            

            xhr.send(null)
            xhr.onreadystatechange=function(){
                console.log(xhr.responseText);
                //xhr.readyState ===3 状态下保持长连接状态
                document.querySelector("#box").innerHTML = xhr.responseText
                // if(xhr.readyState==4 && xhr.status ==200){
                //     document.querySelector("#box").innerHTML = xhr.responseText
                // }
            }
         }
```
## node内置对象 url path querystring 
```js
    const http = require('http');
    const url = require('url')  //操作 url路径  的对象
    const qs= require('querystring') //操作  url路径的查询字符串  的对象
    const path = require('path')  //操作 文件路径 的对象

    let server = http.createServer((req,res)=>{ 
        //将一个路径格式为一个对象,true表示将对象中的query部分从querystring转为对象 
        let urlJson = url.parse(req.url,true)
        // { protocol:'',slashes:'',auth:'',host:'',port:'',hostname:'',hash:'',serach:'',query:'',pathname:'',path:'',href:'' }
        //文件路径 => /1.html                       
        let pathname =  urlJson.pathname             
        //path.extname获取文件后缀名	           
        let extname =   path.extname(pathname)   
        //查询字符串=>  id=1&name=xxx&age=18
        let query = urlJson.query;
        //内置对象 querystring.parse()，将一个query字符转为对象
        let queryJson = qs.parse(query) //类似url.parse(path,true)
                                                    

    }).listen(8888,'172.0.0.1')
```
## 给公共资源静态文件等添加路由
>原生node可以对浏览器的请求路径做处理，根据不同路径响应不同数据，一切都需要自己根据路径返回响应资源，每一个路径名都需要一个if else逻辑判断来处理，包括静态资源或者公共资源，当文件资源过多时就成了大问题，所以需要自己实现静态资源路由
```js
    const http = require('http')
    const url = require('url')
    const qs= require('querystring')
    const path = require('path')
    //mime类型，根据请求的文件类型设置content-type
    const mime ={
        '.jpg':'image/jpeg',
        '.jpeg':'image/jpeg',
        '.gif':'image/gif',
        '.png':'image/png',
        '.html':'text/html;charset=utf-8',
        '.css':'image/css',
        '.js':'application/x-javascript',
        'txt':'text/plain',
    }
    let server = http.createServer((req,res)=>{ 
        let pathname = url.parse(req.url).pathname
        let extname = path.extname(pathname)
        if(!extname){
            if(pathname.substr(-1)!=='/')res.writeHead(302,{'location':pathname+'/'})
        path+='./index.html'
     }
    //fs接受磁盘完整路径或者./相对路径
    //解释一下，03-server是服务器server，浏览器 请求的内容都在public里面，public相当于www文件夹
    fs.readFile('./public'+pathname,(err,data)=>{
        if(err){
            res.writeHead(404)
            res.end('not found')
        }
        mime.hasOwnProperty(extname)?res.setHeader('content-type',mime[extname]):null
        res.end(data)
    })
    })
    }).listen(8888,'172.0.0.1')
```
## 使用server_static和finalhandler配置静态资源服务
```js
const http =require('http')
const serverStatic =require('server-static')
const finalhandler = require('finalhander')
const url = require('url')
const path = require('path')
    //配置静态资源路径
let staticserver = serverStatic('public'.{
    'index':['index.html','index.htm']
}) 
http.createServer((req,res)=>{
    
    //路由
    let pathname = url.parse(req.url).pathname
    if(pathname=='addstudent'){
        let queryJson = url.parse(req.url,true).query
        res.end(queryJson)
    }
    //使用静态资源,要放在末尾
    staticserver(req,res,finalhandler(req,res))
}).listen(8888,console.log('服务启动在8888端口'))
```
## node处理post请求
```js
const http =require('http')
const url = require('url')
const path = require('path')
const querystring = require('querystring')
http.createServer((req,res)=>{
    let pathname = url.parse(req.url).pathname
    if(pathname=='addstudent'){
        let content = ''
        //post请求的数据一般很大，所以是分段传过来的
        //监听传过来的data，并且连接起来
        req.on('data',(chunk)=>{
            //content是post提交的参数(查询字符串)
            content+=chunk
        })
        req.on('end',()=>{
            //querystring将查询字符串转成对象
            content = querystring(content)
            res.end('ok')
        })
        res.end(queryJson)
    }
}).listen(8888,console.log('服务启动在8888端口'))

```
