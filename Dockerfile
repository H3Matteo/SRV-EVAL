FROM nginx:latest

RUN apt-get update && \
    apt-get install -y net-tools iproute2 iputils-ping && \
    rm -rf /var/lib/apt/lists/*  

COPY Workspace/ /usr/share/nginx/html/

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
