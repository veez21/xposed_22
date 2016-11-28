#!/system/bin/sh

MODDIR=${0%/*}
LOGFILE=/cache/magisk.log
DISABLE=/data/data/de.robv.android.xposed.installer/conf/disabled

# Default value
[ -z $MIRRDIR ] && MIRRDIR=/dev/magisk/mirror

log_print() {
  echo "XposedHelper: $1"
  echo "XposedHelper: $1" >> $LOGFILE
  log -p i -t Xposed "$1"
}

bind_mount() {
  # Make sure don't double mount
  if [ `mount | grep -c "$2"` -eq 0 ]; then
    if [ -e "$1" -a -e "$2" ]; then
      mount -o bind "$1" "$2"
      if [ "$?" -eq "0" ]; then log_print "Mount: $1";
      else log_print "Mount Fail: $1"; fi 
    fi
  fi
}

add_list() {
  [ `grep -c "^$1$" $MODDIR/lists` -eq 0 ] && echo $1 >> $MODDIR/lists
}

if [ ! -f $DISABLE ]; then
  # Cleanup
  rm -rf $MODDIR/system $MODDIR/lists 2>/dev/null
  touch $MODDIR/lists

  find /system -type f -name "*.odex*" 2>/dev/null | while read ODEX; do
    mkdir -p $MODDIR${ODEX%/*}
    # Rename the odex files
    ln -s $MIRRDIR$ODEX $MODDIR${ODEX}.xposed
    add_list ${ODEX%/*}
  done
  find /system/framework -type f -name "boot.*" 2>/dev/null | while read BOOT; do
    ln -s $MIRRDIR$BOOT $MODDIR$BOOT 2>/dev/null
  done

  cat $MODDIR/lists | while read ITEM ; do
    bind_mount $MODDIR$ITEM $ITEM
  done
fi
