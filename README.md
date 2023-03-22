# deploy-docker-registry：使用docker-registry搭建容器镜像私有仓库

## 1. 制作SSL/TLS证书
先创建一个用于存储证书和私钥的目录
```
mkdir certs
```
然后使用openssl生成证书和私钥
```
openssl req \
    -newkey rsa:4096 \
    -nodes \
    -sha256 \
    -keyout certs/domain.key \
    -x509 \
    -days 365 \
    -out certs/domain.crt
```

## 2. 运行docker registry容器
```
docker run \
    -d \
    -e REGISTRY_HTTP_ADDR=0.0.0.0:5000 \
    -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/domain.crt \
    -e REGISTRY_HTTP_TLS_KEY=/certs/domain.key \
    -v `pwd`/certs:/certs \
    -p 5000:5000 \
    --restart=always \
    --name registryd \
    registry:2
```

## 3. 在开发主机浏览镜像仓库，推送、拉取、删除镜像
### 3.1 推送镜像
将dockerhub上的mysql:latest镜像标记为私仓镜像，然后推送到私有仓库
```
docker pull mysql:latest
docker tag mysql:latest localhost:5000/mysql:latest
docker push localhost:5000/mysql:latest
```
然后使用curl以非安全的SSL连接形式列出私仓的所有镜像
```
curl -k https://localhost:5000/v2/_catalog

{"repositories":["mysql"]}
```

### 3.2 拉取镜像
先删除刚刚标记为私仓的mysql:latest镜像
```
docker rmi localhost:5000/mysql:latest

Untagged: localhost:5000/mysql:latest
Untagged: localhost:5000/mysql@sha256:d96e939151420ccf4df0ba678f6ed3e61dcaa4f4790c3ae900caf0da69d91f7b
```
然后重新拉取并确认
```
docker pull localhost:5000/mysql:latest

docker images | grep "localhost:5000/mysql"
```