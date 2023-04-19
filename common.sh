app_user=roboshop

print_head() {
echo -e "\e[36m>>>>>>>>>>>$1<<<<<<<<<<<\e[0m"
}

schema_setup(){
if [ "schema_setup" == "mongo" ]; then
echo -e "\e[36m>>>>>>>>>>>Copy mongo repo file<<<<<<<<<<<\e[0m"
cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[36m>>>>>>>>>>>Install mongo client<<<<<<<<<<<\e[0m"
yum install mongodb-org-shell -y

echo -e "\e[36m>>>>>>>>>>>Load schema<<<<<<<<<<<\e[0m"
mongo --host mongodb-dev.sreenivasulareddydevops.online </app/schema/${component}.js
fi
}

func_nodeJs()
{
print_head "Configuring nodejs repos"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

print_head "Install nodejs"
yum install nodejs -y

print_head "Create app user"
useradd ${app_user}

print_head "Create app directory"
rm -rf /app
mkdir /app

print_head "Download app content"
curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
cd /app

print_head "Unzip app content"
unzip /tmp/${component}.zip
cd /app

print_head "Install nodeJS dependencies"
npm install

print_head "Copy cart service"
cp ${script_path}/${component}.service /etc/systemd/system/${component}.service

print_head "Start cart service"
systemctl daemon-reload
systemctl enable ${component}
systemctl start ${component}
schema_setup
}