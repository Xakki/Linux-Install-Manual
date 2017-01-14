#!/bin/bash
set -o nounset
set -o errexit
# https://blog-tree.com/post/2014/06/exim4

srcLib="https://raw.githubusercontent.com/Xakki/kvm.scripts/master/src/bashlibs.sh"

if [ -f "bashlibs.sh" ]; then
    echo "Дополнительный фаил с библеотекой [OK]"
else
    apt-get install exim4 -y -qq
    wget -nv --cache=off "$srcLib"
    chmod 0744 bashlibs.sh
fi

. bashlibs.sh

myAskYN "Запускаем настройку?" && dpkg-reconfigure exim4-config

testEmail=""
myAskVal "Введите ваш Email для тестового письма" "testEmail"

if [[ -n "$testEmail" ]] ; then
   echo "Это тестовое письмо отправлено с вашего сервера!" | mail -s "Тестовое письмо" $testEmail
   myAskYN "Проверьте почту на наличие тестового письма (проверьте спам). Если не пришло, то надо проверить настройки. Заканчиваем на этом?" && exit 0
fi

varDomain=""
myAskVal "Укажите домен" "varDomain" "requare"

if [[ ! -d "/etc/exim4/dkim" ]]; then
    mkdir /etc/exim4/dkim
fi
cd /etc/exim4/dkim
openssl genrsa -out $varDomain.key 1024
openssl rsa -in $varDomain.key -pubout > $varDomain.pub
#chown exim:exim $varDomain.key
#chmod 640 $varDomain.key


sudo tee /etc/exim4/conf.d/main/01_exim4-config_listmacrosdefs <<- EOF
DKIM_DOMAIN = $varDomain
DKIM_SELECTOR = mail
DDKIM_PRIVATE_KEY = /etc/exim4/dkim/$varDomain.key
DKIM_CANON = relaxed
EOF

service exim4 restart
echo
echo "Прописываем открытый ключ в DNS"
echo
echo /etc/exim4/dkim/$varDomain.pub
echo
echo "Добавляем в DNS запись вида TXT, имеющую название mail._domainkey.$varDomain, содержащую"
echo
echo "v=DKIM1; k=rsa; p={сюда вставить публичныйключ}"
echo

