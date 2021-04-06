#!/bin/sh
set -e

if [ -z "$CONFIG" ] ; then
	echo "\$CONFIG not set. Please set it to the variant to build."
	echo "Valid values are: gcw0, rs90, lepus"
	exit 1
fi

# Clear the build location.
echo "Clearing build location..."
rm -rf output/${CONFIG}

# Use the default config.
make od_${CONFIG}_defconfig BR2_EXTERNAL=board/opendingux O=output/${CONFIG}

# Perform the build.
echo "Starting build..."
nice make -j9 sdk BR2_SDK_PREFIX=${CONFIG}-toolchain O=output/${CONFIG}

echo "Recompressing SDK to XZ..."
ARCHIVE_NAME=opendingux-${CONFIG}-toolchain.`date +'%Y-%m-%d'`
gzip -d -c output/${CONFIG}/images/${CONFIG}-toolchain.tar.gz | xz -T0 -9 > output/${CONFIG}/images/$ARCHIVE_NAME.tar.xz
rm output/${CONFIG}/images/${CONFIG}-toolchain.tar.gz

echo "The SDK has been built at:"
echo "output/${CONFIG}/images/$ARCHIVE_NAME.tar.xz"
echo
echo "Remember to run ./relocate-sdk.sh after extracting it to your desired location"
