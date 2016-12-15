#!/bin/bash

./bashlibs.sh

projectName="test"
myAskYN "Введите название виртмашины (оно же название фаила)" "$projectName"

projectCpu="2"
myAskYN "Кол-во доступных процессоров" "$projectCpu"

projectRam="2"
myAskYN "Объем доступной памяти в Гб" "$projectRam"
let "projectRam *= 1024"

projectHdd="2"
myAskYN "Объем диска в Гб" "$projectHdd"

virt-install \
--connect qemu:///system \
--name ${projectName} \
--ram ${projectRam} \
--vcpus ${projectCpu} \
--file /home/kvm/${projectName}.img \
--file-size=${projectHdd} \
-c /usr/src/debian-8.6.0-amd64-netinst.iso \
--initrd-inject=./pressed.cfg
--extra-args="auto keyboard-configuration/xkb-keymap=en"
--os-type linux
--os-variant debianJessie \
-w bridge:br0 \
--vnc \
--vncport=5902 \
--hvm \
--accelerate \
--autostart \
--noautoconsole;

#--vnclisten=127.0.0.1 \
#--graphics vnc,password=pass,listen=0.0.0.0,port=5903;
#--extra-args "auto keyboard-configuration/xkb-keymap=en text"
#--graphics vnc,password=password,listen=0.0.0.0,port=5901
