#!/bin/sh
#* LoginHook
#+ Payload required /Contents/Resources/LoginHook
#+ chris.gerke@gmail.com
#+ Some inspiration from these guys; Per Olofsson, Pete Akins, Karl Kuehn, Greg Neagle and Kyle Crawford.
#+
#+ Description: Setup a LoginHook that will loop a directory containing payloads.
#+
#+ Boot Volume Only: No
#+
#+ Version: 1.0
#+
#+ History:
#+     1.0: Script.
#+
#+ TODO:
#+     * Add error checking?
#+     * Make it dynamic, add a config.plist so people can specify a location?
#+     * Convert to python?

ME=$0
SCRIPT_DIR="$1/Contents/Resources"
TARGET_DIR="$3"

#* Detect payload item(s) & copy to TARGET, set loginhook
if [ -r ${SCRIPT_DIR}/LoginHook ]; then
 #+ TARGET_DIR
 sudo /bin/mkdir -p "${TARGET_DIR}/Library/Scripts/LoginHook"
 #+ Payload
 sudo /bin/cp -Rf "${SCRIPT_DIR}/LoginHook" "${TARGET_DIR}/Library/Scripts/"
 #+ Permissions
 sudo /bin/chmod -R 755 "${TARGET_DIR}/Library/Scripts/LoginHook"
 sudo /usr/sbin/chown -R root:wheel "${TARGET_DIR}/Library/Scripts/LoginHook"
 #+ Payload
 sudo /bin/cp -Rf "${SCRIPT_DIR}/LoginHook.sh" "${TARGET_DIR}/Library/Scripts/LoginHook.sh"
 #+ Permissions
 sudo /bin/chmod -R 755 "${TARGET_DIR}/Library/Scripts/LoginHook.sh"
 sudo /usr/sbin/chown -R "root:wheel ${TARGET_DIR}/Library/Scripts/LoginHook.sh"
 #+ Loginhook
 sudo /usr/bin/defaults write "${TARGET_DIR}/var/root/Library/Preferences/com.apple.loginwindow" LoginHook -string "/Library/Scripts/LoginHook.sh"
 #+ Permissions
 sudo /usr/sbin/chown root:wheel "${TARGET_DIR}/Library/Scripts/LoginHook.sh"
 sudo /bin/chmod 755 "${TARGET_DIR}/Library/Scripts/LoginHook.sh"
fi

exit 0
