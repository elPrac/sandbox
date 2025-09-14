LINUX_OVERRIDE_SRCDIR=$(TOPDIR)/../linux-mainline/
#SYZKALLER_OVERRIDE_SRCDIR=$(TOPDIR)/../syzkaller/
#LINUX_OVERRIDE_SRCDIR_RSYNC_EXCLUSIONS=--include .git
LINUX_OVERRIDE_SRCDIR_RSYNC_EXCLUSIONS += \
  --exclude .cache --exclude .clangd --exclude .vscode \
  --exclude '.*.cmd' --exclude '*.o' --exclude '*.a' --exclude '*.ko' \
  --exclude 'kout-*' --exclude 'build-*'

$(info [BR-EXT] BR2_EXTERNAL=$(BR2_EXTERNAL))
$(info [BR-EXT] LINUX_OVERRIDE_SRCDIR=$(LINUX_OVERRIDE_SRCDIR))
