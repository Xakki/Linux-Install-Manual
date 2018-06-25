#!/bin/bash
# Debian 8 Jessie
# Установка необходимого ПО на веб сервере (в частности на самой виртуалке)
set -o nounset
set -o errexit

cd /tmp
codeName="$(lsb_release -sc)"
apt-get -qq install lsb-release

if [[ 1 ]]; then
  rm nginx_signing.key
  wget http://nginx.org/keys/nginx_signing.key
  apt-key add nginx_signing.key
  listName="/etc/apt/sources.list.d/nginx.list"
  echo "" > "$listName"
  echo "deb http://nginx.org/packages/debian/ $codeName nginx" >> "$listName"
  echo "deb-src http://nginx.org/packages/debian/ $codeName nginx" >> "$listName"
  echo "Nginx ready for instal - OK"
fi

if [[ 1 ]]; then
  apt-get install apt-transport-https lsb-release ca-certificates
  wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
  echo "deb https://packages.sury.org/php/ $codeName main" | sudo tee /etc/apt/sources.list.d/php.list
fi

exit 0
echo
apt-get -qq update
apt-get -qq install php7.2 nginx php7.2-memcached php7.2-imagick php7.2-fpm php7.2-gd php7.2-imap php7.2-curl php7.2-opcache php7.2-zip


#apt-get -qq install build-essential autoconf re2c bison libssl-dev libcurl4-openssl-dev pkg-config libpng-dev libxml2-dev libxml2 libcurl3


