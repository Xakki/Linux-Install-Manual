#!/bin/bash

myAskYN() 
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
