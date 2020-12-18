#!/usr/bin/env bash
#Install Supervisor by https://github.com/ghl1024/supervisor-install

export PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
set -e

USER="root"

# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script to install supervisord!"
    exit 1
fi

# Choice install dir
INSTALL_DIR=${1}
if [ "${INSTALL_DIR}" = "" ]; then
    INSTALL_DIR="/home/supervisor"
    mkdir -p "${INSTALL_DIR}"
else
    INSTALL_DIR=$1
    mkdir -p "${INSTALL_DIR}"
fi

# Install supervisord
if [ -f "setuptools-41.0.0.tar.gz" ];then
    tar -zxvf setuptools-41.0.0.tar.gz 2>&1 >/dev/null
    cd setuptools-41.0.0/
    python setup.py install >/dev/null 2>&1
    cd ..
    easy_install elementtree-1.2.7-20070827-preview.zip >/dev/null 2>&1
    easy_install meld3-2.0.1.tar.gz 2>/dev/null 2>&1
    easy_install supervisor-4.2.1.tar.gz >/dev/null 2>&1
else
    exit 1
fi

#Use systemd manage
cat > /usr/lib/systemd/system/supervisord.service <<EOF
[Unit]
Description=Process Monitoring and Control Daemon
After=rc-local.service nss-user-lookup.target

[Service]
Type=forking
ExecStart=/usr/bin/supervisord -c ${INSTALL_DIR}/etc/supervisord.conf

[Install]
WantedBy=multi-user.target
EOF

# Configure supervisord
if [ $? == 0 ];then
    mkdir -p ${INSTALL_DIR}/{etc,logs,tmp}
    mkdir -p ${INSTALL_DIR}/etc/supervisord
    mv supervisord.conf ${INSTALL_DIR}/etc/
    chmod +x /usr/lib/systemd/system/supervisord.service
    sed -i "s#Install_Dir#${INSTALL_DIR}#g" ${INSTALL_DIR}/etc/supervisord.conf
    sed -i "s#User#${USER}#g" ${INSTALL_DIR}/etc/supervisord.conf
    ln -s /usr/bin/supervisorctl ${INSTALL_DIR}/commandctl
    systemctl daemon-reload >/dev/null 2>&1
    systemctl start supervisord.service >/dev/null 2>&1
    systemctl enable supervisord.service >/dev/null 2>&1
else
    exit 1
fi

# Check supervisord
netstat -tnlp | grep "9001" >/dev/null 2>&1
if [ $? == 0 ];then
    echo =============================================
    echo "supervisord已启动"
    echo "安装目录为：${INSTALL_DIR}"
    echo "被管理程序文件存放位置为：${INSTALL_DIR}/etc/supervisord"
    echo "systemd管理服务名称为：supervisord.service"
    echo "占用端口为：9001"
    echo =============================================
else
    echo ===========================================================
    echo "supervisord服务启动失败，请查看日志：${INSTALL_DIR}/logs"
    echo ===========================================================
    exit 1
fi

# Self-Destruct
BaseName=$(basename $BASH_SOURCE)
BasePath=$(cd `dirname ${BASH_SOURCE}` ; pwd)
cd ${BasePath}/../ && rm -fr supervisor_install.tar.gz
rm -fr ${BasePath}
