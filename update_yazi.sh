#!/bin/bash

if [ -z "$BASH_HELPERS" ]; then
	echo "BASH_HELPERS is not set, quitting"
	exit 1
fi

YAZI="$HOME/code/yazi"
YAZI_RELEASE="$YAZI/target/release"
YAZI_YAZI="$YAZI_RELEASE/yazi"
YAZI_YA="$YAZI_RELEASE/ya"

BIN="$BASH_HELPERS/bin"
BIN_YAZI="$BIN/yazi"
BIN_YA="$BIN/ya"

if [ ! -d "$YAZI" ]; then
	echo "downloading yazi from github"
	cd $(dirname $YAZI)
	git clone https://github.com/sxyazi/yazi.git
fi

# build
echo "Building latest stable version of Yazi"
cd $YAZI
git pull
cargo build --release --locked

# Update links
echo "Updating links"
rm -f $BIN_YAZI $BIN_YA
ln -s $YAZI_YAZI $BIN_YAZI
ln -s $YAZI_YA $BIN_YA

echo "Complete, the new version is:"
$BIN_YAZI --version
