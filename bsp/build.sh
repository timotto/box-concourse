#!/bin/sh -e

dpkg -i ptxdist-root-bucket/*deb
dpkg -i toolchain-bucket/*deb

PTXC="$(pwd)/ci/tools/ptxconf.sh"
RELEASE_BUILD_DIR="$(pwd)/build-repease"
IPKG_REPOSITORY="${RELEASE_BUILD_DIR}/ipkg-repository"
mkdir -p "$RELEASE_BUILD_DIR" "$IPKG_REPOSITORY"

cwd="$(pwd)"
cd "$BSP_DIRECTORY"
ptxdist platform configs/${PLATFORM}/platformconfig
[ -f configs/${PLATFORM}/ptxconfig ] \
    && ptxdist select configs/${PLATFORM}/ptxconfig \
    || ptxdist select configs/ptxconfig

# configure source download from artifact storage
$PTXC \
  setup \
    set PTXCONF_SETUP_PTXMIRROR "$PRIVATE_SOURCES_URL" \
    set PTXCONF_SETUP_IPKG_REPOSITORY "$IPKG_REPOSITORY"

[ "x$PRIVATE_SOURCES_ONLY" = "xtrue" ] \
  && $PTXC setup set PTXCONF_SETUP_PTXMIRROR_ONLY y
  || true

ptxdist go
ptxdist images
ptxdist make ipkg-push

cd "$cwd"

eval "$(grep ^PTXCONF_PLATFORM= ${BSP_DIRECTORY}/configs/${PLATFORM}/platformconfig)"

cp -v ${BSP_DIRECTORY}/platform-${PTXCONF_PLATFORM}/images/* "${RELEASE_BUILD_DIR}"
tar -cv -C "$RELEASE_BUILD_DIR" . | xz > $PACKAGE
