#!/bin/bash

# Step 1: Copy from backup server
REMOTE_HOST="doc@10.166.73.38"
REMOTE_PATH="/backup/db/gintra"
LOCAL_PATH="$HOME/Code/gintra/data/"

scp "$REMOTE_HOST:$REMOTE_PATH/gintra_$(date +'%Y-%m-%d')"*.sql "$LOCAL_PATH"

# Step 2: Remove if exists
if [ -f "$LOCAL_PATH/gintra_db.sql" ]; then
    rm "$LOCAL_PATH/gintra_db.sql"
fi

# Step 3: Rename the backup file
mv "$LOCAL_PATH/gintra_$(date +'%Y-%m-%d')"*.sql "$LOCAL_PATH/gintra_db.sql"

# Step 4: Check if the PostgreSQL container is running
CONTAINER_NAME="mysql_container"
if [[ $(docker ps -q --filter "name=$CONTAINER_NAME") ]]; then
    # Step 5: Drop the 'gintra' database
    docker exec "$CONTAINER_NAME" mysql -u root -p'myrootpassword'  -e 'DROP DATABASE IF EXISTS `gintra`;'

    # Step 6: Create the 'gintra' database
    docker exec "$CONTAINER_NAME" mysql -u root -p'myrootpassword'  -e 'CREATE DATABASE `gintra`;'

    # Step 7: Copy the backup file to the container
    docker cp "$LOCAL_PATH/gintra_db.sql" "$CONTAINER_NAME:/"

    # Step 8: Restore the database
    docker exec "$CONTAINER_NAME" bash -c 'mysql -u root -p"myrootpassword" -D gintra < "/gintra_db.sql"'

    
else
    echo "MariaDB container '$CONTAINER_NAME' is not running."
fi

