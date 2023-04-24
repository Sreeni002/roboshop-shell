script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

Func_print_head "Setup mongo repo file"
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>$log_file
func_status_check $?

Func_print_head "Install mongodb"
yum install mongodb-org -y &>>$log_file
func_status_check $?

Func_print_head "Update mongodb listen address"
sed -i -e 's|127.0.0.1 |0.0.0.0|' /etc/mongod.conf &>>$log_file
func_status_check $?

Func_print_head "Retsart service"
systemctl enable mongod &>>$log_file
systemctl restart mongod &>>$log_file
func_status_check $?

## Edit the file and replace 127.0.0.1 to 0.0.0.0

