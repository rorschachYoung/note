# 闲话不多说，直接上配置
```js
    //webpack.config.js
    const path =require('path');
    module.exports = {
        entry:{
            main:'./src/index.js',
            sub:'./src/sub.js',
        },
        //cheap inline可选，也可以直接source-map,
        //cheap表示报错定位到行不到列，提高打包性能，
        //inline表示不生成sourcemap文件而是注入到出口文件中
        //module表示第三方库都包括
        //eval 也会定位错误，以注释形式跟在语句后面，相对最快的方式
        devtool:'module-cheap-eval-source-map' 
        output:{
            // filename:'bundle.js',
            //当有多个入口文件时，会导致使用同一个bundle,注意配置
            filename:"[name].[hash].[ext]"
            path:path.resolve(__dirname,'dist'),
            //文件打包后被htmlwebpackplugin插入到html文件中，给他们配置一个"www.cdn.com"前缀，以便客户端直接请求cdn服务
            public:"http://www.cdn.com",
        },
        devServer:{
            contentBase:'./dist',
            //自动打开浏览器地址
            open:true,
            proxy:{
                //代理用户的跨域请求api，用服务器去请求，屏蔽跨域
                '/api':'http://localhost:3000",
            },
            //模块热更替 hmr
            hot:true,

        },
        module:{
            rules:[
                {
                    test:/\.js$/,
                    use:'babel-loader',
                    exclude:'/node_modules/',
                    options:{
                        presets:[
                            [
                                '@babel/preset-env',
                                {
                                    targets:{
                                        chrome:'52',
                                        browsers:[ '> 1%','last 2 versions'],
                                    } ,
                                    //babel补充那些低版本无法使用的方法，usage表示补充使用到的
                                    useBuiltIns:'usage',//需要在入口文件import 'babel-polyfill'

                                }
                            ],
                        ],

                    }
                },
                //img loader
                {
                    test:/\.(jpg|png|gif|svg)$/,
                    use:[
                        {
                            loader:'url-loader',
                            options:{
                                name:'[name].[hash5].[ext]',
                                outputPath:'images/',
                                limit:2048,
                            }
                        },
                    ]
                },
                //font loader
                {
                    test:/\.(eot|ttf|svg)/,
                    use:{
                        laoder:'file-loader',
                        
                    }
                },
                //css loader
                {
                    test:/\.(sc|sa|le|s)ss$/,
                    use:[
                        'style-loader',
                        {
                            loader:'css-loader',
                            options:{
                                //以sass为例，当sass文件内部引入了sass文件,退回2个loader处理
                                importloader:2,
                                //例如index.js import css，这时候css是全局的，module可以让css文件只作用于当前文件
                                module:true, // =>import style from './css.scss' node.class.add(style.nodeClass)
                            },
                        },
                        'sass-loader',
                        //post-loader require postcss.config.js
                        'post-loader',    
                    ]
                    //postcss.config.js
                    module.exports ={
                        plugins:{
                            require('Autoprefixer'),
                            'postcss-import':{},
                            'postcss-preset-env':{},
                            'cssnano':{},
                        }
                    }
                }
            ]
        },
        plugins:[
            //html webpack plugin 插件会自动生成html，并把打包后的bundle.js引入
            new HtmlWebpackPlugin({
                //如果引入template后就不会生成html，而是用指定的template
                template:'src/index.html',
            }),
            new webpack.HotMoudleReplacementPlugin(),
            //每次生成时删除上一次产生的dist文件夹
            new CleanWebpackPlugin(['dist']),
        ]
    }
```