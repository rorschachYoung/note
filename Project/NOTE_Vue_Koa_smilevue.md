# Ⅰ. Smile商城
## 1.项目初始化
> npm init webpack smilevue
> cd  smilevue
> npm init
> npm i vant
```js
//main.js
import Vant from 'vant'
import 'vant/lib/index.css'
```
推荐全局引入
方式见官网https://youzan.github.io/vant/#/zh-CN/quickstart
```js
// npm i babel-plugin-import
添加配置后.bablerc文件
{
  "presets": [
    ["env", {
      "modules": false,
      "targets": {
        "browsers": ["> 1%", "last 2 versions", "not ie <= 8"]
      }
    }],
    "stage-2"
  ],
  "plugins": [
    "transform-vue-jsx",
     "transform-runtime",
    ["import",{
      "libraryName": "vant",
      "libraryDirectory": "es",
      "style": true
    }]
  ]
}

```
按需引入vant
新建plugin/vant.js
```js
import Vue from 'vue'
import {
    //引入组件
    Button,

} from 'vant'
// 引入
Vue.use(Button)
```
然后在main.js中引入vant.js
## 2.移动端适配
```js
//     /index/html +
    ;(function(window,desingwidth,rate){

      let rem = function(){
        let htmlwidth = document.documentElement.clientWidth||document.body.clientWidth;
        document.style.fontSize = htmlwidth/desingwidth * rate +'px'//i5下就是  1rem =rate
      }
      rem();
      window.addEventListener('resize',rem,false)
    })(window,750,100)
```
## 3.vant组件
### 3.1  Row,Col
van-row,van-col 常用的布局组件,分为24栏
### 3.2  swipe,SwipeItem,Lazyload
van-swipe ,van-swipe-item , v-lazy
滑动组件没啥好介绍的,主要是lazyload代替了img的src属性
```js
      <van-swipe class="swiper" indicator-color="#ff3f89" :autoplay="1500">
        <van-swipe-item v-for="(item , index) in bannerimg" :key="index">
          <!-- :src="bannerimg[index]" -->
          <img   v-lazy="bannerimg[index]"
          alt="" width="100%" height="100%">
        </van-swipe-item>
      </van-swipe>
```
### 3.3 vue-awesome-swiper
>npm i vue-awesome-swiper
mainjs中全局引入
```js
 import aweSwiper from  'vue-awesome-swiper'
 import 'swiper/dist/css/swiper.css'
 Vue.use(aweSwiper)
```
组件中作为子组件引入(推荐)
```js
import 'swiper/dist/css/swiper.css'

import { swiper, swiperSlide } from 'vue-awesome-swiper'

export default {
  components: {
    swiper,
    swiperSlide
  }
}
```
常用配置
```js
          <swiper :options="swiperOption">
            <swiper-slide v-for="(item,index) in recommendGoods" :key="index">
              <div class="recommend-item">
                <img v-lazy="item.image" alt="" >
                <span>{{item.goodsName}}</span>
                <span>￥{{item.price}}(￥{{item.mallPrice}})</span>
              </div>
            </swiper-slide>
          </swiper>
{
  data(){
      swiperOption:{
        /* 一页展示3项，默认swiper展示一项 */
        slidesPerView:3,
        slidesPerGroup : 3, /* 三个一组 */
        /* direction:'vertical', //竖着滚动
        slidesPerView：'auto',  // 一屏显示的slides,
          freeMode:true, // 默认false，滑动一次一格或者一组，这个则直接根据滑动的距离滑动几格或者几组
          mouseWheel：true,
        pagination:{
          el:'swiper-pagination',
          clickable:true,
        }
        loop:true,
        */

      },
  }
}

```

