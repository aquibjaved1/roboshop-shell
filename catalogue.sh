source common.sh

print_head "Configuring NodeJS repos"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${lOG}
status_check

print_head "Install NodeJS repos"
yum install nodejs -y &>>${lOG}
status_check

print_head "Add Application User"
id roboshop &>>${lOG}
if [ $? -ne 0 ]; then
  useradd roboshop &>>${lOG}
fi
status_check

mkdir -p /app &>>${lOG}
status_check

print_head "Downloading App Content"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${lOG}
status_check

print_head "Clean up Old Content"
rm -rf /app/* &>>${lOG}
status_check

print_head "Extracting App Content"
cd /app
unzip /tmp/catalogue.zip &>>${lOG}
status_check

print_head "Installing NodeJS Dependencies"
cd /app &>>${lOG}
npm install &>>${lOG}
status_check

print_head "Configuring Catalogue Service File"
cp ${script_location}/files/catalogue.service /etc/systemd/system/catalogue.service &>>${lOG}
status_check

print_head "Reload SystemD"
systemctl daemon-reload &>>${lOG}
status_check

print_head "Enable Catalogue Service"
systemctl enable catalogue &>>${lOG}
status_check

print_head "Start Catalogue Service"
systemctl start catalogue &>>${lOG}
status_check

print_head "Configuring Mongo Repo"
cp ${script_location/}/files/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${lOG}
status_check

print_head "Install Mongo Client"
yum install mongodb-org-shell -y &>>${lOG}
status_check

print_head "Load Schema"
mongo --host mongodb-dev.aquibdevops.online </app/schema/catalogue.js &>>${lOG}
status_check