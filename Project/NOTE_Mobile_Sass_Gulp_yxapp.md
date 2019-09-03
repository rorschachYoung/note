# NOTE
## 1.项目初始化
1.移动端h5模板页
2.git init 

3.添加./gitingnore   
 + node_modules/

4.npm init -y  
 + npm i gulp gulp-sass 

5.添加gulpfile.js  
```js
const gulp = require('gulp');
const sass = require('gulp-sass')
gulp.task('sass',function(next){
    gulp.src('./src/sass/**/*.scss')
        .pipe(sass().on('error',sass.logError))
        .pipe(gulp.dest('./src/css'))
        next()
})
gulp.task('default',gulp.series('sass',function(next){
    console.log('gulp start')
    next()
}))
```

6.拷如移动端reset.css到common.css  

7.chrome真机调试      
  
首先得是android手机,打开开发者选项,并且打开usb调试功能,通过usb链接到电脑上  
然后点击chrome控制台的竖3点 选择 more tools -> remote device  
可以看见已经连接了手机,在new tab中输入要打开的网址,open  
此时要确保手机上打开chrome,open之后才会打开网址开启调试,  
如果已经打开过了,下面会有链接历史,直接inspect就好了  

8.移动端事件  
  
用zepto的tap注意页面不要使用click,如果用了的话,注意e.preventDefault(),
来阻止click事件,当然也可以使用fastclick库

## 2.zepto讲解
老马博文  https://www.jianshu.com/p/5d7f2588deae

## 3.swiper
使用方法 https://www.swiper.com.cn/usage/index.html
当给swiper-container设置了1px边框的时候,跟图片会有一个三像素的边距,可以给img设置display:block,或者给图片vertical-align: middle || top;
1px边框 
```css
            .swiper-container::before{
                content:'';
                background-color: #ccc;
                position: absolute;
                width: 200%;
                height: 200%;
                left: 0;
                top: 0;
                border-bottom: 1px solid #ccc;
                transform: scale(.5,.5);
                transform-origin: left top;
                box-sizing: border-box;
                
            }

```