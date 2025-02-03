#!/bin/bash

USERID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

if [ $USERID -ne 0 ]; then
    echo -e $R "you must have the sudo access to executre this $N"
    exit 1
fi

validate (){
    if [ $1 -ne 0 ];then
        echo -e  "$2....$R failure $N"
        exkit 1
    else
        echo -e "$2....$G success $N"
    fi
}

dnf list installed python
if [ $? -ne 0 ]; then
    dnf install python -y
    validate $? "installing pyhton"
else
    echo -e "$Y already installed $N"
fi