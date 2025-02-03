#!/bin/bash

#checking the root accesss

USERID=$(id -u)
if [ $USERID -ne 0 ];then
    echo -e " $R you must have the root access to execute this $N"
    exit 1
fi

#colors
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

#stroing log with date and time
Log_Folder="/var/log/shell_script.log"
Log_File=$(echo $0 | cut -d "." -f1 )
Timestamp=$(date +%y-%m-%d-%H-%M-%S)
Logname=$Log_Folder/$Log_File-$Timestamp

#creating function for checking the packages are installing or not
validate (){
    if [ $1 -ne 0 ]; then
        echo -e "$2 ...$R failure $N"
        exit 1
    else
        echo -e "$2 ... $G Success $N"
    fi
}



for package in $@
do
   dnf list installed $package &>>Logname
    if [ $package -ne 0 ]; then
        dnf install $package -y &>>Logname
        validate $? "installing $package"
    else
        echo -e " $Y $package already installed $N"
    fi
done




