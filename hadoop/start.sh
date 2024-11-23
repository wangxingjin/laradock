#!/bin/bash
whoami
# 启动 SSH 服务
sudo /usr/sbin/sshd
# 切换到 hadoop 用户并启动 Hadoop DFS
$HADOOP_HOME/sbin/start-dfs.sh
$HADOOP_HOME/bin/hdfs --daemon start datanode

$HIVE_HOME/bin/hiveserver2 >> $HIVE_HOME/logs/hiveserver2.log 2>&1 &
$HIVE_HOME/bin/hive --service metastore >> $HIVE_HOME/logs/thriftserver.log 2>&1 &
$PRESTO_HOME/bin/launcher start
# 保持容器运行
tail -f /dev/null