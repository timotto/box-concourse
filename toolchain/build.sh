#!/bin/sh -e

dpkg -i ptxdist-root-bucket/ptxdist-root-*.deb

cd oselas-toolchain
ln -s $(which ptxdist) p
./build_one.sh ${TARGET}
cd ..

ls -la oselas-toolchain/dist/
cp -v oselas-toolchain/dist/*deb ${PACKAGE_FILE}
