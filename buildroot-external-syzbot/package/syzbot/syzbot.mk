################################################################################
#
# syzbot
#
################################################################################

SYZBOT_VERSION = 0.1
SYZBOT_SITE = https://syzkaller.appspot.com/x
SYZBOT_C_REPRO = repro.c?x=$(patsubst "%",%,$(BR2_PACKAGE_SYZBOT_C_REPRO_ID))
SYZBOT_SYZ_REPRO = repro.syz?x=$(patsubst "%",%,$(BR2_PACKAGE_SYZBOT_SYZ_REPRO_ID))
SYZBOT_LICENSE = GPL-2.0

# Define the custom download function
define SYZBOT_DOWNLOAD_REPRO_FILES
    if [ -n "$(BR2_PACKAGE_SYZBOT_C_REPRO_ID)" ]; then \
        wget -O $(DL_DIR)/repro.c "$(SYZBOT_SITE)/$(SYZBOT_C_REPRO)" || true; \
    fi
    if [ -n "$(BR2_PACKAGE_SYZBOT_SYZ_REPRO_ID)" ]; then \
        wget -O $(DL_DIR)/repro.syz "$(SYZBOT_SITE)/$(SYZBOT_SYZ_REPRO)" || true; \
    fi
endef

# Append the custom download function to the pre-download hooks
SYZBOT_PRE_DOWNLOAD_HOOKS += SYZBOT_DOWNLOAD_REPRO_FILES

define SYZBOT_EXTRACT_CMDS
    if [ -f $(DL_DIR)/repro.c ]; then \
        cp $(DL_DIR)/repro.c $(@D)/repro.c; \
    fi
    if [ -f $(DL_DIR)/repro.syz ]; then \
        cp $(DL_DIR)/repro.syz $(@D)/repro.syz; \
    fi
endef

define SYZBOT_BUILD_CMDS
    if [ -f $(@D)/repro.c ]; then \
        cd $(@D) && \
        $(TARGET_MAKE_ENV) $(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS) -Wall repro.c -o c-repro; \
    fi
endef

define SYZBOT_INSTALL_TARGET_CMDS
    if [ -f $(@D)/c-repro ]; then \
        $(INSTALL) -D -m 755 $(@D)/c-repro $(TARGET_DIR)/usr/bin/c-repro; \
    fi
    if [ -f $(@D)/repro.syz ]; then \
        $(INSTALL) -D -m 0644 $(@D)/repro.syz $(TARGET_DIR)/usr/share/syz-repro/repro.syz; \
    fi
endef

$(eval $(generic-package))


