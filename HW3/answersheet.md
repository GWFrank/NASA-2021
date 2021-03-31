---
typora-root-url: pics
---

# NASA HW3

b09902004 郭懷元

## Network Administration

### 1.



---

### 2.



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
reboot
sudo systemctl start libvirtd
sudo systemctl enable libvirtd
reboot
```

---

### 2.

#### 1.



