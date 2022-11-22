# TryHackMe [Active Reconnaissance](https://tryhackme.com/room/activerecon)
## Web Browser
### Browse to the [following website](https://static-labs.tryhackme.cloud/sites/networking-tcp/) and ensure that you have opened your Developer Tools on AttackBox Firefox, or the browser on your computer. Using the Developer Tools, figure out the total number of questions.
1. Open [the website](https://static-labs.tryhackme.cloud/sites/networking-tcp/), and open the source for the main JavaScript file.
2. Find the `questions` global variable:
```javascript
let questions = {
	1: {
		speaking: "alice",
		answer_1: "SYN : Can you hear me Bob?",
		answer_2: "FIN : Goodbye",
		answer_3: "ACK : Erm... What?",
		answer: 1,
	},
	2: {
		speaking: "bob",
		answer_1: "RST : Cya Later",
		answer_2: "PING : 77",
		answer_3: "SYN/ACK : Yes, I can hear you!",
		answer: 3,
	},
	3: {
		speaking: "alice",
		answer_1: "FAIL : SEGMENTATION FAULT",
		answer_2: "ACK : Okay Great",
		answer_3: "SYN : x = 3?",
		answer: 2,
	},
	4: {
		speaking: "alice",
		answer_1: "ICMP : 99",
		answer_2: "SYN : Yes, I can hear you!",
		answer_3: "DATA : Cheesecake is on sale!",
		answer: 3,
	},
	5: {
		speaking: "bob",
		answer_1: "ACK : I Hear ya!",
		answer_2: "REPEAT : What?",
		answer_3: "RESET : Help!",
		answer: 1,
	},
	6: {
		speaking: "alice",
		answer_1: "ACK : OK",
		answer_2: "FIN/ACK : I'm all done",
		answer_3: "ECHO : Retry",
		answer: 2,
	},
	7: {
		speaking: "bob",
		answer_1: "SYN : Received",
		answer_2: "WIRE : Reset Connection",
		answer_3: "FIN/ACK : Yeah Me Too",
		answer: 3,
	},
	8: {
		speaking: "alice",
		answer_1: "SYN : Connected",
		answer_2: "ACK : Okay, Goodbye",
		answer_3: "SYN/ACK : Not Received",
		answer: 2,
	},
};
```

**Answer**: `8`
## `ping`
### Which option would you use to set the size of the data carried by the ICMP echo request?
**Answer**: `-s`
### What is the size of the ICMP header in bytes?
**Answer**: `8`
### Does MS Windows Firewall block ping by default (Y/N)?
**Answer**: `Y`
### Issue the command `ping -c 10 <MACHINE_IP>`. How many ping replies did you get back?
```bash
$ ping -c 10 <MACHINE_IP>
PING <MACHINE_IP> (<MACHINE_IP>) 56(84) bytes of data.
64 bytes from <MACHINE_IP>: icmp_seq=1 ttl=63 time=282 ms
64 bytes from <MACHINE_IP>: icmp_seq=2 ttl=63 time=281 ms
64 bytes from <MACHINE_IP>: icmp_seq=3 ttl=63 time=280 ms
64 bytes from <MACHINE_IP>: icmp_seq=4 ttl=63 time=281 ms
64 bytes from <MACHINE_IP>: icmp_seq=5 ttl=63 time=282 ms
64 bytes from <MACHINE_IP>: icmp_seq=6 ttl=63 time=281 ms
64 bytes from <MACHINE_IP>: icmp_seq=7 ttl=63 time=279 ms
64 bytes from <MACHINE_IP>: icmp_seq=8 ttl=63 time=280 ms
64 bytes from <MACHINE_IP>: icmp_seq=9 ttl=63 time=281 ms
64 bytes from <MACHINE_IP>: icmp_seq=10 ttl=63 time=280 ms

--- <MACHINE_IP> ping statistics ---
10 packets transmitted, 10 received, 0% packet loss, time 9015ms
rtt min/avg/max/mdev = 279.449/280.813/282.259/0.856 ms
```

**Answer**: `10`
## `traceroute`
### In *Traceroute A*, what is the IP address of the last router/hop before reaching `tryhackme.com`?
#### Traceroute A
```bash
user@AttackBox$ traceroute tryhackme.com
traceroute to tryhackme.com (172.67.69.208), 30 hops max, 60 byte packets
 1  ec2-3-248-240-5.eu-west-1.compute.amazonaws.com (3.248.240.5)  2.663 ms * ec2-3-248-240-13.eu-west-1.compute.amazonaws.com (3.248.240.13)  7.468 ms
 2  100.66.8.86 (100.66.8.86)  43.231 ms 100.65.21.64 (100.65.21.64)  18.886 ms 100.65.22.160 (100.65.22.160)  14.556 ms
 3  * 100.66.16.176 (100.66.16.176)  8.006 ms *
 4  100.66.11.34 (100.66.11.34)  17.401 ms 100.66.10.14 (100.66.10.14)  23.614 ms 100.66.19.236 (100.66.19.236)  17.524 ms
 5  100.66.7.35 (100.66.7.35)  12.808 ms 100.66.6.109 (100.66.6.109)  14.791 ms *
 6  100.65.14.131 (100.65.14.131)  1.026 ms 100.66.5.189 (100.66.5.189)  19.246 ms 100.66.5.243 (100.66.5.243)  19.805 ms
 7  100.65.13.143 (100.65.13.143)  14.254 ms 100.95.18.131 (100.95.18.131)  0.944 ms 100.95.18.129 (100.95.18.129)  0.778 ms
 8  100.95.2.143 (100.95.2.143)  0.680 ms 100.100.4.46 (100.100.4.46)  1.392 ms 100.95.18.143 (100.95.18.143)  0.878 ms
 9  100.100.20.76 (100.100.20.76)  7.819 ms 100.92.11.36 (100.92.11.36)  18.669 ms 100.100.20.26 (100.100.20.26)  0.842 ms
10  100.92.11.112 (100.92.11.112)  17.852 ms * 100.92.11.158 (100.92.11.158)  16.687 ms
11  100.92.211.82 (100.92.211.82)  19.713 ms 100.92.0.126 (100.92.0.126)  18.603 ms 52.93.112.182 (52.93.112.182)  17.738 ms
12  99.83.69.207 (99.83.69.207)  17.603 ms  15.827 ms  17.351 ms
13  100.92.9.83 (100.92.9.83)  17.894 ms 100.92.79.136 (100.92.79.136)  21.250 ms 100.92.9.118 (100.92.9.118)  18.166 ms
14  172.67.69.208 (172.67.69.208)  17.976 ms  16.945 ms 100.92.9.3 (100.92.9.3)  17.709 ms
```

**Answer**: `172.67.69.208`
### In *Traceroute B*, what is the IP address of the last router/hop before reaching `tryhackme.com`?
#### Traceroute B
```bash
user@AttackBox$ traceroute tryhackme.com
traceroute to tryhackme.com (104.26.11.229), 30 hops max, 60 byte packets
 1  ec2-79-125-1-9.eu-west-1.compute.amazonaws.com (79.125.1.9)  1.475 ms * ec2-3-248-240-31.eu-west-1.compute.amazonaws.com (3.248.240.31)  9.456 ms
 2  100.65.20.160 (100.65.20.160)  16.575 ms 100.66.8.226 (100.66.8.226)  23.241 ms 100.65.23.192 (100.65.23.192)  22.267 ms
 3  100.66.16.50 (100.66.16.50)  2.777 ms 100.66.11.34 (100.66.11.34)  22.288 ms 100.66.16.28 (100.66.16.28)  4.421 ms
 4  100.66.6.47 (100.66.6.47)  17.264 ms 100.66.7.161 (100.66.7.161)  39.562 ms 100.66.10.198 (100.66.10.198)  15.958 ms
 5  100.66.5.123 (100.66.5.123)  20.099 ms 100.66.7.239 (100.66.7.239)  19.253 ms 100.66.5.59 (100.66.5.59)  15.397 ms
 6  * 100.66.5.223 (100.66.5.223)  16.172 ms 100.65.15.135 (100.65.15.135)  0.424 ms
 7  100.65.12.135 (100.65.12.135)  0.390 ms 100.65.12.15 (100.65.12.15)  1.045 ms 100.65.14.15 (100.65.14.15)  1.036 ms
 8  100.100.4.16 (100.100.4.16)  0.482 ms 100.100.20.122 (100.100.20.122)  0.795 ms 100.95.2.143 (100.95.2.143)  0.827 ms
 9  100.100.20.86 (100.100.20.86)  0.442 ms 100.100.4.78 (100.100.4.78)  0.347 ms 100.100.20.20 (100.100.20.20)  1.388 ms
10  100.92.212.20 (100.92.212.20)  11.611 ms 100.92.11.54 (100.92.11.54)  12.675 ms 100.92.11.56 (100.92.11.56)  10.835 ms
11  100.92.6.52 (100.92.6.52)  11.427 ms 100.92.6.50 (100.92.6.50)  11.033 ms 100.92.210.50 (100.92.210.50)  10.551 ms
12  100.92.210.139 (100.92.210.139)  10.026 ms 100.92.6.13 (100.92.6.13)  14.586 ms 100.92.210.69 (100.92.210.69)  12.032 ms
13  100.92.79.12 (100.92.79.12)  12.011 ms 100.92.79.68 (100.92.79.68)  11.318 ms 100.92.80.84 (100.92.80.84)  10.496 ms
14  100.92.9.27 (100.92.9.27)  11.354 ms 100.92.80.31 (100.92.80.31)  13.000 ms 52.93.135.125 (52.93.135.125)  11.412 ms
15  150.222.241.85 (150.222.241.85)  9.660 ms 52.93.135.81 (52.93.135.81)  10.941 ms 150.222.241.87 (150.222.241.87)  16.543 ms
16  100.92.228.102 (100.92.228.102)  15.168 ms 100.92.227.41 (100.92.227.41)  10.134 ms 100.92.227.52 (100.92.227.52)  11.756 ms
17  100.92.232.111 (100.92.232.111)  10.589 ms 100.92.231.69 (100.92.231.69)  16.664 ms 100.92.232.37 (100.92.232.37)  13.089 ms
18  100.91.205.140 (100.91.205.140)  11.551 ms 100.91.201.62 (100.91.201.62)  10.246 ms 100.91.201.36 (100.91.201.36)  11.368 ms
19  100.91.205.79 (100.91.205.79)  11.112 ms 100.91.205.83 (100.91.205.83)  11.040 ms 100.91.205.33 (100.91.205.33)  10.114 ms
20  100.91.211.45 (100.91.211.45)  9.486 ms 100.91.211.79 (100.91.211.79)  13.693 ms 100.91.211.47 (100.91.211.47)  13.619 ms
21  100.100.6.81 (100.100.6.81)  11.522 ms 100.100.68.70 (100.100.68.70)  10.181 ms 100.100.6.21 (100.100.6.21)  11.687 ms
22  100.100.65.131 (100.100.65.131)  10.371 ms 100.100.92.6 (100.100.92.6)  10.939 ms 100.100.65.70 (100.100.65.70)  23.703 ms
23  100.100.2.74 (100.100.2.74)  15.317 ms 100.100.66.17 (100.100.66.17)  11.492 ms 100.100.88.67 (100.100.88.67)  35.312 ms
24  100.100.16.16 (100.100.16.16)  19.155 ms 100.100.16.28 (100.100.16.28)  19.147 ms 100.100.2.68 (100.100.2.68)  13.718 ms
25  99.83.89.19 (99.83.89.19)  28.929 ms *  21.790 ms
26  104.26.11.229 (104.26.11.229)  11.070 ms  11.058 ms  11.982 ms
```

**Answer**: `104.26.11.229`
### In *Traceroute B*, how many routers are between the two systems?
**Answer**: `26`
## `telnet`
### Open the terminal and use the telnet client to connect to the VM on port 80. What is the name of the running server?
* Run `telnet 10.10.210.42 80` and enter `GET / HTTP/1.1` and `host: telnet` in their own lines:
```
$ telnet 10.10.210.42 80
Trying 10.10.210.42...
Connected to 10.10.210.42.
Escape character is '^]'.
GET / HTTP/1.1
host: telnet

HTTP/1.1 200 OK
Date: Fri, 05 Nov 2021 09:32:29 GMT
Server: Apache/2.4.10 (Debian)
Last-Modified: Mon, 30 Aug 2021 12:09:24 GMT
ETag: "15-5cac5b436ddfa"
Accept-Ranges: bytes
Content-Length: 21
Content-Type: text/html
```

**Answer**: `Apache`
### What is the version of the running server (on port 80 of the VM)?
**Answer**: `2.4.10`
## `nc`
### Use `nc` to connect to the VM port 21. What is the version of the running server?
```bash
$ nc 10.10.89.185 21
220 debra2.thm.local FTP server (Version 6.4/OpenBSD/Linux-ftpd-0.17) ready.
```

**Answer**: `0.17`