@echo off

if "%~1"=="" (
    echo Usage: mongo-sync.bat ^<connection_string^> ^<install_path^>
    exit /b 1
)

if "%~2"=="" (
    echo Usage: mongo-sync.bat ^<connection_string^> ^<install_path^>
    exit /b 1
)

set connectionString=%1
set installPath=%2

echo Checking if the database is cloned...
if exist "%installPath%" (
    echo Database is already cloned. Skipping cloning process.
) else (
    echo Database is not cloned. Cloning the remote database...
    powershell.exe -File clone-mongodb.ps1 -ConnectionString "%connectionString%" -InstallPath "%installPath%"
)