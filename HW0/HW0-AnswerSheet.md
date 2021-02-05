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

#### 3. True

Refernce: https://www.jannet.hk/zh-Hant/post/network-address-translation-nat/

A PAT(Port Address Translation) can achieve port-to-port translation.

#### 4. False

Refernce: 109-1計算機概論(單數班)課程內容 https://mkdev.me/en/posts/how-networks-work-what-is-a-switch-router-dns-dhcp-nat-vpn-and-a-dozen-of-other-useful-things

Asscociating multiple devices with one single public IP can be achieved with hiding multiple device under a router. One device (like a laptop or PC) might also have multiple IPs because the device has multiple NIC in it (WiFi + Ethernet for example).

#### 5. True

Refernce: https://medium.com/@zicodeng/how-vpn-works-b7549dcc6ce4 https://networkengineering.stackexchange.com/questions/51159/how-do-vpns-forward-network-traffic-layer-3

A VPN service encrypts and encapsulates the packet sent from your PC, making the packet seems to be sent to the VPN server. The VPN server then decrypts the packet, apply a NAT to the original packet to change its source IP.

#### 6. False

Refernce: https://en.wikipedia.org/wiki/Intranet https://en.wikipedia.org/wiki/Gateway_(telecommunications)

A gateway is used to communicate between discrete networks. Since a communication in an intranet might not be a cross-network one, not every packet is necessary to go through the gateway.

#### 7. False

Reference: https://serverfault.com/questions/373629/what-is-the-correct-response-for-a-dns-server-when-a-domain-does-not-exist

The standard response for non-existent domain is `NXDOMAIN`, and Google Public DNS (8.8.8.8) follows the standard.

#### 8. False

Reference: http://linux.vbird.org/linux_server/0340dhcp.php https://mkdev.me/en/posts/how-networks-work-what-is-a-switch-router-dns-dhcp-nat-vpn-and-a-dozen-of-other-useful-things

DHCP is used to automaticly set some network parameters, but this progress can be done manually. DNS is used to convert domain names into corresponding IP addresses, but since we already know our destination's IP address, DNS is not needed. NAT is used in routers to convert router's assigned public IP into private IPs of deviced in that LAN, but if both our device and the destination is directly connected to the Internet, NAT isn't necessary.

#### 9. True

Reference: https://en.wikipedia.org/wiki/HTTPS https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol

HTTP protocol doesn't encrypt any data.

 #### 10. False

Reference: http://linux.vbird.org/linux_server/0340dhcp.php

DHCP servers only helps managing IPs, the devices will set those parameters themselves, and then the router can communicate directly with the device.



### 2. Short Answer

#### 1.

Reference: 109-1計算機概論(單數班)課程內容 https://mkdev.me/en/posts/how-networks-work-what-is-a-switch-router-dns-dhcp-nat-vpn-and-a-dozen-of-other-useful-things https://en.wikipedia.org/wiki/MAC_address

**(a)** MAC address

A MAC address a string of number used as a network address. Each network interface controller is assigned with a unique MAC address. This address is used in layer 2 of OSI model. Ethernet, WiFi, and Bluetooth all use MAC addresses.

**(b)** Router

Routers can connect different LANs, route packets from one network to another network. They work on layer 3 of OSI model, and use IP address to direct packets.

**(c)** Switch

Switches work on layer 2 of OSI model. They use MAC address to direct frames from one device to another, and they connect hosts to form a LAN.

#### 2.

Reference: https://www.jannet.hk/zh-Hant/post/IP-Address-Version-4-IPv4

A subnet mask is a string of number that can be used to identify the network ID of an IP address.

(b), (c)











### 3. Command Line Utilities

#### 1.

Refernce: https://www.cloudns.net/blog/10-most-used-nslookup-commands/ https://ithelp.ithome.com.tw/articles/10214407

**(a)** www.ntu.edu.tw : 140.112.8.116

```
(base) 
# frank @ Frank-Desktop-Linux in ~ [16:55:44] 
$ nslookup www.ntu.edu.tw
Server:         127.0.0.53
Address:        127.0.0.53#53

Non-authoritative answer:
Name:   www.ntu.edu.tw
Address: 140.112.8.116
```

**(b)** csie.ntu.edu.tw : 140.112.30.26

```
(base) 
# frank @ Frank-Desktop-Linux in ~ [16:55:52] 
$ nslookup csie.ntu.edu.tw
Server:         127.0.0.53
Address:        127.0.0.53#53

Non-authoritative answer:
Name:   csie.ntu.edu.tw
Address: 140.112.30.26
```

