set -e
storage=/bkp
source=/tmp_backupdate_daily=`date +”%Y-%m-%d”`

month_day=`date +”%d”`
week_day=`date +”%u”`
hour=`date +”%H”`

if [ ! -f $source/jenkins-home-$hour.gz ]; then
    exit 1
fi

# 1-st of each month
if [ “$month_day” -eq 1 ] ; then
    destination=$storage/backup.monthly/$date_daily
else
    # On saturdays
    if [ “$week_day” -eq 7 ] ; then
        destination=$storage/backup.weekly/$date_daily
    else
        # Daliy
        destination=$storage/backup.daily/$date_daily
    fi
fi

mkdir -p $destination
cp -R $source/* $destination
rm -rf $source/*

# daily – keep for 14 days
find $storage/backup.daily/ -maxdepth 1 -mtime +14 -type d -exec rm -rv {} \;

# weekly – keep for 60 days
find $storage/backup.weekly/ -maxdepth 1 -mtime +60 -type d -exec rm -rv {} \;

# monthly – keep for 300 days
find $storage/backup.monthly/ -maxdepth 1 -mtime +300 -type d -exec rm -rv {} \;

SIZE=$(du -sb $destination/jenkins-home-$hour.gz | awk ‘{ print $1 }’)
ls -alh $destination
if ((SIZE < 90000)) ; then
    exit 1
else
    exit 0
fi
