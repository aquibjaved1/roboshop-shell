
script_location=$(pwd)
LOG=/tmp/roboshop.log

status_check() {
  if [ $? -eq 0 ]; then
    echo -e "\e[1;32mSUCCESS\e[0m"
  else
    echo -e "\e[1;31mFAILURE\e[0m"
    echo "Refer Log File for more information, LOG - ${LOG}"
    exit
  fi
 }

 print_head() {
     echo -e "\e[1m $1 \e[0m"
 }

 NODEJS() {
   print_head "Downloading App Content"
   curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
   status_check

   print_head "Clean up Old Content"
   rm -rf /app/*
   status_check

   print_head "Extracting App Content"
   cd /app
   unzip /tmp/{component}.zip &>>${lOG}
   status_check

   print_head "Installing NodeJS Dependencies"
   cd /app &>>${lOG}
   npm install &>>${lOG}
   status_check

   print_head "Configuring ${component} Service File"
   cp ${script_location}/files/${component}.service /etc/systemd/system/catalogue.service &>>${lOG}
   status_check

   print_head "Reload SystemD"
   systemctl daemon-reload &>>${lOG}
   status_check

   print_head "Enable ${component} Service"
   systemctl enable ${component} &>>${lOG}
   status_check

   print_head "Start ${component} Service"
   systemctl start ${component} &>>${lOG}
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
 }