---
typora-root-url: pics
---

# NASA HW4

b09902004 郭懷元

## Network Administration

### Short Answers

#### 1.

> Refs:
>
> https://docs.netgate.com/pfsense/en/latest/firewall/fundamentals.html#block-vs-reject

When using `block`, the packets received are dropped siliently without sending any message to the source. When using `reject`, the firewall will return some message to inform the source that the packet has been dropped.

Generally speaking, `block` is preferred on WAN settings and `reject` is preferred on LAN settings.

---

#### 2.

> Refs:
>
> https://www.reddit.com/r/PFSENSE/comments/jt8be5/whats_the_difference_between_using_lan_net_and/gc42ogx/

`interface net` means all addresses in the same subnet, and `interface address` means the address of the interface on pfsense. For example, suppose an interface `vlan5` is on `192.168.42.1/24`, then `vlan5 net` is `192.168.42.1-255` and `vlan5 address` is `192.168.42.1`.

---

#### 3.

> Refs:
>
> https://lin0204.blogspot.com/2017/01/blog-post_30.html
> https://docs.netgate.com/pfsense/en/latest/firewall/fundamentals.html#stateful-filtering

The firewall in pfsense is a *stateful firewall*. A stateful firewall will keep track of traffics going through, and allow expected respond packets that are not directly allowed in rules. For example, if I send a TCP request to a website, the firewall will allow the respond packet from that website.

---

### pfSense

#### 1.

> Refs:
>
> Lab slides

`Interfaces` -> `Assignments` -> `VLANs` -> `Add`, create one vlan with tag `5` and one with tag `99`.

Go to `Interface Assignments` to add those two vlan interfaces.

`Interfaces` -> `OPT1`, and do the following configs:

- **Enable**: check the box
- **Description**: `VLAN5`
- **IPv4 Configuration Type**: `Static IPv4`
- **IPv4 Address**: `10.5.255.254/16`

`Interfaces` -> `OPT2`, and do the following configs:

- **Enable**: check the box
- **Description**: `VLAN99`
- **IPv4 Configuration Type**: `Static IPv4`
- **IPv4 Address**: `192.168.99.254/24`

`Services` -> `DHCP Server` -> `VLAN5`, and do the following configs:

- **Enable**: check the box
- **Range**: From `10.5.0.1` to `10.5.255.253`
- **DNS Servers**: `8.8.8.8`, `8.8.4.4`

`Services` -> `DHCP Server` -> `VLAN99`, and do the following configs:

- **Enable**: check the box
- **Range**: From `192.168.99.1` to `192.168.99.253`
- **DNS Servers**: `8.8.8.8`, `8.8.4.4`

---

#### 2.

> Refs:
>
> https://forums.serverbuilds.net/t/guide-aliases-in-pfsense/5777

`Firewall` -> `Aliases`

Add one entry with the following configs:

- **Name**: `GOOGLE_DNS`
- **Type**: `Host`
- **IP or FQDN**: `8.8.8.8`, `8.8.4.4`

Add one entry with the following configs:

- **Name**: `ADMIN_PORTS`
- **Type**: `Port`
- **Port**: `22`, `80`, `443`

Add one entry with the following configs:

- **Name**: `CSIE_WORKSTATIONS`
- **Type**: `Host`
- **IP or FQDN**: `linux1.csie.org`, `linux2.csie.org`, `linux3.csie.org`, `linux4.csie.org`, `linux5.csie.org`

---

#### 3.

> Refs:
>
> https://blog.51cto.com/fxn2025/1943916

`System` -> `Advanced` -> navigate to `Secure Shell`

Check the box for enabling ssh

`Firewall` -> `Rules` -> `VLAN99`

Add a new entry with the these config:

- **Action**: `Pass`
- **Interface**: `VLAN99`
- **Address Family**: `IPv4`
- **Protocol**: `TCP`
- **Source**: `VLAN99 net`
- **Destination**: `VLAN99 Address`
- **Destination Port Range**: `ADMIN_PORTS`

---

#### 4.

> Refs:
>
> None

`Firewall` -> `Rules` -> `VLAN99`

Add some entries with these configs:

- Entry 1
  - **Action**: `Pass`
  - **Interface**: `VLAN99`
  - **Address Family**: `IPv4`
  - **Protocol**: `Any`
  - **Source**: `VLAN99 net`
  - **Destination**: `VLAN5 net`
- Entry 2
  - **Action**: `Pass`
  - **Interface**: `VLAN99`
  - **Address Family**: `IPv4`
  - **Protocol**: `Any`
  - **Source**: `VLAN99 net`
  - **Destination**: `Single host or alias`, `GOOGLE_DNS`
- Entry 3
  - **Action**: `Pass`
  - **Interface**: `VLAN99`
  - **Address Family**: `IPv4`
  - **Protocol**: `Any`
  - **Source**: `VLAN99 net`
  - **Destination**: `Single host or alias`, `CSIE_WORKSTATIONS`
- Entry 4
  - **Action**: `Block`
  - **Interface**: `VLAN99`
  - **Address Family**: `IPv4`
  - **Protocol**: `Any`
  - **Source**: `VLAN99 net`
  - **Destination**: `any`

And put entry 4 at the bottom.

---

#### 5.

> Refs:
>
> https://www.reddit.com/r/PFSENSE/comments/7srwxc/question_about_multiple_interfaces_and_firewall/
>
> https://docs.netgate.com/pfsense/en/latest/firewall/floating-rules.html

`Firewall` -> `Rules` -> `Floating`

add an entry with these configs:

- **Action**: `Block`
- **Interface**: `WAN`, `LAN`, `VLAN5`, `VLAN99`
- **Direction**: `any`
- **Address Family**: `IPv4`
- **Protocol**: `any`
- **Source**: invert match `VLAN99 net`
- **Destination**: `VLAN99 net`

---

#### 6.

> Refs:
>
> https://docs.netgate.com/pfsense/en/latest/firewall/time-based-rules.html

`Firewall` -> `Schedules`

add an entry like this:

- **Schedule Name**: `block_VLAN5`
- **Month**: `May_21`
- **Date**: `11`
- **Time**: `0:00` ~ `23:59`
- click `add time`

`Firewall` -> `Rules` -> `VLAN5`

add an entry like this:

- **Action**: `Block`
- **Interface**: `VLAN5`
- **Address Family**: `IPv4`
- **Protocol**: `Any`
- **Source**: `any`
- **Destination**: `any`
- click `Display Advanced`
- **Schedule**: `block_VLAN5`

---

#### 7.

> Refs:
>
> None

`Firewall` -> `Rules` -> `VLAN5`

add an entry to the bottom with these configs:

- **Action**: `Pass`
- **Interface**: `VLAN5`
- **Address Family**: `IPv4`
- **Protocol**: `Any`
- **Source**: `VLAN5 net`
- **Destination**: `any`





---


## System Administration

