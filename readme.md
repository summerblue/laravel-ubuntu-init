
## 说明

此脚本用于在一台全新的 Ubuntu 14.04 LTS 上部署适合 Laravel 使用的 LNMP 生产环境。

## 软件信息

* Ubuntu 16.04
* Git
* PHP 7.0
* Nginx
* MySQL
* Sqlite3
* Composer
* Node (With PM2, Bower, Grunt, and Gulp)
* Redis
* Memcached
* Beanstalkd

## 安装步骤

1). 下载 `deploy.sh` 脚本

```
$ wget https://raw.githubusercontent.com/summerblue/laravel-ubuntu-init/master/deploy.sh
$ chmod +x deploy.sh
```

2). 设置 MYSQL 密码

`vi deploy.sh` 根据情况修改以下：

```
# Configure
MYSQL_ROOT_PASSWORD="这里填写复杂的密码"
MYSQL_NORMAL_USER="estuser"
MYSQL_NORMAL_USER_PASSWORD="这里填写复杂的密码"
```

3). 开始安装

```
$ ./deploy.sh
```

> 注：请使用 root 运行。

安装后会有类似输出：

```
--
--
It's Done.
Mysql Root Password: xxx你的密码xxx
Mysql Normal User: estuser
Mysql Normal User Password: xxx你的密码xxx
--
--
```

## 安装完以后的配置和注意事项

### 1. 修改站点目录权限

通过此脚本配置的 Nginx 将使用 www 用户权限，因此需要在你的站点根目录下运行以下命令更新权限。

```
cd /data/www/{你的网站目录}
chown www:www -R ./
```

### 2. 添加站点的 nginx 配置

下面是站点的 nginx 配置模板，写入按照域名命名的文件中，并放入到 `/etc/nginx/sites-enabled` 目录下。

如：`/etc/nginx/sites-enabled/phphub.org`

```
server {
    listen 80;
    server_name {你的域名};
    root "{站点根目录}";

    index index.html index.htm index.php;

    charset utf-8;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    access_log /data/log/nginx/{你的网站标识}-access.log;
    error_log  /data/log/nginx/{你的网站标识}-error.log error;

    sendfile off;

    client_max_body_size 100m;

    include fastcgi.conf;

    location ~ /\.ht {
        deny all;
    }

    location ~ \.php$ {
        fastcgi_pass   127.0.0.1:9000;
        #fastcgi_pass /run/php/php7.0-fpm.sock;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
        include        fastcgi_params;
    }
}
```

配置完以后重启 nginx 即可。

```
service nginx restart
```


