#!/usr/bin/env bash
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
appdir="$PWD/composeApp/build/compose/binaries/main/app/tasks-personal"
[[ -x "$appdir/bin/tasks-personal" ]]
cat > "$appdir/AppRun" <<'RUN'
#!/bin/sh
APPDIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
exec "$APPDIR/bin/tasks-personal" "$@"
RUN
chmod +x "$appdir/AppRun"
cat > "$appdir/tasks-personal.desktop" <<'DESKTOP'
[Desktop Entry]
Type=Application
Name=Tasks Personal
Exec=tasks-personal
Icon=tasks-personal
Categories=Office;Calendar;
Terminal=false
DESKTOP
cp graphics/icon.png "$appdir/tasks-personal.png"
mkdir -p dist
# Use upstream's pinned and checksum-verified AppImage tooling. No update URL.
scripts/fetch /tmp/personal-appimagetool https://github.com/AppImage/appimagetool/releases/download/1.9.1/appimagetool-x86_64.AppImage ed4ce84f0d9caff66f50bcca6ff6f35aae54ce8135408b3fa33abfc3cb384eb0
scripts/fetch /tmp/personal-runtime https://github.com/AppImage/type2-runtime/releases/download/20251108/runtime-x86_64 2fca8b443c92510f1483a883f60061ad09b46b978b2631c807cd873a47ec260d
chmod +x /tmp/personal-appimagetool
ARCH=x86_64 /tmp/personal-appimagetool --appimage-extract-and-run --runtime-file /tmp/personal-runtime "$appdir" dist/Tasks-Personal-linux-x86_64.AppImage
