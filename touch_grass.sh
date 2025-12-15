#!/bin/bash

# Default version if none provided
VERSION=${1:-"6.1.2"}
URL="https://files.grass.io/file/grass-extension-upgrades/v${VERSION}/Grass_${VERSION}_amd64.deb"
FILENAME="grass_${VERSION}_amd64.deb"
WORK_DIR=$(mktemp -d)
ORIGINAL_DIR=$(pwd)


# Force English locale to prevent date errors (script-only)
export LC_ALL=C

echo "Welcome to the Grass Desktop App installer for Fedora! Please, sit back and get ready to 🌿:touchgrass:🌿 ."
echo "-------------------------------------------"
echo "Target Version: $VERSION"
echo "Working in: $WORK_DIR"

# 1. Prerequisite check:
if ! command -v rpmbuild &> /dev/null; then
    echo "❌Uh-oh... Looks like 'rpm-build' is not installed.❌"
    echo "But don't worry: I got your back. 😊"
    echo "Run ' sudo dnf install rpm-build binutils ' to continue. ⌛"
    exit 1
fi

# 2. Download the official .deb package
echo "⬇️ Downloading the official .deb package...⬇️"
wget -q --show-progress -O "$WORK_DIR/$FILENAME" "$URL"

if [ ! -f "$WORK_DIR/$FILENAME" ]; then
    echo "Task failed successfully. ✅ Could you check the version number next time? 😊"
    exit 1
fi

# 3. Extract the contents
echo "📦Extracting files...📦"
cd "$WORK_DIR"
ar x "$FILENAME"
# Determine if it's tar.gz or tar.xz (Debian pkgs vary)
if [ -f data.tar.gz ]; then
    tar -xf data.tar.gz
elif [ -f data.tar.xz ]; then
    tar -xf data.tar.xz
else
    echo "❌It seems that someone ate our data... 😅 I think you should try again.❌"
    exit 1
fi

# 4. Create the SPEC file dynamically
echo "📝 Generating RPM Specification file (.spec)...📝"
cat <<EOF > grass.spec
Name:           grass-desktop
Version:        ${VERSION}
Release:        1%{?dist}
Summary:        Grass Desktop Node
License:        Proprietary
BuildArch:      x86_64
%define _missing_build_ids_terminate_build 0
%define debug_package %{nil}

# Dependencies for Fedora
Requires:       gtk3
Requires:       libappindicator-gtk3
Requires:       webkit2gtk4.1
Requires:       nss

%description
Grass Desktop Node (Fedora Repack).
The underlying binary is proprietary property of Grass Foundation (Grass OpCo Ltd).

%install
mkdir -p %{buildroot}/usr
cp -r $WORK_DIR/usr/* %{buildroot}/usr/

%files
/usr/bin/grass
/usr/lib/*
/usr/share/*

%changelog
* $(date "+%a %b %d %Y") Fedora User - ${VERSION}-1
- Automated build using Grass-Fedora-Builder
EOF

# 5. Building the RPM...
echo "🔨Building RPM package...🔨"

# Run rpmbuild and capture the output instead of silencing it
BUILD_LOG="$WORK_DIR/rpmbuild.log"
if ! rpmbuild \
  --define "_builddir $WORK_DIR" \
  --define "_rpmdir $WORK_DIR" \
  --define "_buildrootdir $WORK_DIR/.build" \
  -bb grass.spec > "$BUILD_LOG" 2>&1; then

    echo "❌Building failed. Check the logs for more information.❌ "
    echo "👇🏻 Here are the logs, by the way: 👇🏻"
    echo "------------------------------------------------"
    cat "$BUILD_LOG"
    echo "------------------------------------------------"
    exit 1
fi

# 6. Check success and move result
RPM_FILE=$(find "$WORK_DIR/x86_64" -name "*.rpm")

if [ -f "$RPM_FILE" ]; then
    echo "✅Building completed!✅"
if mv "$RPM_FILE" "$ORIGINAL_DIR/"; then
    FINAL_NAME=$(basename "$RPM_FILE")
    echo "🎉 Your package is ready: $(basename "$FINAL_NAME")"
    echo "   You can install it with this command: sudo dnf install $(basename "$FINAL_NAME")"
    echo "   Now you are ready to 🌿:touchgrass:🌿. Enjoy! ✌🏻"
    rm -rf "$WORK_DIR"
else
  echo "⚠️ WARNING: Unable to move the file automatically...⚠️"
        echo " The temporary folder will not be deleted, so you can save your file."
        echo " Your RPM package is currently located here: $RPM_FILE"
        echo " Please copy it manually before closing this terminal."
        exit 1
    fi
else
    echo "❌ Building failed. Check the logs above."
    exit 1
fi



