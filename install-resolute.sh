#! /bin/bash
 
set -Eeuxo pipefail
 
: "${OSATE_DIR:=osate2-2.14.0}"
: "${eclipseRelease:=2023-12}"
: "${OSATE_VERSION:=2.14.0}"
: "${OSATE_URL:=https://osate-build.sei.cmu.edu/download/osate/stable/${OSATE_VERSION}/products/osate2-${OSATE_VERSION}-vfinal-linux.gtk.x86_64.tar.gz}"
: "${RESOLUTE_UPDATE_SITE:=https://raw.githubusercontent.com/loonwerks/Resolute-Updates/master}"
: "${RESOLUTE_FEATURE_ID:=com.rockwellcollins.atc.resolute.feature.feature.group}"

mkdir -p ${OSATE_DIR}
pushd ${OSATE_DIR}
curl ${OSATE_URL} | tar --warning=no-unknown-keyword -xz
popd
 
${OSATE_DIR}/osate -nosplash -console -consoleLog -application org.eclipse.equinox.p2.director -repository ${RESOLUTE_UPDATE_SITE} -installIU ${RESOLUTE_FEATURE_ID}
