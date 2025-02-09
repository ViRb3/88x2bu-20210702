#!/bin/sh

# SMEM needs to be set here if dkms build is not initiated by install-driver.sh
SMEM=$(LANG=C free | awk '/Mem:/ { print $2 }')

# sproc needs to be set here if dkms build is not initiated by install-driver.sh
sproc=$(nproc)

# avoid Out of Memory condition in low-RAM systems by limiting core usage
if [ "$sproc" -gt 1 ]; then
	if [ "$SMEM" -lt 1400000 ]; then
		sproc=2
	fi
fi

KVER="${KVER:-$(uname -r)}"
KSRC="/lib/modules/$KVER/build"
make "-j$sproc" "KVER=$KVER" "KSRC=$KSRC"
