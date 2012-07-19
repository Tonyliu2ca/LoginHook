#!/bin/bash
#* Automate PKG build, a bit of a hacked up script. Not clean but it works.

WORKING_DIR=$(/usr/bin/dirname "${0}")
PATHTO="/Applications"

#+ Move to directory, maybe make this dynamic
cd ${WORKING_DIR}

for pkg in `ls "${WORKING_DIR}" | grep "_Postflight"`
do

 #+ VARS
 IDENTIFIER=$(echo "${pkg}" | sed 's/_Postflight.sh//g')
 DESCRIPTION=$(cat "${WORKING_DIR}/${pkg}" | grep "Description:" | sed 's/#+ Description: //g')
 VERSION=$(cat "${WORKING_DIR}/${pkg}" | grep "Version:" | sed 's/#+ Version: //g')
 ROOTVOLUMEONLY=$(cat "${WORKING_DIR}/${pkg}" | grep "Boot Volume Only:" | sed 's/#+ Boot Volume Only: //g')
 
 #+ postflight
 mkdir "${WORKING_DIR}/SCRIPTS"
 cp -f "${WORKING_DIR}/${pkg}" "${WORKING_DIR}/SCRIPTS/postflight"
 echo "Copying ${WORKING_DIR}/${pkg} ${WORKING_DIR}/SCRIPTS/postflight"
 
 #+ Payload
 mkdir "${WORKING_DIR}/ROOT"
 mkdir "${WORKING_DIR}/ROOT/Library"
 
 #+ Resources
 if [ -r "${WORKING_DIR}/${IDENTIFIER}_RESOURCES" ]; then
  cp -Rf "${WORKING_DIR}/${IDENTIFIER}_RESOURCES" "${WORKING_DIR}/RESOURCES"
 else
  mkdir "${WORKING_DIR}/RESOURCES/"
 fi
 
 #+ Build it.... hopefully
 if [ "${ROOTVOLUMEONLY}" == "Yes" ]; then
 "${PATHTO}/PackageMaker.app/Contents/MacOS/PackageMaker" --root-volume-only --id "com.chrisgerke.${IDENTIFIER}" --title "${IDENTIFIER}" --version "${VERSION}" --resources "${WORKING_DIR}/RESOURCES" --scripts "${WORKING_DIR}/SCRIPTS" --root "${WORKING_DIR}/ROOT" --out "${WORKING_DIR}/${IDENTIFIER}.pkg" --verbose
 else
 "${PATHTO}/PackageMaker.app/Contents/MacOS/PackageMaker" --id "com.chrisgerke.${IDENTIFIER}" --title "${IDENTIFIER}" --version "${VERSION}" --resources "${WORKING_DIR}/RESOURCES" --scripts "${WORKING_DIR}/SCRIPTS" --root "${WORKING_DIR}/ROOT" --out "${WORKING_DIR}/${IDENTIFIER}.pkg" --verbose
 fi
 
 defaults write "${WORKING_DIR}/${IDENTIFIER}.pkg/Contents/Resources/en.lproj/Description" IFPkgDescriptionDescription "${DESCRIPTION}"
 
 cp "${WORKING_DIR}/README.md" "${WORKING_DIR}/${IDENTIFIER}.pkg/Contents/Resources/README.txt"
 
 #+ Cleanup for the next one
 rm -Rf "${WORKING_DIR}/RESOURCES"
 rm -Rf "${WORKING_DIR}/ROOT"
 rm -Rf "${WORKING_DIR}/SCRIPTS"
 
done

exit 0