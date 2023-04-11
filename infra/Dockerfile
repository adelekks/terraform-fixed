FROM nginx

RUN apt-get update

# Install necessary tools
RUN apt-get install -y wget dialog net-tools
RUN apt-get install dnsutils -y

COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./ssl/server.crt /etc/nginx/ssl/nginx.crt
COPY ./ssl/server.key /etc/nginx/ssl/nginx.key
