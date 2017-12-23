#!/bin/bash
# Установка необходимого ПО на веб сервере (в частности на самой виртуалке)
set -o nounset
set -o errexit

cd /tmp
codeName="$(lsb_release -c -s)"
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
  # Only DEBIAN
  rm dotdeb.gpg
  wget https://www.dotdeb.org/dotdeb.gpg
  apt-key add dotdeb.gpg
  listName="/etc/apt/sources.list.d/dotdeb.list"
  echo "" > "$listName"
  echo "deb http://packages.dotdeb.org $codeName all" >> "$listName"
  echo "deb-src http://packages.dotdeb.org $codeName all" >> "$listName"
  echo "Doteb (PHP7) ready for instal - OK"
fi

exit 0
echo
apt-get -qq update

apt-get -qq install php7.0 nginx
apt-get -qq -f install
apt-get -qq install php7.0-memcached php7.0-imagick php7.0-fpm php7.0-gd php7.0-imap php7.0-curl php7.0-opcache php7.0-zip


#apt-get -qq install build-essential autoconf re2c bison libssl-dev libcurl4-openssl-dev pkg-config libpng-dev libxml2-dev libxml2 libcurl3


