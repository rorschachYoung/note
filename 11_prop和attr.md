#prop和attr的区别
## 一、jquery下的区别
```js

    $('btn').on('click',function(){
        $('.checkbox1').attr("checked",true)
        $('.checkbox2').prop("checked",true)
    })
    //讲解一下现象的区别，当触发点击事件的时候，box1和box2都会被选中，
    //然后手动点击取消选中box1,box2
    //再一次触发点击事件  ，box2会被选中，box1不会
```
#### checked属性讲解
```js
    `<input type='checkbox' checked='checked'> 
    <input type='checkbox' checked='true'> 
    <input type='checkbox' checked='false'> 
    <input type='checkbox' checked=''> 
    <input type='checkbox' checked=null > 
    <input type='checkbox' checked=undefined > 
    <input type='checkbox' checked=0> 
    <input type='checkbox' checked> `
    //以上都会被选中
    //checked = ''和 checked 这两个在元素中显示为 checked
    //其余的都变成字符串
```
#### js dom节点的attribute属性
>html元素上的不论是自定义属性还是html属性都会出现在dom.attribute属性里面
## 二、prop和attribute的区别
>每一个html的预定义属性不仅出现在dom.attribute里面,还会被代理到dom节点下，成为dom节点的属性
```js
    '<input type="checkbox" name="checkbox" checked="checked" >'
    var i = document.querySelector('input[type=checkbox]')
    i.setAttribute('checked','checked1')
    i.setAttribute('checked','checked2')
    i.setAttribute('checked','checked3')
    i.checked = 'checked4'
    i.checked = true
    //这里有两个区别，bool值属性和 !bool 值属性
    //  !bool值属性，来看一下非布尔值属性
        i.setAttribute('name','checkbox1')
        //i.arrtibutes.name.nodevalue = checkbox1 , i.name = checkbox1

        i.name = 'checkbox2'
        //i.arrtibutes.name.nodevalue = checkbox2 , i.name = checkbox2

        //---不论是操作属性还是attr都会同步改变两个值---

    //  bool值属性
        i.setAttribute('checked','checked1')
        //i.arrtibutes.checked.nodevalue = checked1 , i.checked = true
        i.checked = 'checked2'
        //i.arrtibutes.checked.nodevalue = checked1 , i.checked = true
        i.checked = true
        //i.arrtibutes.checked.nodevalue = checked1 , i.checked = true

        //---改变property属性值，永远不会改变attr---
        //---在没有动过property之前，改变attr会同步property---
        //---在动过property之后，改变attr不会同步property---
        //---浏览器和用户操作的是property属性 ---

```
## 三、如何区别使用这两个属性
>当操作bool属性值的时候，推荐prop，非bool值得时候推荐attr节约开销，或者一股脑全用prop也无大碍，jq中也是如此