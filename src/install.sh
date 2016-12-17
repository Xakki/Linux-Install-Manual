
#!/bin/bash
# Установка необходимого ПО на веб сервере (в частности на самой виртуалке)
set -o nounset

cd /tmp
wget http://nginx.org/keys/nginx_signing.key
apt-key add nginx_signing.key
apt-get -qq install lsb-release

codeName="$(lsb_release -c -s)"
listName="/etc/apt/sources.list.d/nginx.list"

cat "$listName"
echo "deb http://nginx.org/packages/debian/ $codeName nginx" >> "$listName"
echo "deb-src http://nginx.org/packages/debian/ $codeName nginx" >> "$listName"

apt-get -qq update
apt-get -qq install nginx

echo "Nginx - OK"
echo
