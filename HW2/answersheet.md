---
typora-root-url: pics
---

# NASA HW2

b09902004 郭懷元

## Network Administration

### 1. Short Answer

#### 1.

> Reference:
>
> http://www.cs.nthu.edu.tw/~nfhuang/chap04.htm
>
> https://zh.wikipedia.org/wiki/%E8%BD%BD%E6%B3%A2%E4%BE%A6%E5%90%AC%E5%A4%9A%E8%B7%AF%E8%AE%BF%E9%97%AE
>
> https://www.geeksforgeeks.org/collision-avoidance-in-wireless-networks/

CSMA/CD passively detects if a collision has happened. If it detects a collision, it will stop sending frames as soon as possible. CSMA/CA, on the other hand, will check if the medium is busy or not before sending anything. If it's busy, it will wait for a random time then continue the transmission. CSMA/CA also uses a three-way handshake called RTS/CTS.

In wireless network, it's really difficult to precisely detect a collision, because the two nodes that collides might not be within each other's range (a.k.a. hidden node). Therefore CSMA/CD won't work in   a wireless condition, but CSMA/CA's RTS/CTS can fix this problem.

#### 2.

> References:
>
> http://ccna2012.weebly.com/24291257732131222495-30896257583893622495.html
>
> https://www.geeksforgeeks.org/collision-domain-and-broadcast-domain-in-computer-network/

Collision domain is the range where the frames transferred will collide with each other. Broadcast domain is the range where a broadcast message sent by any device will be received by every other devices in this domain.

(a) Hubs can't split either collision domains or broadcast domains. That's because hubs don't uses MAC address table, and they will sent the received packet to every connected device except the source.

(b) Each port on a switch is an individual collision domain, because switches uses MAC address tables to achieve point-to-point transfer. But switches can't split broadcast domains, splitting them requires a network layer device.

(c) A router splits both collision domain and broadcast domain, because a router connects different networks, and those two domains are restricted to a local network.

#### 3.

> References:
>
> https://en.wikipedia.org/wiki/Broadcast_storm
>
> https://en.wikipedia.org/wiki/Spanning_Tree_Protocol

When many broadcast traffics accumulate on a network and consumes lots of resources, we called this broadcast storm. It's usually caused by loops in network topology. STP solve this problem by cutting excessive paths , breaking all loops in the network topology.

---

### 2. IPerf

#### 1.

**From R204 PC to CSIE Workstation**

On R204 PC

```shell
nslookup linux12.csie.ntu.edu.tw # to get the IP address of workstation
iperf -c 140.112.30.43
```

On CSIE Workstation

```shell
iperf -s -i 5
```

Result

![iperf-p1](iperf-p1.png)

**From laptop (connected to `csie-5G`) to R204 PC**

On R204 PC

```shell
ifconfig # to get the IP address of this system
iperf -s
```

On my laptop

```shell
iperf -c 192.168.204.36 -t 60 -i 5
```

Result

![iperf-p2-1](iperf-p2-1.png)

**From R204 PC to laptop  (connected to `csie-5G`)**

On my laptop

```shell
ifconfig # to get the IP address of this system
iperf -s -i 5
```

On R204 PC

```shell
iperf -c 10.5.0.147 -t 60
```

Result

![iperf-p2-2](iperf-p2-2.png)

**From laptop A to laptop B (both connected to `csie-5G`)**

On laptop A

```shell
ifconfig # to get the IP address of this system
iperf -s
```

On laptop B

```shell
iperf -c 10.5.6.200 -t 60 -i 5
```

Result

![iperf-p3](iperf-p3.png)

#### 2.

| From                              | To                                | Bandwidth Measured |
| --------------------------------- | --------------------------------- | ------------------ |
| R204 PC                           | CSIE Workstation                  | 626 Mbps           |
| Laptop (connected to `csie-5G`)   | R204 PC                           | 220 Mbps           |
| R204 PC                           | Laptop (connected to `csie-5G`)   | 140 Mbps           |
| Laptop A (connected to `csie-5G`) | Laptop B (connected to `csie-5G`) | 66.6 Mbps          |

The highest bandwidth is betweem R204 PC and CSIE Workstation, and it's because the path is completely on wire, which is more robust than WiFi.

