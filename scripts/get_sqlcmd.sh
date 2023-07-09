# Download the sqlcmd tool, extract it, and make it executable
mkdir -p /opt/mssql-tools/bin &&
cd /opt/mssql-tools/bin &&
wget https://github.com/microsoft/go-sqlcmd/releases/download/v1.1.0/sqlcmd-v1.1.0-linux-arm64.tar.bz2 &&
bzip2 -d sqlcmd-v1.1.0-linux-arm64.tar.bz2 &&
tar -xvf sqlcmd-v1.1.0-linux-arm64.tar &&
chmod 755 sqlcmd