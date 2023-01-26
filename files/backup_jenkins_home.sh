#!/bin/bash
SCRIPTS_DIR=/root/scripts
hour=`date +"%H"`

# Create the backup
cd /tmp_backup/
tar czf jenkins-home-$hour.gz --warning=no-file-changed --exclude='cache' --exclude='caches' --exclude='plugins' --exclude='shelvedProjects' --exclude='tools' --exclude="monitoring" --exclude="logs" /var/lib/jenkins || [[ $? -eq 1 ]]

# Run backup rotate
cd $SCRIPTS_DIR
bash rotate_backup.sh
