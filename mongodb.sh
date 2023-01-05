script_location=$(pwd)

cp ${script_location/}/files/mongodb.repo /etc/yum.repos.d/mongodb.repo
script_location
yum install mongodb-org -y

systemctl enable mongod
systemctl start mongod

