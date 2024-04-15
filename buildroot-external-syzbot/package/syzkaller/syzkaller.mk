################################################################################
#
# syzkaller
#
################################################################################

#SYZKALLER_VERSION := c8349e48534ea6d8f01515335d95de8ebf5da8df
#SYZKALLER_SITE := https://github.com/google/syzkaller.git
#SYZKALLER_SITE_METHOD := git
#SYZKALLER_LICENSE := Apache-2.0
#SYZKALLER_LICENSE_FILES := LICENSE
#SYZKALLER_GOMOD = github.com/google/syzkaller/tools/syz-execprog
#
#
#define SYZKALLER_INSTALL_TARGET_CMDS
#	$(INSTALL) -D -m 0755 $(@D)/bin/syzkaller $(TARGET_DIR)/usr/bin/syz-execprog
#endef
#
## Use the golang-package infrastructure
#$(eval $(golang-package))

SYZKALLER_VERSION := c8349e48534ea6d8f01515335d95de8ebf5da8df
SYZKALLER_SITE := https://github.com/google/syzkaller.git
SYZKALLER_SITE_METHOD := git
SYZKALLER_LICENSE := Apache-2.0
SYZKALLER_LICENSE_FILES := LICENSE

# Define the post-extraction hook to copy the .git directory
define SYZKALLER_POST_EXTRACT_HOOK
    echo $(SYZKALLER_DL_DIR)
    echo "Checking directories..."
    ls -la $(SYZKALLER_DL_DIR)/git/  # Make sure this lists the .git directory
    cp -a $(SYZKALLER_DL_DIR)/git/.git $(@D)/
endef

# Register the post-extraction hook
SYZKALLER_POST_EXTRACT_HOOKS += SYZKALLER_POST_EXTRACT_HOOK

define SYZKALLER_BUILD_CMDS
    $(TARGET_CONFIGURE_OPTS) \
    GOPATH=$(HOST_DIR)/usr GO111MODULE=on \
    GOARCH=amd64 \
    TARGETOS=linux \
    TARGETARCH=amd64 \
    $(MAKE) $(TARGET_MAKE_ENV) -C $(@D) target
endef

define SYZKALLER_INSTALL_TARGET_CMDS
    $(INSTALL) -D -m 0755 $(@D)/bin/syz-manager $(TARGET_DIR)/usr/bin/syz-manager
    $(INSTALL) -D -m 0755 $(@D)/bin/syz-fuzzer $(TARGET_DIR)/usr/bin/syz-fuzzer
    $(INSTALL) -D -m 0755 $(@D)/bin/syz-execprog $(TARGET_DIR)/usr/bin/syz-execprog
    # Include other binaries as needed
endef

# Use the golang-package infrastructure
$(eval $(golang-package))



