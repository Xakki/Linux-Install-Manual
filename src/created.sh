#!/bin/bash
set -o nounset
# https://debian.pro/1334
# http://fai-project.org/fai-guide/

baseDir="/home/kvm"
pressedFile="$baseDir/pressed.cfg"
srcLib="https://raw.githubusercontent.com/Xakki/kvm.scripts/master/src/bashlibs.sh"

cd $baseDir

if [ -f "$baseDir/bashlibs.sh" ]; then
    echo "Дополнительный фаил с библеотекой [OK]"
else
    apt-get install qemu-kvm bridge-utils libvirt-bin virtinst -y -qq
    wget -nv --cache=off "$srcLib"
    chmod 0744 bashlibs.sh
fi

. bashlibs.sh

if [ -z $BLV ]; then
    echo "Ошибка загрузки библеотеки [error]"
    exit 0
else
    echo "Загруженна библеотека с версией $BLV [OK]"
fi

if [ -f "$pressedFile" ]; then
    myAskYN "Настройки конфига автоустановки отредактировали? ($pressedFile) Продолжаем?" | exit 0
else
    wget -nv https://raw.githubusercontent.com/Xakki/kvm.scripts/master/src/pressed.cfg
    echo
    echo "Предварительно проверьте настройки конфига автоустановки $pressedFile!!!!!!"
    echo
    exit 0
fi

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

echo 
# http://www.andybotting.com/automating-debian-installs-with-preseeding
# http://kerunix.com/preseed_kvm_using_virt_install.html

virt-install \
--connect qemu:///system \
--name="$projectName" \
--ram="$projectRam" \
--vcpus="$projectCpu" \
--file="/var/lib/libvirt/images/$projectName.img" \
--file-size="$projectHdd" \
--location="http://ftp.nl.debian.org/debian/dists/jessie/main/installer-amd64/" \
--initrd-inject="$pressedFile" \
--extra-args="auto=true" \
--os-type=linux \
--os-variant=debianwheezy \
--network=bridge:br0 \
--vnc \
--vncport=5902 \
--hvm \
--accelerate \
--autostart \
--noautoconsole \
--nographics \
--debug;

# --extra-args="auto keyboard-configuration/xkb-keymap=en" \

