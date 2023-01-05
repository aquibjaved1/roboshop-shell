script_location=$(pwd)

cp ${script_location/}/files/mongodb.repo /etc/yum.repos.d/mongodb.repo
script_location
yum install mongodb-org -y

systemctl enable mongod
systemctl restart mongod

sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