The difference between laptop to PC and PC to laptop is probably because more downstream bandwidth is occupied than upstream one, and becomes the bottleneck in transmission.

The lowest bandwidth occurs when both server and client are connected to WiFi, because wireless transmission could have more data loss then wired.

---

 ### 3. IPv6

> Reference:
>
> https://unix.stackexchange.com/questions/457670/netcat-how-to-listen-on-a-tcp-port-using-ipv6-address
>
> https://ithelp.ithome.com.tw/articles/10244029
>
> https://stackoverflow.com/questions/24780404/python-tcp-socket-with-ipv6-address-failed

Commands:

```shell
ifconfig
ncat fe80::5054:ff:fecf:12d9%net0 9453
```

Server message:

```
284a1e00b75784f5ab2f45a086e48bb6
```

![ipv6](ipv6.png)

---

## System Administration

### 1.

> Reference:
>
> Lab 3 slides
>
> https://zh.wikipedia.org/wiki/%E6%96%87%E4%BB%B6%E7%B3%BB%E7%BB%9F
>
> http://linux.vbird.org/linux_basic/0230filesystem.php
>
> https://askubuntu.com/questions/24027/how-can-i-resize-an-ext-root-partition-at-runtime
>
> https://unix.stackexchange.com/questions/61209/create-and-format-exfat-partition-from-linux

Commands:

```shell
sudo -i
lsblk # check current status
parted /dev/sda print # check if it's MBR or GPT
pacman -Syy
pacman -S gdisk # install gdisk bc it's GPT
umount /dev/sda3
e2fsck /dev/sda3
resize2fs /dev/sda3 5G
gdisk /dev/sda
# then follow the instructions in gdisk to:
# 1. delete partition3
# 2. create partition 3 with 5 GB
# 3. create partition 4 with rest of the space
partprobe
vim /etc/fstab
# in vim:
# find the line for mounting /home/nasa/documents
# change the original 'UUID=<some ID>' to '/dev/sda3'
reboot
# after reboot
sudo -i
lsblk
mkfs.exfat /dev/sda4
mount /dev/sda4 /home/nasa/share
vim /etc/fstab
# in vim:
# add a new line like this:
# /dev/sda4    /home/nasa/share    exfat    defaults    0 0
reboot
lsblk; df -hT
```

![sa-p1](sa-p1.png)

---

### 2.

> Reference:
>
> https://www.cyberciti.biz/faq/linux-add-a-swap-file-howto/

Commands:

```shell
sudo -i
dd if=/dev/zero of=/myswap bs=1024 count=2097152
chown root:root /myswap
chmod 0600 /myswap
mkswap /swapfile1
swapon /myswap
free -h
```

![sa-p2](/sa-p2.png)

---

### 3.

> References:
>
> https://linuxhint.com/set-up-btrfs-raid/

Commands:

```shell
sudo mkfs.btrfs -L p3 -d raid1 -m raid1 -f /dev/sdb /dev/sdc
sudo mount /dev/sdb /home/nasa/mnt
cd ~
ls -lah
sudo chown nasa:nasa ~/mnt
sudo btrfs filesystem show /home/nasa/mnt; sudo btrfs filesystem df /home/nasa/mnt
```

![sa-p3](/sa-p3.png)

---

### 4.

> References:
>
> https://linuxhint.com/create-mount-btrfs-subvolumes/

Commands:

```shell
sudo mount /dev/sdb /home/nasa/mnt
sudo btrfs subvolume create /home/nasa/mnt/@
sudo btrfs subvolume create /home/nasa/mnt/@videos
sudo btrfs subvolume create /home/nasa/mnt/@documents
sudo mount /dev/sdb -o subvol=@ /home/nasa/courses
sudo mount /dev/sdb -o subvol=@videos /home/nasa/courses/videos
sudo mount /dev/sdb -o subvol=@documents /home/nasa/courses/documents
sudo blkid --match-token TYPE=btrfs # look for the UUID of /dev/sdb
sudo vim /etc/fstab
sudo reboot
```

![sa-p4](/sa-p4.png)

---

### 5.

> References:
>
> https://linuxhint.com/use-btrfs-snapshots/

