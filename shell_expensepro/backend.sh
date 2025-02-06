#!/bin/bash

USERID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

check_root () {

if [ $USERID -ne 0 ];then
    echo -e " $R you must have the sudo access to execute this $N"
    exit 1
fi
}
check_root

logfolder="/var/log/backend.log"
logfile=$(echo $0 | cut -d "." -f1 )
Timestamp=$(date +%y-%m-%d-%H-%M-%S)
logname="$logfolder/$logfile-$Timestamp.log"

validate (){
    if [ $1 -ne 0 ];then
        echo -e " $2 ... $R failure $N"
        exit 1
    else
        echo -e " $2 ... $G success $N"
    fi
}

dnf module disable nodejs -y &>>$logname
validate $? "disabling current nodejs"

dnf module enable nodejs:20 -y &>>$logname
validate $? "enable nodejs 20"

dnf install nodejs -y &>>$logname
validate $? "installing nodejs"

id expense &>>$logname
if [ $? -ne 0 ];then  &>>$logname
    echo "user not exists"
    useradd expense
    validate $? "adding user"
else
    echo "user exists"
fi

mkdir -p /app &>>$logname
validate $? "creating app folder"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$logname
validate $? "downloading the code"

cd /app
rm -rf /app/*

unzip /tmp/backend.zip &>>$logname
validate $? "unzip the bakcend"

npm install &>>$logname
validate $? "installing dependencies"

cp -r /home/ec2-user/shell_final/shell_expensepro /etc/systemd/system/backend.service &>>$logname

dnf install mysql -y &>>$logname
validate $? "installing mysql schema"

mysql -h mysql.myfooddy.fun -uroot -pExpenseApp@1 < /home/ec2-user/shell_final/shell_expensepro /root/app/schema/backend.sql &>>$logname
validate $? "setting schema"


systemctl daemon-reload &>>$logname
validate $? "Daemon Reload"

systemctl enable backend &>>$logname
validate $? "Enabling backend"

systemctl restart backend &>>$logname
validate $? "Starting Backend"
