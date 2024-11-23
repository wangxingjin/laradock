FROM apache/hadoop:3

USER root

RUN mkdir -p /etc/yum.repos.d.bak && \
    cp -r /etc/yum.repos.d/* /etc/yum.repos.d.bak/ && \
    rm -rf /etc/yum.repos.d/* && \
    mkdir -p /etc/yum.repos.d
COPY CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo
# 安装 SSH 客户端和服务器
RUN yum update -y && \
    yum install -y openssh-clients openssh-server which net-tools  && \
    yum clean all

RUN ssh-keygen -A

# 安装 Flume
# RUN curl -O https://archive.apache.org/dist/flume/1.9.0/apache-flume-1.9.0-bin.tar.gz && \
#     tar -xzf apache-flume-1.9.0-bin.tar.gz -C /opt/ && \
#     rm apache-flume-1.9.0-bin.tar.gz

# 安装 Hive
RUN curl -O https://archive.apache.org/dist/hive/hive-3.1.2/apache-hive-3.1.2-bin.tar.gz && \
    tar -xzf apache-hive-3.1.2-bin.tar.gz -C /opt/ && \
    mv /opt/apache-hive-3.1.2-bin/ /opt/hive/ && \
    mv /opt/hive/conf /opt/hive/conf_bak && \
    mkdir -p /opt/hive/logs && \
    mkdir -p /opt/hive/hive_workspace && \
    mkdir -p /opt/hive/conf && \
    rm apache-hive-3.1.2-bin.tar.gz

RUN wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-8.0.24.tar.gz && \
    tar -xzf mysql-connector-java-8.0.24.tar.gz && \
    cp ./mysql-connector-java-8.0.24/mysql-connector-java-8.0.24.jar /opt/hive/lib && \
    wget https://www.congiu.net/hive-json-serde/1.3.8/hdp23/json-serde-1.3.8-jar-with-dependencies.jar && \
    cp ./json-serde-1.3.8-jar-with-dependencies.jar /opt/hive/lib

RUN wget --quiet https://repo1.maven.org/maven2/com/facebook/presto/presto-server/0.289/presto-server-0.289.tar.gz && \
    tar -xzf presto-server-0.289.tar.gz -C /opt/ && \
    mv /opt/presto-server-0.289/ /opt/presto-server/ && \
    cp ./json-serde-1.3.8-jar-with-dependencies.jar /opt/presto-server/plugin/hive-hadoop2/ && \
    mkdir -p /opt/presto-server/etc && mkdir -p /opt/presto-server/var/log && \
    chmod 755  /opt/presto-server/var/log

COPY start.sh /usr/local/bin/start.sh
COPY ./.bashrc /opt/hadoop
RUN chmod +x /usr/local/bin/start.sh && \
    chmod +x /opt/hadoop/.bashrc

USER hadoop
RUN  ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa  && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 0600 ~/.ssh/authorized_keys
RUN /opt/hadoop/bin/hdfs namenode -format

# ENV FLUME_HOME=/opt/apache-flume-1.9.0-bin
ENV HIVE_HOME=/opt/hive
ENV PRESTO_HOME=/opt/presto-server
ENV HADOOP_HOME=/opt/hadoop

ENV HDFS_NAMENODE_USER=hadoop
ENV HDFS_DATANODE_USER=hadoop
ENV HDFS_SECONDARYNAMENODE_USER=hadoop
# # 启动 SSH 服务（如果需要）
CMD ["/usr/local/bin/start.sh"]