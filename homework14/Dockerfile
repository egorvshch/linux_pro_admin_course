FROM nginx:alpine
LABEL maintainer="https://github.com/egorvshch"
RUN apk update && apk upgrade
COPY ./index.html /usr/share/nginx/html/index.html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]