Run the emulation with:

  qemu-system-x86_64 -m 2G -M pc -smp 2,sockets=2,cores=1 -kernel output/images/bzImage -drive file=output/images/rootfs.ext2,if=virtio,format=raw -append "rootwait root=/dev/vda console=tty1 console=ttyS0 earlyprintk=serial net.ifnames=0" -enable-kvm -serial stdio -net nic,model=virtio -net user,host=10.0.2.25,hostfwd=tcp::10022-:22 # qemu_x86_64_syzbot_defconfig

Optionally add -smp N to emulate a SMP system with N CPUs.

The login prompt will appear in the graphical window.
