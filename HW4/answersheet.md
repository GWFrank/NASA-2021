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

#### 2.

> Refs:
>
> https://www.reddit.com/r/PFSENSE/comments/jt8be5/whats_the_difference_between_using_lan_net_and/gc42ogx/

`interface net` means all addresses in the same subnet, and `interface address` means the address of the interface on pfsense. For example, suppose an interface `vlan5` is on `192.168.42.1/24`, then `vlan5 net` is `192.168.42.1-255` and `vlan5 address` is `192.168.42.1`.

#### 3.

> Refs:
>
> https://lin0204.blogspot.com/2017/01/blog-post_30.html
> https://docs.netgate.com/pfsense/en/latest/firewall/fundamentals.html#stateful-filtering

The firewall in pfsense is a *stateful firewall*. A stateful firewall will keep track of traffics going through, and allow expected respond packets that are not directly allowed in rules. For example, if I send a TCP request to a website, the firewall will allow the respond packet from that website.

---




## System Administration