**(c)** linux1.csie.ntu.edu.tw : 140.112.30.32


```
(base) 
# frank @ Frank-Desktop-Linux in ~ [16:56:00] 
$ nslookup linux1.csie.ntu.edu.tw 
Server:         127.0.0.53
Address:        127.0.0.53#53

Non-authoritative answer:
Name:   linux1.csie.ntu.edu.tw
Address: 140.112.30.32
```

**(d)** ceiba.ntu.edu.tw : 140.112.161.178

```
(base) 
# frank @ Frank-Desktop-Linux in ~ [16:56:06] 
$ nslookup ceiba.ntu.edu.tw
Server:         127.0.0.53
Address:        127.0.0.53#53

Non-authoritative answer:
Name:   ceiba.ntu.edu.tw
Address: 140.112.161.178
```

#### 2.

**(a)**

Public IP: 140.112.150.127, Private IP: 192.168.50.52

Reference: https://opensource.com/article/18/5/how-find-ip-address-linux

```
(base) 
# frank @ Frank-Desktop-Linux in ~ [17:04:26] 
$ hostname -I | awk '{print $1}'
192.168.50.52
(base) 
# frank @ Frank-Desktop-Linux in ~ [17:08:35] 
$ curl ifconfig.me
140.112.150.127
```

**(b)**

Refernce: https://www.cloudns.net/blog/10-most-used-nslookup-commands/ https://ithelp.ithome.com.tw/articles/10214407

DNS server IP: 140.112.254.4

```
(base) 
# frank @ Frank-Desktop-Linux in ~ [17:24:28] 
$ nslookup csie.ntu.edu.tw
Server:         140.112.254.4
Address:        140.112.254.4#53

Non-authoritative answer:
Name:   csie.ntu.edu.tw
Address: 140.112.30.26
```

Delegation path: 140.112.254.4 -> b.root-servers.net -> g.dns.tw -> moemoon.edu.tw -> dns.tp1rc.edu.tw -> csman.csie.ntu.edu.tw

```
(base) 
# frank @ Frank-UX425EA-Linux in ~ [14:20:08] 
$ dig +trace csie.ntu.edu.tw | grep Received
;; Received 1137 bytes from 140.112.254.4#53(140.112.254.4) in 3 ms
;; Received 1004 bytes from 199.9.14.201#53(b.root-servers.net) in 223 ms
;; Received 784 bytes from 220.229.225.195#53(g.dns.tw) in 7 ms
;; Received 382 bytes from 192.83.166.17#53(moemoon.edu.tw) in 3 ms
;; Received 117 bytes from 163.28.16.10#53(dns.tp1rc.edu.tw) in 3 ms
;; Received 1365 bytes from 140.112.30.13#53(csman.csie.ntu.edu.tw) in 0 ms
```

**(c)**

DNS server IP: 127.0.0.53

```
(base) 
# frank @ Frank-Desktop-Linux in ~ [16:55:52] 
$ nslookup csie.ntu.edu.tw
Server:         127.0.0.53
Address:        127.0.0.53#53

Non-authoritative answer:
Name:   csie.ntu.edu.tw
Address: 140.112.30.26
```

**(d)**



## System Administration

### 1. Capture The Flag

#### 1.

Flag: `NASA{echo_"$USER"}`, `NASA{id_-u_-n}`, `NASA{whoami}`

Reference: 陳可邦 林弘毅 https://www.cyberciti.biz/faq/appleosx-bsd-shell-script-get-current-user/

#### 2.

Flag: `NASA{ssh_bbsu@ptt.cc}`

Refernce: https://chakra-zh.blogspot.com/2013/02/chakra-linux-ssh-ptt.html

#### 3.

Flag: `NASA{man_man}`

Reference: B09前瞻營課程內容&手冊

#### 4.

Flag: `NASA{71_921}`

Reference: https://cmdlinetips.com/2011/08/how-to-count-the-number-of-lines-words-and-characters-in-a-text-file-from-terminal/

```
cd ~
ls -lah
chmod 777 toilet
cd toilet
wc -l article
wc -w article
```

#### 5.

Flag: `NASA{MEOW_CAT}`

Reference: B09前瞻營課程內容&手冊 https://stackoverflow.com/questions/18006581/how-to-append-contents-of-multiple-files-into-one-file

```
cd ~/cartoon
ls -lah
cat *
cat flag0* flag1* flag2*
cat flag2* flag3* flag4* flag5*
```

