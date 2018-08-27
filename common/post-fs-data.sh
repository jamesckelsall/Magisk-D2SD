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

mount_dalvik_cache () {
  mkdir /data/dalvik-cache
  busybox mount -w /sdpart2/$1 /data/dalvik-cache
}

mount_data_apk () {
    mkdir /data/app/$1-1
    busybox mount -w /sdpart2/$1/app /data/app/$1-1
}

mount_obb () {
  mkdir /data/media/obb/$1
  busybox mount -w /sdpart2/$1/obb /data/media/obb/$1
}

mount_sdpart2

mount_data_apk "com.google.android.apps.maps"
mount_data_apk "com.imaginecurve.curve.prd"
mount_data_apk "com.tinyrebel.doctorwholegacy"
mount_data_apk "org.videolan.vlc"

mount_obb "com.tinyrebel.doctorwholegacy"

if [ -f "$MODDIR/../xposed/disable" ]
  then
    log "Xposed disabled"
    mount_dalvik_cache "dalvik-cache"

    mount_data_apk "com.google.android.apps.walletnfcrel"
  else
    log "Xposed enabled"
    mount_dalvik_cache "dalvik-cache-xposed"

    mount_data_apk "com.audio.privacy"
    mount_data_apk "com.ceco.marshmallow.gravitybox"
    mount_data_apk "eu.chylek.adam.fakewifi"
    mount_data_apk "fi.veetipaananen.android.disableflagsecure"
    mount_data_apk "io.noisyfox.butteredtoast"
    mount_data_apk "me.rapperskull.burnttoastrevived"
fi
