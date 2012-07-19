#!/bin/sh
#* LoginHook
#+ chris.gerke@gmail.com
#+ Some inspiration from these guys; Per Olofsson, Pete Akins, Karl Kuehn, Greg Neagle and Kyle Crawford.
#+
#+ Description: Execute LoginHook items
#+
#+ Boot Volume Only: Yes
#+
#+ Version: 1.0
#+
#+ History:
#+     1.0: Script.
#+
#+ TODO:
#+     * Add error checking?
#+     * Make loop more dynamic you idiot?
#+     * Make self destruct more dynamic too?
#+     * Convert to python?

WORKING_DIR=$(/usr/bin/dirname "${0}")

#+ Install PKGs
for i in `/bin/ls ${WORKING_DIR}/LoginHook | /usr/bin/grep ".pkg"`
do
 sudo /usr/sbin/installer -pkg "${WORKING_DIR}/LoginHook/${i}" -target /
done

#+ Install MPKGs
for i in `/bin/ls ${WORKING_DIR}/LoginHook | /usr/bin/grep ".mpkg"`
do
 sudo /usr/sbin/installer -pkg "${WORKING_DIR}/LoginHook/${i}" -target /
done

#+ Execute scripts
for i in `/bin/ls "${WORKING_DIR}/LoginHook" | /usr/bin/grep ".sh"`
do
 sudo "${WORKING_DIR}/LoginHook/${i}"
done

#+ Self destruct?
##if [ ${SELF_DESTRUCT} == "Yes" ]; then
 sudo /bin/rm -Rf ${WORKING_DIR}/LoginHook
 sudo /usr/bin/srm "$0"
##fi