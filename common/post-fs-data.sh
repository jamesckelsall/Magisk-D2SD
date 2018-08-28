#!/system/bin/sh
# Please don't hardcode /magisk/modname/... ; instead, please use $MODDIR/...
# This will make your scripts compatible even if Magisk change its mount point in the future
MODDIR=${0%/*}
# This script will be executed in post-fs-data mode
# More info in the main Magisk thread
echo $(date) > $MODDIR/post-fs-data-log
log () {
  echo "$(date) $1" >> $MODDIR/post-fs-data-log
}
log "Logging started"

mount_sdpart2 () {
  mount -o rw,remount /
  mkdir /sdpart2
  busybox mount -w /dev/block/mmcblk1p2 /sdpart2
  mount -o ro,remount /
}
mount_sdpart2
mount_dalvik_cache () {
  mkdir "/data/dalvik-cache"
  busybox mount -w "/sdpart2/data/dalvik-cache/$1" "/data/dalvik-cache"
}
if [ -f "$MODDIR/../xposed/disable" ]
  then
    log "Xposed disabled"
    mount_dalvik_cache "standard"
  else
    log "Xposed enabled"
    mount_dalvik_cache "xposed"
fi
