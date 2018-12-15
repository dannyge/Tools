#!/bin/bash
# @Function
# Find out the highest cpu consumed threads of java, and print the stack of these threads.
#
# @Usage
#   $ ./show-busiest-java-threads
# 此命令通过结合Linux操作系统的ps命令和jvm自带的jstack命令，查找Java进程内CPU利用率最高的线程，
# 一般适用于服务器负载较高的场景，并需要快速定位导致负载高的原因。
#
# 命令格式：
#   ./show-busiest-java-threads -p 进程号 -c 显示条数
#   ./show-busiest-java-threads -h
#
# @author Jerry Lee

PROG=`basename $0`

usage() {
   cat < /dev/null; then
   [ -n "$JAVA_HOME" ] && [ -f "$JAVA_HOME/bin/jstack" ] && [ -x "$JAVA_HOME/bin/jstack" ] && {
       export PATH="$JAVA_HOME/bin:$PATH"
   } || {
       redEcho "Error: jstack not found on PATH and JAVA_HOME!"
       exit 1
   }
fi

uuid=`date +%s`_${RANDOM}_$$

cleanupWhenExit() {
   rm /tmp/${uuid}_* &> /dev/null
}
trap "cleanupWhenExit" EXIT

printStackOfThread() {
   while read threadLine ; do
       pid=`echo ${threadLine} | awk '{print $1}'`
       threadId=`echo ${threadLine} | awk '{print $2}'`
       threadId0x=`printf %x ${threadId}`
       user=`echo ${threadLine} | awk '{print $3}'`
       pcpu=`echo ${threadLine} | awk '{print $5}'`
       
       jstackFile=/tmp/${uuid}_${pid}
       
       [ ! -f "${jstackFile}" ] && {
           jstack ${pid} > ${jstackFile} || {
               redEcho "Fail to jstack java process ${pid}!"
               rm ${jstackFile}
               continue
           }
       }
       
       redEcho "The stack of busy(${pcpu}%) thread(${threadId}/0x${threadId0x}) of java process(${pid}) of user(${user}):"
       sed "/nid=0x${threadId0x}/,/^$/p" -n ${jstackFile}
   done
}

[ -z "${pid}" ] && {
   ps -Leo pid,lwp,user,comm,pcpu --no-headers | awk '$4=="java"{print $0}' |
   sort -k5 -r -n | head --lines "${count}" | printStackOfThread
} || {
   ps -Leo pid,lwp,user,comm,pcpu --no-headers | awk -v "pid=${pid}" '$1==pid,$4=="java"{print $0}' |
   sort -k5 -r -n | head --lines "${count}" | printStackOfThread
}