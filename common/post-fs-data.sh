#!/system/bin/sh
# Please don't hardcode /magisk/modname/... ; instead, please use $MODDIR/...
# This will make your scripts compatible even if Magisk change its mount point in the future
MODDIR=${0%/*}
# This script will be executed in post-fs-data mode
# More info in the main Magisk thread

echo "$(date) Logging started" > $MODDIR/post-fs-data-log

mount -o rw,remount /
mkdir /sdpart2
busybox mount -w /dev/block/mmcblk1p2 /sdpart2
busybox mount -w /sdpart2/com.tinyrebel.doctorwholegacy/obb /data/media/obb/com.tinyrebel.doctorwholegacy
busybox mount -w /sdpart2/com.tinyrebel.doctorwholegacy/app /data/app/com.tinyrebel.doctorwholegacy-1

file="$MODDIR/../xposed/disable"
if [ -f "$file" ]
then
    echo "$(date) Xposed disabler exists, loading standard dalvik" >> $MODDIR/post-fs-data-log
    busybox mount -w /sdpart2/dalvik-cache /data/dalvik-cache
else
    echo "$(date) Xposed disabler does not exist, loading xposed dalvik" >> $MODDIR/post-fs-data-log
    busybox mount -w /sdpart2/dalvik-cache-xposed /data/dalvik-cache
    #also mount all xposed module related files
fi


mount -o ro,remount /
