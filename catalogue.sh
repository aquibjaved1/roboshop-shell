
script_location=$(pwd)
LOG=/tmp/roboshop.log

echo -e "\e[35m Configuring NodeJS repos\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${lOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
  exit
fi

echo -e "\e[35m Install NodeJS repos\e[0m"
yum install nodejs -y &>>${lOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
  exit
fi

echo -e "\e[35m Add Application User\e[0m"
useradd roboshop &>>${lOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
  exit
fi

mkdir -p /app &>>${lOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
  exit
fi

echo -e "\e[35m Downloading App Content\e[0m"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${lOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
  exit
fi

echo -e "\e[35m Clean up Old Content\e[0m"
rm -rf /app/* &>>${lOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
   exit
fi

echo -e "\e[35m Extracting App Content\e[0m"
cd /app
unzip /tmp/catalogue.zip &>>${lOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
   exit
fi

echo -e "\e[35m Installing NodeJS Dependencies\e[0m"
cd /app &>>${lOG}
npm install &>>${lOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
   exit
fi

echo -e "\e[35m Configuring Catalogue Service File\e[0m"
cp ${script_location}/files/catalogue.service /etc/systemd/system/catalogue.service &>>${lOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
   exit
fi

echo -e "\e[35m Reload SystemD\e[0m"
systemctl daemon-reload &>>${lOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
   exit
fi

echo -e "\e[35m Enable Catalogue Service\e[0m"
systemctl enable catalogue &>>${lOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
   exit
fi

echo -e "\e[35m Start Catalogue Service\e[0m"
systemctl start catalogue &>>${lOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
   exit
fi

echo -e "\e[35m Configuring Mongo Repo\e[0m"
cp ${script_location/}/files/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${lOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
   exit
fi

echo -e "\e[35m Install Mongo Client\e[0m"
yum install mongodb-org-shell -y &>>${lOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
   exit
fi

echo -e "\e[35m Load Schema\e[0m"
mongo --host mongodb-dev.aquibdevops.online </app/schema/catalogue.js &>>${lOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
   exit
fi