#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
echo "logfile location = $LOGFILE"
#exec &>>$LOGFILE

if [ $USERID -ne 0 ]
then
    echo "Please run this script with root access."
    exit 1 # manually exit if error comes.
else
    echo "You are super user."
fi

VALIDATE(){
    if [ $1 -ne 0 ]
   then
        echo -e "$2...$R FAILURE $N"
        exit 1
    else
        echo -e "$2...$G SUCCESS $N"
    fi
}

# Install packages
apt update

#Setup Web Server (Frontend)
apt install nginx -y
VALIDATE $? "Installing nginx"

#Start and enable nginx and check status:
systemctl start nginx
VALIDATE $? "Starting nginx"

systemctl enable nginx
VALIDATE $? "Enabling nginx"

systemctl status nginx

#📁 Clean default web folder
rm -rf /usr/share/nginx/html/*
VALIDATE $? "Cleaning default web folder of nginx"

mkdir -p /app
cd /app

# Move to /app
cd /app

# Clone or pull repo safely
if [ ! -d "localhelp-frontend" ]; then
    echo "Cloning frontend repo..."
    git clone https://github.com/sbp828/localhelp-frontend.git &>>$LOGFILE
    VALIDATE $? "Cloning frontend code"
else
    echo "Repo exists, updating..."
    cd localhelp-frontend
    git pull &>>$LOGFILE
    VALIDATE $? "Pulling latest code"
    cd ..
fi

# Copy content to nginx html
if [ -d "/app/localhelp-frontend" ]; then
    cp -r /app/localhelp-frontend/* /usr/share/nginx/html/
    VALIDATE $? "Copying frontend files"
else
    echo "Frontend repo not found, cannot copy files"
    exit 1
fi


echo "Creating Nginx reverse proxy config..." 

#check your repo and path
cp /app/localhelp-frontend/localhelp.conf /etc/nginx/sites-available/localhelp
VALIDATE $? "Copied localhelp conf"

ln -sf /etc/nginx/sites-available/localhelp /etc/nginx/sites-enabled/localhelp
VALIDATE $? "Enabled localhelp site"


nginx -t
VALIDATE $? "Nginx syntax check"

systemctl reload nginx
VALIDATE $? "Reloading nginx"

# Restart nginx
systemctl restart nginx 
VALIDATE $? "Restarting Nginx..."

if [ $? -eq 0 ];then
    echo "🎉 Frontend setup completed successfully!"
    echo "Access your app via browser using server IP"
else
    echo "something went wrong..check logs"
    exit 1
fi


