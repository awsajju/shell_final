#!/bin/bash

USERID=$(id -u)

if [ $? -ne 0 ];then
    echo "you must have the sudo access to execute this"
    exit 1
fi

validate (){
    if [ $1 -ne 0 ]; then
        echo "$2 ... failure"
        exit 1
    else
        echo "$2 .... success"
    fi
}

dnf list installed mysql
if [ $? -ne 0 ]; then
    dnf install mysql -y 
        validate $? "installing mysql"
else
    echo "already installed"
fi

dnf list installed git
if [ $? -ne 0 ]; then
    dnf install git -y
        vlaidate $? "installing git"
else
    echo "already installed"
fi 

    