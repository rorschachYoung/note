# jq入口和核心函数

## 一、入口函数
#### 1、比较原生和jq的入口函数区别
```js
    //js页面dom加载完成
    window.onload = function(){
        //页面加载完成，可以获取图片宽度
        var width = window.getComputedStyle(document.getElementById("img")).width
    }
    //load函数用的dom0级事件，下面load事件会覆盖上面的，但是jq并不会
    window.onload = function(){

    }
    //jq页面dom加载完成 --入口函数
    $(document).ready(function(){
        //能获取dom，无法获取属性，虽然dom加载完成，但是不包括图片

        $('img').width()
    })

    //入口函数  推荐写法
    $(function(){


    })
```
#### 2、jq 的 $ 冲突问题
```js
    //可以使用noConflict函数
     jQuery.conflict()//释放$使用权,用JQuery
     
     var jq = jQuery.confilct()//让jq替代$
```
## 二、核心函数
>核心函数就是$()
#### 1、函数作为参数
>接受入口函数
#### 2、字符串作为参数 选择器 || dom代码片段
```js
    //选择器  return jq object 返回类数组
    $('.box1') 
    $('#box1')  
    //把字符转换为dom，jq obj
    var $p = $("<p> 这是个p </p>")
    $('box1').append($p)
    
```
#### 3、dom作为参数
>会将dom obj 转换为jq obj ,this也会被转成 jq obj

```js
//
    var span = document.getElementByTagName('span')[0]
    var $span =  $(span)

    //
    $('#btn').on('click',fucntion(){
        //this ==> #btn   $(this) ==> $('#btn')
        $(this)
    })
    
```