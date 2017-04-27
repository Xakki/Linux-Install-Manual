#!/bin/bash
# Установка необходимого ПО для Student-Assistent
set -o nounset
set -o errexit

cd /tmp

apt-get -qq install lsb-release
codeName="$(lsb_release -c -s)"

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
  rm dotdeb.gpg
  wget https://www.dotdeb.org/dotdeb.gpg
  apt-key add dotdeb.gpg
  listName="/etc/apt/sources.list.d/dotdeb.list"
  echo "" > "$listName"
  echo "deb http://packages.dotdeb.org $codeName all" >> "$listName"
  echo "deb-src http://packages.dotdeb.org $codeName all" >> "$listName"
  echo "Doteb (PHP7) ready for instal - OK"
fi

echo
apt-get -qq update
apt-get -qq install nginx php5 php5-common php5-curl php5-fpm php5-gd php5-imagick php5-imap php5-json php5-mcrypt php5-mysql php5-xhprof php5-xsl



