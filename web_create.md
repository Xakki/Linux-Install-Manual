# На виртуалке ставим ПО

Only Debian

```
cd /temp
wget https://raw.githubusercontent.com/Xakki/kvm.scripts/master/src/install.sh
chmod 0774 install.sh
./install.sh
```
---------------------

### Настроем iptables

```bash
wget https://raw.githubusercontent.com/Xakki/kvm.scripts/master/web.src/iptables.rules
```

Если у вас ssh на другом порту, фаил нужно править!

```bash
cp iptables.rules /etc/iptables.rules
iptables-restore < /etc/iptables.rules
```

Если все ок и интернет и ssh все еще работает, то продолжаем


Делаем загрузку правил при включении и сохранение счетчиков и возможных временных правил 

```bash
echo -e \#\!"/bin/sh \niptables-save -c > /etc/iptables.rules" > /etc/network/if-post-down.d/iptables
chmod 0755 /etc/network/if-post-down.d/iptables
echo -e \#\!"/bin/sh \niptables-restore < /etc/iptables.rules" > /etc/network/if-pre-up.d/iptables
chmod 0755 /etc/network/if-pre-up.d/iptables
```

---------------------

### Открытые порты

```bash
netstat -ntulp
```
---------------------

### Apache
Отключить бы полностью, но вдруг понадобится, поэтому пусть висит на 81 и 444 порту 

```bash
nano /etc/apache2/ports.conf
```

Listen 127.0.0.1:81

---------------------

### Tarantool (https://tarantool.org/download.html)

```bash
wget https://raw.githubusercontent.com/Xakki/kvm.scripts/master/web.src/tarantool.sh
chmod 0744 tarantool.sh
./tarantool.sh
```
---------------------

### Postgres
from manual (https://www.postgresql.org/download/linux/debian/)

```bash
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo rm -f /etc/apt/sources.list.d/*postgresql*.list
sudo echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -c -s`-pgdg main" > /etc/apt/sources.list.d/postgresql.list
sudo apt-get update
sudo apt-get install postgresql-9.6
```

---------------------

### Mysql

---------------------

### Memcache

---------------------

### MongoDB

---------------------
