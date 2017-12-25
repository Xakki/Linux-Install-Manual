#!/bin/bash
set -o nounset
set -o errexit

BLV='0.2'

myAskYN() 
{
    local AMSURE
    if [[ -n "$1" ]] ; then
       read -n 1 -p "$1 (y/[n]): " AMSURE
    else
       read -n 1 AMSURE
    fi
    echo "" 1>&2
    if [[ "$AMSURE" = "y" ]] ; then
       return 0
    else
       return 1
    fi
}

myAskVal()
{
    set +o nounset
    local local_var
    eval 'echo -n "$1 [$'$2'] "'
    read local_var
    if [[ -n "$local_var" ]] ; then
        eval $2=\$local_var
        echo "" 1>&2
    else
        [[ ! -z $3 ]] && myAskVal "$1" "$2"
    fi
    set -o nounset
    return 0
} 

restoreMyDB()
{
    echo
    if ! [[ -d "/var/backup" ]]; then
        echo "Error: not exist /var/backup"
        return 1
    fi

    LOCALDB=$1
    LOCALPASS=$2
    
    if ! [[ -f /var/backup/$LOCALDB.sql ]]; then
        echo "Error: Not exist dump /var/backup/$LOCALDB.sql"
        return 1
    fi

    echo "Restore dump: /var/backup/$LOCALDB.sql"
    # If /root/.my.cnf exists then it won't ask for root password
    if [[ -f ~/.my.cnf ]]; then
        mysql -e "CREATE DATABASE ${LOCALDB} /*\!40100 DEFAULT CHARACTER SET utf8 */;"
        mysql -e "CREATE USER ${LOCALDB}@localhost IDENTIFIED BY '${LOCALPASS}';"
        mysql -e "GRANT ALL PRIVILEGES ON ${LOCALDB}.* TO '${LOCALDB}'@'localhost';"
        mysql -e "FLUSH PRIVILEGES;"
        mysql $LOCALDB < /var/backup/$LOCALDB.sql
    # If /root/.my.cnf doesn't exist then it'll ask for root password
    else
        echo "Enter MySQL root pass for you local server!"
        read rootpasswd
        mysql -uroot -p${rootpasswd} -e "CREATE DATABASE ${LOCALDB} /*\!40100 DEFAULT CHARACTER SET utf8 */;"
        mysql -uroot -p${rootpasswd} -e "CREATE USER ${LOCALDB}@localhost IDENTIFIED BY '${LOCALPASS}';"
        mysql -uroot -p${rootpasswd} -e "GRANT ALL PRIVILEGES ON ${LOCALDB}.* TO '${LOCALDB}'@'localhost';"
        mysql -uroot -p${rootpasswd} -e "FLUSH PRIVILEGES;"
        mysql -uroot -p${rootpasswd} $LOCALDB < /var/backup/$LOCALDB.sql
    fi
    echo "READY"
    echo 
}

getDumpDB()
{
    echo 
    if ! [[ -d "/var/backup" ]]; then
        mkdir /var/backup
    fi

    sshconnect="$1"
    mylogin="$2"
    mypass="$3"
    LOCALDB="$4"
    echo
    echo "Create dump: /var/backup/$LOCALDB.sql"
    exs="ssh -o 'Compression yes' -o 'CompressionLevel 9' $sshconnect mysqldump -u$mylogin -p$mypass $LOCALDB > /var/backup/$LOCALDB.sql"
    eval "$exs"

    if ! [[ -f /var/backup/$LOCALDB.sql ]]; then
       echo "Error download dump"
       echo
       return 1
    fi
    echo "Download complete"
    echo
}
