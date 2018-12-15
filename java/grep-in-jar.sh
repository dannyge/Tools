#!/bin/bash
# grep text in jars
#本在Jar包中进行二进制内容查找，通常会解决一些线上出现的“不可思议”的问题，
# 例如：某些功能上线没有生效、某些日志没有打印等，
# 通常是上线工具或者上线过程出现了问题，把线上的二进制包拉下来并查找特定的关键字来定位问题。
#命令格式：
#grep-in-jar 关键字 路径

if [ $# -lt 2 ];then
   echo 'Usage : jargrep text path'
   exit 1;
fi

LOOK_FOR=$1
LOOK_FOR=`echo ${LOOK_FOR//\./\/}`
folder=$2
echo "find '$LOOK_FOR' in $folder "
for i in `find $2 -name "*jar"`
do
   unzip -p $i | grep "$LOOK_FOR" > /dev/null
   if [ $? = 0   ]
   then
       echo "==> Found \"$LOOK_FOR\" in $i"
   fi
done