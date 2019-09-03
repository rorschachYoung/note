# throttle debounce 函数节流 防抖
## throttle 函数节流
不论触发函数多少次，函数只在设定条件到达时调用第一次函数设定，函数节流
```js
let throttle  = function(fn,intervalTime){
    let lastTime = 0;
    return function(){

        let now = new Date().getTime();
        if(now-lastTime>= intervalTime){
            lastTime = now;
            fn.apply(this,arguments)
        }
    }
}
```
## debounce 函数防抖 
不论出发函数多少次，函数只在最后一次调用函数时开始计时，函数防抖
```js
let debounce = function(fn,intervalTime){
    let timer = null;
    return function(){
        if(timer)clearTimeout(timer)
        timer = setTimeout(()=>{
            fn.apply(this,arguments)
            clearTimeout(timer)
        },intervalTime)
    }
}
```
## throttle debounce 结合优化
优化后的开源库版本的throttle函数
```js
    let throttle  = function(fn,intervalTime){
        let last = 0;
        let timer = null;
        return function(){
            let now = new Date.getTime();
            let ctx = this;
            if((now-last) < intervalTime}{
                if(timer)clearTimeout(timer);
                setTimeout(function(){
                    last = now
                    fn.apply(ctx,arguments)
                    clearTimeout(timer)
                },intervalTime);
            }else{
                last = now;
                if(timer)clearTimeout(timer) 
                fn.apply(this,arguments); 
                 
            }
        }
    }
```




