FROM apache/hadoop:3

USER root

COPY ./build/* ./build/
RUN mkdir -p /etc/yum.repos.d.bak && \
    cp -r /etc/yum.repos.d/* /etc/yum.repos.d.bak/ && \
    rm -rf /etc/yum.repos.d/* && \
    mkdir -p /etc/yum.repos.d && \
    cp ./build/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo && \
    yum update -y && \
    yum install -y openssh-clients openssh-server which net-tools  && \
    yum clean all && \
    ssh-keygen -A && \
    cp ./build/start.sh /usr/local/bin/start.sh && \
    cp ./build/.bashrc /opt/hadoop && \
    chmod +x /usr/local/bin/start.sh && \
    chmod +x /opt/hadoop/.bashrc && \
    rm -rf ./build

USER hadoop
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa  && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 0600 ~/.ssh/authorized_keys && \
    curl -O https://archive.apache.org/dist/hive/hive-3.1.2/apache-hive-3.1.2-bin.tar.gz & \
    wget --quiet https://repo1.maven.org/maven2/com/facebook/presto/presto-server/0.289/presto-server-0.289.tar.gz & \
    wait && \
    tar -xzf apache-hive-3.1.2-bin.tar.gz -C /opt/ && rm ./apache-hive-3.1.2-bin.tar.gz && \
    mv /opt/apache-hive-3.1.2-bin/ /opt/hive/ && \
    mv /opt/hive/conf /opt/hive/conf_bak && \
    mkdir -p /opt/hive/logs && mkdir -p /opt/hive/hive_workspace && mkdir -p /opt/hive/conf && \
    tar -xzf presto-server-0.289.tar.gz -C /opt/ && rm ./presto-server-0.289.tar.gz && \
    mv /opt/presto-server-0.289/ /opt/presto-server/ && \
    mkdir -p /opt/presto-server/etc && mkdir -p /opt/presto-server/var/log && \
    chmod 755  /opt/presto-server/var/log && \
    wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-8.0.24.tar.gz && \
    tar -xzf mysql-connector-java-8.0.24.tar.gz && \
    cp ./mysql-connector-java-8.0.24/mysql-connector-java-8.0.24.jar /opt/hive/lib && \
    rm -rf ./mysql-connector-java-8.0.24/ && rm mysql-connector-java-8.0.24.tar.gz && \
    wget https://www.congiu.net/hive-json-serde/1.3.8/hdp23/json-serde-1.3.8-jar-with-dependencies.jar && \
    cp ./json-serde-1.3.8-jar-with-dependencies.jar /opt/presto-server/plugin/hive-hadoop2/ && \
    cp ./json-serde-1.3.8-jar-with-dependencies.jar /opt/hive/lib && \
    rm ./json-serde-1.3.8-jar-with-dependencies.jar

ENV HIVE_HOME=/opt/hive
ENV PRESTO_HOME=/opt/presto-server
ENV HADOOP_HOME=/opt/hadoop

ENV HDFS_NAMENODE_USER=hadoop
ENV HDFS_DATANODE_USER=hadoop
ENV HDFS_SECONDARYNAMENODE_USER=hadoop

CMD ["/usr/local/bin/start.sh"]