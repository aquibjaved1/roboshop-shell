source common.sh

echo -e "\e[35m Configuring NodeJS repos\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${lOG}
status_check

echo -e "\e[35m Install NodeJS repos\e[0m"
yum install nodejs -y &>>${lOG}
status_check

echo -e "\e[35m Add Application User\e[0m"
useradd roboshop &>>${lOG}
status_check

mkdir -p /app &>>${lOG}
status_check

echo -e "\e[35m Downloading App Content\e[0m"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${lOG}
status_check

echo -e "\e[35m Clean up Old Content\e[0m"
rm -rf /app/* &>>${lOG}
status_check

echo -e "\e[35m Extracting App Content\e[0m"
cd /app
unzip /tmp/catalogue.zip &>>${lOG}
status_check

echo -e "\e[35m Installing NodeJS Dependencies\e[0m"
cd /app &>>${lOG}
npm install &>>${lOG}
status_check

echo -e "\e[35m Configuring Catalogue Service File\e[0m"
cp ${script_location}/files/catalogue.service /etc/systemd/system/catalogue.service &>>${lOG}
status_check

echo -e "\e[35m Reload SystemD\e[0m"
systemctl daemon-reload &>>${lOG}
status_check

echo -e "\e[35m Enable Catalogue Service\e[0m"
systemctl enable catalogue &>>${lOG}
status_check

echo -e "\e[35m Start Catalogue Service\e[0m"
systemctl start catalogue &>>${lOG}
status_check

echo -e "\e[35m Configuring Mongo Repo\e[0m"
cp ${script_location/}/files/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${lOG}
status_check

echo -e "\e[35m Install Mongo Client\e[0m"
yum install mongodb-org-shell -y &>>${lOG}
status_check

echo -e "\e[35m Load Schema\e[0m"
mongo --host mongodb-dev.aquibdevops.online </app/schema/catalogue.js &>>${lOG}
status_check