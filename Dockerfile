# Get SQL Server 2022
FROM mcr.microsoft.com/mssql/server:2022-latest

# Switch to the root user
USER root

# Set the working directory its owner
WORKDIR /tmp
RUN chown mssql /tmp

# Copy the scripts into the image
COPY sql /tmp/
COPY scripts /tmp/

# Mark the scripts as executable
RUN chmod +x /tmp/*.sh

# Switch to working directory owner
USER mssql

# Initialise SQL Server
RUN /bin/bash /tmp/initialise_db.sh