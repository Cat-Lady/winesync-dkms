_kernver="${1:-$(uname -r)}"
_commit=73f1881d402c72370f821868a3f1bf7f57f0b0e8
curl "https://repo.or.cz/linux/zf.git/blob_plain/$_commit:/drivers/misc/winesync.c" --output "winesync.c-$_commit"
curl "https://repo.or.cz/linux/zf.git/blob_plain/$_commit:/include/uapi/linux/winesync.h" --output "winesync.h-$_commit"

rm -rf build
install -Dm644 Makefile "build/winesync-$_commit/Makefile"
install -Dm644 "winesync.c-$_commit" "build/winesync-$_commit/src/drivers/misc/winesync.c"
install -Dm644 "winesync.h-$_commit" "build/winesync-$_commit/include/uapi/linux/winesync.h"
install -Dm644 dkms.conf "build/winesync-$_commit/dkms.conf"
sed "s/@PACKAGE_VERSION@/$_commit/g" -i "build/winesync-$_commit/dkms.conf"
mkdir build/build
dkms build --sourcetree "$PWD/build" --dkmstree "$PWD/build/build" -m "winesync/$_commit" -k "$_kernver"
dkms add --sourcetree "$PWD/build" --dkmstree "$PWD/build/build" -m "winesync/$_commit" -k "$_kernver"
dkms install --sourcetree "$PWD/build" --dkmstree "$PWD/build/build" -m "winesync/$_commit" -k "$_kernver"
