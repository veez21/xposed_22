#!/system/bin/sh

MODDIR=${0%/*}
LOGFILE=/cache/magisk.log
DISABLE=/data/data/de.robv.android.xposed.installer/conf/disabled

log_print() {
  echo "Xposed: $1"
  echo "Xposed: $1" >> $LOGFILE
  log -p i -t Xposed "$1"
}

bind_mount() {
  if [ -e "$1" -a -e "$2" ]; then
    mount -o bind $1 $2
    if [ "$?" -eq "0" ]; then log_print "Mount: $1";
    else log_print "Mount Fail: $1"; fi 
  fi
}

find $MODDIR/system -type f 2>/dev/null | while read f; do
  TARGET=${f#$MODDIR}
  bind_mount $f $TARGET
done

# Disable
if [ -f "$DISABLE" ]; then
  umount /system/bin/app_process32
  umount /system/bin/app_process64
fi
