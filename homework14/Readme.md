Домашнее задание по Docker
-----------------------------------------
#### Описание задания

1. Установите Docker на хост машину https://docs.docker.com/engine/install/ubuntu/
2. Установите Docker Compose - как плагин, или как отдельное приложение
3. Создайте свой кастомный образ nginx на базе alpine. После запуска nginx должен отдавать кастомную страницу (достаточно изменить дефолтную страницу nginx)
4. Определите разницу между контейнером и образом. Вывод опишите в домашнем задании.
5. Ответьте на вопрос: Можно ли в контейнере собрать ядро?
6. Собранный образ необходимо запушить в docker hub и дать ссылку на ваш репозиторий.

Результаты:
----------

### ЗАДАНИЕ 1 и 2 . 
1. Установка Docker на хост машину https://docs.docker.com/engine/install/ubuntu/
2. Установите Docker Compose - как плагин, или как отдельное приложение

- Установка выполнялась через добавление apt репозитория (Вывод команд опущен):

```
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
```
- Установка пакетов Docker:
```
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```
-Проверяем установку:

```
root@evengtest:/home/eve/dock_test# docker -v
Docker version 27.1.2, build d01f264

root@evengtest:/home/eve/dock_test# docker compose version
Docker Compose version v2.29.1
```

### ЗАДАНИЕ 3. 
Создайте свой кастомный образ nginx на базе alpine. После запуска nginx должен отдавать кастомную страницу (достаточно изменить дефолтную страницу nginx).

Для этого в рабочей директории:
* Создаем `Dokerfile`:

```
FROM nginx:alpine
LABEL maintainer="https://github.com/egorvshch"
RUN apk update && apk upgrade
COPY ./index.html /usr/share/nginx/html/index.html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```
* И файл с измененой дефолтной страницей для `NGINX` сервера:
```
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>Главная страница</title>
  </head>
  <body>
    Welcome to Docker Homework!!
  </body>
</html>
```
* Собираем образ командой `docker build -t alpineserver .`:
```
  root@evengtest:/home/eve/dock_test# docker build -t alpineserver .
[+] Building 0.2s (8/8) FINISHED                                                                                                                                                                                                    docker:default
 => [internal] load build definition from Dockerfile                                                                                                                                                                                          0.0s
 => => transferring dockerfile: 231B                                                                                                                                                                                                          0.0s
 => [internal] load metadata for docker.io/library/nginx:alpine                                                                                                                                                                               0.0s
 => [internal] load .dockerignore                                                                                                                                                                                                             0.0s
 => => transferring context: 2B                                                                                                                                                                                                               0.0s
 => [internal] load build context                                                                                                                                                                                                             0.0s
 => => transferring context: 32B                                                                                                                                                                                                              0.0s
 => [1/3] FROM docker.io/library/nginx:alpine                                                                                                                                                                                                 0.0s
 => CACHED [2/3] RUN apk update && apk upgrade                                                                                                                                                                                                0.0s
 => CACHED [3/3] COPY ./index.html /usr/share/nginx/html/index.html                                                                                                                                                                           0.0s
 => exporting to image                                                                                                                                                                                                                        0.0s
 => => exporting layers                                                                                                                                                                                                                       0.0s
 => => writing image sha256:3388af1a9e48e327d876bdcb8c03aa1b0fce4403f9420879174a513dd5b7511f                                                                                                                                                  0.0s
 => => naming to docker.io/library/alpineserver                                                                                                                                                                                               0.0s
root@evengtest:/home/eve/dock_test#
```
* Проверим наш образ:
```
root@evengtest:/home/eve/dock_test# docker images
REPOSITORY     TAG       IMAGE ID       CREATED          SIZE
alpineserver   latest    3388af1a9e48   56 minutes ago   45.7MB
nginx          alpine    0f0eda053dc5   10 days ago      43.3MB
hello-world    latest    d2c94e258dcb   16 months ago    13.3kB
```
* Из собранного образа запустим контейнер командой `docker run -d --name webserver -it -p 8080:80 alpineserver`:
```
root@evengtest:/home/eve/dock_test# docker run -d --name webserver -it -p 8080:80 alpineserver
fc109364745c51585f7664e70f1f7447d55a102fb5056d61bd5f4893f0613804
root@evengtest:/home/eve/dock_test# 
```
* Проверим запустился ли контейнер и что он отдает нашу кастомную страницу:
```
root@evengtest:/home/eve/dock_test# docker ps 
CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS         PORTS                                   NAMES
fc109364745c   alpineserver   "/docker-entrypoint.…"   9 seconds ago   Up 8 seconds   0.0.0.0:8080->80/tcp, :::8080->80/tcp   webserver
root@evengtest:/home/eve/dock_test#

root@evengtest:/home/eve/dock_test# sudo curl http://localhost:8080
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>Главная страница</title>
  </head>
  <body>
    Welcome to Docker Homework!!
  </body>
root@evengtest:/home/eve/dock_test# 
```

