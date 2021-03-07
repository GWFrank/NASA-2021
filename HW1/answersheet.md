# NASA HW1

b09902004 郭懷元

## Network Administration

### 野生的密碼難道會在網路上赤裸地奔馳著?

#### 1.

Type `http` in display filter to make it easier to find the packet.

![http-packet](/home/frank/Github_Repos/NASA-2021/HW1/pics/http-packet.png)

#### 2.

The packet can't be found. Because we are accessing `登入界面．改` with https, the content of packets sent between the server and pc is encrypted. Therefore it is impossible to identify which packet contains my account and password if we only look at the content of each packet.

-----

### 好玩遊戲也有暗潮洶湧的一面

#### 1.

In Wireshark, go to `statistics`->`conversations`, and we can see something like the image below after playing 2 games while Wireshark is running. Select the first row and click `Follow Stream...`.

 ![NA-p2-1](/home/frank/Github_Repos/NASA-2021/HW1/pics/NA-p2-1.png)

After reading the conversation between client and server, we know the game works this way:

0. The client and  the server establish a TCP connection. All conversation are made on this TCP connection.

1. The client sends `start <game mode>` to the server at `localhost:9393`. The default game mode is `default`, other available game modes are `fast` and `double`.
2. The server will send horizontal blocks' position, vertical blocks' position, ball's cordinate, and a countdown. The message is sent at a fixed frequency. 
3. While the server updates information to let client render, the client will send our moves to host, so that the server know to update blocks' position.
4. If the countdown goes to 0, the server will send `win`. If the ball hits the wall, the server will send `lose`. When client receives game result, the result will be printed and game will stop running.
5. The TCP connection is terminated only when the process is killed.

#### 2.

In the `conversation` window, choose the conversation to `127.0.0.1:9394`

![NA-p2-2](/home/frank/Github_Repos/NASA-2021/HW1/pics/NA-p2-2.png)

The server will send a message that includes the line `give me secret\n` at a random time during game at port `localhost:9393`. Then the client will send content of `~/.bash_history` to the server at `localhost:9394`. `.bash_history` contents every line you entered in bash before, and it might contains some sensitive information such as passwords and api keys.

#### 3.

Go to `statistics` -> `conversations`, find the conversation to `127.0.0.1:9394`.

![NA-p2-3](/home/frank/Github_Repos/NASA-2021/HW1/pics/NA-p2-3.png)

We can see that the password is `WoBuHueA_WoJiouJenDeBuHueA`.

#### 4.

> Reference:
>
> b09902011 陳可邦
>
> https://clay-atlas.com/blog/2019/10/15/python-chinese-tutorial-socket-tcp-ip/

Flag: `HW1{d0_y0u_knovv_wH0_KaienLin_1s?}`

![flag1](/home/frank/Github_Repos/NASA-2021/HW1/pics/flag1.png)

Since the client only handles transfering user inputs to the server, we can still play the game without `client-linux`. I choose python to communicate with the server and play games, because I am familiar with it and Ubuntu already has it. We can know what to send to the server by simply looking at past conversation when playing game with `client-linux`.

Below is the python script I use:

```python
import socket

HOST = "127.0.0.1"
PORT = 9393

# gamemode = "default"
gamemode = "fast"
start_msg = "start " + gamemode

right = "right"
left = "left"
up = "up"
down = "down"
move = "Move: "
break_line = "\n"

MAX_Y = 21
MAX_X = 34

def moveX(step):
    if step > 0:
        move_str = move + right + break_line
        client.sendall(move_str.encode())
    if step < 0:
        move_str = move + left + break_line
        client.sendall(move_str.encode())

def moveY(step):
    if step > 0:
        move_str = move + down + break_line
        client.sendall(move_str.encode())
    if step < 0:
        move_str = move + up + break_line
        client.sendall(move_str.encode())

def decmps(host_msg):
    msg_list = host_msg.split("\n")
    block_x = msg_list[0]
    block_y = msg_list[1]
    ball_x = msg_list[2]
    ball_y = msg_list[3]
    block_x = int(block_x.split(" ")[1])
    block_y = int(block_y.split(" ")[1])
    ball_x = [int(i) for i in ball_x.split(" ") if i != "ballx:"]
    ball_y = [int(i) for i in ball_y.split(" ") if i != "bally:"]
    return block_x, block_y, ball_x, ball_y

win = "win"
lose = "lose"

client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
client.connect((HOST, PORT))
client.sendall(start_msg.encode())

while True:
    server_msg = str(client.recv(1024), encoding="utf-8")
    if server_msg[:3] == win or server_msg[:4] == lose:
        print(server_msg)
        break
    if server_msg[:4] == "give":
        continue    
    block_x, block_y, ball_x, ball_y = decmps(server_msg)

    # for default and fast mode
    moveX(ball_x[0] - block_x)
    moveY(ball_y[0] - block_y)

client.close()
```



#### 5.

> Reference:
>
> b09902011 陳可邦
>
> https://clay-atlas.com/blog/2019/10/15/python-chinese-tutorial-socket-tcp-ip/

Flag: `HW1{Dou8l3_b@ll_d0uB1e_Fun!}`

![flag2](/home/frank/Github_Repos/NASA-2021/HW1/pics/flag2.png)

The approach is basically the same as last one. The only thing I changed is game strategy because there are two balls.

