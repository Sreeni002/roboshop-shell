script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

Func_print_head "Install redis repos"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>$log_file
func_status_check $?

Func_print_head "Install redis"
dnf module enable redis:remi-6.2 -y &>>$log_file
yum install redis -y &>>$log_file
func_status_check $?

Func_print_head "Update listen address"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/redis.conf &>>$log_file
func_status_check $?

Func_print_head "Start redis"
systemctl enable redis &>>$log_file
systemctl start redis &>>$log_file
func_status_check $?