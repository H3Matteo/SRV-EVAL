FROM nginx:latest

RUN apt-get update && \
    apt-get install -y net-tools iproute2 iputils-ping && \
    rm -rf /var/lib/apt/lists/*  

COPY . /usr/share/nginx/html/

EXPOSE 80
