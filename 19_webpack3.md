# webpack3
>写这份笔记的时候webpack5早已发布了beta版本

## 使用方式

### 1、webpack命令  

    webpack 1.js 2.js  
    webpack -h/-v //帮助信息版本信息  
    webpakc --config config.js //指定配置文件并编译  
    webpack --watch //自动监测文件改动并打包  
    webpack --display-modules //打包时显示隐藏的模块  
    webpack --display-chunks //显示chunks，就是代码块  
    webpack --display-error-details //显示详细错误信息  
    webpack -p //对代码进行压缩混淆  
    webpack -d //sourcemap，调试代码的时候定位源码位置  
    webpack --profile //输出性能数据  
    ......

### 2、webpack 配置 

    定义一个webpack.config.js 文件，使用commonjs规范导出config对象

### 3丶脚手架

    vue-cli/react-creat-app/angular-cli

## webpack编译js

### 1、webpack命令 

    webpack  entry.js  output.js
    webpakc [config config.js] //webpack=>默认webpack.config.js

    
  webpack可以打包多种模块化文件，例如amd规范，哪怕没有引入amd模块化文件，依旧可以使用webpack处理模块化打包的问题  

  amd是一个异步加载模块，所有模块会提前加载，所以webpack打包时会形成单独的`chunk`文件，就是因为amd的异步模块。  

  cmd加载模块，如nodejs下，是按需加载，同步执行require函数，只有当执行到加载语句才会加载模块

### 2、webpack.config.js 出入口基本配置
```js
const path  = require('path');

module.exports = {
    //entry:'entry.js'==>entry:{ main : 'index.js' }//main表示默认
    //entry:['index.js','app.js']//多入口
    //-------【entry的key就是chunk名称】------
    entry:{
        //多入口
        index:'./index.js',
        app:'./app.js'
    },
    //output:'output.js'
    output:{
        path:path.resolve(__dirname,'dist')
        //name代表文件的名称，hash代表hash值，hash5表示5位hash值
        //打包成index.min.xxxxx.js , app.min.xxxxx.js  name=>entry[key]
        filename:'[name].min.[hash5].js',
    },

}
```
### 3、Babel编译ES6/7/8  

介绍一下webpack配置文件的module属性，module属性用来配置其他文件如css/sass/less,img/png/jpeg, ts/es6+语法的打包方式

```js   
    const path = require('path');
    module.exports = {
        entry:{
            app:'./app.js',
        },
        output:{
            path:path.resolve(__dirname,'dist'),
            filename:'[name].min.[hash].js',
        },
        module:{
            rules:[
                //first rule
                {
                    //test传入一个正则，正则内容表示匹配哪些文件，并用use列表的loader对文件进行处理
                    test:/\.js$/,
                    //use表示使用哪些loader
                    use:[
                        //loader执行是从数组最后一项执行到第一项，babel-loader是最后执行的js-loader
                        'babel-loader',/* 需要安装babel-loader和presets */
                    ],
                    //排除哪些目录
                    exclude:'/node_modules/',
                },
                //second rule
            ]
        }
    }
```
**这里使用到了babel,需要介绍一下babel相关的内容。**    
**安装babel-loader**  
npm install  babel-loader@8.0.0-beta.0 @babel/core //最新版本   
npm install -D babel-loader babel-core    //普通版本

**Babel Presets有一些内容**     
es2015 es2016 es2017  env babel-preset-react babel-preset-stage 0-3  
一般使用env，他会自动根据代码检测到合适的presets 

**安装babel presets需要根据babel-loader版本。**     
如果是上面的新版本loader，则 npm i @babel/preset-env -D  
如果是上面的普通版本，则 npm i babel-preset-env -D  
```js
    //我们可以更改一下上面的babel-loader相关的配置
  module:{
    rules:[{
        test:/\.js$/,
        use:{
            loader:'babel-loader',//loader:[]
            options:{
              //presets:['@babel/preset-env']
               presets:[
                  ['@babel/preset-env',{
                    //targets可以根据targets.browsers浏览器版本打包
                    //或者targets.node根据node版本打包，用于运行在node环境下
                    targets:{
                        chrome:'52',//兼容chrome52版本
                        //大于  浏览器全球占有率/使用率  浏览   主流浏览器最新的两个版本
                        browsers:[ '> 1%','last 2 versions'],
                        
                    } 
                  }]
              ],
              
          }
      },
      exclude:'/node_modules/',
    }]
}
```
**介绍两个babel插件Babel Polyfill , Babel Runtime Transform**    
babel-loader只是给我们编译了语法部分，一些ES6+的native-code 如Generator，Set等这些函数或者方法并无法编译，这时候就需要借助到这两个插件  

