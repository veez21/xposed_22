#!/system/bin/sh

LOGFILE=/cache/magisk.log

XPOSEDPATH=/magisk/xposed
HELPERPATH=/magisk/xposed_helper
COREDIR=/magisk/.core
MIRRDIR=$COREDIR/mirror

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

# Android 5.1 dirty workaround
find $HELPERPATH/system -type f -name "*.odex*.xposed" -size 0 2>/dev/null | while read ODEX; do
  ORIG=${ODEX%.xposed}
  ORIG=${ORIG/$HELPERPATH/$MIRRDIR}
  TARGET=${ODEX#$HELPERPATH}
  bind_mount $ORIG $TARGET
done

find $HELPERPATH/system/framework -type f -name "boot.*" -size 0 2>/dev/null | while read BOOT; do
  ORIG=${BOOT/$HELPERPATH/$MIRRDIR}
  TARGET=${BOOT#$HELPERPATH}
  bind_mount $ORIG $TARGET
done