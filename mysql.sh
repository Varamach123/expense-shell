#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPTNAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPTNAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

VALIDATE(){
    if [$1 -ne 0]
    then 
    echo "$2 .... is failure"
    else 
    echo "$2.... is sucuss"
    fi
}

if [$USERID -ne 0]
then
   echo "please run the script with root access"
   exit 1
   else 
   echo "Now you are super user"
   fi


  dnf install mysql-server -y &>>$LOGFILE
  VALIDATE $? "INSTALLING MY SQL SERVER"

  systemctl enable mysqld -y &>>$LOGFILE
  VALIDATE $? "ENABLE MY SQL SERVER"


  systemctl start mysqld
  VALIDATE $? "START MY SQL SERVER"


  mysql -h db.awsdevops.fun -uroot -pExpenseApp@1 -e 'show databases;' &>>$LOGFILE

  if [ $? -ne 0 ]
  then
  mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
  VALIDATE $? "Mysql Root password Setup"

  else 
 echo  -e "Mysql root password is already setup ...$Y skipping $N"
fi




  









