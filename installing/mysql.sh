#!/bin/bash



USERID=$(id -u)

if [ $USERID -ne 0 ]; then
    echo "you must have the execute sudo access to execute this"
    exit 1
fi

dnf list insalled mysql -y
if [ $? -ne 0 ]; then

    dnf install mysql -y
    if [ $? -ne 0 ]; then
        echo "installing mysql..... failure"
        exit 1
    else
        echo "installing mysql..... success"
    fi
elif
    echo "already installed"


dnf list installed git -y
if [ $? -ne 0 ]; then

    dnf install git -y
    if [ $? -ne 0 ]; then
        echo "installing git .... failure"
        exit 1
    else
        echo "installing git .... success"
    fi
elif
    echo "already installed"


