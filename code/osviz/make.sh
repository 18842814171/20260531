#!/usr/bin/bash
source "$(dirname "$0")/../common.sh"

PKGNAME=osviz
PKGVERSION=
PKGSOURCE_DIR=
PKGSOURCE=

PKGBUILDNAME=${PKGNAME}
PKGBUILD_DIR=${BUILD_DIR}/${PKGBUILDNAME}

echo "----> Building ${PKGBUILDNAME} ..."

stamp_downloaded
stamp_extracted
stamp_patched
stamp_configured

step_start build
mkdir -p "${BUILD_DIR}/${PKGNAME}"
${CROSS_COMPILE}gcc -Wall -Wextra -O2 -I"${PROJECT_DIR}/package/${PKGNAME}/include" \
	-c -o "${BUILD_DIR}/${PKGNAME}/log.o" "${PROJECT_DIR}/package/${PKGNAME}/src/log.c"
${CROSS_COMPILE}ar rcs "${BUILD_DIR}/${PKGNAME}/libosviz.a" "${BUILD_DIR}/${PKGNAME}/log.o"
${CROSS_COMPILE}gcc -static -O2 -I"${PROJECT_DIR}/package/${PKGNAME}/include" \
	-o "${BUILD_DIR}/${PKGNAME}/osviz-record" \
	"${PROJECT_DIR}/package/${PKGNAME}/src/osviz-log.c" \
	"${PROJECT_DIR}/package/${PKGNAME}/src/log.c"
step_end build

step_start install-target
mkdir -p "${TARGET_DIR}/usr/include/osviz" "${TARGET_DIR}/usr/lib" "${TARGET_DIR}/usr/bin" "${TARGET_DIR}/etc/init.d"
/usr/bin/install -D -m 0644 "${PROJECT_DIR}/package/${PKGNAME}/include/osviz/log.h" "${TARGET_DIR}/usr/include/osviz/log.h"
/usr/bin/install -D -m 0644 "${BUILD_DIR}/${PKGNAME}/libosviz.a" "${TARGET_DIR}/usr/lib/libosviz.a"
/usr/bin/install -D -m 0755 "${BUILD_DIR}/${PKGNAME}/osviz-record" "${TARGET_DIR}/usr/bin/osviz-record"
chmod a+x "${PROJECT_DIR}/package/${PKGNAME}/osviz-snapshot" "${PROJECT_DIR}/package/${PKGNAME}/osviz-help"
/usr/bin/install -D -m 0755 "${PROJECT_DIR}/package/${PKGNAME}/osviz-snapshot" "${TARGET_DIR}/usr/bin/osviz-snapshot"
/usr/bin/install -D -m 0755 "${PROJECT_DIR}/package/${PKGNAME}/osviz-help" "${TARGET_DIR}/usr/bin/osviz-help"
/usr/bin/install -D -m 0755 "${PROJECT_DIR}/package/${PKGNAME}/S98osviz" "${TARGET_DIR}/etc/init.d/S98osviz"
step_end install-target

stamp_installed

echo "<---- ${PKGBUILDNAME} build complete."
