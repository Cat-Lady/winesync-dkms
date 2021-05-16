# winesync-dkms
Winesync/fastsync DKMS kernel module.
---
Allows to build the winesync (fastsync):

https://repo.or.cz/linux/zf.git/shortlog/refs/heads/winesync


...kernel-side part as external module, handled by DKMS.
---
## Usage:
**1.** From within the winesync-dkms directory, run ``build.sh`` as a user privilleged to use DKMS (usually, root).

**2.** Copy the ``99-winesync.rules`` into your udev rules directory (usually, ``/etc/udev/rules.d/``), reboot or reload udev rules (``udevadm control --reload; udevadm trigger``).

**3.** (Optional, if you don't have fastsync-enabled wine build ready, yet):
Before building fastsync-enabled wine - for example, using wine-tkg (recommended):

https://github.com/Frogging-Family/wine-tkg-git


...either on its own (wine mainline only, for now), or using staging rebase of fastsync patches by openglfreak:

https://github.com/openglfreak/wine-tkg-userpatches/tree/next/patches/0001-fastsync


...copy winesync.h that you get in ``winesync-dkms`` directory, (as a result of using ``build.sh``) into ``/usr/include/linux/winesync.h`` (be sure to ommit ``-<commit>`` part of the name).

**4.** Before trying to run fastsync enabled wine, be sure you disable esync/fsync, for example, by setting enviromental variables:

```WINEFSYNC=0 WINEESYNC=0 WINEFSYNC_FUTEX2=0```

**5.** To confirm that your wine is using fastsync properly:

a) Check for ``wine: using fast synchronization.`` mesage in stdout (for example, when running the wine stuff from terminal) upon startup.

b) ``lsof /dev/winesync`` *while running* wine stuff should show wine processes as output.

If you're getting ``wine: using server-side synchronization``, your fastsync is not working properly and you're using vanilla wine sync.

---
Based on openglfreak's work from here:

https://aur.archlinux.org/packages/winesync-dkms/


...just edited to work on non-makepkg distros, like Debian, Ubuntu, etc. Basically, anywhere where DKMS is available (and kernel version used is recent enough for it to compile sucessfuly).

## Problems?

Open issue or @CatLady on Frogging Family discord's #support channel:

https://discord.gg/jRy3Nxk
