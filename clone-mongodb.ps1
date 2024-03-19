param (
    [Parameter(Mandatory=$true)]
    [string]$ConnectionString,
    [Parameter(Mandatory=$true)]
    [string]$InstallPath
)

# Detect the operating system
$osName = $PSVersionTable.OS

# Set the MongoDB installation directory based on the provided install path
$mongoInstallPath = $InstallPath

# Set the appropriate MongoDB installer URL based on the operating system
if ($osName -like "*Windows*") {
    $osInfo = Get-WmiObject -Class Win32_OperatingSystem
    $osArchitecture = $osInfo.OSArchitecture

    if ($osArchitecture -eq "64-bit") {
        $installerUrl = "https://fastdl.mongodb.org/windows/mongodb-windows-x86_64-6.0.5-signed.msi"
    } else {
        $installerUrl = "https://fastdl.mongodb.org/windows/mongodb-windows-i386-6.0.5-signed.msi"
    }
} elseif ($osName -like "*Darwin*") {
    $installerUrl = "https://fastdl.mongodb.org/osx/mongodb-macos-x86_64-6.0.5.tgz"
} else {
    Write-Error "Unsupported operating system. This script supports Windows and macOS."
    exit 1
}

# Set the MongoDB shell path based on the installation directory
$mongoShellPath = "$mongoInstallPath/bin"
$mongoPath = "$mongoShellPath/mongo"

# Check if MongoDB is installed locally
if (-not (Test-Path -Path $mongoPath)) {
    Write-Host "MongoDB is not installed locally. Installing MongoDB..."

    # Create the installation directory if it doesn't exist
    if (-not (Test-Path -Path $mongoInstallPath)) {
        New-Item -ItemType Directory -Path $mongoInstallPath | Out-Null
    }

    # Download MongoDB installer
    $installerPath = "$mongoInstallPath/mongodb-installer"
    Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath

    # Install MongoDB based on the operating system
    if ($osName -like "*Windows*") {
        Start-Process msiexec.exe -ArgumentList "/i $installerPath /quiet INSTALLLOCATION=$mongoInstallPath" -Wait
    } elseif ($osName -like "*Darwin*") {
        tar -zxvf $installerPath -C $mongoInstallPath --strip-components=1
    }

    # Add the MongoDB binaries to the system's PATH
    $env:PATH += ";$mongoShellPath"
    [Environment]::SetEnvironmentVariable("PATH", $env:PATH, "Machine")

    Write-Host "MongoDB installation completed."
} else {
    Write-Host "MongoDB is already installed locally."
}

# Extract the database name from the connection string
$connectionStringParts = $ConnectionString -split "/"
$databaseName = $connectionStringParts[-1] -split "[?]" | Select-Object -First 1

# Clone the remote database locally
Write-Host "Cloning the remote database '$databaseName' locally..."
$mongodumpPath = "$mongoShellPath/mongodump"
$mongodumpArgs = "--uri `"$ConnectionString`" --out `"$mongoInstallPath/$databaseName`""
Start-Process -FilePath $mongodumpPath -ArgumentList $mongodumpArgs -Wait

Write-Host "Restoring the cloned database locally..."
$mongorestorePath = "$mongoShellPath/mongorestore"
$mongorestoreArgs = "`"$mongoInstallPath/$databaseName`" --drop"
Start-Process -FilePath $mongorestorePath -ArgumentList $mongorestoreArgs -Wait

Write-Host "Database cloned successfully."

# Get the local IP address
$localIpAddress = "localhost"

# Generate the local connection string
$localConnectionString = "mongodb://$localIpAddress:27017/$databaseName"

# Print the local connection string
Write-Host "Local Connection String: $localConnectionString"

# Open local MongoDB and show the cloned database
Write-Host "Opening local MongoDB..."
$mongoArgs = "$databaseName"
Start-Process -FilePath $mongoPath -ArgumentList $mongoArgs

Write-Host "Local MongoDB opened with the cloned database."