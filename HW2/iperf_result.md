# iperf result

## 1.

### From R204 PC to CSIE Workstation

On R204 PC

```shell
nslookup linux12.csie.ntu.edu.tw # to get the IP address of workstation
iperf -c 140.112.30.43
```

On CSIE Workstation

```shell
iperf -s -i 5
```



## 2.

### From laptop (connected to `csie-5G`) to R204 PC

On R204 PC

```shell
ifconfig # to get the IP address of this system
iperf -s
```

On my laptop

```shell
iperf -c 192.168.204.36 -t 60 -i 5
```

### From R204 PC to Laptop

On my laptop

```shell
ifconfig # to get the IP address of this system
iperf -s -i 5
```

On R204 PC

```shell
iperf -c 10.5.0.147 -t 60
```

## 3.

### From laptop A to laptop B (both connected to `csie-5G`)

On laptop A

```shell
ifconfig
iperf -s
```

On laptop B

```shell
iperf -c 10.5.6.200 -t 60 -i 5
```

 