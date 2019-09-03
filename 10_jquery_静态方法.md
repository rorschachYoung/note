# jquery 静态方法
>首先介绍一下什么是静态方法，是指类的函数方法或者说属性，实例方法是指类原型上的方法
```js
    function A(name,age){
        this.name = name ;
        this.age = age ;
        //ageAdd 实例方法 每一个A对象实例的 方法
        this.ageAdd = function(){
            this.age++
        }
    }
    //ageMinus静态方法，是类函数的属性
    A.ageMinus = function(){
        this.age--
    }
    //setAge 实例方法，每一个A对象实例的 方法
    A.prototype.setAge = function(){
        this.age = 18
    }
```

#### 1、$.each 方法
>和原生不同，each可以便利类数组(伪数组)
>需要注意的是，原生方法的参数是 v-k系列，即(item,value,v) - (index,key,i)
>jq静态方法是 k-v系列 即(index,key,i) -(item,value,v)
```js
    //原生forEach
    var arr = [1,3,5];
    arr.forEach(function(value,index){
        console.log(value);
    })
    //1,3,5
    var obj ={1:1,3:3,5:5,length:3}
    $.each(obj,function(index,value){
        console.log(index,value);
    })
    //0,1  1,3  2,5
```
#### 2、$.map 方法 
>和原生不同，emapach可以便利类数组(伪数组)
>需要注意的是，原生方法的参数是 v-k-arr系列，即(item,value,v) - (index,key,i) - (arr)
>jq静态方法是 k-v系列 即(index,key,i) -(item,value,v)
```js
    var arr = [1,3,5];
    //原生map  v-k-arr
    //返回一个新数组newarr
    var newarr = arr.map(function(item,i,array){
        console.log(item,i,array);
        return item+i
    })
    //1,0,[1,3,5]  3,1,[1,3,5]  5,2,[1,3,5] 

    var obj ={1:1,3:3,5:5,length:3}
    var newarr = $.map(obj,function(index,value){
        console.log(index,value);
        return index + value
    })
    //0,1  1,3  2,5


```
>需要注意，map方法返回一个新数组，即return组成的值，如果没有return语句，则默认是空数组
>