### ЗАДАНИЕ 4. 
Определите разницу между контейнером и образом:
- Образ - это отдельный исполняемый файл, содержащий все необходимые зависимости и приложения в нем, необходимые для работы контейнера. При исполнении образа запускается/создается работающий контейнер.

### ЗАДАНИЕ 5. 
Ответьте на вопрос: Можно ли в контейнере собрать ядро?
- Да, можно, однако идея контейнеров в легковесности и минимальном наборе пакетов/зависимостей.

### ЗАДАНИЕ 6. 
Запушим созданный образ  в docker hub и дать ссылку на ваш репозиторий.
* Для этого подключимся к репозиторию Docker Hub:

```
root@evengtest:/home/eve/dock_test# docker login
Log in with your Docker ID or email address to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com/ to create one.
You can log in with your password or a Personal Access Token (PAT). Using a limited-scope PAT grants better security and is required for organizations using SSO. Learn more at https://docs.docker.com/go/access-tokens/

Username: egorvshch
Password: 
WARNING! Your password will be stored unencrypted in /root/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credential-stores

Login Succeeded
root@evengtest:/home/eve/dock_test# 
```

* Назначим тэг для образа, чтобы запушить в реестр (ниже выводы результата назначения тега и сама команда):
```
root@evengtest:/home/eve/dock_test# docker images
REPOSITORY     TAG       IMAGE ID       CREATED             SIZE
alpineserver   latest    3388af1a9e48   About an hour ago   45.7MB
nginx          alpine    0f0eda053dc5   10 days ago         43.3MB
hello-world    latest    d2c94e258dcb   16 months ago       13.3kB
root@evengtest:/home/eve/dock_test# 
root@evengtest:/home/eve/dock_test# docker tag alpineserver:latest egorvshch/alpineserver:alpine
root@evengtest:/home/eve/dock_test# 
root@evengtest:/home/eve/dock_test# docker images
REPOSITORY               TAG       IMAGE ID       CREATED             SIZE
*egorvshch/alpineserver   alpine    3388af1a9e48   About an hour ago   45.7MB
alpineserver             latest    3388af1a9e48   About an hour ago   45.7MB
nginx                    alpine    0f0eda053dc5   10 days ago         43.3MB
hello-world              latest    d2c94e258dcb   16 months ago       13.3kB
```
* Отправляем созданный образ в репозиторий:
```
root@evengtest:/home/eve/dock_test# docker push egorvshch/alpineserver:alpine
The push refers to repository [docker.io/egorvshch/alpineserver]
da7ca335d78c: Pushed 
7440e75bdc71: Pushed 
26d9c9583797: Mounted from library/nginx 
2cdd4bacf827: Mounted from library/nginx 
f3719eb0da5e: Mounted from library/nginx 
9a2d14b22cbe: Mounted from library/nginx 
16f2939def51: Mounted from library/nginx 
b65aff7ee426: Mounted from library/nginx 
c028c01f43bc: Mounted from library/nginx 
78561cef0761: Mounted from library/nginx 
alpine: digest: sha256:dbfebb0634d3a6abd9deea2817c3f95fca289665172462476818bc049bdef5be size: 2407
root@evengtest:/home/eve/dock_test#
```
* Ссылка на образ в репозитории: https://hub.docker.com/r/egorvshch/alpineserver/tags


