# File systems and swap files
## fat32

``` sh
mkfs.fat -F 32 /dev/sdX1
fatlabel /dev/sdX1 nixbook
```

## ext4

``` sh
mkfs.ext4 /dev/sdX1 -L nixroot
```

## ntfs

``` sh
mkfs.ntfs /dev/sdX1
ntfslabel /dev/sdX1 data
```

## swap

``` sh
swapon -L swap /dev/sdX1
swaplabel -L swap /dev/sdX1
```

``` sh
dd if=/dev/zero of=/mnt/.swapfile bs=1024 count=2097152 (2 GB)
chmod 600 /mnt/.swapfile
mkswap /mnt/.swapfile
swapon /mnt/.swapfile
```

# Internet
If internet broke, try one of the following:
- nixos-rebuild switch --option substitute false # no downloads
- nixos-rebuild switch --option binary-caches "" # no downloads
- wpa_supplicant flags to connect to wifi

# How to install

1. Partition the disk
   a. Mark NixOS partition as nixroot - use ext4
   b. Mark additional data partition as data (if applicable)
   c. Mark swap partition as swap / use swap file
   d. mark boot partition as nixboot - use fat32 `mkfs.fat -F 32 /dev/sdX1`


2. Mount the partitions

```sh
swapon /dev/disk/by-label swap
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/nixboot /mnt/boot
mount /dev/disk/by-label/data /mnt/data
```

3. Generate

``` sh
nixos-generate-config --root /mnt
nix-env -iA nixos.git
git clone https://github.com/Rutherther/nixos-config /mnt/etc/nixos/config
cp /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/nixos-config/hosts/<host>
```

4. Install

``` sh
cd /mnt/etc/nixos/config
nixos-install --flake .#<host>
```

5. Finalize
  a. Before reboot
    Set root and user password
    ``` sh
    chroot /mnt
    passwd root
    passwd ${user}
    ```

  b. After reboot
    Install doom-emacs (as user)

    ``` sh
    ~/.emacs.d/bin/doom install
    ~/.emacs.d/bin/doom sync
    ```