Commands:

```shell
sudo btrfs subvolume snapshot -r /home/nasa/courses/documents /home/nasa/courses/documents_backup
```

---

### 6.

> References:
>
> https://linuxhint.com/back_up_btrfs_snapshots_external_drives/

Commands:

```shell
sudo cp -R /home/nasa/videos/* /home/nasa/courses/videos
sudo btrfs subvolume snapshot -r /home/nasa/courses/videos /home/nasa/courses/videos_backup
sudo btrfs send /home/nasa/courses/videos_backup | sudo btrfs receive /home/nasa/backup
```

![sa-p6](/sa-p6.png)

---

### 7.

> References:
>
> https://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices
>
> https://superuser.com/questions/901067/btrfs-convert-from-raid1-to-raid5

Commands

```shell
sudo btrfs device add /dev/sdd /home/nasa/courses
sudo btrfs balance start -dconvert=raid5 -mconvert=raid5 /home/nasa/courses
```

![sa-p7](/sa-p7.png)

---

### 8.

> References:
>
> https://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices

Commands

```shell
sudo btrfs device delete /dev/sdc /home/nasa/courses
sudo btrfs balance start -dconvert=raid1 -mconvert=raid1 /home/nasa/courses
```

![sa-p8](/sa-p8.png)

---

### 9.

#### (i)

> References:
>
> https://en.wikipedia.org/wiki/Comparison_of_file_systems
>
> https://linuxhint.com/btrfs-vs-ext4-filesystems-comparison/

Btrfs has built-in RAID 1, RAID 0 , and RAID 10 support, but ext4 doesn't have any RAID built-in. Btrfs supports online shrinking, but ext4 doesn't support it.

#### (ii)

> References:
>
> https://zh.wikipedia.org/wiki/RAID

In RAID 0, we parallelize reading and writing over all the disks in the array, thus increase performance. Files would have only a single copy and the data is distributed all over the disk array.

In RAID 1, the data on a disk would be mirrored to all the other disks in the array, thus the security is ensured, but waste lots of space.

RAID 5 is like a more secure RAID 0, the data is also distributed to all disks, but a parity data is calculated and stored in a disk different to where the corresponding data is stored. RAID 5 have slightly lower performance than RAID 0, but can allow a single disk failure.

RAID 10 is a combination of RAID 1 and RAID 0. Two disks are paired to build a RAID 1 array, and every RAID array is then combined to build a RAID 0 array. As long as not both disks in a pair are dead, the data is still secure and the system would still work.

#### (iii)

> References:
>
> https://medium.com/@jain.sm/filesystem-in-userspace-5d1b398b04e
>
> https://www.jianshu.com/p/c2b77d0bbc43

FUSE is a feature that lets users define file operations and create their filesystems without having to deal with kernel-related stuff. One advantage is that it can be more portable because libraries would deal with the kernel. The obvious disadvantage is that efficiency is worse than those directly implemented in kernel.

#### (iv)

> References:
>
> https://en.wikipedia.org/wiki/ZFS
>
> https://zh.wikipedia.org/wiki/RAID
>
> https://www.reddit.com/r/homelab/comments/b4iz3w/zfs_vs_hardware_raid/
>
> https://superuser.com/questions/1134753/can-zfs-cope-with-sudden-power-loss-what-events-cause-a-pool-to-be-irrecoverab

ZFS is a system that combines both file system and volume manager. It has control from physical layer to file system layer. ZFS uses many checksum mechanisms to secure data. It also has features like RAID, snapshots, and cloning.

Hardware RAID is a means to implement RAID. A RAID card is used in hardware RAID, and has dedicated processor, memory, and backup battery to handle reading and writing. Because it's implemented in hardware, it can be separated from the OS easily and it's almost plug-and-play.

In the case of a server, I would choose ZFS over hardware RAID. The first reason being hardware RAID relies heavily on the RAID card, which means that if the RAID card somehow dies, you probably would need to find the exact card. On the other hand, ZFS is completely a software solution, therefore doesn't have this problem.

Also, the resources ZFS might consume is becoming negligible as CPU performance is increasing a lot, making dedicated hardware just for RAID a bit excessive.