# 打包指令
```shell
docker buildx build --platform linux/amd64,linux/arm64 -t service .
```
# tag
```shell
docker tag service:latest sawyer532/service:latest
```
# 上传
```shell
docker push sawyer523/service:latest
```