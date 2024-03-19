#!/bin/bash
connectionString="mongodb://username:password@host:port/database"
localDatabaseName="localdatabase"

echo "Checking if the database is cloned..."
if [ -d "$localDatabaseName" ]; then
    echo "Database is already cloned. Syncing with the remote database..."
    pwsh -File sync-mongodb.ps1 -ConnectionString "$connectionString" -LocalDatabaseName "$localDatabaseName"
else
    echo "Database is not cloned. Cloning the remote database..."
    pwsh -File clone-mongodb.ps1 -ConnectionString "$connectionString"
fi