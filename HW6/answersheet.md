---
typora-root-url: pics/
---

# NASA HW6

b09902004 郭懷元

# Network Administration

## 1. DNS & DHCP

> Refs:
>
> DNS lab slides
> https://magiclen.org/ubuntu-start-job-wait-network/
> https://ubuntu.com/server/docs/network-dhcp
> https://ithelp.ithome.com.tw/articles/10030241

### Server VM setup

**Hypervisor:** VMWare
In the hardware setting, give the VM a NAT adapter and a LAN segment adapter.

![na-p1-6](/na-p1-6.png)

The NAT adapter is the interface to outer network, and the LAN segment adapter is for internal network.

---

### OS installation & static IP configuration

**OS:** Ubuntu Server 20.04

During the installation steps, just follow the default options.
After the installation and reboot, check which interface is the internal one:

```shell
ip a
```

The one without `inet` is the LAN segment interface, in my case it's `ens34`.

Check which file keeps the config for `ens34`:

```shell
cd /etc/netplan; grep -r ens34
```

Turns out it's in `00-installer-config.yaml`

Edit only the `ens34` part of `00-installer-config.yaml` like this:

```yaml
ens34:
      addresses: ["192.168.5.254/24"]
```

Then regenerate the network config file for systemd and apply it:

```shell
sudo netplan generate && sudo netplan apply
```

Check interfaces:

```shell
ip a
```

![na-p1-7](/na-p1-7.png)

---

### DHCP configuration

Install `dhcpd`

```shell
sudo apt install isc-dhcp-server
```

Edit `/etc/dhcp/dhcpd.conf`

```
default-lease-time 600;
max-lease-time 7200;
ddns-update-style none;
authoritative;
subnet 192.168.5.0 netmask 255.255.255.0 {
        range 192.168.5.100 192.168.5.200;
        option routers 192.168.5.254;
        option domain-name-servers 192.168.5.254;
}
```

`subnet 192.168.5.0 netmask 255.255.255.0` specifies the subnet.
`range` is the range of IP addresses that will be given to the client.
`option routers` is the default router/gateway our clients will have.
`option domain-name-servers` is the DNS server our clients will have.

Edit `/etc/default/isc-dhcp-server`

```
INTERFACESv4="ens34"
INTERFACESv6=""
```

`ens34` is the interface to the internal network.

Finally, restart  `dhcpd`

```shell
sudo systemctl restart isc-dhcp-server.service
```

---

### DNS configuration

Install `bind9`, then `cd` to the folder with configs.

```shell
sudo apt install bind9
cd /etc/bind
sudo mkdir zones
```

Edit `named.conf.options`:

```
options {
        directory "/var/cache/bind";
        dnssec-validation auto;
        allow-query { any; };
        listen-on { 192.168.5.254; };
        allow-recursion { any; };
};
```

The first two lines are just defaults.
`allow-query` sets who's DNS queries are allowed.
`listen-on` sets on which interface (specified by IP address) the DNS service will listen for queries.
`forwarders` are the DNS servers we will forward non-local.
`allow-recursion` sets who's DNS queries are allowed to do recursive query.

Edit `named.conf.options`:

```
zone "b09902004.com" {
        type master;
        file "/etc/bind/zones/named.hosts";
};

zone "3.2.1.in-addr.arpa" {
        type master;
        file "/etc/bind/zones/named.rev";
};
```

`zone "b09902004.com"` is for using domain name to look up IP address.
`zone "3.2.1.in-addr.arpa"` is for using IP address to look up domain name.
Note that `3.2.1` is the reverse of first 3 numbers of the address `1.2.3.4`.

Create `zones/named.hosts`:

```
$TTL    604800
@       IN      SOA     ns.b09902004.com.       root.b09902004.com. (
        3               ; Serial
        604800          ; Refresh
        86400           ; Retry
        2419200         ; Expire
        604800 )        ; Negative Cache TTL
                        IN      NS      ns.b09902004.com.
www                     IN      A       1.2.3.4
```

Create `zones/named.rev`:

```
$TTL    604800
@       IN      SOA     ns.b09902004.com.       root.b09902004.com. (
                        3               ; Serial
                        604800          ; Refresh
                        86400           ; Retry
                        2419200         ; Expire
                        604800 )        ; Negative Cache TTL
        IN      NS      ns.b09902004.com.
4       IN      PTR     www.b09902004.com.
```

Finally, check the configuration and restart `bind`

```shell
sudo named-checkconf
sudo service bind9 reload
```

---

### Client VM setup

Basically the same as the server. Still add two network interfaces because we need the NAT interface for the installation process.

After the OS is installed, the NAT interface can be removed so that test result isn't influenced.

---

### DHCP result

![na-p1-1](/na-p1-1.png)

![na-p1-2](/na-p1-2.png)

---

### DNS result

![na-p1-3](/na-p1-3.png)

![na-p1-4](/na-p1-4.png)

![na-p1-5](/na-p1-5.png)

---

## 2. Short Answer







---

# System Administration

## 1. This Problem Is Not For Sale

### 1.1 Using a Saddle? Shame on You!

> Refs:
>
> https://qizhanming.com/blog/2018/08/08/how-to-install-nfs-on-centos-7

flag: `NASA{M0un71n6_NF5!2021}`

#### On workstation:

Create a `.qcow2` disk for VM

```shell
mkdir -p /tmp2/b09902004/img
cd /tmp2/b09902004/img
qemu-img create -f qcow2 nfs.qcow2 10G
```

Install VM with `virt-install` (basically copy-paste from previous homework)

```shell
virt-install \
--name centos-1 \
--ram 2048 \
--vcpus 2 \
--disk /tmp2/b09902004/img/nfs.qcow2 \
--location http://centos.cs.nctu.edu.tw/7.9.2009/os/x86_64/ \
--extra-args="console=tty0 console=ttyS0,115200n8" \
--nographics
```

#### On VM

Install `nfs-utils`, setup the firewall

```shell
yum install -y nfs-utils
systemctl enable --now rpcbind
firewall-cmd --permanent --add-service={rpc-bind,mountd,nfs}
firewall-cmd --reload
```

Mount and get the flag

```shell
mount.nfs 10.217.44.112:/e/NASA_flag /mnt
cd /mnt
cat flag
```

