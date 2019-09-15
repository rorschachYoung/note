
# git 初始化操作
## 对远程git仓库拉取后如何操作
```s
git clone .... 克隆仓库
git fetch origin  对origin仓库地址拉去所有分支
git branch 查看当前的分支
git checkout dev 切换到开发分支
git pull origin dev  拉取分支代码
git push origin dev
git checkout -b newbranch 切换分支newbranch,如果没有该分支则创建

```
## git 操作
```
git log 查看 commit 记录版本号
git reset --hard  [版本号]  版本回退
```
#### git config -l
    表示列表出config配置
#### git config --global user.name [myname]
    配置我的git user name
#### git config --global user.email [myemail]
    配置我的git user myemail
#### 进入要创建git仓库的目录，打开git bush输入命令
#### git init
    会创建一个.git的隐藏文件
#### 可以手动创建.gitignore,可以通过mkdir或者linux的touch创建.gitignore文件
# git 仓库介绍
    git本地仓库有三个区域，分为工作区，暂存区，历史区
    工作区->暂存区->历史区
# git 命令
#### git status
    查看 仓库文件状态，
    红色表示处于工作区
    绿色表示已经保存到了暂存区，但没有保存到历史区
    没有表示已经存到了历史区
#### git 提交命令
    git add filename 提交指定文件
    git add .        提交修改和增加的，删除不算
    git add -u       提交修改和删除的，增加不算
    git add -A       全部提交
#### git add 提交（暂存区）
    git add -A       工作区文件全部提交到暂存区
#### git rm  从缓存区删除
    git rm --cached 1.txt
    git rm --cached . -r    删除
    如果工作区文件已经出现修改，上面命令会失效，需要加上 -f(force)
    git rm --cached . -rf
#### git chechout 从暂存区撤回
    git checkout 1.txt
#### git commit 提交（历史区）
    git commit -m 'content' 把暂存区文件提交到历史区，content为提交描述
#### git log
    查看历史区提交历史记录
#### git reflog
    查看历史区提交历史记录包括回滚记录
#### git diff [master | --cached]
    git diff 表示查看工作区和暂存区不同
    git diff master 查看工作区和历史区master分支不同
    git diff --cached 查看暂存区和历史区
# git 远程命令  
#### git remote add [origin] [github地址]
    建立仓库 关联远程地址[github地址] 取名为[origin] ，origin为默认值
#### git remote remove [origin]
    删除关联远程仓库[origin]
#### git pull [origin] master
    拉取远程 master分支
#### git push [origin] master
    推送到远程master分区
#### git remote -v
    查看remote关联的仓库地址
# git快捷开发操作
#### git clone [github地址] [project_name]
    在当前文件夹下从远程仓库 [github地址] clone 项目并取名 [project_name]
#### 开发完成后同步所需操作
    git pull 拉取
    git add .   添加到暂存区
    git commit -m 'content' 添加到历史区
    git push   历史区推送同步到远程仓库
# git回滚操作
#### git checkout .       把暂存区回滚到工作区
#### git reset HEAD .     把暂存区回滚到上一个暂存区
#### git reset --hard [version]    把历史区回滚到某一指定版本,暂存和工作区都变成该版本
#### history >  1.txt     把历史操作输出到1.txt 
# git分制管理
#### git branch查看当前分支
#### git branch dev 创建一个dev的分支
#### git branch -D [分支] 删除分支
#### git checkout dev  切换到dev分支
#### git checkout -b dev 创建并且切换到这个分支
#### git stash 