## 4.EasyMock的使用
[https://www.easy-mock.com/](https://www.easy-mock.com/)
新建项目,将数据拷贝到这里做成接口
## 5.Axios的使用
[http://www.axios-js.com/zh-cn/docs/](http://www.axios-js.com/zh-cn/docs/)
http://www.axios-js.com/zh-cn/docs/
### 5.1 基本使用,全局引入
在main.js引入axios挂载到Vue实例上
```js
const apiBaseURL = ' https://www.easy-mock.com/mock/5d2663c0ed1f913e136c8c0a'
axios.defaults.baseURL = apiBaseURL+'/smilevue'
Vue.prototype.axios = axios
```

### 6.Axios高级,请求节流
```js

methods: {
        handleTap(item) {
      console.log('tap movie--',item.id);
      this.$router.push(`/movie/detail/${item.id}`)
    },
    requestDebounce() {
      if (typeof this.source === "function") {
        this.source("停止请求");
      }
    },
  },
  watch: {
    searchText(newval, oldval) {
      if (newval !== oldval) {
        this.requestDebounce();
        this.$axios
          .get(`/api/searchlist?cityid=10&kw=${this.searchText}`, {
            cancleToken: this.$axios.CancelToken(c => (this.source = c))
          })
          .then(res => {
            if ((res.data.data, res.data.data.movies)) {
              this.searchList = res.data.data.movies.list;
            } else {
              if (newval === "") {
                console.log(1);
                this.searchList = this.templist;
              } else {
                this.searchList = [];
              }
            }
          })
          .catch(err => {
            if (this.$axios.isCancel(err)) {
              console.log("req取消");
            } else {
              console.log(err);
            }
          });
      }
    }
```
## 7.Nginx代理演示
```bash
	server{
	location /miaomiao/ {
		root   html;
		index  index.html index.html
		# vue-router 的history
		try_files $uri $uri/ /miaomiao/index.html
	}
	location /api/ {
		#  2line proxy
		proxy_set_header X-Real-IP $remote_addr;
		proxy_pass http://39.97.33.178/api/;
		# 关闭重定向,用用户ip获取定位
		proxy_redirect     off;
		proxy_set_header   X-Forwarded-For  $proxy_add_x_forwarded_for;
		proxy_set_header   Host             $http_host;
		proxy_set_header X-NginX-Proxy true;

	}
}
```


## 8.异步数据传值给子组件
如果没获取到 就 item.image可能会报错undefined,
这时候可以通过watch或者给props类型指定默认值 这样
```js
<template>
  <div>
    <p class="floor-title">{{title}}</p>
    <ul class="floor">
      <li v-for="(item,index) in floorData" :key="index">
        <img v-lazy="item.image" alt="">
      </li>
    </ul>
  </div>
</template>

<script>
export default {
  props:['title','floorData'],
  data(){
    return {
      // floorTitle:'',
      // floor:[]
    }
  },
  // watch:{
  //   floorData:function(newval,oldval){
  //     console.log(newval)
  //     this.floorTitle = this.title;
  //     this.floor = this.floorData;
  //   }
  // }
}
</script>
```
## 9.Vue - filter
### 9.1 全局filter
```js
Vue.filter('a',function(v){
  if(!v) return v;
  return v+'haha'
})
```
### 9.2 组件内filter
```js
//   component.vue 文件中
export default {
    data(){
      return {

      }
    },
    filter:{
      a:function(v){
            if(!v) return v;
            return v+'haha'
      }
    }
}
```
### 9.3 filter传参
```js
<div>{{ title | a('arg1','arg2') }} </div>
export default {
    data(){
      return {
          title:'this is title'
      }
    },
    filter:{
      //  v = title  ,arg1 =arg1 , arg2 = arg2
      a:function(v,arg1,arg2){
            if(!v) return v;
            return v+'haha'
      }
    }
}
```
## 10.filter应用
```js
export default (v=0) => v.toFixed(2)

```
## 11.滑动切换tab,tab吸顶
1.tab组件(van-tabs)有一个属性可以切换tab,swipeable
2.tab组件(van-tabs)有一个属性可以实现粘性定位布局,吸顶效果,sticky
```js
<van-tabs swipeable sticky>
  <van-tab>
    <p>content</p>
  <van-tab>
</van-tabs>
```
## 12.图片失效处理
```js
<img :src="v.IMAGE1" alt width="100%" :onerror="errimg"/>

export default {
  data(){
    return {
      errimg:`this.src = "${require('@/assets/img/errorimg.png')}"` /* 错误图片的地址 */
    }
  }
}

```
## 13.出现横向滚动条处理
  overflow-x:hidden;
  更多细节参考 https://www.zhangxinxu.com/wordpress/2015/01/css-page-scrollbar-toggle-center-no-jumping/
# Ⅱ.Koa server
## 1.koa基本骨架
```js
const Koa =  require('koa')
const Router = require('koa-router')
const http = require('http')
const path  =require('path')
const router = new Router()
const app = new Koa()
router.get('/',(ctx,next)=>{
  ctx.body="这是index"
})
// koa-static
// koa-bodyparser
// koa-art-template
// koa-session
// koa-multer
app.use(router.routes(),router.allowedMethods());
http.createServer(app.callback())
    .listen(4000,'127.0.0.1',()=>console.log('listen port 4000, http://localhost:4000/'))

```
## 2.mongoose链接
```js
//   /server/database/db.js
const {DBURL} = require('../config')
const mongoose = require('mongoose')
// mongoose第二个参数是配置项
  let maxConnectionCount = 0
  mongoose.connect(DBURL,{useNewUrlParser:true,useCreateIndex:true})
  mongoose.connection.once("open",()=>{
    console.log('mongodb已连接')
  })
  mongoose.connection.on("disconnected",()=>{
    console.log('mongodb断开连接')
  // 断开之后进行重连
    maxConnectionCount ++
    if(maxConnectionCount>=3)throw new Error('数据库连接失败')
    mongoose.connect(DBURL,{useNewUrlParser:true,useCreateIndex:true})
  })
  mongoose.connection.on("error",()=>{
    console.log('数据库错误')
    maxConnectionCount ++
    if(maxConnectionCount>=3)throw new Error('数据库连接失败')
    mongoose.connect(DBURL,{useNewUrlParser:true,useCreateIndex:true})
  })
module.exports = mongoose
```
## 2.Schema
**schema在数据库生成的表会加上一个s,如果需要手动配置schema的话,**
**就给Schema实例加上第二个参数 {collection:SchemaName}**
类似mysql的表结构

1.String  字符串类型
2.Number  类型
3.Date  日期类型
4.Bollean 布尔类型
5.Buffer buffer类型
6.ObjectId 主键类型
7.Mixed  混合类型
8.Array 集合类型
**创建schema**
```js
//    /server/database/schema/User.js
const mongoose = require('mongoose')
const {ObjectId}  = mongoose.Types
const UserSchema = new mongoose.Schema({
    userid:ObjectId,
    username:{
      type:String,
      unique:true, /* 解決重名注册问题 */
    },
    password:String,
    password_backup:String,
    createat:{
      type:Date,
      default:Date.now()
    },
    lastloginat:{
      type:Date,
      default:Date.now()
    }
})
module.exports = UserSchema

```
## 3.Model
引入schema并创建model 导出
```js
//   /server/database/model.js
const mongoose = require('./db')
const User =  require('./schema/User')
module.exports  = {
    User:mongoose.model('User',User)
}
```
## 4.创建一个entiy并操作
在index.js中创建一个entity 并操作
```js
router.post('/user',async(ctx,next)=>{
  let userentity =  await new User({username:'xixi',password:'12345'})
  userentity.save() /* 保存数据 */
            .then(console.log)

})

```
## 5.bcrypt加盐加密,验证解密
**加密**
在用户UserSchema中对save操作添加前置钩子  
加密过程,先生成一个位数SALBIT的SALT盐,然后用这个盐去hash加密密码  
分别有同步异步的加密方式,回调遵循node的规定
```js
  UserSchema.pre('save',function(next){/* 不能写箭头函数,不然获取不到this */
  bcrypt.genSalt(SALTBIT ,(err,salt)=>{
      if(err) return next(err)
      bcrypt.hash(this.password,salt,(err,hash)=>{
        console.log(22222222,err,hash)
        if(err) return  next(err)
        this.password =  hash;
        next()
      })
  })
})
  /**
   *  @param {NUmber} SALIBIT (设置加密位数长度)
   */
  bcrypt.genSalt(SALIBIT,(err,salt)=>{})
  /**
   *  @param {String,NUmber} PASSWORD 需要加密的内容
   *  @param {Salt} SALT bcrypt生成的盐
   */
  bcrypt.hash(PASSWORD,SALT,(err,salt)=>{})

```
**验证**
```js
/** 
 * @param {String}  PASSWORD (需要验证的用户表单密码)
 * @param {String}  BCRYPT_DB_PASSWORD (加密后存在数据库的密码)
 * @param {Bollean} ismatched (验证成否)
 */
bcrypt.comparePassword(PASSWORD,BCRYPT_DB_PASSWORD,(err,ismatched)=>{})

// 把他放在挂载在UserModel的类上面成为  MODEL实例(entity)   方法
UserSchema.methods = {
  comparePassword:(pwd,dbpwd)=>{
      return new Promise((res,rej)=>{
        bcrypt.compare(pwd,dbpwd,(err,result)=>{
          if(err){
            console.log(err);
            rej(err)
          }
          res(result)
        })
      })
  }
}
//  通过 MODEL实例 entity 调用
await user.comparePassword(password,user.password).then(res=>console.log())
```
## 6.jwt生成token,验证token
注意jwt生成一定是 "Bearer "+token 一定是Bearer加一个空格+token
**jsonwebtoken 生成token**  
```js
  /**
   *  @param {Object} INFO (需要加密的内容)
   *  @param {object} KEY (自己配置的加密KEY对象)
   *  @param {object} [CONFIG={}] (配置信息)
  */
  jwt.sign(INFO,KEY[,CONFIG],(err,token)=>{})

```
**验证token**
用jwt.verify()验证token,或者用一些封装好的jwt中间件passport-jwt
```js


```
## 7.登录表单页面
添加新页面,首先在page页面下添加一个对应页面,然后在路由中添加路由,并采用按需引入
```js
//    /src/router/index.js
    {
      path:'/login',
      name:'login',
      component:()=> import(/*webpackChunkName:login  */'@/page/Login.vue')
    },
```
添加需要的vant的表单组件 Field(表单项) ,NavBar (导航栏)
```js
//   /src/plugin/vant.js


```
## 8.前端开发,配合代理,如何设计接口
1.预设接口为 baseURL/projectName/ ,前端直接请求接口,可以通过代理或者easymock自带跨域来访问接口
2.项目部署上线之后访问接口,修改路径为bassURL+projectName,http://mysite.com/smilevue/
3.因为部署多个项目,所以需要设计接口规范
baseURL :  开发时的接口,或者上线后根路径http://mysite.com/
projectName :  项目名称,每一个项目有一个名称,这样就通过项目名划分了子目录
route : 项目路由,这是后台划分的子路由,直接跟在http://mysite.com/smilevue/user/,http://mysite.com/smilevue/goods/

以smilevue项目为例

后台路由不管怎么设计,最后都是通过nginx代理的,所以前缀不重要,路径如下
http://localhost:4001/api/user/getuser
http://localhost:4001/api/admin/getadmin


前台路由前缀不用考虑后台,只要子路由对上即可
开发地址 URL = baseURL + projectName = http://easy-mock/adadadasdas/simevue
线上地址 URL = baseURL + projectName = http://mysite.com/smilevue
路径如下
URL/user/
URL/admin/


前后台路由通过nginx匹配
```bash
    server{
      location /smilevue/ {
          proxy: 127.0.0.1:4001/api/
      }
    }
```
这样访问  http://mysite.com/smilevue/ = http://localhost:4001/api/
这样访问  http://mysite.com/smilevue/user/getuser = http://localhost:4001/api/user/getuser
这样访问  http://mysite.com/smilevue/admin/getadmin = http://localhost:4001/api/admin/getadmin


## 9.注册业务
1.首先得是做好接口错误的message,还得验证用户是否输入了账户密码,不仅前端验证,后端也的不信任前端验证自己验证一次
2.然后就是查重,如果已经定义则相应200 和 注册错误message
3.前端根据响应的不同状态做处理,成功则跳转home或者login,失败则显示失败信息,注册请求期间还需要设置loading态
4.需要做表单验证,根据v-model绑定的值,来做表单验证,判断长度或者直接根据正则匹配等等 也可以不需要

## 10.记录一个登录bug
**处理前**
```js

```
**处理后**
```js
.post('/login',async(ctx,next)=>{
  console.log('访问/login')
  let {username, password}  =  ctx.request.body ;
  try {
    const user = await User.findOne({username}).exec();
    console.log(user)
    if(user){
      console.log(0000,user)
      return await user.comparePassword(password,user.password).then(res=>{
         ctx.body ={
          code:200,
          msg:'登陆成功'
        }
      }).catch(err=>{
        console.log('比较密码失败',err)
        ctx.body = {
          code:403, /* 登录失败 */
          errmsg:'登录失败'
        }
      })
    }else{
      ctx.body = {
        code:402,/* 用户不存在 */
      }
    }
  } catch (error) {
    console.log('err')
    ctx.body = {
      code:500,
      errmsg:error
    }
  }
  console.log('提前返回首页')
  ctx.body = '用户首页'
})
```

# Ⅲ.vue.config.js基础配置
## 1.基础配置
```js
module.exports  = {
  baseUrl:'/[projectname]',/* 一般选/但是考虑到多项目部署,还是加上projectname部署到子目录 */
  outputDir:'dist',/* 打包目录 */
  assetsDir:'assets', /* 静态资源目录 */
  lintOnSave:false, /* eslint 保存文件检查 */
  devServer:{
    open:true,
    // host:'localhost',/* 本地开发,默认配置*/
    host:'0.0.0.0',/*真机测试, 局域网访问,手机跟电脑同一路由器网络下可访问 */
    port:8080,/* 默认端口配置 */
    https:false, /* 配合服务器*/
    hotOnly:false, /* 热模块更新,不知道干啥的 */
    proxy:{
      '/api':{
        target:'http://www.baidu.com:4000/api',
        ws:true, /* 是否跨域 */
        changeOrigin:true, /*  */
        pathRewrite:{
          '^/api':'',/* 例子解释 /api/user = >  /user  (http://www.baidu.com:4000/api/user)   */
        }
      }
    }
  }
}
```
## 2.拦截请求,Mock数据
通过配置vue.config.js中的before字段来拦截请求,用Mock返回数据,
实际上这是webpack.devServer的配置
```js
module.exports = {
  // ...
  proxy:{},
  devServer:{},
  before(app){/* 会传递一个app参数 */
    app.get('/api',(req,res)=>{
        res.send({})
    })
  }
}
```
# Ⅳ.pm2
第一步全局安装pm2
## 1.pm.yml
pm.yml是pm2的配置文件
```yml
apps:
  - script: ./index.js
    name: smilevue  #  pm2 start 执行会生成随机名称,name 用来指定服务名称
    env_production: #当执行 pm2 start pm.yml --producton 指定读取production配置
      NODE_ENV: production # 定义当前环境 production
      HOST: localhost # 配置只能本地locakhost访问,外部只能通过NGINX代理
      PORT: 4000
```
## 2.pm 指令
1.pm2 start index.js 启动index
2.pm2 start pm2.yml  启动yml配置的服务,
3.pm2 start pm2.yml --env production  启动yml配置的服务,指定环境
4.pm2 stop [name]  pm启动服务后 会有实例名称name
5.pm2 restart [name]  
6 pm2 list  查看所有pm2启动的服务
7.pm2 log [name] 查看指定服务的日志
# Ⅴ.项目部署
占用端口 4000
**一定要配置的地方**
1.router路由的配置 history跟base
2.访问api一定要配置,线上的api跟
3.服务器要配置代理
**路由配置**
```js
export default new Router({
  mode:'history',
  base:'smilevue',
  routes: []
}
```
**nginx配置**
线上访问地址
前端 http://120.55.57.19/smilevue/home  
线上访问api     http://120.55.57.19/smilevueapi/goods/detail/:id
线上访问api     http://120.55.57.19/smilevueapi/category/categorylist
线上访问api     http://120.55.57.19/smilevueapi/categorysub/categorysublist
服务器本地 api  http://localhost:4000/api/goods/detail/:id
服务器本地 api  http://localhost:4000/api/goods/category/categorylist
服务器本地 api  http://localhost:4000/api/goods/categorysub/categorysublist
更多 api查看 https://github.com/rorschachYoung/smilevue/
    
```
        location /smilevue/ {
                root   html;
                index  index.html index.html;
                # vue-router 的history;
                try_files $uri $uri/ /smilevue/index.html;
        }
		location /smilevueapi/ {
				#  2line proxy
                proxy_set_header X-Real-IP $remote_addr;
                proxy_pass http://localhost:4000/api/;
                # 关闭重定向,用用户ip获取定位
                proxy_redirect     off;
                proxy_set_header   X-Forwarded-For  $proxy_add_x_forwarded_for;
                proxy_set_header   Host             $http_host;
                proxy_set_header X-NginX-Proxy true;

		}

```
因为没有配置前缀路径所以报错http://0.0.0.0/static/css/app.d86f18fbe175
,访问的是根路径,所以需要重修修稿vue.config.js配置 修改配置前缀路径
```js
module.exports = {
  build: {
    // Template for index.html
    index: path.resolve(__dirname, '../dist/index.html'),

    // Paths
    assetsRoot: path.resolve(__dirname, '../dist'),
    assetsSubDirectory: 'static',
    assetsPublicPath: '/smilevue/',  /* 资源访问路径前缀,配合线上子目录访问 */
 
    /**
     * Source Maps
     */

    productionSourceMap: true,
	// ......
  }
}

```
配置流程 
首先 登录阿里云 默认进入 /root 路径
然后 git clone https://github.com/rorschachYoung/smilevue
把打包生成好的dist 目录 移到对应的nginx根路径的子目录下,这样就可以子路径访问,可以配置多个项目
mv smilevue/dist /usr/share/nginx/html/smilevue
然后把server端放入 /home目录下,一般node项目都放在这里运行
mv smilevue/server /home/vuesmile-server
cd /home/vuesmile-server    进入目录
npm i      安装依赖  bcrypt在高版本node会有一些 error,建议使用nvm降低版本
node index
访问http://120.55.57.19/smilevueapi/categorysub/categorysublist
访问http://120.55.57.19/smilevueapi/category/initcategory
访问http://120.55.57.19/smilevueapi/goods/initgoods
访问一下路径进行数据初始化
访问项目路径http://120.55.57.19/smilevue/category

第一步全局安装pm2
pm2 start index.js

