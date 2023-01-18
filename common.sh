
script_location=$(pwd)
LOG=/tmp/roboshop.log

status_check() {
  if [ $? -eq 0 ]; then
    echo -e "\e[1;32mSUCCESS\e[0m"
  else
    echo -e "\e[1;31mFAILURE\e[0m"
    echo "Refer Log File for more information, LOG - ${LOG}"
    exit 1
  fi
 }

 print_head() {
     echo -e "\e[1m $1 \e[0m"
 }

NODEJS() {
  print_head "Configuring NodeJS repos"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash
  status_check

  print_head "Install NodeJS repos"
  yum install nodejs -y
  status_check

  print_head "Add Application User"
  id roboshop
  if [ $? -ne 0 ]; then
    useradd roboshop
  fi
  status_check

  mkdir -p /app
  status_check

  print_head "Downloading App Content"
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
  status_check

  print_head "Clean up Old Content"
  rm -rf /app/*
  status_check

  print_head "Extracting App Content"
  cd /app
  unzip /tmp/${component}.zip
  status_check

  print_head "Installing NodeJS Dependencies"
  cd /app
  npm install
  status_check

  print_head "Configuring ${component} Service File"
  cp ${script_location}/files/${component}.service /etc/systemd/system/${component}.service
  status_check

  print_head "Reload SystemD"
  systemctl daemon-reload
  status_check

  print_head "Enable ${component} Service"
  systemctl enable ${component}
  status_check

  print_head "Start ${component} Service"
  systemctl start ${component}
  status_check

 if [ ${schema_load} == "true" ]; then
   print_head "Configuring Mongo Repo"
   cp ${script_location/}/files/mongodb.repo /etc/yum.repos.d/mongodb.repo
   status_check

   print_head "Install Mongo Client"
   yum install mongodb-org-shell -y
   status_check

    print_head "Load Schema"
    mongo --host mongodb-dev.aquibdevops.online </app/schema/${component}.js
    status_check
 fi
}