## 连接方式
#### 长轮询 long_pull
> 客户端不停的发送请求，例如用setinterval
> 服务器不停回，浏览器不停发
#### 长连接 long_connection
>服务器设置content-type 为event-stream   或者octet-stream(参考node_httpServer.md)8进制流写入
>浏览器发一次，服务器多次写流，服务器单向输出
```js
    //服务器端设置content-type = text/event-stream
    //html5中使用EnevtSource来单向推数据
    var es = new  EventSource('/getconnection');
    es.onmessage = function(e){
        console.log(e.data);       
    }
    //关闭事件源
    es.close()
```
#### websocket(全双工) 
>兼容问题 IE11
```js
    //使用websocket实现server-browser双向通信
    var ws = new WebScoket('ws://127.0.0.1:8080')
    ws.onopen = function(e){
        ws.send('连接上了')
    }
    ws.onmessage = function(e){
        console.log(data)
    }
    ws.onclose = function(){
        //关闭的操作
    }
    ws.onclose();
```
## socket.io 因为兼容性问题，所以封装上面三种方式
>以koa实现，因为socket.io官网未看见koa实现的方式，所以添加koa-socket
>socket.io-client客户端
>npm i socket.io-client koa-socket
>当使用了scoket.io协议后，底层使用了tcp，udp等协议，所以没有了http的头行体，也就没有办法传递session
>所以需要在服务器端创建一个可标记的独立id