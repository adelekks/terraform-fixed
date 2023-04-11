#!/bin/bash
sudo mkdir -pv /etc/docker/certs.d/$2
sudo mkdir -pv /etc/docker/certs.d/$1
sudo openssl s_client -showcerts -connect $2:443 </dev/null 2>/dev/null|openssl x509 -outform PEM > /etc/docker/certs.d/$2/nginx.crt
sudo openssl s_client -showcerts -connect $1:443 </dev/null 2>/dev/null|openssl x509 -outform PEM > /etc/docker/certs.d/$1/nginx.crt
