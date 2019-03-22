echo "Installing required packages"

yum install -y postgresql-server postgresql-contrib

postgresql-setup initdb
systemctl start postgresql
systemctl enable postgresql

