# SQL Server on Mac

SQL Server was designed by Microsoft for its own operating system, Windows.

This creates a problem for those wishing to develop SQL Server systems on Apple's operating system, as SQL Server cannot be run on macOS.

This is a repository of solutions for developing SQL Server systems on macOS.

## Description

SQL Server is a relational database management system (RDBMS) used to manage the storage, retrieval, and manipulation of data. SQL Server Management Studio (SSMS) is a graphical user interface (GUI) used to develop and administer SQL Server systems.

Neither SQL Server nor SSMS can be run on Apple's macOS. While Microsoft's Azure Data Studio, a cross-platform GUI, serves as an adequate replacement for SSMS, there is currently no native solution for directly running SQL Server on a Mac. 

The solutions in this repository use Docker, an isolated runtime environment in which an RDBMS image can be downloaded, installed, initialised, and interacted with. Since Docker is cross-platform, it can be run natively on macOS, thus providing a means of image operation and resource management.

In short, SQL Server is run inside a Docker container and the Docker container is run on a Mac. Azure Data Studio can optionally be run on the Mac to interface with SQL Server. 

However, since Apple's 2020 transition from using Intel x86-64 processors to Apple silicon processors, which are based on the ARM64 processor architecture, Docker images that are built on the x86-64 architecture [can no longer be run natively](https://github.com/docker/for-mac/issues/4733) on Apple silicon machines. 

## Solutions

### Solution 1. Use Apple's Rosetta emulator

Rosetta 2 is a dynamic binary translator that enables the emulation of x86-64 software into the ARM64 architecture. It was built by Apple as part of its Big Sur release for macOS. Since its [integration with Docker in v4.16](https://docs.docker.com/desktop/release-notes/#4160), it can be used to run x86-64 Docker images, including SQL Server, on Apple silicon machines. 

This solution requires that Docker Desktop be configured to [use Rosetta emulation](https://devblogs.microsoft.com/azure-sql/wp-content/uploads/sites/56/2023/01/dockerdesktop-beta.png).


### Solution 2. Use Microsoft's Azure SQL Edge

Azure SQL Edge is a version of SQL Server designed by Microsoft to be run on edge devices. Its Docker image is available in both x86-64 and ARM64 architectures, which means that it can be run on Apple silicon machines.

However, the tool to run database commands [(sqlcmd) is not available](https://learn.microsoft.com/en-us/azure/azure-sql-edge/disconnected-deployment#connect-to-azure-sql-edge) in the ARM64 version of Azure SQL Edge. This solution follows Microsoft's advice to [use sqlcmd-go](https://learn.microsoft.com/en-us/sql/linux/sql-server-linux-setup-tools) instead.

## Dependencies

* [Apple silicon machine](https://support.apple.com/en-gb/HT211814)
* [Docker Desktop](https://docs.docker.com/desktop/install/mac-install/) (v4.16 or later)
    * Requires at least 2gb of memory allowance
* [Azure Data Studio](https://learn.microsoft.com/en-us/sql/azure-data-studio/download-azure-data-studio) (optional)

## Build and Initialise the System

The following instructions are for [solution 1](#solution-1-use-apples-rosetta-emulator).
To follow [solution 2](#solution-2-use-microsofts-azure-sql-edge), please go to the [solution_2 branch](https://github.com/adkwalters/sql-server-on-mac/tree/solution_2)

1. Create a folder in which to store this application

2. Open the macOS Terminal and navigate to the newly created folder
```
cd <path_to_folder>
```
3. Clone this repository
```
git clone https://github.com/adkwalters/sql-server-on-mac --branch solution_1 --single-branch
```
4. Navigate into the repository
```
cd sql-server-on-mac
```
5. Open Docker and [enable Rosetta emulation](https://devblogs.microsoft.com/azure-sql/wp-content/uploads/sites/56/2023/01/dockerdesktop-beta.png)

6. Return to the Terminal and build the docker image
```
docker image build -t sqlserver .
```
7. Once the image has finished buiding, run the container
```
docker run --platform linux/amd64 -p 1433:1433 --name sqlserver_container -d sqlserver
```
8. Observe the container's ID represented in hexadecimal

## Query the Database with Terminal

1. Remain in the Terminal and query the database
```
docker exec -it sqlserver_container /opt/mssql-tools/bin/sqlcmd -U sa -P MSsql2023! -Q "SELECT * FROM WelcomeMessage;"
```
2. Observe the message 'Hello, World'

## Query the Database with Azure Data Studio

1. Open Azure Data Studio and start a new connection 
```
Server: localhost
User name: sa
Password: MSsql2023!
Trust server certificate: True
```
2. Open a new query window and query the database
```
SELECT Message FROM WelcomeMessage;
```
3. Observe the message 'Hello, World'

## Possible Problems

Please ensure that all instructions are followed, and that the commands are copied entirely before pasting them into the Terminal. For example, missing the final full-stop when building the docker image will result in the build failing.

If the hosting network includes firewalls or VPNs, traffic to the Docker container might be blocked. This may only become apparent when attempting, and failing, to query the database.

To test whether the host network is blocking traffic to the database, query the database from within the Docker container. 

1. Open Docker and navigate to the Containers tab

2. Open the container and navigate to the Terminal tab

3. Query the database
```
docker exec -it sqlserver_container /opt/mssql-tools/bin/sqlcmd -U sa -P MSsql2023! -Q "SELECT * FROM WelcomeMessage;"
```
If the welcome message 'Hello, World' is returned, contact your network administrator to permit the connection.