**Babel Polyfill**    
`为开发前端项目应用准备，全局垫片`   
npm i babel-polyfill -S => import 'babel-polypill' 
个人开发不需要在.babelrc文件中配置runtime,直接在文件中引用如下所示，  
这样就可以随意引用使用ES6+语法了，并且会在全局生成垫片函数等，而不是runtime的生成额外的引用文件
```js
  //app.js文件中
  import 'babel-polyfill'
  ...
  打包后生成一个较大的文件
```
**Babel Runtime Transform**    
`为开发框架准备，不会污染全局变量,是局部垫片，并且形成独立文件，需要在.babelrc配置文件中配置`  

npm i @babel/runtime -S //新版本loader需要安装的runtime版本  
npm i @babel/plugin-transform-runtime -D

npm i babel-runtime -S //普通版本loader需要安装的runtime版本  
npm i babel-plugin-transform-runtime -D
```js
    //可以吧module中的babel配置放到.babelrc下
    module:{
        rules:[
            {
                test:/\.js$/,
                use:'babel-loader',
                exclude:'/node_modules/',
            }
        ]
    }
    //.babelrc文件 注意是json格式的
    {
        "presets":{
            ["@babel/preset-env",{
                    "targets":{
                        "chrome":"52",
                        "browsers":[ "> 1%","last 2 versions"],
                    } 
                }
            ],
            //
        },
        "plugins":["@babel/transform-runtime",{
          "helpers": true,
          "polyfill": true,//全局垫片
          "regenerator": true,
          "moduleName": "babel-runtime"
        }]
    }

```
### 4、编译 typescript  
**安装**    
npm i typescript  ts-loader -D //官方loader  
npm i typescript   awesom-typescript-loader -D  //第三方loader  
**配置**    
ts有一个tsconfig.json配置文件，更多编译配置可以参考·官网/ docs /hanbook/ compiler-options.html
```js
    //webpack.config.js
    const path = require('path');
    module.exports = {
        entry:'./app.js',
        output:'app.bundle.[hash5].js',
        module:{
            rules:[
                {
                    test:/\.tsx?$/, //ts文件以ts或者tsx结尾
                    use:['ts-loader']
                }
            ]
        }
    }
    //tsconfig.json 更多编译配置可以参考·官网/ docs /hanbook/ compiler-options.html
    {
        "compilerOptions":{
            "module":"commonjs",//因为commonjs规范不仅包含自己也包含es6+的import引入
            "target":"es5",//编译到es版本，可选es3,es5,es2015...
            "allowjs":true,//是否允许js语法存在于ts中
            //typings/types,当webpack打包时会根据node_modules下的type类型包检查错误
            //或者当前目录下./typings/modules 的typeing类型包检查错误
            "typeRoots":[
                //type文件的路径
                "./node_modules/@type", //types不配置好像也可以在vscode和webpack打包中提示错误
                //typings文件的路径
                "./typings/modules",
            ]
        },
        "include":["./src/*"],
        "exclude":["./node_modules"],

    }
```
**介绍一下`types`声明文件(需要局部安装)**    
npm i @types/loadsh  
npm i @types/vue  
`开发过程中会vscode会提示loadsh vue的一些错误语法错误用法`  
`webpack打包的时候也会提示报错`  ss

**介绍一下`Typings`声明文件(全局或者局部安装)**    
npm i  typings  -g  
typings install lodash -S  此时项目根目录下会创建一个`typings.json文件`和`typings目录`(类型文件以.d.ts结尾)  
```js
{
 "dependecies":{
     "lodash":"reigstry:npm/lodash#4.0.....",
 }
}
//typeings目录
/typings/modules/lodash/['index.d.ts','typings.json']
```
`typings安装后仅在开发过程中会vscode会提示loadsh vue的一些错误语法错误用法`  
但是如果需要webpack编译过程成检测错误需要在tsconfig.json文件中配置(如上tsconfig.json)  

  

