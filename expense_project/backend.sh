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

logfolder="/var/log/backed.log"
logfile=$(echo $0 | cut -d "." -f1 )
Timestamp=$(date +%y-%m-%d-%H-%M-%S )
logname="$logfolder/$logfile-$Timestamp.log"

validate () {
    if [ $1 -ne 0 ];then
        echo -e "$2 ....$R failure $N"
        exit 1
    else
        echo -e "$2....$G success $N"
    fi
}

dnf module disable nodejs -y &>>$logname
validate $? "Disabling nodejs"

dnf module enable nodejs:20 -y &>>$logname
validate $? "enable nodejs 20"

dnf install nodejs -y &>>$logname
validate $? "installing nodejs"

id expense &>>$logname
if [ $? -ne 0 ];then
 useradd expense &>>$logname
 validate $? "user adding"
else
    echo "user already exists $Y skipp $N" &>>$logname
fi

mkdir -p app &>>$logname
validate $? "creating app folder"


curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$logname

validate $? "downloading code"

cd /app
rm -rf /app/*

unzip /tmp/backend.zip &>>$logname
validate $? "unziping the code"


npm install &>>$logname
validate $? "installing dependencies"

cp /home/ece-user/SHELL_FINAL/expense_project /etc/systemd/system/backend.service &>>$logname

dnf install mysql -y &>>$logname
vlaidate $? "installing mysql schema"

mysql -h myfooddy.fun -uroot -pExpenseApp@1 < /app/schema/backend.sql &>>$logname
validate $? "setting schema"


systemctl daemon-reload &>>$logname
VALIDATE $? "Daemon Reload"

systemctl enable backend &>>$logname
VALIDATE $? "Enabling backend"

systemctl restart backend &>>$logname
VALIDATE $? "Starting Backend"