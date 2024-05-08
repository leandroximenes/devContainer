#!/bin/bash

# Step 1: Copy from backup server
REMOTE_HOST="doc@10.166.73.38"
REMOTE_PATH="/backup/db/sioc"
LOCAL_PATH="$HOME/Code/sioc/config"

scp "$REMOTE_HOST:$REMOTE_PATH/sioc_$(date +'%Y-%m-%d')"*.sql "$LOCAL_PATH"

# Step 3: Remove if exists
if [ -f "$LOCAL_PATH/sioc_db.sql" ]; then
    rm "$LOCAL_PATH/sioc_db.sql"
fi

# Step 4: Rename the backup file
mv "$LOCAL_PATH/sioc_$(date +'%Y-%m-%d')"*.sql "$LOCAL_PATH/sioc_db.sql"

# Step 5: Check if the PostgreSQL container is running
CONTAINER_NAME="postgres_container"
if [[ $(docker ps -q --filter "name=$CONTAINER_NAME") ]]; then
    # Step 6: Install the PostgreSQL client
    docker exec "$CONTAINER_NAME" apk add postgresql-client

    # Step 7: Drop the 'sioc-local' database
    docker exec "$CONTAINER_NAME" psql -d postgres -U doc -c 'DROP DATABASE IF EXISTS "sioc-local";'

    # Step 8: Create the 'sioc-local' database
    docker exec "$CONTAINER_NAME" psql -d postgres -U doc -c 'CREATE DATABASE "sioc-local";'

    # Step 9: Copy the backup file to the container
    docker cp "$LOCAL_PATH/sioc_db.sql" "$CONTAINER_NAME:/docker-entrypoint-initdb.d/sioc_db.sql"

    # Step 10: Restore the database
    docker exec "$CONTAINER_NAME" pg_restore --jobs=4 --no-owner --no-privileges -U doc -d "sioc-local" -c -v "/docker-entrypoint-initdb.d/sioc_db.sql"

    # Step 11: set all password to 654321
    # docker exec "$CONTAINER_NAME" psql -d sioc-local -U doc -c "UPDATE seguranca.usuarios SET senha = 'c33367701511b4f6020ec61ded352059';"
else
    echo "PostgreSQL container '$CONTAINER_NAME' is not running."
fi