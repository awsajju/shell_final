#!/bin/bash
USERID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
 
check_root () {
if [ $USERID -ne 0 ]; then
    echo -e  " $R you must have the sudo access to execute this $N"
    exit 1
fi
}

check_root

logfolder="/var/log/mysql.log"
logfile=$(echo $0 | cut -d "." -f1 )
Timestamp=$(date +%y-%m-%d-%H-%M-%S )
logname=$logfolder/$logfile-$Timestamp

validate () {
    if [ $1 -ne 0 ];then
        echo -e "$2 ....$R failure $N"
        exit 1
    else
        echo -e "$2....$G success $N"
    fi
}

dnf install mysql-server -y &>>$logname
    validate $? "installing mysql serever"

systemctl enable mysqld &>>$logname
validate $? "enable mysql"

systemctl start mysqld &>>$logname
validate $? "start the mysql"

mysql -h mysql.myfooddy.fun -u root -pExpenseApp@1 -e 'show databases;' &>>$logname

if [ $? -ne 0 ];then
echo "mysql root password not setup" &>>$logname
mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$logname
validate $? "setting root passworrd" 
else
    echo -e "mysql root password already setup ...$Y SETUP $N" &>>$logname
fi

