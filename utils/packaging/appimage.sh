#!/usr/bin/env bash
set -x
set -e

REPO_DIR="$(git rev-parse --show-toplevel)"

mkdir build/bin -p
cd build

cmake -DCMAKE_INSTALL_PREFIX=/usr "$REPO_DIR"
make install DESTDIR=AppDir

# Only downloads linuxdeploy if the remote file is different from local
if [ -e linuxdeploy-x86_64.AppImage ]; then
  curl -Lo linuxdeploy-x86_64.AppImage \
    -z linuxdeploy-x86_64.AppImage \
    https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage  
else
  curl -Lo linuxdeploy-x86_64.AppImage \
    https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage
fi
chmod +x linuxdeploy-x86_64.AppImage

# Appimage set the ARGV0 environment variable. This causes problems in zsh.
# To prevent this, we use wrapper script to unset ARGV0 as AppRun.
# See https://github.com/AppImage/AppImageKit/issues/852
#
cat << 'EOF' > AppDir/AppRun
#!/bin/bash
unset ARGV0
ROOT_DIR="$(dirname "$(readlink  -f "${0}")")"
exec "$ROOT_DIR/usr/bin/lvim" ${@+"$@"}
EOF
chmod 755 AppDir/AppRun

# initialize AppDir and build AppImage

if [ -z "$ARCH" ]; then
  ARCH="$(arch)"
  export ARCH
fi

export OUTPUT=lvim.AppImage
./linuxdeploy-x86_64.AppImage --appdir AppDir -d "$REPO_DIR/utils/desktop/lvim.desktop" -i "$REPO_DIR/utils/desktop/64x64/lvim.svg" --output appimage
mv lvim.AppImage bin/
