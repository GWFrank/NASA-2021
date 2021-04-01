---
typora-root-url: pics
---

# NASA HW3

b09902004 郭懷元

## Network Administration

### 1.

#### 1.

> References:
>
> https://www.netadmin.com.tw/netadmin/zh-tw/technology/FFD0629A85794E9BAC2A9173D5B96EDC
>
> 

When the packets is sent to `Gi1/0/3`, because this interface is set to `access` mode, the packet will be tagged to be in `vlan 307`. However, when it's sent to either `Gi1/0/4` or `Gi1/0/5`, because these two interface are set to `trunk` mode, no tags would be added, despite the fact that they have different native vlans.

#### 2.

When the packets goes through `Gi1/0/1`, the `802.1q header` is added and it's tagged to be in `vlan 424`. When the packets goes through `Gi1/0/2`, the header is stripped.

#### 3.








---

### 2.

#### 1.

> References:
>
> https://en.wikipedia.org/wiki/Link_aggregation#Same_link_speed

No. According to the IEEE standard, link aggregation requires all ports to have the same speed. In this case the maxmium bandwidth would be 2*100Mbps.

2.

`channel-group mode` is preferred to be set to `active` rather than `passive`.

---

### 3.



---

### 4.



---

### 5.

> References:
>
> Lab 4 slides
>
> https://smallbusiness.chron.com/disable-dns-lookup-cisco-58863.html
>
> http://www.james-tw.com/cisco/cisco-she-ding-yuan-duan-lian-xian-telnet-ssh

#### 1

```
Switch> ena
Switch# conf t
Switch(config)# hostname CiscoLab
CiscoLab(config)# exit
CiscoLab# copy running-config startup-config
```

#### 2

```
CiscoLab# conf t
CiscoLab(config)# no ip domain-lookup
CiscoLab(config)# exit
CiscoLab# copy running-config startup-config
```

#### 3

```
CiscoLab(config)# enable password CISCO
CiscoLab(config)# service password-encryption
CiscoLab(config)# exit
CiscoLab# copy running-config startup-config
```

#### 4 ~ 6

```
CiscoLab# conf t
CiscoLab(config)# int range fa0/1-2
CiscoLab(config-if-range)# switchport mode access
CiscoLab(config-if-range)# switchport access vlan 10
CiscoLab(config-if-range)# exit
CiscoLab(config)# int range fa0/3-4
CiscoLab(config-if-range)# switchport mode access
CiscoLab(config-if-range)# switchport access vlan 20
CiscoLab(config-if-range)# exit
CiscoLab(config)# int fa0/5
CiscoLab(config-if)# switchport mode access
CiscoLab(config-if)# switchport access vlan 99
CiscoLab(config-if)# exit
CiscoLab(config)# exit
CiscoLab# copy running-config startup-config 
```

#### 7

```
CiscoLab# conf t
CiscoLab(config)# int vlan 99
CiscoLab(config-if)# ip address 192.168.99.1 255.255.255.0
CiscoLab(config-if)# no shutdown
CiscoLab(config)# line vty 0 4
CiscoLab(config-line)# password cisco
CiscoLab(config-line)# login
CiscoLab(config-line)# exit
CiscoLab(config)# service password-encryption 
CiscoLab(config)# exit
CiscoLab # copy running-config startup-config 
```

![na-p5](/na-p5.png)





---

## System Administration

### 1.

> References:
>
> http://linux.vbird.org/linux_basic/0157installcentos7.php
>
> https://blog.gtwang.org/linux/centos-7-install-kvm-qemu-virtual-machine-tutorial/

#### 4.

![sa-p1-1](/sa-p1-1.png)

![sa-p1-2](/sa-p1-2.png)

#### 5.

```shell
sudo yum install virt-install qemu-kvm libvirt
```

#### 6.

```shell
sudo yum install vim
sudo vim /etc/sysconfig/selinux
# change "SELINUX=enforced" to "SELINUX=disabled"
reboot
sudo systemctl start libvirtd
sudo systemctl enable libvirtd
reboot
```

---

### 2.

#### 1.



---

### 3.

> References:
>
> https://serverfault.com/questions/731417/how-do-you-create-a-qcow2-file-that-is-small-yet-commodious-on-a-linux-server
>
> https://serverfault.com/questions/995957/kickstart-create-users-and-add-to-groups
>
> https://docs.fedoraproject.org/en-US/fedora/rawhide/install-guide/appendixes/Kickstart_Syntax_Reference/
>
> https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/virtualization_deployment_and_administration_guide/sect-guest_virtual_machine_installation_overview-creating_guests_with_virt_install
>
> https://wyde.github.io/2017/10/15/How-to-Install-VM-on-Linux-KVM-Virtualization-Host-using-Kickstart-File/

#### 1.

```shell
sudo mkdir -p /data/img
```

#### 2.

```shell
cd /data/img
sudo qemu-img create -f qcow2 nasa.qcow2 10G
```

#### 3.

```shell
cd ~
sudo yum install wget
wget ix.io/1ElA -O xm.cfg
vim xm.cfg
sudo cp xm.fg /data
```

added lines:

```
# create user "xiaoming" under group "wheel"
user --name=xiaoming --groups=wheel --password=XMishandsome --iscrypted


%packages
# some packages already in here
epel-release # not in base repo
vim
sudo
wget

%end
```

#### 4.

```
virt-install \
--name ILoveNASA \
--ram 2048 \
--vcpus 2 \
--disk /data/img/nasa.qcow2 \
--location http://centos.cs.nctu.edu.tw/ \
--osvariant centos7.0 \
--initrd-inject /data/xm.cfg
--extra-args="ks=file:/xm.cfg console=tty0 console=ttyS0,115200n8"

```

