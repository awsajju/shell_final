#!/bin/bash

USERID=$(id -u)
if [ $? -ne 0 ]; then
    echo "You must have the sudo access to execute this"
    exit 1
fi 

dnf list installed java -y
if [ $? -ne 0 ]; then
    dnf install java -y 
if [ $? -ne 0 ]; then
    echo "installed java fialure"
    exit 1
else
    echo "installed java successful"
else
    echo "java is already installed"
fi

