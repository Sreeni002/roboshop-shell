script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

Func_print_head "Install nginx"
yum install nginx -y &>>$log_file
func_status_check $?

Func_print_head "Copy roboshop config file"
cp roboshop.conf /etc/nginx/default.d/roboshop.conf &>>$log_file
func_status_check $?

Func_print_head "Clean old App content"
rm -rf /usr/share/nginx/html/* &>>$log_file
func_status_check $?

Func_print_head "Download App content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>$log_file
func_status_check $?

Func_print_head "extract App content"
cd /usr/share/nginx/html &>>$log_file
unzip /tmp/frontend.zip &>>$log_file
func_status_check $?

Func_print_head "Restart service"
systemctl restart nginx &>>$log_file
systemctl enable nginx &>>$log_file
func_status_check $?
