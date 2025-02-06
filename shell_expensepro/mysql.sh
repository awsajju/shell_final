#!/bin/bash

USERID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

logfolder="/var/log/mysql.log"
logfile=$(echo $0 | cut -d "." -f1 )
Timestamp=$(date +%y-%m-%d-%H-%M-%S)
logname="$logfolder/$logfile-$Timestamp.log"

check_root (){
if [ $USERID -ne 0 ];then
    echo -e " $R You must required sudo access to execute this $N"
    exit 1
fi
}
check_root

validate () {
    if [ $1 -ne 0 ];then
        echo -e " $2 .... $R failure $N "
        exit 1
    else
        echo -e " $2 .... $G Success $N "
    fi
}

dnf install mysql-server -y &>>$logname
validate $? "installing mysql server"

systemctl enable mysqld &>>$logname
validate $? "enbaling mysqld"

systemctl start mysqld  &>>$logname
validate $? "started mysqld"

mysql -h mysql.proawsdevops.fun -u root -pExpesneApp@1 -e 'show databases;' &>>$logname
if [ $? -ne 0 ]; then
    echo "Root password not setup" &>>$logname
    mysql-mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$logname
else
    echo -e "already root password setup ... $Y skkip $N"
fi
