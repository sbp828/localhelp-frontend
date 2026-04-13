#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
REPO="/home/ubuntu/localhelp-frontend/"
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

echo "Deploying frontend build/source..."
cp -r $REPO/* /usr/share/nginx/html/
VALIDATE $? "Copying frontend files"



echo "Creating Nginx reverse proxy config..." 

#check your repo and path
cat > /etc/nginx/sites-available/localhelp <<EOF
server {
    listen 80;
    server_name _;

    root /usr/share/nginx/html;
    index index.html;

    location / {
        try_files \$uri /index.html;
    }

    location /api/ {
        proxy_pass http://backend.localhelp.store:8080/;
    }
}
EOF
VALIDATE $? "Copied localhelp conf"

ln -sf /etc/nginx/sites-available/localhelp /etc/nginx/sites-enabled/localhelp
VALIDATE $? "Enabled localhelp site"

echo "Removing default nginx site..."
rm -f /etc/nginx/sites-enabled/default


nginx -t
VALIDATE $? "Nginx syntax check"

systemctl reload nginx
VALIDATE $? "Reloading nginx"



if [ $? -eq 0 ];then
    echo "🎉 Frontend setup completed successfully!"
    echo "Access your app via browser using server IP"
else
    echo "something went wrong..check logs"
    exit 1
fi


