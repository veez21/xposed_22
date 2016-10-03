##########################################################################################
#
# Magisk
# by topjohnwu
# 
# This is a template zip for developers
#
##########################################################################################
##########################################################################################
# 
# Instructions:
# 
# 1. Place your files into system folder
# 2. Fill in all sections in this file
# 3. For advanced features, add commands into the script files under common:
#    post-fs.sh, post-fs-data.sh, service.sh
# 4. Change the "module.prop" under common with the info of your module
# 
##########################################################################################
##########################################################################################
# 
# Limitations:
# 1. Can not place any new items under /system root!! e.g. /system/newfile, /system/newdir
#    Magisk will delete these items at boot.
# 
##########################################################################################

##########################################################################################
# Defines
##########################################################################################

# NOTE: This part has to be adjusted to fit your own needs

# Is this a cache mod?
CACHEMOD=false

# This will be the folder name under /magisk or /cache/magisk
# This should also be the same as the id in your module.prop to prevent confusion
MODID=xposed
HELPERID=xposed_helper

# Set to true if you need automount
# Most mods would like it to be enabled
AUTOMOUNT=false

# Set to true if you need post-fs script (Only available in cache mods)
POSTFS=false

# Set to true if you need post-fs-data script (Only available in non-cache mods)
POSTFSDATA=true

# Set to true if you need late_start service script (Only available in non-cache mods)
LATESTARTSERVICE=false

##########################################################################################
# Installation Message
##########################################################################################

# Set what you want to show when installing your mod

print_modname() {
  ui_print "*******************************"
  ui_print "Xposed framework installer zip "
  ui_print "*******************************"
}

##########################################################################################
# Replace list
##########################################################################################

# List all directories you want to directly replace in the system
# By default Magisk will merge your files with the original system
# Directories listed here however, will be directly mounted to the correspond directory in the system

# This is an example
REPLACE="
/system/app/Youtube
/system/priv-app/SystemUI
/system/priv-app/Settings
/system/framework
"

# Construct your own list
REPLACE="
"

##########################################################################################
# Permissons
##########################################################################################

# NOTE: This part has to be adjusted to fit your own needs

set_permissions() {
  # Default permissions, don't remove them
  set_perm_recursive  $MODPATH  0  0  0755  0644

  set_perm_recursive  $MODPATH/system/bin       0       2000    0755    0755

  set_perm  $MODPATH/system/bin/app_process32   0       2000    0755         u:object_r:zygote_exec:s0
  set_perm  $MODPATH/system/bin/dex2oat         0       2000    0755         u:object_r:dex2oat_exec:s0
  set_perm  $MODPATH/system/bin/patchoat        0       2000    0755         u:object_r:zygote_exec:s0

  ($IS64BIT) && set_perm $MODPATH/system/bin/app_process64   0   2000  0755  u:object_r:zygote_exec:s0
}
