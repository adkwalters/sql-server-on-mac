# Export the environment variables
export $(xargs < /tmp/sapassword.env)
export $(xargs < /tmp/sqlcmd.env)

# Set the SQL Server configuration
cp /tmp/mssql.conf /var/opt/mssql/mssql.conf

# Start SQL Server and wait for its initialisation
( /opt/mssql/bin/sqlservr & ) \
    | grep -q "Service Broker manager has started" 

# Run a test command
/opt/mssql-tools/bin/sqlcmd  \
    -Q "CREATE TABLE WelcomeMessage (Message VARCHAR(20))
        INSERT INTO WelcomeMessage VALUES ('Hello, World');"