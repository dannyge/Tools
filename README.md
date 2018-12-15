#常用工具、脚本收集
##java
 - 服务器负载高、服务超时、CPU利用率高 show-busiest-java-threads
java.lang.NoClassDefFoundError、java.lang.ClassNotFoundException、程序未按照预期运行   find-in-jar
程序未按照预期运行、上线后未执行新逻辑、查找某些关键字 grep-in-jar
Jar包版本冲突、程序未按照预期运行  jar-conflict-detect
HTTP调用后发现未按照预期输出结果  http-spy
数据库负载高、SQL超时    show-mysql-qps
没有源码的Jar包出了问题、破解别人的代码   jad
线上出问题还无法上线打点日志、线上调试、做切面 btrace
内存不足、OutOfMemoryError   jmap
内存不足、OutOfMemoryError、GC频繁、服务超时、响应长尾    jstat
服务超时、线程死锁、服务器负载高    jstack
查看或者修改Java进程环境变量和Java虚拟机变量  jinfo
使用JNI开发Java本地程序库    javah
查找java进程ID  jps
分析jmap产生的java堆的快照   jhat
QA环境无法重现，需要在准生产线上远程调试   jdb
与jstat相同，但是可以在线下用客户端连接，可线下操作    jstatd
简单的有界面的内存分析工具，JDK自带 JConsole
全面的有界面的内存分析工具，JDK自带 JVisualVM
专业的Java进程性能分析和跟踪工具  JMAT
商业化的Java进程性能分析和跟踪工具 JProfiler