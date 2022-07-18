![author](https://img.shields.io/badge/author-Hayden-blueviolet.svg)
![license](https://img.shields.io/github/license/ghl1024/supervisor-install.svg)
![last commit](https://img.shields.io/github/last-commit/ghl1024/supervisor-install.svg)
![issues](https://img.shields.io/github/issues/ghl1024/supervisor-install.svg)
![stars](https://img.shields.io/github/stars/ghl1024/supervisor-install.svg)
![forks](https://img.shields.io/github/forks/ghl1024/supervisor-install.svg)

# 在 `CentOS7.x` 系统中一键安装 `supervisord` 服务

> 适用系统自带的python2.7版本，升级与否都可。

| **软件** | 版本 |
| :---: | :---: |
| OS | CentOS 7.x |
| supervisor | 4.2.1 |
| setuptools | 41.0.0 |
| meld | 3-2.0.1 |

## :pushpin: 安装步骤

> 默认安装在`/home/supervisor`下，也可指定安装目录参数自定义安装。执行完安装脚本，就可以在 `/home/supervisor` 目录下看到有相应的配置文件目录`etc`、日志目录`logs`及临时文件目录`tmp`，并且使用 `systemd` 对 `supervisord` 进行管理，安装完成后会自动销毁安装文件。

### 1.使用 `root` 用户上传 `supervisor_install.tar.gz` 到任意目录

```bash
cd /root
curl -o ${PWD}/supervisor_install.tar.gz https://github.com/ghl1024/supervisor-install/releases/download/V1.0/supervisor_install.tar.gz
```

### 2.解压

```bash
tar xf supervisor_install.tar.gz
```

### 3.进入到目录

```bash
cd supervisor_install
```

### 4.执行安装脚本

```bash
./supervisor_install.sh                     #不跟参数默认安装在/home/supervisor下
./supervisor_install.sh /opt/supervisor     #安装在/opt/supervisor下
./supervisor_install.sh /data/supervisor    #安装在/data/supervisor下
```

### 5.查看状态

```bash
systemctl status supervisord.service
netstat -tnlp | grep "9001" | grep -v "grep"
ps -ef | grep "supervisord" | grep -v "grep"
```

### 6.浏览器访问

http://IP:9001

![](https://cdn.jsdelivr.net/gh/ghl1024/supervisor-install/supervisor/supervisor.jpg)

## :triangular_flag_on_post: 安装在`/home/supervisor`下示例

```bash
[root@hayden ~]$ pwd
/root

[root@hayden ~]$ curl -o ${PWD}/supervisor_install.tar.gz https://github.com/ghl1024/supervisor-install/releases/download/V1.0/supervisor_install.tar.gz

[root@hayden ~]$ ll
total 1316
-rw-r--r-- 1 root root 1346912 Dec 17 19:38 supervisor_install.tar.gz

[root@hayden ~]$ tar xf supervisor_install.tar.gz 
[root@hayden ~]$ cd supervisor/
[root@hayden supervisor]$ ll
total 1336
-rw-r--r-- 1 root root  64610 Dec 17 19:37 elementtree-1.2.7-20070827-preview.zip
-rwxr-xr-x 1 root root   2336 Dec 17 19:37 install_supervisor.sh
-rw-r--r-- 1 root root  36097 Dec 17 19:37 meld3-2.0.1.tar.gz
-rw-r--r-- 1 root root 786744 Dec 17 19:37 setuptools-41.0.0.tar.gz
-rw-r--r-- 1 root root 460935 Dec 17 19:37 supervisor-4.2.1.tar.gz
-rw-r--r-- 1 root root   2060 Dec 17 19:37 supervisord.conf
-rw-r--r-- 1 root root    245 Dec 17 19:37 supervisord.service

[root@hayden supervisor]$ sh install_supervisor.sh 
......
=============================================
supervisord已启动
安装目录为：/home/supervisor
systemd管理服务名称为：supervisord.service
占用端口为：9001
=============================================

[root@hayden supervisor]$ systemctl status supervisord.service
......
   Active: active (running) since Thu 2020-12-17 19:48:15 CST; 14s ago
 Main PID: 11606 (supervisord)
   CGroup: /system.slice/supervisord.service
           └─11606 /usr/bin/python /usr/bin/supervisord -c /home/supervisor/etc/supervisord.conf

[root@hayden supervisor]$ netstat -tnlp | grep "9001"
tcp        0      0 0.0.0.0:9001            0.0.0.0:*               LISTEN      11606/python

[root@hayden supervisor]$ ps -ef | grep "supervisord" | grep -v "grep"
root     11606     1  0 19:48 ?        00:00:00 /usr/bin/python /usr/bin/supervisord -c /home/supervisor/etc/supervisord.conf
```

## :rocket: 安装在`/opt/supervisor`下示例

```bash
[root@hayden ~]$ pwd
/root

[root@hayden ~]$ curl -o ${PWD}/supervisor_install.tar.gz https://github.com/ghl1024/supervisor-install/releases/download/V1.0/supervisor_install.tar.gz

[root@hayden ~]$ ll
total 1316
-rw-r--r-- 1 root root 1346912 Dec 17 19:38 supervisor_install.tar.gz

[root@hayden ~]$ tar xf supervisor_install.tar.gz 
[root@hayden ~]$ cd supervisor/
[root@hayden supervisor]$ ll
total 1336
-rw-r--r-- 1 root root  64610 Dec 17 19:37 elementtree-1.2.7-20070827-preview.zip
-rwxr-xr-x 1 root root   2336 Dec 17 19:37 install_supervisor.sh
-rw-r--r-- 1 root root  36097 Dec 17 19:37 meld3-2.0.1.tar.gz
-rw-r--r-- 1 root root 786744 Dec 17 19:37 setuptools-41.0.0.tar.gz
-rw-r--r-- 1 root root 460935 Dec 17 19:37 supervisor-4.2.1.tar.gz
-rw-r--r-- 1 root root   2060 Dec 17 19:37 supervisord.conf
-rw-r--r-- 1 root root    245 Dec 17 19:37 supervisord.service

[root@hayden supervisor]$ sh install_supervisor.sh /opt/supervisor
......
=============================================
supervisord已启动
安装目录为：/opt/supervisor
systemd管理服务名称为：supervisord.service
占用端口为：9001
=============================================

[root@hayden supervisor]$ systemctl status supervisord.service
......
   Active: active (running) since Thu 2020-12-17 19:58:19 CST; 2min 50s ago
 Main PID: 12548 (supervisord)
   CGroup: /system.slice/supervisord.service
           └─12548 /usr/bin/python /usr/bin/supervisord -c /opt/supervisor/etc/supervisord.conf

[root@hayden supervisor]$ netstat -tnlp | grep "9001" | grep -v "grep"
tcp        0      0 0.0.0.0:9001            0.0.0.0:*               LISTEN      12548/python
[root@hayden supervisor]$ ps -ef | grep "supervisord" | grep -v "grep"
root     12548     1  0 19:58 ?        00:00:00 /usr/bin/python /usr/bin/supervisord -c /opt/supervisor/etc/supervisord.conf
```
