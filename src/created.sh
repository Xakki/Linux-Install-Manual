#!/bin/bash

./bashlibs.sh

vmDir="/home/kvm/vm"
if [ -d "$vmDir" ]; then
else
    mkdir "$vmDir"
fi

isoFile="/home/kvm/debian-8.6.0-amd64-netinst.iso"
if [ -f "$isoFile" ]; then
else
    myAskYN "ISO образ не найден. Скачать?" | exit 0
    wget http://cdimage.debian.org/debian-cd/8.6.0/amd64/iso-cd/debian-8.6.0-amd64-netinst.iso
fi


projectName="test"
myAskVal "Введите название виртмашины (оно же название фаила)" "$projectName"

projectCpu="2"
myAskVal "Кол-во доступных процессоров" "$projectCpu"

projectRam="2"
myAskVal "Объем доступной памяти в Гб" "$projectRam"
let "projectRam *= 1024"

projectHdd="10"
myAskVal "Объем диска в Гб" "$projectHdd"

projectHost="test.example.ru"
myAskVal "Укажите домен" "$projectHost"

projectLastIp="2"
myAskVal "Укажите последнюю цифру IP (192.168.11.X)" "$projectLastIp"

virt-install \
--connect qemu:///system \
--name ${projectName} \
--ram ${projectRam} \
--vcpus ${projectCpu} \
--file /home/kvm/vm/${projectName}.img \
--file-size=${projectHdd} \
-c ${isoFile} \
--initrd-inject=./pressed.cfg
--extra-args="auto keyboard-configuration/xkb-keymap=en ip=192.168.11.$projectLastIp::192.168.11.1:255.255.255.0:$projectHost:eth0:none"
--os-type linux
--os-variant debianJessie \
-w bridge:br0 \
--vnc \
--vncport=5902 \
--hvm \
--accelerate \
--autostart \
--noautoconsole;

#ip=192.168.1.2::192.168.1.1:255.255.255.0:test.example.com:eth0:none
#ip=[ip]::[gateway]:[netmask]:[hostname]:[interface]:[autoconf]

#--vnclisten=127.0.0.1 \
#--graphics vnc,password=pass,listen=0.0.0.0,port=5903;
#--extra-args "auto keyboard-configuration/xkb-keymap=en text"
#--graphics vnc,password=password,listen=0.0.0.0,port=5901
