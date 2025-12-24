# 使用官方 Debian 镜像作为基础镜像
FROM debian:bullseye

# 安装 dnsmasq
RUN apt-get update && \
    apt-get install -y dnsmasq && \
    rm -rf /var/lib/apt/lists/*

# 复制 dnsmasq 配置文件到容器中
# COPY dnsmasq.conf /etc/dnsmasq.conf

# 开放 53 端口
EXPOSE 53/udp
EXPOSE 53/tcp

# 启动 dnsmasq
CMD ["dnsmasq", "-k"]