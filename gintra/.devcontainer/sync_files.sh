#!/bin/bash

# Step 1: Copy from backup server
REMOTE_HOST="doc@10.166.73.38"
REMOTE_PATH="/backup/backup_sistemas/gintra_rsync/public"
LOCAL_PATH="$HOME/Code/gintra/public/"

# step 1: sync public/images
scp -r $REMOTE_HOST:$REMOTE_PATH/images $LOCAL_PATH

# step 2: sync public/BI
scp -r $REMOTE_HOST:$REMOTE_PATH/BI $LOCAL_PATH

# step 2: sync public/downloads
scp -r $REMOTE_HOST:$REMOTE_PATH/downloads $LOCAL_PATH
