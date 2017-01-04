## Установка Виртуальной ОС Debian

Проверка аппаратной поддержки

```bash
egrep '(vmx|svm)' --color=always /proc/cpuinfo
```

на Сервере все обновляем

```bash
apt-get update; apt-get upgrade -y;
apt-get install qemu-kvm bridge-utils libvirt-bin virtinst virt-top
```

qemu-kvm — основной эмулятор, сама виртуализация (модуль для ядра).
bridge-utils — утилиты для конфигурирования Linux Ethernet мост.
libvirt-bin — виртуальная оболочка API.
virtinst — софт для создания впс.

Проверяем установленоое

```bash
lsmod | grep kvm
```

На домашнем установим

```bash
apt-get update; apt-get install virt-manager
```

-------------------

### Настроим /etc/sysctl.conf

форвардинга и проксирования arp запросов

```
net.ipv4.conf.all.forwarding=1
net.ipv6.conf.all.forwarding=1
net.ipv4.conf.all.proxy_arp=1

net.ipv4.conf.all.forwarding=1
net.ipv6.conf.all.forwarding=1
net.ipv4.conf.all.proxy_arp=1

##Фильтр обратного пути, защита от спуфинга (подмены адресов)
net.ipv4.conf.all.rp_filter=1

# Ignore ICMP broadcasts
net.ipv4.icmp_echo_ignore_broadcasts = 1

##Максимальное число сокетов, находящихся в состоянии TIME-WAIT одновременнo
## При превышении этого порога «лишний» сокет разрушается и пишется сообщение в системный журнал Цель этой переменной – предотвращение простейших разновидностей DoS-атак.
net.ipv4.tcp_max_tw_buckets=72000
net.ipv4.tcp_tw_reuse=1
net.ipv4.tcp_tw_recycle=1
net.ipv4.tcp_fin_timeout=10
net.ipv4.tcp_keepalive_time=1800
net.ipv4.tcp_keepalive_probes=7
net.ipv4.tcp_keepalive_intvl=15

##Размер буферов по умолчанию для приема и отправки данных через сокеты
net.core.wmem_default=4194394
net.core.rmem_default=8388608

##Увеличиваем максимальный размер памяти отводимой для TCP буферов
net.core.wmem_max=996777216
net.core.rmem_max=996777216

##Тюнинг буферов для TCP и UDP соединений (min, default, max bytes)
net.ipv4.tcp_rmem = 4096 87380 4194304
net.ipv4.tcp_mem = 786432 1048576 996777216
net.ipv4.tcp_wmem = 4096 87380 4194304
net.core.somaxconn= 16096

# Controls whether core dumps will append the PID to the core filename Useful for debugging multi-threaded applications
kernel.core_uses_pid=1
##Controls the maximum size of a message, in bytes
kernel.msgmnb=65536
##Controls the default maxmimum size of a mesage queue
kernel.msgmax=65536
##Controls the maximum number of shared memory segments, in pages
kernel.shmall=268435456
##Controls the maximum shared segment size, in bytes
kernel.shmmax=494967295
```

------------------

### Сетевой мост

```
nano /etc/network/interfaces
```

добавляем 

```
auto dummy0
iface dummy0 inet manual

iface br0 inet static
        address 192.168.11.1
        network 192.168.11.0
        netmask 255.255.255.0
        bridge_ports dummy0
        bridge_stp off
        bridge_fd 0
        bridge_maxwait 0
auto br0
```

---------------------

Пора перезагрузится

```
reboot
```

----------------------

Создадим спец директорию для наших виртуальных машин и будем проводить все операции в нем

```
mkdir /home/kvm
cd /home/kvm
```

Скачиваем скрипты для установки

```
wget https://raw.githubusercontent.com/Xakki/kvm.scripts/master/src/created.sh
chmod 0774 created.sh
./created.sh
```

Предварително скачается дополнительная библиотека и фаил для автоустановки -  preseed.cfg,
где нужно указать свои настройки и потом снова запускаем create.sh и отвечаем на вопросы по конфигурации

Запускаем виртуалку

```
virsh start temporary
```


---------------------

Источники:
http://linuxguru.ru/virtualization/kvm/ustanovka-virtualizacii-kvm-v-debian-squeeze/
http://it.w-develop.com/ustanovka-virtualizacii-kvm-v-debian/
https://debian.pro/1334
http://blog.erema.name/virt-install-man-po-russki/21/
http://www.opennet.ru/docs/RUS/bash_scripting_guide/c2792.html
