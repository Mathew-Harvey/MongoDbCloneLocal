#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Usage: ./mongo-sync.sh <connection_string> <install_path>"
    exit 1
fi

connectionString="$1"
installPath="$2"

echo "Checking if the database is cloned..."
if [ -d "$installPath" ]; then
    echo "Database is already cloned. Skipping cloning process."
else
    echo "Database is not cloned. Cloning the remote database..."
    pwsh -File clone-mongodb.ps1 -ConnectionString "$connectionString" -InstallPath "$installPath"
fi