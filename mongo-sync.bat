@echo off
set "connectionString=mongodb://username:password@host:port/database"
set "localDatabaseName=localdatabase"

echo Checking if the database is cloned...
if exist "%localDatabaseName%" (
    echo Database is already cloned. Syncing with the remote database...
    powershell.exe -File sync-mongodb.ps1 -ConnectionString "%connectionString%" -LocalDatabaseName "%localDatabaseName%"
) else (
    echo Database is not cloned. Cloning the remote database...
    powershell.exe -File clone-mongodb.ps1 -ConnectionString "%connectionString%"
)