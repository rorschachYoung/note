## node中的module
>node的模块遵循commonJS规范，引用文件用require('moduleName'),导出文件使用exports和module.exports
#### require
```js
//http是node内置模块
    const http =require('http')
    //require引包的时候，会查找node_modules文件夹并向上层递归查找
    
    //以jq为例，require会查找jquery下面的packag.json的module,其次是main，然后引入main值
    //所对应的文件夹，如果值路径无效，则查找jquery文件下的同名jquery.js或者
    //jquery.json或者index.js,按照顺序查找
    const pathname = require.resolve('jquery')
    //require.resolve()方法返回jquery的文件目录，jquery的文件路径为
    // 'node_modules/jquery/'+package.json.main

    const test =require('./test')//引入./test.js||./test/index.js并立即执行
    console.log('after test'); //./test.js||./test/index.js执行完毕后执行log语句

    //**注意**
    //导入自定义模块需要相对路径，如果require('test')没有./的话，则会向node_modules文件夹查找并向上级递归查找，从而导致引包报错
    
```
## 自定义模块
#### exports暴露模块
```js
    //a.js
    exports.a = 'a'
    exports.b = 'b'
    //b.js
    const a = require('a')//引入a.js
    console.log(a.a)//'a'
    console.log(a.b)//'b'
    // a对象  => exporsts对象
    
```
#### module.exports暴露模块
```js
    //a.js
    module.exports = 'a' 
    //b.js
    const a = require('a')//引入a.js
    console.log(a)//'a'
    // a对象  => exporsts对象==module.exports
    
```
## node_modules特性
>node_modules文件夹有一些特性
>+ 会查找当前目录的node_modules的文件夹，并向上递归查找node_modules文件夹以及全局npm文件夹下的node_modules文件夹
>+ 默认会查找package.json配置里面的module,其次是main值路径，并依次查找同名.js,同名.json,index.js
```js
    //文件查找会根据上面的查找规则，注释以.js为例讲解
    require('./a.js')  //   ./a.js
    require('./a')     //   ./a.js
    require('a')       //   node_modules/a/index.js
    require('a.js')    //   node_modules/a.js
```