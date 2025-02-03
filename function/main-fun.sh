#!/bin/bash

USERID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"

if [ $USERID -ne 0 ]; then
    echo "you must have the sudo access to executre this"
    exit 1
fi

validate (){
    if [ $1 -ne 0 ];then
        echo "$2....failure"
        exkit 1
    else
        echo "$2....success"
    fi
}

dnf list installed python
if [ $? -ne 0 ]; then
    dnf install python -y
    validate $? "installing pyhton"
else
    echo "already installed"
fi