### 5、公共代码打包  
介绍一下插件的用法，前面我们已经使用过了entry，output,module。webpackconfig对象一个plugin属性，主要是使用一些插件来提供一些功能，比如公共代码部分打包插件 webpack.optimize.CommonsChunkplugin,这是一个类，接受一个options配置对象  
`chunk->代码片段`
```js
    //webpack.config.js - 
    //new webpack.optimize.CommonsChunkplugin(options)
    options：{
        // name:'',设置提取出来的chunk Name，也就是给提取出来的代码取名
        names:[],//设置多个chunk的名称，根据数组长度新建实例多少次，如果3个，则会提取成3个chunk，并且根据chunkName生出3个Name的文件到dist
        filename:'',//打包的名称，如果设置了filename,则打包名称为filename
        //num|fn|infinity
        minChunks: 2,//当代码出现次数超过2次及以上的时候提取为公共代码
        chunks:[], //指定提取代码的范围,从指定的chunks中提取公共代码
        children:true, //入口文件的子模块
        deepchildren:true,//所有子模块
        async:true,//创建一个异步的公共代码块
    }

```
**使用场景**    

    单页应用  
    单页应用 + 第三方依赖   
    多页应用 + 第三方依赖 + webpack生成代码  

**配置并测试一下这个插件**  

```js
    const path = require('path');
    const webpack = require('webpack')
    module.exports = {
        entry:{
            app:'./app.js'
        },
        output:{
            path:path.resolve(__dirname,'dist'),
            filename:'[name].bundle.[hash5].js',
            chunkFilename:'[name].chunk.[hash5].js'//webpack打包过程中会生成chunk文件，为了区别开filenamem配置一下chunk的filename
        },
        plugin:[
            new webpack.optimize.CommonsChunkPlugin({
                //从入口文件开始寻找公共代码
                name:'common',
                minChunks:2,
            })
        ]
        
    }
```
上面我们的配置是没问题的，但是依旧没办法将公共代码打包出去，因为是单入口文件，所以需要改变一下代码，代码改变细节需要仔细注意
```js
    const path = require('path');
    const webpack = require('webpack')
    module.exports = {
        entry:{
            app:'./app.js',
            index:'./index.js',
            //声明了vender后，在打包公共代码的时候会根据数组列表的内容打包成公共文件
            vender:['lodash'],
        },
        output:{
            path:path.resolve(__dirname,'dist'),
            filename:'[name].bundle.[hash5].js',
            chunkFilename:'[name].chunk.[hash5].js'//webpack打包过程中会生成chunk文件，为了区别开filenamem配置一下chunk的filename
        },
        plugin:[
            new webpack.optimize.CommonsChunkPlugin({
                name:'common',
                minChunks:2,
                //必填项，到指定chunk代码片段中抽离打包公共代码
                chunks:['app','index']
            }),
            new webpack.optimize.CommonsChunkPlugin({
                //当name指定成了入口的vender数组，
                name:'vender',
                //此时就不需要公共代码重复次数了
                minChunks:Infinity,
            }),
            new webpack.optimize.CommonsChunkPlugin({
                //把webpack生成代码单独提取出来
                name:'mainifest',
                minChunks:Infinity,
            })
            //这是一段猜测，plugin也是从后往前执行的，
            //第一次webpack将公共代码打包出来到mainifest
            //第二次根据vender将指定的lodash文件打包出来
            //第三次将项目代码的公共代码按照重复2次及以上这个标准打包出来
        ],
        //*****注意*****
        //上面的3个公共代码打包插件，下面两个可以合并
        plugin:[
            new webpack.optimize.CommonsChunkPlugin({
                name:'common',
                minChunks:2,
                chunks:['app','index']
            }),
            new webpack.optimize.CommonsChunkPlugin({
                names:['vender','common'],
                minChunks:Infinity,
            }),
        ]
    }
```

### 6、代码分割和懒加载  
**webpack methods**  

require.ensure(['dependencies'],calaback(){  require('a')   },errcb(){},chunkName)  
require.ensure对promise有强依赖的，如果你说运行的浏览器环境没有promise，注意添加polyfill   

require.inclued('dependencies'|['dependencies'])  
requrie.include 当两个模块都加载了同一个模块的时，可以将这个模块提取到父模块加载  

**ES2015 loader spec**  
System.import() => import()  
import()返回一个promise，所以可以import().then()这样调用  

