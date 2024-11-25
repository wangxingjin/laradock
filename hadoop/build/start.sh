#!/bin/bash
whoami
# 启动 SSH 服务
sudo /usr/sbin/sshd
# 切换到 hadoop 用户并启动 Hadoop DFS

if [ ! "$(ls -A /data/hadoop/namenode)" ]; then
    echo "Formatting NameNode..."
    $HADOOP_HOME/bin/hdfs namenode -format
fi

$HADOOP_HOME/sbin/start-dfs.sh

if [ $? -ne 0 ]; then
    echo "Failed to start HDFS"
    exit 1
fi

# 等待 HDFS 启动并可用，通过检查端口
HDFS_PORT=9000
until netstat -tuln | grep ":$HDFS_PORT" &> /dev/null; do
    echo "Waiting for HDFS NameNode to start on port $HDFS_PORT..."
    sleep 5
done

$HADOOP_HOME/bin/hdfs --daemon start datanode

# 初始化 Hive 仓库目录
HIVE_WAREHOUSE_DIR="/user/hive/warehouse"
if ! $HADOOP_HOME/bin/hdfs dfs -test -e $HIVE_WAREHOUSE_DIR; then
    echo "Creating Hive warehouse directory: $HIVE_WAREHOUSE_DIR"
    $HADOOP_HOME/bin/hdfs dfs -mkdir -p $HIVE_WAREHOUSE_DIR
fi

$HIVE_HOME/bin/hiveserver2 >> $HIVE_HOME/logs/hiveserver2.log 2>&1 &
$HIVE_HOME/bin/hive --service metastore >> $HIVE_HOME/logs/thriftserver.log 2>&1 &
$PRESTO_HOME/bin/launcher start
# 保持容器运行
tail -f /dev/null