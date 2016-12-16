#!/bin/bash
set -o nounset

baseDir="/home/kvm"
vmDir="$baseDir/vm"
pressedFile="$baseDir/pressed.cfg"
isoFile="$baseDir/debian-8.6.0-amd64-netinst.iso"

cd $baseDir

if [ -f "$baseDir/bashlibs.sh" ]; then
    echo "Дополнительный фаил с библеотекой [OK]"
else
    wget -nv https://raw.githubusercontent.com/Xakki/kvm.scripts/master/src/bashlibs.sh
    chmod 0744 bashlibs.sh
fi

. bashlibs.sh

if [ -z $BLV ]; then
    echo "Ошибка загрузки библеотеки [error]"
    exit 0
else
    echo "Загруженна библеотека с версией $BLV"
fi

if [ -d "$vmDir" ]; then
    echo "Директория VM [OK]"
else
    mkdir "$vmDir"
fi

if [ -f "$isoFile" ]; then
    echo "ISO образ [OK]"
else
    myAskYN "ISO образ не найден. Скачать?" | exit 0
    wget -nv http://cdimage.debian.org/debian-cd/8.6.0/amd64/iso-cd/debian-8.6.0-amd64-netinst.iso
fi

if [ -f "$pressedFile" ]; then
    echo "ISO образ [OK]"
else
    wget -nv https://raw.githubusercontent.com/Xakki/kvm.scripts/master/src/pressed.cfg
fi

# http://fai-project.org/fai-guide/
apt-get install fai-quickstart -y

echo

projectName="test"
myAskVal "Введите название виртмашины (оно же название фаила)" "projectName"

projectCpu="2"
myAskVal "Кол-во доступных процессоров" "projectCpu"

projectRam="2"
myAskVal "Объем доступной памяти в Гб" "projectRam"
let "projectRam *= 1024"

projectHdd="10"
myAskVal "Объем диска в Гб" "projectHdd"

projectHost="test.example.ru"
myAskVal "Укажите домен" "projectHost"

projectLastIp="2"
myAskVal "Укажите последнюю цифру IP (192.168.11.X)" "projectLastIp"

virt-install \
--connect qemu:///system \
--name="$projectName" \
--ram="$projectRam" \
--vcpus="$projectCpu" \
--file="$vmDir/$projectName.img" \
--file-size="$projectHdd" \
--location="http://ftp.nl.debian.org/debian/dists/jessie/main/installer-amd64/" \
--initrd-inject="$pressedFile" \
--extra-args="auto keyboard-configuration/xkb-keymap=en ip=192.168.11.$projectLastIp::192.168.11.1:255.255.255.0:$projectHost:eth0:none" \
--os-type=linux \
--os-variant=debianwheezy \
-w bridge:br0 \
--vnc \
--vncport=5902 \
--hvm \
--accelerate \
--autostart \
--noautoconsole \
--debug;


