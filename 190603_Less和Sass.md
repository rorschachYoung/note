# Less Sass

## 1. Less 

### 1.1 安装 less
```js

    npm i less -D
    //如果是全局安装的话 可以直接 lessc
    //如果是局部安装的话 可以./node_modules/bin/lessc  xxx.less  xxx.css
    //                  或者 npx lessc xxx.less xxx.css
```

### 1.2 less > 变量
```less
@fontsize:12px;
@color:red;
body{
    font-size: @fontszie +2px;//14 px
    background:lighten(@color,40%);//变浅40% => 浅红色

    //  & 表示body
     &:hover{
         color:red;
         fontsize: @fontsize*2;
     }
     & .container{
         width:100px;
         height:100px;
        //  &表示 container
         & .header{

         }
     }
     //嵌套关系,表示 body .header,注意和mixin区分开
     .header{

     }
 }
``` 
### 1.3 less > mixin
 ```less
    // 声明变量和mixin
    @fontsize:12px;
    //mixin不会编译到样式表中
    .block(@fontsize){
        font-size:@fontsize;
        border:1px solid #ccc;
        border-radius:4px;
    }
    //代码区
    .container{
        color:red;
        //这里不是嵌套关系,而是mixin
        .block(16px);
        .content{
            .block(@fontsize*4);
        }
    }

 ```
```less
//注意一下
//这是一个类的样式,但是也可以当成mixin使用
//但是因为这是类的写法,所以这个类会被编译到css样式表中,而mixin不会
.box{
    color:red;
}
body{
    .box()//使用mixin的混入方式
}
```

### 1.4 less > extend
extend表示扩展一个类的样式(一个选择器)
```less
    @fontsize:12px;
    .block{
        font-size:@fontsize;
        border:1px solid #ccc;
        border-radius:4px;
    }
    //代码区
    body:extend(.block){
        color:red;
    }
    body{
        &:extend(.block);/* 这样写和上面是一样的 */
        &:hover{
            font-size:16px;
        }
    }

```

### 1.5 less >  循环loop
```less

    .gen-col(@n) when(@n>0){
        .gen-col(@n-1)
        .col-@{n}{
            width:1000px/12*@n
        }
    }
```

### 1.6 less > import 
```less
    //全局变量是可以跨文件使用的
    @import "./variable";
    @import "./base";
    @import "./reset";
```

## 2. Sass

### 2.1 安装Sass
```js

    npm i node-sass -D 
    //全局安装 node-sass xxx.sass
    //拒不安装 npx node-sass xxx.sass
    //编译成css后就成正常css样式,在排版视觉上还是趋于嵌套 , 所以 (嵌套排版只是视觉表现而已,实际上就是正常编译后的可用css)
    // npx node-sass --output-style expanded(取消嵌套排版) xxx.sass xxx.css
    //                                        xxx.sass>xxx.css
```

### 2.2 Sass变量
   sass和less变量的区别就在于 less是@定义@取用  sass是$定义 $取用
```scss
$fontsize:12px;
$color:red;
body{
    font-size: $fontszie +2px;//14 px
    background:lighten($color,40%);//变浅40% => 浅红色

    //  & 表示body
     &:hover{
         color:red;
         fontsize: $fontsize*2;
     }
     & .container{
         width:100px;
         height:100px;
         //&表示 container
         & .header{

         }
     }
 }

```

### 2.3 Sass的mixin 
```scss
$fontsize:12px;
$color:red;
@mixin block($fontsize/* 变量 */){
    font-size:$fontsize;
    border:1px solid #ccc;
    border-radius:4px;
}
body{
    @include block($fontsize*2/* 24px */)
}

```

### 2.4 Sass > extend
```scss

    $fontsize:12px;
    .block{
        font-size:$fontsize;
        border:1px solid #ccc;
        border-radius:4px;
    }
    //代码区

    body{
        @:extend(.block)
        &:hover{
            font-size:16px;
        }
    }
```

### 2.5 Sass > 循环loop
```scss
    @mixin gen-col ($n) {
        @if $n>0{
            @include gen-col ($n - 1);
            .col-#{$n}{
                width:1000px/12*$n
            }
        }
    //调用
    @include gen-col(12)
```

### 2.6 Sass > import 
```scss
    //全局变量是可以跨文件使用的
    @import "./variable";
    @import "./base";
    @import "./reset";
```