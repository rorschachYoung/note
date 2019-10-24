# 阿里云node+mysql+mongodb+mysql环境搭建
## 0.先导
安装环境是在7.4,安装过程成最好
> yum update 升级一下
> yum install git 
**`git安装`**
参考但并非完全是 https://www.cnblogs.com/kevingrace/p/8252517.html    
首先用yum安装git  
>yum instal git  
只是yum安装的git版本过低,无法vscode的remote,所以需要安装最新的git 
```s
    # 1
    yum install curl-devel expat-devel gettext-devel openssl-devel zlib-devel asciidoc
    # 2 
    yum install  gcc perl-ExtUtils-MakeMaker
    # 3
    cd /usr/local/src/
    # 4 获取git方式1
    git clone https://github.com/git/git
    # 5 获取git方式2
    wget https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.23.0.tar.gz
    # 6 卸载yum的低版本git
    yum remove git
    # 7 解压
    tar -vxf git-2.23.0.tar.gz
    # 8 
    cd git-2.23.0.tar.gz
    # 9 编译
    make prefix=/usr/local/git all
    make prefix=/usr/local/git install
    echo "export PATH=$PATH:/usr/local/git/bin" >> /etc/profile
    source /etc/profile
    
```
## 1.安装nodejs
首先进入/usr/local/src目录  
>cd /usr/local/src  
获取当前的最新稳定版本node,此时版本为10.16.0    
在/usr/local/src下  
>wget https://npm.taobao.org/mirrors/node/v10.16.0/node-v10.16.0-linux-x64.tar.xz  
然后解压 该文件,网上有两种解压方法,  
1.tar xvf  node-v10.16.0-linux-x64.tar.xz  
2.  xz -d node-v10.16.0-linux-x64.tar.xz           tar -xvf node-v10.16.0-linux-x64.tar.xz  
两种方法都应该行,我用了第一种解压
>tar xf  node-v10.16.0-linux-x64.tar.xz  
在linux环境下 也跟windows一样,当然想要node file  或者 python file的时候  
需要配置环境变量,linux下稍有不同,它是把这样的解释程序 或者 编译程序放在  
/usr/bin/node /usr/bin/python3 目录,全局使用命令时就会去 /usr/bin/ 目录下找  
相应的程序,所以需要将node跟npm全局执行文件软连接到/usr/bin目录下,效果等同于windows  
的环境变量,但是实现手段不一样,注意下面链接路径的差异  
>$  ln -s /usr/local/src/node-v10.16.0-linux-x64/bin/node   /usr/bin/node
>$  ln -s /usr/local/src/node-v10.16.0-linux-x64/bin/npm   /usr/local/bin/npm
检查版本
> node -v   # v10.16.0  
> npm -v # 6.9.0  
设置npm淘宝源  
>npm config set registry https://registry.npm.taobao.org  
至此安装成功  
## 2.安装mongodb 
### 2.1 wget安装(源太慢了,不推荐)  
首先进入/usr/local/src目录   
>wget https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-rhel70-4.0.0.tgz  
然后解压    
>tar -zxvf mongodb-linux-x86_64-rhel70-4.0.0.tgz  
修改文件命名  
> mv mongodb-linux-x86_64-rhel70-4.0.0 mongodb 实际上做了一个拷贝剪切重命名操作  
创建日志目录和数据文件目录    
>cd /usr/local/src/mongodb/  
>mkdir -p data/logs  
>mkdir -p data/db 
### 2.2 yum安装
配置 mongodb repo
> cd /etc/yum.repos.d 
> vim mongodb-org-4.0.repo 

```bash
[mongodb-org-4.0]
name=MongoDB Repository
baseurl=http://mirrors.aliyun.com/mongodb/yum/redhat/7Server/mongodb-org/4.0/x86_64/
gpgcheck=0
enabled=1 
```
然后安装mongodb
>yum install -y mongodb-org
### 2.3 配置
>vim /etc/mongodb.conf
```bash
net:
    port:27017
    bindIp:0.0.0.1
```
### 2.4 设置开机启动
 systemctl enable mongod
 systemctl start mongod


