Docker
Цель домашнего задания
Разобраться с основами docker, с образом, эко системой docker в целом;
Описание домашнего задания
Установите Docker на хост машину
https://docs.docker.com/engine/install/ubuntu/
Установите Docker Compose - как плагин, или как отдельное приложение
Создайте свой кастомный образ nginx на базе alpine. После запуска nginx должен отдавать кастомную страницу (достаточно изменить дефолтную страницу nginx)
Определите разницу между контейнером и образом
Вывод опишите в домашнем задании.
Ответьте на вопрос: Можно ли в контейнере собрать ядро?
Собранный образ необходимо запушить в docker hub и дать ссылку на ваш репозиторий.



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



root@evengtest:/home/eve/dock_test# docker images
REPOSITORY     TAG       IMAGE ID       CREATED          SIZE
alpineserver   latest    3388af1a9e48   56 minutes ago   45.7MB
nginx          alpine    0f0eda053dc5   10 days ago      43.3MB
hello-world    latest    d2c94e258dcb   16 months ago    13.3kB


root@evengtest:/home/eve/dock_test# docker run -d --name webserver -it -p 8080:80 alpineserver
fc109364745c51585f7664e70f1f7447d55a102fb5056d61bd5f4893f0613804
root@evengtest:/home/eve/dock_test# 
root@evengtest:/home/eve/dock_test# 
root@evengtest:/home/eve/dock_test# docker ps 
CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS         PORTS                                   NAMES
fc109364745c   alpineserver   "/docker-entrypoint.…"   9 seconds ago   Up 8 seconds   0.0.0.0:8080->80/tcp, :::8080->80/tcp   webserver
root@evengtest:/home/eve/dock_test# 


eve@evengtest:~$ sudo curl http://localhost:8080
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>Главная страница</title>
  </head>
  <body>
    Welcome to Docker Homework!!
  </body>
eve@evengtest:~$ 
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
