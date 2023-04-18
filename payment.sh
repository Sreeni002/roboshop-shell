script_path=$(dirname $0)
source ${script_path}/common.sh

echo -e "\e[36m>>>>>>>>>>>Install Python<<<<<<<<<<<\e[0m"
yum install python36 gcc python3-devel -y

echo -e "\e[36m>>>>>>>>>>>Add application user<<<<<<<<<<<\e[0m"
useradd ${app_user}

echo -e "\e[36m>>>>>>>>>>>Create application directory<<<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[36m>>>>>>>>>>>Download the application content<<<<<<<<<<<\e[0m"
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip
cd /app

echo -e "\e[36m>>>>>>>>>>>Extract the app content<<<<<<<<<<<\e[0m"
unzip /tmp/payment.zip
cd /app

echo -e "\e[36m>>>>>>>>>>>Install dependencies<<<<<<<<<<<\e[0m"
pip3.6 install -r requirements.txt

echo -e "\e[36m>>>>>>>>>>>Copy the systemd payment service file<<<<<<<<<<<\e[0m"
cp ${script_path}/payment.service /etc/systemd/system/payment.service

echo -e "\e[36m>>>>>>>>>>>Start the payment service<<<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable payment
systemctl restart payment
