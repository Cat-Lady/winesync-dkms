# winesync-dkms
ntsync DKMS kernel module.

---
Allows to build ntsync:

https://github.com/torvalds/linux/blob/master/drivers/misc/ntsync.c

...kernel-side part as external module, handled by DKMS.

---

## Usage:
**1.** From within the winesync-dkms directory, run ``build.sh`` as a user privilleged to use DKMS (usually, root).

**2.** Copy the ``99-ntsync.rules`` into your udev rules directory (usually, ``/etc/udev/rules.d/``).

**3.** Copy the ``ntsync.conf`` into your module load list directory (usually, ``/etc/modules-load.d/``).

**4.** Reboot.

**5.** Obtain/Build wine/proton with ntsync enabled

https://github.com/CachyOS/proton-cachyos/issues/3#issuecomment-2566734394

https://github.com/Frogging-Family/wine-tkg-git/issues/1352

**6.** Before trying to run fastsync enabled wine, be sure you disable esync/fsync, and/or enable ntsync, for example, by setting enviromental variables:

```WINEFSYNC=0 WINEESYNC=0 WINEFSYNC_FUTEX2=0 WINESYNC=1```

Environment variable might vary depending on ntsync patches used, consult your wine/proton install's documentation

**7.** To confirm that your wine is using fastsync properly:

a) Check for ``wine: using fast synchronization.`` mesage in stdout (for example, when running the wine stuff from terminal) upon startup.

b) ``lsof /dev/ntsync`` *while running* wine stuff should show wine processes as output.

If you're getting ``wine: using server-side synchronization``, your fastsync is not working properly and you're using vanilla wine sync.

---
Based on openglfreak's work from here:

https://aur.archlinux.org/packages/winesync-dkms/


...just edited to work on non-makepkg distros, like Debian, Ubuntu, etc. Basically, anywhere where DKMS is available (and kernel version used is recent enough for it to compile sucessfuly).

## Problems?

Open issue or @CatLady on Frogging Family discord's #support channel:

https://discord.gg/jRy3Nxk
