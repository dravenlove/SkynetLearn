FROM centos:7

LABEL maintainer "13725162400@163.com"

RUN yum -y update

# GCC update
RUN yum install -y centos-release-scl && \
    yum install -y devtoolset-9 && \
    echo "source /opt/rh/devtoolset-9/enable" >> ~/.bashrc

RUN yum install -y wget make git autoconf net-tools telnet

# Lua install
RUN wget -P /download --no-check-certificate https://www.lua.org/ftp/lua-5.4.4.tar.gz && \
    cd /download && \
    tar -xzvf lua-5.4.4.tar.gz && \
    cd lua-5.4.4 && \
    make linux test && \
    make install

# MYSQL Client
RUN yum install -y mysql

ENV PATH="/opt/rh/devtoolset-9/root/usr/bin:${PATH}"
#192.168.65.254
ENV ROOT_HOST=host.docker.internal

CMD ["/bin/bash"]