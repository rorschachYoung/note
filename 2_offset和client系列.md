# offset和client系列
left top  width hegiht 都是元素的offset client属性
## 1、Element.offset 系列  
元素属性,记录元素的偏移量,参照定位父元素?定位父元素:body
### 1.1 --offsetParent--
>从ie7开始区分
>- 如果本身定位为fixed：
>      + offsetParent = null (ie7以上浏览器) 
>      + offsetParent = body (火狐有些特殊) 
>- 如果本身定位不为fixed
>      + 父级有定位    offsetParent = 父级
>      + 父级无定位    offsetParent = body             
>
>ie7以下
>- 如果某一个向上父级触发了haslayout
>      + offsetParent = haslayout父级
### 1.2 offsetLeft offsetTop 
Element.offsetLeft Element.offsetTop
相对于父定位元素的 左上偏移,如果没有父定位元素,则直接根据body定位

### 1.2 offsetWidth offsetheight
>   获取元素的border-box的宽高

    1、根标签依旧是获取border-box的宽高，如果html设置了margin，则根标签的ow oh是指视口大小减去margin
    2、在ie10及ie10一下，根标签的cw ch，ow,oh统一被指定视口大小

## 2、Element.client系列

### 2.1 clientWidth clientHeight
获取元素的padding-box的宽高

>    1、doucment.doucumentElement是根标签(html)，这里有些区别
>    根标签的cw，ch不是指可 视区域(padding-box)的大小，而是指视口大小
### 2.2 clientLeft clientTop
获取的是border-top  border-left的值
## 3、Element.scroll 系列
### 3.1 scrollTop  scrollLeft
获取的scrollTop scollLeft 元素滚动的距离
document.scrollTop  dcoument.scollLeft 窗口滚动的距离
### 3.2 scrollHeight scrollWidth
当内容超出元素的时候,出现滚动条,这时候scrollHeight scrollWidth是内容的高度  比 元素要大很多

## 5、getBundingClientRect--API
>   返回一个对象
>    left top right bottom：返回元素相对于视口的位置
>    x y height(border-box) width(border-box) :有部分兼容问题参考mdn
>   获取绝对位置
>    需要加上
>           document.documentElement.scrollLeft(scrollerTop)
>           ||
>           document.body.scrollLeft(scrollerTop)

