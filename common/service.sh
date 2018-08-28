#!/system/bin/sh
# Please don't hardcode /magisk/modname/... ; instead, please use $MODDIR/...
# This will make your scripts compatible even if Magisk change its mount point in the future
MODDIR=${0%/*}

# This script will be executed in late_start service mode
# More info in the main Magisk thread
echo $(date) > $MODDIR/service-log
log () {
  echo "$(date) $1" >> $MODDIR/service-log
}
log "Logging started"
mount_data_apk () {
  log "attempting to mount $1 apk"
  if [ -f "/data/app/$1-2/base.apk" ]
    then
      mkdir -p "/sdpart2/data/app/$1/"
      cp -a "/data/app/$1-2/"* "/sdpart2/data/app/$1/"
      rm -rf "/data/app/$1-2/"*
      rm -rf "/data/app/$1-1/"
      touch "/sdpart2/data/app/$1/updated"
      mkdir -p "/data/app/$1-2"
      busybox mount -w "/sdpart2/data/app/$1/" "/data/app/$1-2"
      log "$1 apk mounted"
  elif [ -f "/sdpart2/data/app/$1/updated" ]
    then
      mkdir -p "/data/app/$1-2"
      busybox mount -w "/sdpart2/data/app/$1/" "/data/app/$1-2"
      log "$1 apk mounted"
  elif [ -f "/data/app/$1-1/base.apk" ]
    then
      mkdir -p "/sdpart2/data/app/$1/"
      cp -a "/data/app/$1-1/"* "/sdpart2/data/app/$1/"
      rm -rf "/data/app/$1-1/"*
      busybox mount -w "/sdpart2/data/app/$1/" "/data/app/$1-1"
      log "$1 apk mounted"
  elif [ -f "/sdpart2/data/app/$1/base.apk" ]
    then
      mkdir -p "/data/app/$1-1"
      busybox mount -w "/sdpart2/data/app/$1/" "/data/app/$1-1"
      log "$1 apk mounted"
  else
    log "$1 apk not mounted: apk not found in /data/app or /sdpart2/data/app/"
  fi
}
mount_obb () {
  if [ "$(ls -A /data/media/obb/$1)" ]
    then
      mkdir -p "/sdpart2/data/media/obb/$1"
      rm -rf "/sdpart2/data/media/obb/$1/"*
      cp -a "/data/media/obb/$1/"* "/sdpart2/data/media/obb/$1"
      rm -rf "/data/media/obb/$1/"*
      busybox mount -w "/sdpart2/data/media/obb/$1" "/data/media/obb/$1"
  elif [ "$(ls -A /sdpart2/data/media/obb/$1)" ]
    then
      mkdir -p "/data/media/obb/$1"
      busybox mount -w "/sdpart2/data/media/obb/$1" "/data/media/obb/$1"
  fi
}



mount_data_apk "com.appinio.appinio"
mount_data_apk "com.citizenme"
mount_data_apk "com.google.android.apps.maps"
mount_data_apk "com.google.android.googlequicksearchbox"
mount_data_apk "com.google.android.play.games"
mount_data_apk "com.imaginecurve.curve.prd"
mount_data_apk "com.kantarworldpanel.shoppix"
mount_data_apk "com.rawduck.onepulse"
mount_data_apk "com.rbs.mobile.android.natwest"
mount_data_apk "com.tesco.clubcardmobile"
mount_data_apk "com.thetrainline"
mount_data_apk "com.tinyrebel.doctorwholegacy"
mount_obb "com.tinyrebel.doctorwholegacy"
mount_data_apk "in.sweatco.app"
mount_data_apk "jackpal.androidterm"
mount_data_apk "org.videolan.vlc"

if [ -f "$MODDIR/../xposed/disable" ]
  then
    log "Xposed disabled"
    mount_data_apk "com.google.android.apps.walletnfcrel"
  else
    log "Xposed enabled"
    mount_data_apk "com.audio.privacy"
    mount_data_apk "com.ceco.marshmallow.gravitybox"
    mount_data_apk "eu.chylek.adam.fakewifi"
    mount_data_apk "fi.veetipaananen.android.disableflagsecure"
    mount_data_apk "io.noisyfox.butteredtoast"
    mount_data_apk "me.rapperskull.burnttoastrevived"
fi
