#!/bin/bash
#此脚本用于识别冲突的Jar包，可以在一个根目录下找到所有包含相同类的Jar包，并且根据相同类的多少来判断Jar包的相似度，
#常常用于某些功能上线不可用或者没有按照预期起到作用，使用此脚本分析是否存在两个版本的类，而老版本的类被Java虚拟机加载，
#其实，JVM规范并没有规定类路径下相同类的加载顺序，实现JVM规范的虚拟机的实现机制也各不相同，
#因此无法判断相同的类中哪个版本的类会被先加载，因此Jar包冲突是个非常讨厌的问题。
#命令格式：
# jar-conflict-detect 路径
if [ $# -eq 0 ];then
   echo "please enter classpath dir"
   exit -1
fi

if [ ! -d "$1" ]; then
   echo "not a directory"
   exit -2
fi

tmpfile="/tmp/.cp$(date +%s)"
tmphash="/tmp/.hash$(date +%s)"
verbose="/tmp/cp-verbose.log"

declare -a files=(`find "$1" -name "*.jar"`)
for ((i=0; i < ${#files[@]}; i++)); do
   jarName=`basename ${files[$i]}`
   list=`unzip -l ${files[$i]} | awk -v fn=$jarName '/\.class$/{print $NF,fn}'`
   size=`echo "$list" | wc -l`
   echo $jarName $size >> $tmphash
   echo "$list"
done | sort | awk 'NF{
   a[$1]++;m[$1]=m[$1]","$2}END{for(i in a) if(a[i] > 1) print i,substr(m[i],2)
}' > $tmpfile

awk '{print $2}' $tmpfile |
awk -F',' '{i=1;for(;i<=NF;i++) for(j=i+1;j<=NF;j++) print $i,$j}' |
sort | uniq -c | sort -nrk1 | while read line; do
   dup=${line%% *}
   jars=${line#* }
   jar1=${jars% *}
   jar2=${jars#* }
   len_jar1=`grep -F "$jar1" $tmphash | grep ^"$jar1" | awk '{print $2}'`
   len_jar2=`grep -F "$jar2" $tmphash | grep ^"$jar2" | awk '{print $2}'`
   # Modified by Robert 2017.4.9
   #len=$(($len_jar1 > $len_jar2 ? $len_jar1 : $len_jar2))
   len_jar1=`echo $len_jar1 | awk -F' ' '{print $1}'`
   len_jar2=`echo $len_jar2 | awk -F' ' '{print $1}'`
   if [ $len_jar1 -gt $len_jar2 ]
   then
     len=$len_jar1
   else
     len=$len_jar2
   fi
   per=$(echo "scale=2; $dup/$len" | bc -l)
   echo ${per/./} $dup $jar1 $jar2
done | sort -nr -k1 -k2 |
awk 'NR==1{print "Similarity DuplicateClasses File1 File2"}{print "%"$0}'| column -t

sort $tmpfile | awk '{print $1,"\n\t\t",$2}' > $verbose
echo "See $verbose for more details."

rm -f $tmpfile
rm -f $tmphash