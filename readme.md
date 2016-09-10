
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

## 预计安装时间

视网络情况而定，平均安装需要 15 分钟左右。

## 安装步骤

1). 运行以下命令，生成 `deploy.sh` 脚本文件

```
touch ~/deploy.sh
chmod +x ~/deploy.sh
```

<img src="http://7xrxcg.com1.z0.glb.clouddn.com/dc0b2cee0ff1abfe63465beb69067d10.png" width="600">

2). 将 [服务器部署脚本](https://coding.net/u/estgroup/p/est-docs/git/blob/master/%E5%9B%A2%E9%98%9F%E6%96%87%E6%A1%A3/%E5%BC%80%E5%8F%91%E6%8A%80%E5%B7%A7/%E6%9C%8D%E5%8A%A1%E5%99%A8%E9%83%A8%E7%BD%B2%E8%84%9A%E6%9C%AC/deploy.sh) 里的内容复制到 `deploy.sh` 文件里，并修改 5 - 7 行的配置。

![](media/14618913496721.jpg)

3). 直接运行 `~/deploy.sh` 文件, 会看到安装程序开始执行了

<img src="http://7xrxcg.com1.z0.glb.clouddn.com/d23db6f3040931d8c60c2b2b262bdc62.png">

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


