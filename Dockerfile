FROM nginx:latest

COPY ./coffee-shop-free-html5-template /usr/share/nginx/html

CMD ["nginx", "-g", "daemon off;"]