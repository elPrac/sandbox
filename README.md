# Linux sandbox

## Overview
Welcome to my Linux Sandbox. The purpose of this Linux kernel development environment is to make it easier
for us to reproduce a Kernel Bug. Buildroot is an excellent tool to customize the Linux image, as it allows
us to have control over what is installed in our rootfs. Moreover, I chose this build system because
I wanted to gain more experience working with it, as I am not an expert.

The primary objective of this sandbox is to simplify the debugging process of a Syzkaller
Bug report when we have C & Syz reproducers, kernel config files, and a Syzkaller report.

## Prerequisities:
Before we begin, it is necessary to install the following packages on your Ubuntu (Focal) distro Linux machine:
```
# Miscelaneus
$ sudo apt install git docker.io

# Make sure the service is up and running, and don't forget to enable it
$ sudo systemctl start docker
$ sudo systemctl enable docker

# Install the Qemu system packages that you intend to use as target (recommended)
$ sudo apt install qemu qemu-kvm libvirt-clients libvirt-daemon-system virtinst bridge-utils
```


## How to clone
To clone this project, run the following command:
`git clone --recurse-submodules https://github.com/elPrac/sandbox.git --depth=100`
*Note: use --depth for a faster clone.

## How to start
To get started, run `./scripts/start.sh`. The script will build a Docker image that has everything you need to work with Buildroot.
If this is your first time running it, the script will set a BR2_EXTERNAL variable pointing to our `buildroot-external-syzbot`
and it will pick the default `qemu_x86_64_syzbot_defconfig`, which is our defconfig for x86_64 machines.

The `start.sh` script will check your BR2 artifacts directory (output) and if it exists, it won't try to configure your current
BR2 environment. This script will allow you to interact with a container that has everything you need to build your image.

If you want to work with another machine defconfig, run `make *_defconfig`. You can also add your custom external directory if you want one by your own.

## Workflow
### BR2 Config
The first thing you need to do is configure your Buildroot environment. After running the `start.sh` script, you will
be prompted to a console under the BR2 directory where you can start configuring your build by running `make menuconfig`
once you have identified a bug that you want to reproduce.

For the bug, we picked the main artifacts that we are interested in, namely:
```
HEAD commit:    40f71e7cd3c6 Merge tag 'net-6.4-rc7' of git://git.kernel.o..   
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=7ff8f87c7ab0e04e
compiler:       Debian clang version 15.0.7, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=142e7287280000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13fd185b280000
```

#### Head commit & git tree:
To use the specific commit you to want for the Linux kernel source code and the Linux tree/subsystem,
add your custom remotes that you are interested in with `git remote add linux-next https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/`.
You can then checkout to the specific commit you want to try. We make use of the BR2_OVERRIDE_SRCDIR
mechanism so we can keep the Linux kernel source directory outside the Buildroot directory.

#### kernel config
For the kernel defconfig, which we want to use to reproduce the bug, we must fetch this and place it in our BR2_EXTERNAL.
You can always change the way BR2 picks the Linux kernel defconfig with the BR2_LINUX_KERNEL_USE_CUSTOM_CONFIG.
But for now, we use BR2_LINUX_KERNEL_CUSTOM_CONFIG_FILE, so please follow the next command: `wget https://syzkaller.appspot.com/x/.config?x=7ff8f87c7ab0e04e -O buildroot-external-syzbot/board/syzbot/linux.config`.

The next important thing is to tell BR2 the Linux kernel version we want to build, which we can get from the top of this defconfig:
```
#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 6.4.0-rc6 Kernel Configuration
#
```
Within BR2 menuconfig search for the BR2_LINUX_KERNEL_CUSTOM_VERSION_VALUE and put the version string
`6.4.0-rc6`

#### compiler:
BR2 offers to work with an internal and external toolchain, you can pick between versions or specify yours
please visit the BR2 manual for more [info](https://buildroot.org/downloads/manual/manual.html#_cross_compilation_toolchain)

#### Syz & C reproducers:
To enable the Syz & C reproducers, search for the BR2_PACKAGE_SYZBOT option in the menuconfig.
After enabling it with (Y), you will see two new options: BR2_PACKAGE_SYZBOT_C_REPRO_ID and BR2_PACKAGE_SYZBOT_SYZ_REPRO_ID.
You need to enter the ID of the reproducer, which can be found at the end of the Syzkaller bug URL.
Here's an example of a Syz reproducer identifier:`https://syzkaller.appspot.com/x/repro.syz?x=<Identifier>`. 
Enter this ID under the config options mentioned above.

Once your configuration is complete, you can start the build process by running `make` under the buildroot directory.
If you need to modify something later, you won't need to do a full rebuild. Instead, run `make linux-rebuild all`.
If you need to access a specific kernel config option, you can run the menuconfig by typing `make linux-menuconfig`.

You can also customize your configurations. For example, if you prefer to use System-V init system instead of
System-D (which is set by default), you can search for the appropriate option.

## BR2 Build
To start building the BR2 configuration, run `make` under the buildroot directory.
If you need to modify something later, you don't need to do a full build again; just run `make linux-rebuild all`.
If you need a specific kernel config option, run the menuconfig by `make linux-menuconfig`.


## Run Qemu
To run Qemu, go to `buildroot/output/images` and run the script `./start-qemu.sh --serial-only`.
The QEMU VM runs with hostfwd on port 10022, so if you want to ssh or scp into it, use the following examples:
```
ssh -p 10022 root@localhost
scp -P 10022 root@localhost:/etc/ssh/sshd_config ./
```

# Build Syzkaller target fuzzers
To build Syzkaller fuzzers like execprog, stress, or executor, there is a current work in progress to add the package recipe.
There is a submodule pointing to the Syzkaller repository so you can build these artifacts accordingly and deploy them using the scp tool like so:
```
scp -P 10022 -o UserKnownHostsFile=/dev/null  -o StrictHostKeyChecking=no -o IdentitiesOnly=yes ./bin/linux_amd64/* ./repro.syz root@127.0.0.1:/root/
```

## Syzkaller refereces
Here are some references regarding the use of Syzkaller;
[How to set up syzkaller](https://github.com/google/syzkaller/blob/master/docs/linux/setup.md#how-to-set-up-syzkaller)
[Reproduce a bug with syzbot's downloadable assets](https://github.com/google/syzkaller/blob/master/docs/syzbot_assets.md#reproduce-a-bug-with-syzbots-downloadable-assets)