**webpack import function**  
```js
// import(moduleA)
//import的注释是webpack的magicComments特性
 import(
     /* webpackChunkName:async-chunk-name */ ==>chunkName
     /* webpackMode:lazy */  ==>懒加载
          modulename
 )
```
**总结一下代码分割使用场景**  
分离业务代码  和  第三方依赖                 CommonsChunkPlugin插件 章节5 结尾的那段配置  
分离业务代码  和  业务公共代码 和 第三方依赖  CommonsChunkPlugin插件 章节5 结尾的那段配置  
分离首次加载  和  访问后加载的代码           lazy load  

## webpack编译css

### 1、css style-loader 和 css-loader  
style-loader会把css代码打包到style标签内,只是有创建标签的作用,css的打包分离还是css-loader来完成,css-loader会把js文件中import的css文件进行处理，并交给style-loader做成标签放进html页面中  

style-loader还有其他选项  
style-loader/url  
style-loader/useable  
```js
    const path = require('path');
    const webpack = require('webpack')
    module.exports = {
        entry:{
            app:'./app.js',
        },
        output:{
            path:path.resolve(__dirname,'dist'),
            //打包后的css文件找不到正确路径，这时候需要配置publicPath
            publicPath:'./dist',
            filename:'[name].bundle.[hash5].js',
        },
        module:{
            rule:[ {
                    //v1
                    //import 'css.css'
                    test:/\.css$/,
                    //npm i style-loader css-loader
                    use:['style-loader','css-loader'],

                    //v2
                    //这种方式不同的import css会打包成不同的link标签，增加http请求
                    test:/\.css$/,
                    use:[  
                        //import 'css.css'
                        'style-loader/url',//插入link标签
                        //npm i file-loader 
                        'file-loader',//这样会把css当成文件来打包，这样就用不上css-loader了
                    ],

                    //v3
                    test:/\.css$/,
                    use:[  
                        'style-loader/useable',
                        'css-loader',
                        //使用方式就变成了
                        //import css from 'css.css'
                        // css.use() css.unuse()这样可以通过代码控制css 也可以通过bool值来在浏览器下添加取消css的引入
                    ]
                }, ]
        }
```
**`style-loader还有一些配置选项`**  
options{
    insetAt(插入位置)
    insertInto(插入到dom)
    singleton (是否只是用一个style标签)
    transform(转化,浏览器环境下,插入页面前)
}
```js

    test:/\.css$/,
    use:[{
        loader:'style-loader',
        options:{
            insetInto:'app'，//插入到#app内
            singleton:true,
            //自己定义transform规则，这个函数并不是在打包时执行，而是在运行环境下执行，可以根据浏览器环境，window对象等判断如何处理css
            transform:'./transform.js'||fn 
        }
    }],
```
**`css-loader配置选项`**   
options{
    alias(解析的别名)
    importLoader(@import)
    Minimize(压缩)
    modules(是否启用css-moudles){
        :local
        :global
        composes: .class from './css.css'
    }
}  
`css-module的一些知识`
```js
    use:['style-loader',{
            loader:'css-loader',
            optiosn:{
                minimize:true,
                modules:true,//遮掩就可以使用modules的一些功能比如composes
                lcalIndentName:'[name][path][local][hash:base64:5]',
                //path,引用的css路径，name:引入的css名称，local本身的class名称
            }
        },}
```
### 2 sass-loader less-loader  
npm i less  less-loader -D  
npm i node-sass sass-loader -D
```js
    test:/\.(c|le|sa|sc)ss$/,
    use:[
       'style-loader',
       'css-loader',
       'less-loader'|| 'sass-loader',
       //loader像是中间件，从数组末尾向前也就是 从下到上传递执行
```

### 3、css提取
css提取有两个方式，一个是extract-loader,还有一个是ExtractTextWebpackPlugin  
npm i estract-text-webpack-plugin -D  
**`额外提示一个插件mini-css-extract-plugin `**
```js
//webpack.config.js
modules:{
    rule:[
        test:/\.(c|le|sa|sc)ss$/,
        //return use
        ExtractTextWebpackPlugin.extract(
            {  //fallback表示不使用提取时使用style-loader插入标签
                fallback:{
                    loader:'style-loader',
                }//extract提取后再转交给以下loader执行
                use:[/* the normal loader */'css-loader','less-loader',]
             }
        ), ]
}
plugins:[
    new ExtractTextWebpackPlugin({
        filename:'[name].min.css',//提取成什么文件名
        allChunks:true //默认false提取的是初始化入口内的css，动态导入import的css模块并不会被提取成文件，需要配置allchunks
    })
]

```
### 4、postcss-loader
postcss是一个多功能的强大的css预处理工具，配合生态插件可以做很多强大的事情  

