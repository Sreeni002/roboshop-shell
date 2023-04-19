script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

if [ -z "$mysql_root_password" ]; then
    echo Input My SQL root password is missing
    exit
fi

echo -e "\e[36m>>>>>>>>>>>Disable mysql 8 version<<<<<<<<<<<\e[0m"
dnf module disable mysql -y

echo -e "\e[36m>>>>>>>>>>>Copy my sql repo file <<<<<<<<<<<\e[0m"
cp ${script_path}/mysql.repo /etc/yum.repos.d/mysql.repo

echo -e "\e[36m>>>>>>>>>>>Install my sql <<<<<<<<<<<\e[0m"
yum install mysql-community-server -y

echo -e "\e[36m>>>>>>>>>>>Start my sql <<<<<<<<<<<\e[0m"
systemctl enable mysqld
systemctl start mysqld

echo -e "\e[36m>>>>>>>>>>>Reset my sql password <<<<<<<<<<<\e[0m"
mysql_secure_installation --set-root-pass $mysql_root_password
