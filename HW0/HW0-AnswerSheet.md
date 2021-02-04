# NASA HW0

b09902004 郭懷元

##  Network Administration

### 1. True/False

#### 1. False

Refernce: https://en.wikipedia.org/wiki/IMT_Advanced https://en.wikipedia.org/wiki/IMT-2020

It also has specification for capabilities such as latency, connection density, energy efficiency, etc. 


#### 2. False

Refernce: B09新生手冊

The "5G" in "csie-5G" means 5GHz, which is the frequency of WiFi signal.

#### 3. *False

Refernce: https://www.jannet.hk/zh-Hant/post/network-address-translation-nat/

#### 4. False

Refernce: 109-1 計算機概論(單數班)課程內容 https://mkdev.me/en/posts/how-networks-work-what-is-a-switch-router-dns-dhcp-nat-vpn-and-a-dozen-of-other-useful-things

Asscociating multiple devices with one single public IP can be achieved with hiding multiple device under a router. One device (like a laptop or PC) might also have multiple IPs because the device has multiple NIC in it (WiFi + Ethernet for example).

#### 5. True

Refernce: https://medium.com/@zicodeng/how-vpn-works-b7549dcc6ce4 https://networkengineering.stackexchange.com/questions/51159/how-do-vpns-forward-network-traffic-layer-3

A VPN service encrypts and encapsulates the packet sent from your PC, making the packet seems to be sent to the VPN server. The VPN server then decrypts the packet, apply a NAT to the original packet to change its source IP.

#### 6. False

Refernce: https://en.wikipedia.org/wiki/Intranet https://en.wikipedia.org/wiki/Gateway_(telecommunications)

A gateway is used to communicate between discrete networks. Since a communication in an intranet might not be a cross-network one, not every packet is necessary to go through the gateway.

#### 7. True

Reference: https://serverfault.com/questions/373629/what-is-the-correct-response-for-a-dns-server-when-a-domain-does-not-exist

The standard response for non-existent domain is `NXDOMAIN`, and Google Public DNS (8.8.8.8) follows the standard.

#### 8. False

Reference: http://linux.vbird.org/linux_server/0340dhcp.php https://mkdev.me/en/posts/how-networks-work-what-is-a-switch-router-dns-dhcp-nat-vpn-and-a-dozen-of-other-useful-things

DHCP is used to automaticly set some network parameters, but this progress can be done manually. DNS is used to convert domain names into corresponding IP addresses, but since we already know our destination's IP address, DNS is not needed. NAT is used in routers to convert router's assigned public IP into private IPs of deviced in that LAN, but if both our device and the destination is directly connected to the Internet, NAT isn't necessary.

#### 9. False

Reference: https://en.wikipedia.org/wiki/HTTPS https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol https://en.wikipedia.org/wiki/IPsec

Although HTTP protocol doesn't encrypt the message, in other layers of network the content might still be encrypted. For example if you use IPsec in layer 3, the payload is encrypted.

 #### 10. False

Reference: http://linux.vbird.org/linux_server/0340dhcp.php

DHCP servers only helps managing IPs, the devices will set those parameters themselves, and then the router can communicate directly with the device.

### 2. Short Answer



### 3. Command Line Utilities

#### 1.

```shell
(base)
# frank @ Frank-Desktop in /mnt/c/Users/frank [1:45:24]
$ nslookup www.ntu.edu.tw
Server:         192.168.50.1
Address:        192.168.50.1#53

Non-authoritative answer:
Name:   www.ntu.edu.tw
Address: 140.112.8.116

(base)
# frank @ Frank-Desktop in /mnt/c/Users/frank [1:45:26]
$ nslookup csie.ntu.edu.tw
Server:         192.168.50.1
Address:        192.168.50.1#53

Non-authoritative answer:
Name:   csie.ntu.edu.tw
Address: 140.112.30.26

(base)
# frank @ Frank-Desktop in /mnt/c/Users/frank [1:45:28]
$ nslookup linux1.csie.ntu.edu.tw
Server:         192.168.50.1
Address:        192.168.50.1#53

Non-authoritative answer:
Name:   linux1.csie.ntu.edu.tw
Address: 140.112.30.32

(base)
# frank @ Frank-Desktop in /mnt/c/Users/frank [1:45:32]
$ nslookup ceiba.ntu.edu.tw
Server:         192.168.50.1
Address:        192.168.50.1#53

Non-authoritative answer:
Name:   ceiba.ntu.edu.tw
Address: 140.112.161.178
```

(a) www.ntu.edu.tw : 140.112.8.116

(b) csie.ntu.edu.tw : 140.112.30.26

(c) linux1.csie.ntu.edu.tw : 140.112.30.32

(d) ceiba.ntu.edu.tw : 140.112.161.178



