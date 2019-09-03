# mongoose基础

## 1.model
```js
    //dbconfig.js--------------------------------
    //声明配置选项
    module.exports = {
        //数据链接地址
        dbs:'mongodb://127.0.0.1:27017',

    }
    //person.js----------------------------------
    // person就是表名 collection
    let mongoose = require('mongoose');
    //创建schema
    let personSchema = mongoose.Schema({
        name:String,
        age:Number,
    })
    //导出model，跟后台model一样，有增删改查，在第二节讲
    module.exports = mongoose.model('Person',personSchema)
    //app.js-----------------------------------------
    //如何使用
    const mongoose = require('mongoose');
    const dbconfig =require('./dbconfig');
    const Person = require('./person.js');
    const Koa = require('koa');
    let app = new Koa();
    mongoose.connect(dbconfig.dbs,{
        useNewUrlParser:true,
    })
    app.use('/',async(ctx,next)=>{
        //建立model实例，可以使用增删改查方法
        let person = new Person({
            name:ctx.request.body.name,
            age : ctx.request.body.age,
        })
        let result = await person.save()
        ctx.body = {
            code:200
        }
    })
```

## 2. mongoose增删改查案列
上面我们介绍mongoose的基本使用，下面将介绍mongoose的基本增删查改操作
```js
    //app.js
    const Person  = require('./person.js');//person.js内容在上一讲
    //Person类的方法都是node回调形式的异步函数，即function(err,doc){},
    let name,age;
    //查询单个
    Person.findOne({name,age})；
    Person.find({name})
    //给所有name = name的更新为{name,age}
    Person.where({name}).update({name,age})
    Person.where({name}).remove()
```
**`>>案例如下<<`**
```js
/* 
    mongoose pratice
    以博客为例
*/
const mongoose = require('mongoose');
mongoose.connect('mongodb://localhost:27017/test',{
    useNewUrlParser:true,
})

/* 创建model */
const Post = mongoose.model('Post',new mongoose.Schema({
    title:{
        type:String,
    },
    body:{
        type:String,
    },
    category:{
        type:mongoose.SchemaTypes.ObjectId,
        ref:"Category"
    },
    categorys:[{
        type:mongoose.SchemaTypes.ObjectId,
        ref:"Category",
    }]
}))
// 表的关联
const CategorySchema = new mongoose.Schema({
    name:{
        type:String,
    },
},
{
    toJSON:{
        virtuals:true,//下面tojson输出的时候带上virtual的字段
    }
})
CategorySchema.virtual('post',{
    localField:'_id',  
    ref:'Post',                //表示本地_id关联到Post.category
    foreignField:'category', 
    justOne:false,//查询的是否是一条
})
const Category = mongoose.model('Category',CategorySchema)
async function getRelation(){
    // let category  = await Category.find().populate('posts')
    // console.log(JSON.stringify(category)) //输出category要设置{toJson:{virtuals:true}}
    let category  = await Category.find().populate('posts').lean() //表示输出纯粹的json数据
    console.log(category[0]) //效果同上
}
getRelation()


//获取
async function getPost(){
    // Category.db.dropCollection('categorys');
    // Post.db.dropCollection('posts');
    // await Category.insertMany([
    //     {
    //         name:'nodejs'
    //     },
    //     {
    //         name:'vuejs'
    //     } 
    // ])
    // await Post.insertMany([
    //     {
    //         title:"title1",
    //         body:"content1",

    //     },
    //     {
    //         title:"title2",
    //         body:"content2",
    //     }
    // ])
    // const cate1 =await Category.findOne({name:'vuejs'})
    // const cate2 = await Category.findOne({name:"nodejs"})
    // const post1 = await Post.findOne({title:"title1"})
    // const post2 = await Post.findOne({title:"title2"})

    // post1.category = cate1;
    // post1.categorys = [cate1,cate2];
    // post2.category = cate2;
    // post2.categorys = [cate1,cate2];
    // await post1.save();
    // await post2.save();
    // let data = await Post.find().populate('categorys');//查询关联表的数据
    // console.log(data)
}
let data = getPost()
```