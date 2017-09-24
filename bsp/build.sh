#!/bin/sh

dpkg -i ptxdist-root-bucket/*deb
dpkg -i toolchain-bucket/*deb

PTXC="$(pwd)/ci/tools/ptxconf.sh"
RELEASE_BUILD_DIR="$(pwd)/build-repease"
IPKG_REPOSITORY="${RELEASE_BUILD_DIR}/ipkg-repository"
mkdir -p "$RELEASE_BUILD_DIR" "$IPKG_REPOSITORY"

cd bsp
ptxdist platform configs/${PLATFORM}/platformconfig
ptxdist select configs/ptxconfig

# configure source download from artifact storage
$PTXC \
  setup \
    set PTXCONF_SETUP_PTXMIRROR "$PRIVATE_SOURCES_URL" \
    set PTXCONF_SETUP_IPKG_REPOSITORY "$IPKG_REPOSITORY"

ptxdist go
ptxdist images
ptxdist make ipkg-push

cd ..

eval "$(grep ^PTXCONF_PLATFORM= bsp/configs/${PLATFORM}/platformconfig)"

cp -v bsp/platform-${PTXCONF_PLATFORM}/images* "${RELEASE_BUILD_DIR}"
tar -cv -C "$RELEASE_BUILD_DIR" . | xz > $PACKAGE