#### 6.

Flag: `NASA{IM_SHERLOCKED}`

Reference: B09前瞻營課程內容&手冊

```
cd ~/TW
mkdir CSIE
chmod 700 CSIE
mv hide CSIE
cd CSIE
mkdir vote
chmod 700 vote
mv hide vote
cd vote
mkdir box
chmod 700 box
mv hide box
./hide
```

#### 7.

Flag: `NASA{grep_virus_nasa}`

Refernce: B09前瞻營課程內容&手冊 http://benjr.tw/97395 https://www.cyberciti.biz/faq/grep-regular-expressions/

```
grep -E "NASA\{[[:alpha:]]+_virus_[[:alpha:]]+\}" flags
```

#### 8.

Flag: `NASA{12402_0_1000000}`

Reference: B09前瞻營課程內容&手冊 http://linux.vbird.org/linux_basic/0330regularex.php#sed_file

```
cd ~/nanasasa
cp nasa_report clone_nasa_report
sed -i 's/nasa/NASA/g' clone_nasa_report
./test clone_nasa_report
```

#### 9.

Flag: `NASA{UR_MAZ3_RUNN3R}`

Reference: https://blog.gtwang.org/linux/unix-linux-find-command-examples/ https://stackoverflow.com/questions/3458461/find-file-then-cd-to-that-directory-in-linux

```
cd ~/maze
find -name flag
cd "$(dirname "$(find -name flag)")"
ls
cat flag
```

#### 10.

Flag: `NASA{0BS3RV3_M3}`

Reference: https://www.twblogs.net/a/5b7afe162b7177539c2499ab https://linuxize.com/post/vim-search/ https://blog.gtwang.org/useful-tools/how-to-use-vim-as-a-hex-editor/

In bash:

```
cd ~/image
wget "$(cat url)"
cp s1PiDl5.jpg cat_pic.jpg
vim cat_pic.jpg
```

In vim:

```
:%! xxd
/SA
```

#### 11.

Flag: `NASA{kill_-9_"$(pgrep_guineaPig)"}` `NASA{pkill_-9_guineaPig}`

Reference: 陳可邦 林弘毅 B09前瞻營課程內容&手冊 https://blog.gtwang.org/linux/linux-howto-find-process-by-name/

#### 12.

Reference: https://david50.pixnet.net/blog/post/45252072-%5B%E7%AD%86%E8%A8%98%5Dlinux---top%E8%B3%87%E8%A8%8A https://stackoverflow.com/questions/17394356/how-can-i-make-a-bash-command-run-periodically http://linux.vbird.org/linux_basic/0430cron.php

First, I use `top -o S` to see what processes are running, and I find out that the process that is printing the message is not constantly running (because the number of running processes is 1 most of the time).  Then, I use `crontab -l` to see if there are any scheduled jobs, and find the command is there (it's also the only one in the table). Finally, I use `crontab -r` to remove all the scheduled jobs. Problem solved!

#### 13.

Reference: https://unix.stackexchange.com/questions/6050/is-it-possible-to-stop-a-shutdown-command https://stackoverflow.com/questions/5050780/detect-pending-linux-shutdown https://unix.stackexchange.com/questions/56083/how-to-write-a-shell-script-that-gets-executed-on-login

Since it's a auto shutdown, it's probably a script that runs at login or startup and schedules a shutdown.  First, I run `cat /run/systemd/shutdown/scheduled` to see if any shutdowns are scheduled, and there is one. Then I run `shutdown -c` to cancel it to fix the problem for now.

Now, I want to find where the script or command is at. I check `~/.profile`,  `/etc/profile`, files under `/etc/profile.d` but nothing strange was there. Then I run `bash` and run `cat /run/systemd/shutdown/scheduled` in the newly started bash. A scheduled shutdown appears, so that means the command is in `~/.bashrc`. Finally run `vim ~/.bashrc`, `/ shutdown`, remove the line.

#### 14.

Reference: B09前瞻營課程內容&手冊 https://wiki.archlinux.org/index.php/File_permissions_and_attributes

The `r`, `w`, and `x` mean different permissions as the table below.

| Permissions | Meaning to a file              | Meaning to a directory                                       |
| ----------- | ------------------------------ | ------------------------------------------------------------ |
| r           | Permission to read the file    | Permission to show content of the directory                  |
| w           | Permission to modify the file  | Permission to modify content of the directory (such as renaming files or folders, creating new files or folders) |
| x           | Permission to execute the file | Permission to access the directory with `cd`                 |

#### 15.