**安装**  
npm i postcss 
npm i postcss-loader Autoprefixer postcss-cssnano posticss-cssnext -D  

**postcss生态**    
Autoprefixer  浏览器前缀补齐  
postcss-cssnano  压缩优化(内部也是使用的css-loader minimize)  
postcss-cssnext  可以使用css4语法，嵌套语法(内部包含了autoprefixer)      
postcss-import   监听  @import 导入的css的变化并编译   
postcss-url      @import的url可能会发生变化，需要配合url来使用  
postcss-assets  
precss(类似scss语法，嵌套语法)  

**使用** 
```js
    modules:{
    rule:[
        test:/\.(c|le|sa|sc)ss$/,
        use:[
            'style-loader',
            {
                loader:'postcss-loader',
                options:{
                    ident:'postcss',//表面下面的拆件是给postcss使用的
                    plugins:[
                        // require('autoprefixer')(),
                        require('postcss-next')(),//内部包含了autoprefixer

                    ]
                }
            }
        ]
    ]
```
### 5、补充   browserlist 知识点
上一章节的loader，如 autoprefixer 或者 babel-loader 都会用到相关的 browsetlist
，所以我们可以把 browsetlist 整理成 .browserlistrc   

或者把 browsetlist 放入 package.json 中，这样使用到browserlist的插件都会去 package.json 中查找 browserlist  
```js
//package.json
{
    ...
    "depedencies":{

    },
    "browserslist":[
        ">=1%,",
        "last 2 versions",

        
    ]

    ...
}
```
## Tree Shaking(css,js)
### 1、js tree shaking
```js
    //webpack.config.js
    const webpack =requie('webpack');
    plugin:{
        //本地自己写的代码的tree shaking 
        new webpack.optimize.UgfifyJsPlugin()
        
    }
    //第三方库的tree shaking 
    module:{
        rules:[
            {
                test:/\.(c|le|sa|sc)ss$/,
                use:[
                    'style-loader',
                    {
                        loader:'postcss-loader',
                        options:{
                            indent:'postcss',
                            plugins:[
                                require('postcss-next')(),
                            ]
                        }
                    }
                ]
            }
            {
                test:/\.js/,
                use:[
                    {
                     loader:'babel-loader',
                     options:{
                         preset:['env'],
                         plugins:['lodash'], //lodash无法tree shaking 需要借助babel-plugin-lodash  [import lodasEs from 'lodash-es']

                     }
                    }
                ]
            }
        ]
    }
```
### 2、css tree shaking
 Purify css 
 options{
      paths:glob.sycn
 }
```js
    //npm i -D purifycss-webpack
    const PurifyCss= require("purifycss");
    //npm i -D glob-all
    const glob = require('glob');
    

    plugin:{
        new ExtractTextWebpackPligin()
        new PurfiyCss({
            paths:glob.sync([ //glob.sync为了加载多路径  npm i -D glob-all
                path.join(__dirname,'./*.html')
                path.join(__dirname,'./src/*.js)
            ])
        })
        new webpack.optomize.UglifyJsPlugin(

        )
    }
```
## webpack 打包 img 文件 等
```js
module:{
    
    rules:[
        {
            ...
        },
        //v1
        {
            //打包图片
            test:/\.(img|png|jpeg|gif)$/,
            use:{
                loader:"file-loader",
                options:{       
                    public:'',//3、按照下面设置后，如果../引入的文件路劲依旧会报错如/dist/../assets，设置为''则表示路径开头../assets 注意css文件目录在(dist/css/a.css)才会需要这样配置
                    output: './dist/',//2、设置下面选项后，指定输出到./dist 下
                    ussRelativePath:true,//1、根据你引入的图片路径保留路径，并且根据这个路径生成文件
                }
            }
        } 

        //v2 
        {
            test:/\.(img|png|jpeg|gif)$/,
            use:{
                loader:"url-loader",
                options:{
                    limit:4000,//< 4kb  的图片会被打包成base64

                }
            }
        } 
        //v3
        {
            test:/\.(img|png|jpeg|gif)$/,
            use:[
                "url-loader",
                {
                    loader:"img-loader",
                    options:{
                        limit:4000,//< 4kb  的图片会被打包成base64
                        //压缩图片
                        pngquont:{
                            quality:80
                        }
                    }
                }
            ]
        } 
    ]
}
```