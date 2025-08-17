#!/bin/bash

# VPS settings
VPS_HOST="50.21.186.174"  # Replace with your VPS IP or hostname
VPS_USER="root"        # Replace with your VPS username
VPS_DB_NAME="363jp"                 # Database name on the VPS
VPS_DB_USER="root"  # Replace with your VPS MySQL username
VPS_DB_PASS="mountaintop42"  # Replace with your VPS MySQL password

# SQL file path
SQL_FILE="/Users/corysreveimacbook/_SanctuaryOfAden/L1J-JP_3.63c/db/l1jdb_363.sql"

echo "=== L1J Database Upload Script ==="
echo "1. Transferring SQL file to VPS..."

# Transfer the SQL file to VPS using the SSH alias
scp -P 22 ${SQL_FILE} soa:~/l1jdb_363.sql

if [ $? -ne 0 ]; then
    echo "Error: File transfer failed!"
    exit 1
fi

echo "File transferred successfully to VPS"
echo "2. Creating and importing database on VPS MySQL..."

# Create the database and import the SQL file on the VPS using the SSH alias
ssh soa "mysql -u${VPS_DB_USER} -p${VPS_DB_PASS} -e \"DROP DATABASE IF EXISTS ${VPS_DB_NAME}; CREATE DATABASE ${VPS_DB_NAME} DEFAULT CHARACTER SET utf8;\" && mysql -u${VPS_DB_USER} -p${VPS_DB_PASS} ${VPS_DB_NAME} < l1jdb_363.sql && echo 'Database imported successfully!'"

if [ $? -ne 0 ]; then
    echo "Error: Database creation or import on VPS failed!"
    exit 1
fi

echo "=== Database upload completed successfully! ==="
echo "Database '${VPS_DB_NAME}' has been created and populated on your VPS."
