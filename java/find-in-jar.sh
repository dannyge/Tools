#!/bin/bash
# 此脚本在Jar包中的包名和类名中查找某一关键字，并高亮显示匹配的Jar包名称和路径，
#多用于定位java.lang.NoClassDefFoundError和java.lang.ClassNotFoundException的问题，以及类版本重复或者冲突的问题等。
#命令格式：
# find-in-jar 关键字或者类名 路径
find . -name "*.jar" > /tmp/find_in_jar_temp

while read line
do
 if unzip -l $line | grep $1 &> /tmp/find_in_jar_temp_second
 then
   echo $line | sed 's#\(.*\)#\x1b[1;31m\1\x1b[00m#'
   cat /tmp/find_in_jar_temp_second
 fi
done < /tmp/find_in_jar_temp