# React-Native环境搭建

## 一、安装简易脚手架Expo(简易配置运行环境)
### 1、Expo
>$ npm i -g expo-cli   
>$ expo init rndemo  
> //然后配置项目名称的json  
>$ cd rndemo   
>$ npm start || yarn start | expo start  

这是expo的基本搭建流程，除此之外你还得去google play下载expo app来运行项目  

### 2、create-react-native-app
>$ npm i -g create-react-native-app  
>$ create-react-native-app rndemo  
>$ cd rndemo  
>$ npm start  | expo start  

这也是简易运行react-native的方式，需要下载npm包，而且这是基于expo的，当你用create-react-native-app rndemo初始化项目的时候他会提示你依赖expo-cli，所以还是得装expo-cli，同expo的方式基本一样  

### 3、这里可能有一个网卡错误问题
> cmd $ ipconfig 
>//查看启动服务的ip处于哪个网段
  **expo运行的项目会选取本地的某一个网卡，可能是无线网卡，可能是虚拟网卡，因为环境要求手机上的expo和expo项目处在一个局域网环境下，所以就意味着必须选择无线网卡，因为expo选取网卡是随机的，所以当选取的网卡不是无线网卡的时候，重新运行项目尝试即可**  

`解决`  
  1、修改环境变量<方法1>  
  这个ip地址应该是你无线网卡的ipv4地址

  >$ set REACT_NATIVE_PACKAGER_HOSTNAME=192.168.x.x  

  2、设置网卡优先级  
    修改网络优先级，Win10之前，控制面板>网络连接页面>菜单栏>高级>高级设置。Win10可能需要修改接口跃点数  

## 二、连接安卓设备  
    需要安装adb，也就是安卓sdk的环境配置
    adb connect 127.0.0.1:7555   //端口是mumu模拟器的的默认端口
    adb connect 127.0.0.1:62001  //端口是夜神模拟器的默认端口


## 三、配置开发环境
    前面我们只是配置了简单的运行环境，可以在手机上查看，如果想要连接到本地模拟器，Android虚拟机 还需要安装java_jdk1.8  python_2 node_npm react-native-cli，这些不仅是为了开发配置也是为了打包生成而配置。