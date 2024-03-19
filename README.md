MongoDB Database Cloning Script

This script allows you to clone a remote MongoDB database locally. The script automatically installs the correct version of MongoDB if it's not already installed on your system.

Prerequisites:
- PowerShell installed (for Windows and macOS)
- Administrative privileges to install software (if MongoDB is not already installed)

Instructions:

1. Extract the contents of the zip file to a directory of your choice.

2. Open a terminal or command prompt and navigate to the directory where the scripts are located.

3. Run the appropriate script for your operating system with the following command, replacing the placeholders with your actual values:
   - For Windows:
     mongo-sync.bat "mongodb://username:password@host:port/database" "C:\path\to\install\mongodb"

   - For macOS or Linux:
     ./mongo-sync.sh "mongodb://username:password@host:port/database" "$HOME/path/to/install/mongodb"

   Replace "mongodb://username:password@host:port/database" with the connection string for your remote MongoDB database.
   Replace "C:\path\to\install\mongodb" (Windows) or "$HOME/path/to/install/mongodb" (macOS or Linux) with the desired installation path for MongoDB.

4. The script will check if MongoDB is installed locally. If it's not installed, the script will automatically download and install the correct version of MongoDB for your system.

5. After the installation (if required), the script will clone the remote database locally to the specified installation path.

6. Once the cloning process is complete, the script will display the local connection string for the cloned database.

7. The script will also open the local MongoDB instance with the cloned database.

Note: Make sure you have the necessary permissions and access to the remote MongoDB database.

Troubleshooting:
- If you encounter any issues during the installation or cloning process, please ensure that you have the necessary permissions and that your system meets the prerequisites.
- If the script fails to install MongoDB, you can try installing it manually and then running the script again.
- If the cloning process fails, double-check your connection string and make sure you have the correct permissions to access the remote database.

For more information and support, please refer to the MongoDB documentation or contact your database administrator.