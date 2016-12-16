#!/bin/bash

export bashLibsVersion='0.1'

myAskYN() 
{
    local AMSURE
    if [ -n "$1" ] ; then
       read -n 1 -p "$1 (y/[n]): " AMSURE
    else
       read -n 1 AMSURE
    fi
    echo "" 1>&2
    if [ "$AMSURE" = "y" ] ; then
       return 0
    else
       return 1
    fi
}

myAskVal()
{
    local local_var
    eval 'echo -n "$1 [$'$2'] "'
    read local_var
    [ -n "$local_var" ] && eval $2=\$local_var
    echo "" 1>&2
    return 1

} 
