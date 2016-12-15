#!/bin/bash

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
    if [ -n "$1" ] ; then
        read -p "$1 (по умолчанию $2): " projectName
    else
        read projectName
    fi

    if [ -z "$projectName" ]; then
        projectName="$2"
    fi
    echo
    return 1
} 