```python
import socket

HOST = "127.0.0.1"
PORT = 9393

# gamemode = "default"
# gamemode = "fast"
gamemode = "double"
start_msg = "start " + gamemode

right = "right"
left = "left"
up = "up"
down = "down"
move = "Move: "
break_line = "\n"

MAX_Y = 21
MAX_X = 34

def moveX(step):
    if step > 0:
        move_str = move + right + break_line
        client.sendall(move_str.encode())
    if step < 0:
        move_str = move + left + break_line
        client.sendall(move_str.encode())

def moveY(step):
    if step > 0:
        move_str = move + down + break_line
        client.sendall(move_str.encode())
    if step < 0:
        move_str = move + up + break_line
        client.sendall(move_str.encode())

def decmps(host_msg):
    msg_list = host_msg.split("\n")
    block_x = msg_list[0]
    block_y = msg_list[1]
    ball_x = msg_list[2]
    ball_y = msg_list[3]
    block_x = int(block_x.split(" ")[1])
    block_y = int(block_y.split(" ")[1])
    ball_x = [int(i) for i in ball_x.split(" ") if i != "ballx:"]
    ball_y = [int(i) for i in ball_y.split(" ") if i != "bally:"]
    return block_x, block_y, ball_x, ball_y

win = "win"
lose = "lose"

client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
client.connect((HOST, PORT))
client.sendall(start_msg.encode())

while True:
    server_msg = str(client.recv(1024), encoding="utf-8")
    if server_msg[:3] == win or server_msg[:4] == lose:
        print(server_msg)
        break
    if server_msg[:4] == "give":
        continue    
    block_x, block_y, ball_x, ball_y = decmps(server_msg)

    # for double mode
    if min(ball_x) < MAX_X-max(ball_x):
        idx = ball_x.index(min(ball_x))
        moveY(ball_y[idx] - block_y)
    else:
        idx = ball_x.index(max(ball_x))
        moveY(ball_y[idx] - block_y)
    
    if min(ball_y) < MAX_Y-max(ball_y):
        idx = ball_y.index(min(ball_y))
        moveX(ball_x[idx] - block_x)
    else:
        idx = ball_y.index(max(ball_y))
        moveX(ball_x[idx] - block_x)

client.close()
```

An alternative approach is by looking at the server's binaries.

```shell
netstat -tulpn
htop
sudo cp /root/server ~
strings server | grep HW1
```

Using `netstat -tulpn` & `htop`, we can find out that the server is at `/root/server`. Then `sudo cp /root/server ~` and `strings server | grep HW1`. The flag for double mode and the fake flag is here.

![strings-and-grep](/home/frank/Github_Repos/NASA-2021/HW1/pics/strings-and-grep.png)

-----


### 這麼多的網路協定要是能全部都認識的話該有多好

#### 1.

> Reference:
>
> http://linux.vbird.org/linux_server/0110network_basic.php#tcpip_network_icmp

![icmp-echo-request](/home/frank/Github_Repos/NASA-2021/HW1/pics/icmp-echo-request.png)

![icmp-echo-reply](/home/frank/Github_Repos/NASA-2021/HW1/pics/icmp-echo-reply.png)

ICMP is a protocol working in network layer. The main task of ICMP is sending error messages and information about connection status. Both `ping` and `traceroute` rely on ICMP to work.

#### 2.

> Reference:
>
> https://en.wikipedia.org/wiki/Domain_Name_System

![dns-query](/home/frank/Github_Repos/NASA-2021/HW1/pics/dns-query.png)

![dns-response](/home/frank/Github_Repos/NASA-2021/HW1/pics/dns-response.png)

DNS works on application layer. DNS is used to translate human-readible hostnames (e.g. `www.ntu.edu.tw`) to IP addresses (e.g. `140.112.8.116`) that network devices use. It's an essential part of the Internet we use today.

#### 3.

> Reference:
>
> https://zh.wikipedia.org/wiki/%E5%9C%B0%E5%9D%80%E8%A7%A3%E6%9E%90%E5%8D%8F%E8%AE%AE

![arp-request](/home/frank/Github_Repos/NASA-2021/HW1/pics/arp-request.png)

![arp-reply](/home/frank/Github_Repos/NASA-2021/HW1/pics/arp-reply.png)

ARP is a protolcol working on link layer. In TCP/IP protocols, network layer and transport layer uses IP addresses, but Ethernet requires MAC addresses to transfer data. ARP handles the transition between IP addresses and MAC addresses to make everything work.

#### 4.

> Reference:
>
> http://linux.vbird.org/linux_server/0340dhcp.php

![dhcp-discover](/home/frank/Github_Repos/NASA-2021/HW1/pics/dhcp-discover.png)

![dhcp-offer](/home/frank/Github_Repos/NASA-2021/HW1/pics/dhcp-offer.png)

![dhcp-request](/home/frank/Github_Repos/NASA-2021/HW1/pics/dhcp-request.png)

![dhcp-ack](/home/frank/Github_Repos/NASA-2021/HW1/pics/dhcp-ack.png)

DHCP works on application layer. A DHCP server automatically offers parameters for network configurations (such as IP address) to devices within the same LAN. It makes adding new devices in to the current network much easier.

-----



## System Administration

> Reference:
>
> http://linux.vbird.org/linux_basic/0340bashshell-scripts.php
>
> https://blog.techbridge.cc/2019/11/15/linux-shell-script-tutorial/
>
> https://gary840227.medium.com/linux-bash-array-%E4%BB%8B%E7%B4%B9-6e30ffe87978
>
> https://stackoverflow.com/questions/806906/how-do-i-test-if-a-variable-is-a-number-in-bash
>
> 

