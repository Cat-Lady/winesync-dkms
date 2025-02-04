_kernver="${1:-$(uname -r)}"

_url=https://raw.githubusercontent.com/torvalds/linux
_commit=970b9757cb44c315b5c3da6b1b35a1ffb07cca5a

curl "$_url/$_commit/drivers/misc/ntsync.c" --output "ntsync.c-$_commit"
curl "$_url/$_commit/include/uapi/linux/ntsync.h" --output "ntsync.h-$_commit"

set -xe

rm -rf build
install -Dm644 Makefile "build/ntsync-$_commit/Makefile"
install -Dm644 "ntsync.c-$_commit" "build/ntsync-$_commit/src/drivers/misc/ntsync.c"
install -Dm644 "ntsync.h-$_commit" "build/ntsync-$_commit/include/uapi/linux/ntsync.h"
install -Dm644 dkms.conf "build/ntsync-$_commit/dkms.conf"
sed "s/@PACKAGE_VERSION@/$_commit/g" -i "build/ntsync-$_commit/dkms.conf"
sed -i 's,#include <uapi/linux/ntsync.h>,#include "../../../include/uapi/linux/ntsync.h",' "build/ntsync-$_commit/src/drivers/misc/ntsync.c"
mkdir build/build
dkms build --sourcetree "$PWD/build" --dkmstree "$PWD/build/build" -m "ntsync/$_commit" -k "$_kernver"
dkms remove --sourcetree "$PWD/build" --dkmstree "$PWD/build/build" -m "ntsync/$_commit" -k "$_kernver" || true
dkms add --sourcetree "$PWD/build" --dkmstree "$PWD/build/build" -m "ntsync/$_commit" -k "$_kernver"
dkms install --sourcetree "$PWD/build" --dkmstree "$PWD/build/build" -m "ntsync/$_commit" -k "$_kernver" --force

if [ "$MODULES_LOAD" == "true" ]
then
	install -Dm644 ntsync.conf /usr/lib/modules-load.d/ntsync.conf
	modprobe -rv ntsync
	modprobe -v ntsync
fi

if [ "$UDEV_RULES" == "true" ]
then
	install -Dm644 99-ntsync.rules /usr/lib/udev/rules.d/99-ntsync.rules
	udevadm control --reload
	udevadm trigger
fi
