set names utf8; -- 设置字符集
create database if not exists school;
use school;
-- 创建学生表
create table if not exists student(
	no varchar(32) not null comment '学生编号number',
	name varchar(20) not null comment '学生姓名',
	gender int(1) not null default 1 comment '性别1为男,0为女',
	birthday datetime comment '出生日期',
	class varchar(20) comment '班级'
);
-- 创建教师表
create table if not exists teacher(
	no varchar(32) not null comment '教师编号number',
	name varchar(20) not null comment '教师姓名',
	gender int(1) not null default 1 comment '1为男,0为女',
	birthday datetime comment '出生日期',
	profession varchar(20) comment '职位',
	department varchar(20) not null comment '部门'
);
-- 创建课程表
create table if not exists course(
	no varchar(20) not null comment '课程编号',
	name varchar(20) not null comment '课程名称',
	tno varchar(20) not null comment '教师编号'
);
-- 创建成绩表
create table if not exists score(
	sno varchar(20) not null comment'学生编号',
	cno varchar(20) not null comment'课程标号',
	degree decimal(4,1) not null comment'分数' -- decimal(4,1) 表示长度为4,但有一位是小数,例如 125.0 , 59.5
);
-- 添加主键外键,后续添加的方式(表已存在)建立外键
alter table student add constraint primary key(no); -- 给学生表添加主键,key是id字段
alter table teacher add constraint primary key(no); -- 给教师表添加主键,key是id字段
alter table course add constraint primary key(no); --  给课程表添加主键,key是id字段
alter table course add constraint foreign key(tno) references teacher(no); --  给课程表添加外键约束是course.tno,teacher.no
alter table score add constraint foreign key(sno) references student(no);-- 给分数表添加外键约束是score.sno,student.no
alter table score add constraint foreign key(cno) references course(no);-- 给分数表添加外键约束是score.cno,course.no
alter table score add constraint primary key(sno,cno); -- 给分数表添加联合主键,key是sno,cno字段
-- 插入数据
insert into student(no,name,gender,birthday,class) values
('108','曾华',1,'1977-09-01','95033'),
('105','匡明',1,'1975-10-02','95031'),
('107','王丽',0,'1976-01-23','95033'),
('101','李军',1,'1976-02-20','95033'),
('109','王芳',0,'1975-02-10','95031'),
('103','陆君',1,'1974-06-03','95031');
insert into teacher values
('804','李诚',1,'1958-12-02','副教授','计算机系'),
('856','张旭',1,'1969-03-12','讲师','电子工程系'),
('825','王萍',0,'1972-05-05','助教','计算机系'),
('831','刘冰',0,'1977-08-14','助教','电子工程系');
insert into course values
('3-105','计算机导论',825),
('3-245','操作系统',804),
('6-166','数据电路',856),
('9-888','高等数学',831);
insert into score values
(103,'3-245',86),
(105,'3-245',75),
(109,'3-245',68),
(103,'3-105',92),
(105,'3-105',88),
(109,'3-105',76),
(101,'3-105',64),
(107,'3-105',91),
(108,'3-105',78),
(101,'6-166',85),
(107,'6-166',79),
(108,'6-166',81);
-- 后续新增
create table if not exists grade (
	low int(3),
	up int(3),
	rank char(1)
);
insert into grade values
(90,100,'A'),
(80,89,'B'),
(70,79,'C'),
(60,69,'D'),
(0,59,'E');
