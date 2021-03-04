# NASA HW1

b09902004 郭懷元

## Network Administration

### 野生的密碼難道會在網路上赤裸地奔馳著?

#### 1.

Type `http` in display filter to make it easier to find the packet.

![http-packet](/home/frank/Github_Repos/NASA-2021/HW1/pics/http-packet.png)

#### 2.

The packet can't be found. Because we are accessing `登入界面．改` with https, the content of packets sent between the server and pc is encrypted. Therefore it is impossible to identify which packet contains my account and password if we only look at the content of each packet.

### 好玩遊戲也有暗潮洶湧的一面

#### 1.

In Wireshark, go to `statistics`->`conversations`, and we can see something like the image below after playing 2 games while Wireshark is running. Select the first row and click `Follow Stream..`.

 ![NA-p2-1](/home/frank/Github_Repos/NASA-2021/HW1/pics/NA-p2-1.png)

After reading the conversation between client and server, we know the game works this way:

0. The client and  the server establish a TCP connection. All conversation are made on this TCP connection.

1. The client sends `start <game mode>` to the server at `127.0.0.1:9393`. The default game mode is `default`, other available game modes are `fast` and `double`.
2. The server will send horizontal blocks' position, vertical blocks' position, ball's cordinate, and time until game end. The time between each such packet depends on the speed of the ball and its angle.
3. While the server updates information to let client render, the client will send our moves to host, so that the server know to update blocks' position.
4. If the countdown goes to 0, the server will send `win`. If the ball hits the wall, the server will send `lose`. When client receives game result, the result will be printed and game will stop running (but sending moves is still possible).
5. The TCP connection is terminated only when the process is killed.

#### 2.

In the `conversation` window, choose the conversation to `127.0.0.1:9394`

 ![NA-p2-2](/home/frank/Github_Repos/NASA-2021/HW1/pics/NA-p2-2.png)

The game will send content of `~/.bash_history` to the server at `127.0.0.1:9394`. `.bash_history` contents every line you entered in bash before, and it might contains some sensitive information such as passwords and api keys.

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

Since the client only handles transfering user inputs to the server, we can still play the game without `client-linux`. I decide to use python and its `socket` module to communicate with the server and play games, because I am familiar with python and Ubuntu has python built in.

We can know what to send to the server by simply looking at past conversation when playing game with `client-linux`. 

### 這麼多的網路協定要是能全部都認識的話該有多好

#### 1.

![icmp-echo-request](/home/frank/Github_Repos/NASA-2021/HW1/pics/icmp-echo-request.png)

![icmp-echo-reply](/home/frank/Github_Repos/NASA-2021/HW1/pics/icmp-echo-reply.png)

