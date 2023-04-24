app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")
log_file=/tmp/roboshop.log
#rm -f $log_file

Func_print_head() {
echo -e "\e[36m>>>>>>>>>>>$1<<<<<<<<<<<\e[0m"
echo -e "\e[36m>>>>>>>>>>>$1<<<<<<<<<<<\e[0m" &>>$log_file
}

func_status_check() {
  if [ $1 -eq 0 ]; then
    echo -e "\e[32mSUSSESS\e[0m"
  else
    echo -e "\e[31mFailure\e[0m"
    echo "Refer the log file /tmp/roboshop.log file for more info"
    exit 1
  fi
}
schema_setup(){
if [ "schema_setup" == "mongo" ]; then
Func_print_head "Copy mongo repo file"
cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo &>>$log_file
func_status_check $?

Func_print_head"Install mongo client"
yum install mongodb-org-shell -y &>>$log_file
func_status_check $?

Func_print_head"Load schema"
mongo --host mongodb-dev.sreenivasulareddydevops.online </app/schema/${component}.js &>>$log_file
func_status_check $?
fi
if [ "${schema_setup}" == "mysql" ]; then

Func_print_head "Install Mysql client"
yum install mysql - &>>$log_file
func_status_check $?

Func_print_head "Load schema"
mysql -h mysql-dev.sreenivasulareddydevops.online -uroot -${mysql_root_password} < /app/schema/shipping.sql &>>$log_file
func_status_check $?
fi
}

func_app_prereq(){
Func_print_head "Create application user"
id ${app_user} &>>$log_file
if [ $? -ne 0]; then
  useradd ${app_user} &>>$log_file
fi

Func_print_head "Create application directory"
rm -rf /app &>>$log_file
mkdir /app &>>$log_file
func_status_check $?


Func_print_head "Download the app content"
curl -L -o /tmp/${componet}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>$log_file
cd /app
func_status_check $?

Func_print_head "Extract the app content"
unzip /tmp/${component}.zip &>>$log_file
func_status_check $?

func_status_check $?
}

func_system_setup(){
Func_print_head "Setup systemd service"
cp ${script_path}/${component}.service /etc/systemd/system/${component}.service &>>$log_file
func_status_check $?

Func_print_head "Start cart service"
systemctl daemon-reload &>>$log_file
systemctl enable ${component} &>>$log_file
systemctl start ${component} &>>$log_file
func_status_check $?
schema_setup
func_status_check $?
}
func_nodeJs()
{
Func_print_head "Configuring nodejs repos"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$log_file
func_status_check $?

Func_print_head "Install nodejs"
yum install nodejs -y &>>$log_file
func_status_check $?

func_app_prereq

func_print_head "Install nodeJS dependencies"
npm install &>>$log_file
func_status_check $?

func_schema_setup
func_system_setup
func_status_check $?
}

func_java(){

Func_print_head "Install Maven"
yum install maven -y &>>$log_file
func_status_check $?

func_app_prereq
Func_print_head "Download Maven dependencies"
mvn clean package &>>$log_file
func_status_check $?
mv target/${component}-1.0.jar ${component}.jar &>>$log_file
func_status_check $?
func_system_setup
}