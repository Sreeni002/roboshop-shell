app_user=roboshop

func_nodeJs()
{
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
curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
cd /app

echo -e "\e[36m>>>>>>>>>>>Unzip app content<<<<<<<<<<<\e[0m"
unzip /tmp/${component}.zip
cd /app

echo -e "\e[36m>>>>>>>>>>>Install nodeJS dependencies<<<<<<<<<<<\e[0m"
npm install

echo -e "\e[36m>>>>>>>>>>>Copy cart service<<<<<<<<<<<\e[0m"
cp ${script_path}/${component}.service /etc/systemd/system/${component}.service

echo -e "\e[36m>>>>>>>>>>>Start cart service<<<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable ${component}
systemctl start ${component}
}