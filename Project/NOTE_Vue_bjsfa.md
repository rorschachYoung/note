# 开发日记


## 1.hotcss天坑
在main.js或者app.vue中引入可能会出现类似meta-viewport失效的问题,
命名设置了viewport但是却显示成pc的样式,百度了一番之后,无果,但是注意到
一点,hotcss一定先于其他js先加载,虽然放入了主入口文件,可能是加载速度的原因导致的问题
所以将hotcss.js直接从html文件直接导入 
**`几遍如上所做,还是存在bug,无奈`**
如果都不行的话,换回原来的方案,hotcss放入main.js,commoncss放入app,然后重新npm run serve
**`如果有bug重新编译`**
## 2.全局引入px2rem的scss函数
需要配置全局的sass-loader配置,新建vue.config.js
```js
module.exports = {
    css:{
        loaderOptions:{
            sass:{
                data:`@import "src/lib/hotcss/px2rem.scss"; `
            }
        }
    }
}

```
## 3.解決移动端click事件延迟
 用封装了hammer的vue-touch 或者 使用fastclick
## 4.表单校验
vee-validate插件,注意是vee
>npm i vee-validate
到main.js中引用 然后Vue.use(vee-validate)注册插件
```js
            <div class="input-group " :class="{active:style.activeIndex===1,error:errors.has('ccode')}">
                <label for="compony-code">公司编号:</label>
                <input type="text" id="compony-code" name="ccode"
                v-validate="{required:true,min:5,max:18}"
                v-model="ccode" @click="style.activeIndex = 1">
            </div>
            <div class="input-group " :class="{active:style.activeIndex===2,error:errors.has('ecode')}">
                <label for="employee-code">员工编号:</label>
                <input type="text" id="employee-code" name="ecode"
                v-validate="{required:true,min:5,max:18}"
                v-model="ecode" @click="style.activeIndex =2">
            </div>
            <div class="input-group " :class="{active:style.activeIndex===2,error:errors.has('pwd')}">
                <label for="pwd">登录密码:</label>
                <input type="text" id="pwd"  name="pwd"
                v-validate="{required:true,min:5,max:18}"
                v-model="pwd"  @click="style.activeIndex = 3">
            </div>
```
注意添加的name属性,通过errors.has(namestring)来验证该项有没有错误,有则显示error类
v-validate则是校验指令
## 5.引入mint-ui
babel配置
```js
module.exports = {
  presets: [
    '@vue/app'
  ],
  plugin:[
    ["component",{librarytName:"mint-ui",style:true}]
  ]
}

```
## 6.router-link的样式问题
router-exact-link0-active 表示当前路由激活的样式类,如果是子路由,则只应用在子路由上,
负路由则不会应用这个样式
router-link-active 表示激活的路由,包括父子路由等都应用这个样式
所以需要按照以下顺序书写样式
router-link-active
router-exact-link-active
## 7.引入iconfont问题
直接main.js中全局引入就好了

## 8.axios.interceptors
aixos的拦截器返回一个实例,拦截器的作用是给请求加上token,但是logout之后就无须加token了,
这个拦截器也就可以删除了
```js
let interceptors = axios.interceptors.request.use(
    config=>{
        config.headers.Authorization = token
    }
)
// ...

logout(){
    axios.interceptors.request.eject(interceptors)
}

```


