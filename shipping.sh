script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysql_root_password=$1

if [ -z "mysql_root_password" ]; then
    echo Input My SQL root password is missing
    exit
fi

echo -e "\e[36m>>>>>>>>>>>Install Maven<<<<<<<<<<<\e[0m"
yum install maven -y

echo -e "\e[36m>>>>>>>>>>>Add application user<<<<<<<<<<<\e[0m"
useradd roboshop

echo -e "\e[36m>>>>>>>>>>>Create application directory<<<<<<<<<<<\e[0m"
mkdir /app

echo -e "\e[36m>>>>>>>>>>>Download the app content<<<<<<<<<<<\e[0m"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip
cd /app

echo -e "\e[36m>>>>>>>>>>>Extract the app content<<<<<<<<<<<\e[0m"
unzip /tmp/shipping.zip
cd /app

echo -e "\e[36m>>>>>>>>>>>Download Maven dependencies<<<<<<<<<<<\e[0m"
mvn clean package
mv target/shipping-1.0.jar shipping.jar

echo -e "\e[36m>>>>>>>>>>>Install Mysql<<<<<<<<<<<\e[0m"
yum install mysql -y

echo -e "\e[36m>>>>>>>>>>>Load schema<<<<<<<<<<<\e[0m"
mysql -h mysql-dev.sreenivasulareddydevops.online -uroot -${mysql_root_password} < /app/schema/shipping.sql

echo -e "\e[36m>>>>>>>>>>>setup systemD service file <<<<<<<<<<<\e[0m"
cp ${script_path}/shipping.service /etc/systemd/system/shipping.service

echo -e "\e[36m>>>>>>>>>>>Start shipping service<<<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable shipping
systemctl restart shipping