## 3.安装mysql
1运行以下命令更新YUM源。
>rpm -Uvh  http://dev.mysql.com/get/mysql57-community-release-el7-9.noarch.rpm
2 运行以下命令安装MySQL
>yum -y install mysql-community-server
3 运行以下命令查看MySQL版本号
>mysql -V 显示版本则安装成功
4 运行mysqld
>systemctl start mysqld
5 获取初始密码
> grep 'temporary password' /var/log/mysqld.
6 有可能获取不到密码,这是因为安装的可能是5.6版本的mysql,注意查看mysql版本,5.6跟5.7,以及最新版的8可能都不会一样
7 mysql5.6版本解决修改密码等问题
发现进不去系统无法执行 "设置密码"操作,请注意修改无密码登录
>vim /etc/my.cnf 
> + skip-grant-tables
> systemctl restart mysql
> mysql -u root -p
> SET PASSWORD = PASSWORD('12345');
>vim /etc/my.cnf
8 mysql5.7版本
设置密码
>ALTER USER USER() IDENTIFIED BY '12345';
9 给数据库设置可远程链接
>grant all privileges on *.* to root@"%" identified by "12345";
10 刷新权限
>flush privileges;
11 设置开机自启动,这样离开终端后依旧开启
> systemctl enable mysqld
## 4.Nginx安装
> yum install nginx 
**目录**
```
(1) Nginx配置路径：/etc/nginx/

(2) PID目录：/var/run/nginx.pid

(3) 错误日志：/var/log/nginx/error.log

(4) 访问日志：/var/log/nginx/access.log

(5) 默认站点目录：/usr/share/nginx/html

(6) 配置目录 /etc/nginx/nginx.conf
进入/etc/nginx/nginx.conf 输入nginx 启动nginx
```
**配置**
这是喵喵的配置 
地址:http://120.55.57.19/miaomiao/movie/hotplaying
github:https://github.com/rorschachYoung/vue_movie
```


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
**命令**
nginx -s  reload  修改 nginx.conf 配置后 可以重启一下
如果出现  nginx: [error] invalid PID number "" in "/run/nginx.pid"
> killall nginx 杀死所有nginx线程
> systemctl start nginx 重启nginx线程
> systemctl enable nginx 
查看进程
ps -aux | grep nginx 
ps -ef |grep nginx

## 5.部署vue单页应用
vue还是react其实都差不多,都是生成静态页面后放到html文件下,主要是目录等一些配置问题
### 5.1 喵喵的配置
**注意一定要配置router的base**
```js
let router = new Router({
    mode:'history',
    // base:process.env.BASE_URL,
    base:'miaomiao',  /* 这是配置路由访问前缀的,如果是放在子目录下,需要配置这个 */
    routes:[
        {
            path:'/',
            name:'home',
            redirect:'/movie/hotplaying',
        },
    ]
}
```
**vue.config.js**
```js

const config  =require('./src/config')
//config.apiBaseUrl = > 'http://39.97.33.178'
module.exports={
    publicPath:'/miaomiao',/* 这是配置资源访问路径的,一般配合路由的base 前缀 子目录路径使用 */
    devServer:{
        proxy:{
            '/api':{
                target:config.apiBaseUrl,
                changeOrigin:true,
            }
        }
    }
}

```
也就是说 vue里面的axios.get('/api/user') => 实际上请求 'http://39.97.33.178/api/user'
这里面的请求代理是本地的webpack-dev-server代理的,实际上线还要nginx配置

**nginx.conf**
```bash
    # 配置项目到指定根目录下面的子目录 , 这里需要和vue.config.js的publicPath要一样
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

```
**这里发现nginx代理的/api/被占用了,以后其他类似有关api的代理都会冲突,所以需要改进**
```bash
  # 这样的话只要在axios的baseUrl中添加

  	location /vue_movie/api/ {
		#  2line proxy
		proxy_set_header X-Real-IP $remote_addr;
		proxy_pass http://39.97.33.178/api/;
		# 关闭重定向,用用户ip获取定位
		proxy_redirect     off;
		proxy_set_header   X-Forwarded-For  $proxy_add_x_forwarded_for;
		proxy_set_header   Host             $http_host;
		proxy_set_header X-NginX-Proxy true;

	}
```
**改变线上nginx的代理路径后,也要修改项目中的路径重新打包**
这次路径改变比较简单,只要在axios的baseUrl中添加 就行了
```js
  //main.js 
  +   axios.defaults.baseURL = '/vue_movie'
      Vue.prototype.$axios = axios

 // 本地项目
  npm run build 
  git add . 
  git commit -m'baseURL + prefix'
  git push 
 //线上部署
  /home目录下
  git clone https://github.com/rorschachYoung/vue_movie
  ls   >   vue_movie
  mv  vue_movie/dist  /usr/share/nginx/html/miaomiao   

    将dist目录拷贝到nginx下的项目目录 /usr/share/nginx/html/miaomiao,
	
  vim /etc/nginx/nginx.conf 
    这里注意nginx配置vue单页应用,查看vue官网.
    	location /miaomiao/ {
		root   html;
		index  index.html index.html
		# vue-router 的history
		try_files $uri $uri/ /miaomiao/index.html
	}
  rm -rf vue_movie //删除 /home下面的项目
  

```
### 5.2 smilevue的配置
占用端口 4000
**一定要配置的地方**
1.router路由的配置 history跟base
2.访问api一定要配置,线上的api跟
3.服务器要配置代理
**路由配置**
```js
export default new Router({
  mode:'history',
  base:'smilevue', /* 线上访问的 http://..../smilevue/index,这个base就是/smilevue 前缀 ,
                      这样 下面的路由才会匹配到 /smielvue/index => path:'/index'  */ 
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

### 5.2.1 pm.yml
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
### 5.2.2 pm 指令
1.pm2 start index.js 启动index
2.pm2 start pm2.yml  启动yml配置的服务,
3.pm2 start pm2.yml --env production  启动yml配置的服务,指定环境
4.pm2 stop [name]  pm启动服务后 会有实例名称name
5.pm2 restart [name]  
6 pm2 list  查看所有pm2启动的服务
7.pm2 log [name] 查看指定服务的日志

