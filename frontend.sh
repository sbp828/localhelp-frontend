#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

REPO="/home/ubuntu/localhelp-frontend"

echo "logfile location = $LOGFILE"

if [ $USERID -ne 0 ]
then
    echo "Please run this script with root access."
    exit 1
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

echo "================ UPDATING SYSTEM ================"
apt update -y

echo "================ INSTALLING NGINX ================"
apt install nginx -y
VALIDATE $? "Installing nginx"

systemctl start nginx
VALIDATE $? "Starting nginx"

systemctl enable nginx
VALIDATE $? "Enabling nginx"

echo "================ BUILDING REACT APP ================"
cd $REPO || exit 1

npm install
VALIDATE $? "npm install"

npm run build
VALIDATE $? "React build"

echo "================ DEPLOYING BUILD ================"

rm -rf /var/www/localhelp
mkdir -p /var/www/localhelp

cp -r build/* /var/www/localhelp/
VALIDATE $? "Copying build files"

echo "================ CONFIGURING NGINX ================"

cat > /etc/nginx/sites-available/localhelp <<EOF
server {
    listen 80;
    server_name _;

    root /var/www/localhelp;
    index index.html;

    location / {
        try_files \$uri /index.html;
    }

    location /api/ {
        proxy_pass http://backend.localhelp.store:8080;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }
}
EOF

VALIDATE $? "Creating nginx config"

ln -sf /etc/nginx/sites-available/localhelp /etc/nginx/sites-enabled/localhelp

rm -f /etc/nginx/sites-enabled/default

VALIDATE $? "Cleaning default site"

echo "================ TESTING NGINX ================"
nginx -t
VALIDATE $? "Nginx syntax check"

systemctl restart nginx
VALIDATE $? "Restarting nginx"

echo "================ DONE ================"

echo "🎉 Frontend deployed successfully!"
echo "👉 Open: http://<your-ec2-public-ip>"