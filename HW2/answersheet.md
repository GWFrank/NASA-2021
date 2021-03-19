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
> 



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

![iperf-p1](/home/frank/Github_Repos/NASA-2021/HW2/iperf-p1.png)

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

![iperf-p2-1](/home/frank/Github_Repos/NASA-2021/HW2/iperf-p2-1.png)

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

![iperf-p2-2](/home/frank/Github_Repos/NASA-2021/HW2/iperf-p2-2.png)

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

![iperf-p3](/home/frank/Github_Repos/NASA-2021/HW2/iperf-p3.png)

#### 2.

| From                              | To                                | Bandwidth Measured |
| --------------------------------- | --------------------------------- | ------------------ |
| R204 PC                           | CSIE Workstation                  | 626 Mbps           |
| Laptop (connected to `csie-5G`)   | R204 PC                           | 220 Mbps           |
| R204 PC                           | Laptop (connected to `csie-5G`)   | 140 Mbps           |
| Laptop A (connected to `csie-5G`) | Laptop B (connected to `csie-5G`) | 66.6 Mbps          |



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

![ipv6](/home/frank/Github_Repos/NASA-2021/HW2/ipv6.png)



---

## System Administration



