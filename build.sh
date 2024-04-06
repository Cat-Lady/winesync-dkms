_kernver="${1:-$(uname -r)}"
_commit=e6bc51b547bbe820055e73cdbb93755b5bfa368c

curl "https://repo.or.cz/linux/zf.git/blob_plain/$_commit:/drivers/misc/winesync.c" --output "winesync.c-$_commit"
curl "https://repo.or.cz/linux/zf.git/blob_plain/$_commit:/include/uapi/linux/winesync.h" --output "winesync.h-$_commit"

set -xe

rm -rf build
install -Dm644 Makefile "build/winesync-$_commit/Makefile"
install -Dm644 "winesync.c-$_commit" "build/winesync-$_commit/src/drivers/misc/winesync.c"
install -Dm644 "winesync.h-$_commit" "build/winesync-$_commit/include/uapi/linux/winesync.h"
install -Dm644 dkms.conf "build/winesync-$_commit/dkms.conf"
sed "s/@PACKAGE_VERSION@/$_commit/g" -i "build/winesync-$_commit/dkms.conf"
mkdir build/build
dkms build --sourcetree "$PWD/build" --dkmstree "$PWD/build/build" -m "winesync/$_commit" -k "$_kernver"
dkms remove --sourcetree "$PWD/build" --dkmstree "$PWD/build/build" -m "winesync/$_commit" -k "$_kernver" || true
dkms add --sourcetree "$PWD/build" --dkmstree "$PWD/build/build" -m "winesync/$_commit" -k "$_kernver"
dkms install --sourcetree "$PWD/build" --dkmstree "$PWD/build/build" -m "winesync/$_commit" -k "$_kernver" --force

if [ "$MODULES_LOAD" == "true" ]
then
	install -Dm644 winesync.conf /usr/lib/modules-load.d/winesync.conf
	modprobe -rv winesync
	modprobe -v winesync
fi

if [ "$UDEV_RULES" == "true" ]
then
	install -Dm644 99-winesync.rules /usr/lib/udev/rules.d/99-winesync.rules
	udevadm control --reload
	udevadm trigger
fi
