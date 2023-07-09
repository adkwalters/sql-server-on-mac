# Get Azure SQL Edge
FROM mcr.microsoft.com/azure-sql-edge

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

# Install sqlcmd
RUN /bin/bash /tmp/get_sqlcmd.sh

# Initialise SQL Server
RUN /bin/bash /tmp/initialise_db.sh