surce common.sh

echo -e "\e[36m>>>>>>>>>>>Configuring nodejs repos<<<<<<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[36m>>>>>>>>>>>Install nodejs <<<<<<<<<<<\e[0m"
yum install nodejs -y

echo -e "\e[36m>>>>>>>>>>>Create app user <<<<<<<<<<<\e[0m"
useradd ${app_user}

echo -e "\e[36m>>>>>>>>>>>Create app directory <<<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[36m>>>>>>>>>>>Download app content<<<<<<<<<<<\e[0m"
curl -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip
cd /app

echo -e "\e[36m>>>>>>>>>>>Unzip app content<<<<<<<<<<<\e[0m"
unzip /tmp/cart.zip
cd /app

echo -e "\e[36m>>>>>>>>>>>Install nodeJS dependencies<<<<<<<<<<<\e[0m"
npm install

echo -e "\e[36m>>>>>>>>>>>Copy cart service<<<<<<<<<<<\e[0m"
cp /home/centos/roboshop-shell/cart.service /etc/systemd/system/cart.service

echo -e "\e[36m>>>>>>>>>>>Start cart service<<<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable user
systemctl start user