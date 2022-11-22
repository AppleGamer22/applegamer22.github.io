# TryHackMe [Crack The Hash](https://www.tryhackme.com/room/crackthehash)
### References
* https://embeddedworld.home.blog/2019/05/11/hacking-walk-through-cracking-the-hashes/
## Level 1
### Hash: `48bb6e862e54f2a795ffc4e541caed4d`
```bash
$ hashcat -D 2 -m 0 '48bb6e862e54f2a795ffc4e541caed4d' rockyou.txt
48bb6e862e54f2a795ffc4e541caed4d:easy

Session..........: hashcat
Status...........: Cracked
Hash.Name........: MD5
Hash.Target......: 48bb6e862e54f2a795ffc4e541caed4d
Time.Started.....: Sun May  9 12:47:03 2021 (0 secs)
Time.Estimated...: Sun May  9 12:47:03 2021 (0 secs)
Guess.Base.......: File (rockyou.txt)
Guess.Queue......: 1/1 (100.00%)
Speed.#2.........:  1112.7 kH/s (10.32ms) @ Accel:64 Loops:1 Thr:8 Vec:1
Recovered........: 1/1 (100.00%) Digests
Progress.........: 196608/14344384 (1.37%)
Rejected.........: 0/196608 (0.00%)
Restore.Point....: 172032/14344384 (1.20%)
Restore.Sub.#2...: Salt:0 Amplifier:0-1 Iteration:0-1
Candidates.#2....: florian1 -> piggy!
```
### Hash: `CBFDAC6008F9CAB4083784CBD1874F76618D2A97`
```bash
$ hashcat -D 2 -m 100 'CBFDAC6008F9CAB4083784CBD1874F76618D2A97' rockyou.txt
cbfdac6008f9cab4083784cbd1874f76618d2a97:password123

Session..........: hashcat
Status...........: Cracked
Hash.Name........: SHA1
Hash.Target......: cbfdac6008f9cab4083784cbd1874f76618d2a97
Time.Started.....: Sun May  9 12:49:37 2021 (0 secs)
Time.Estimated...: Sun May  9 12:49:37 2021 (0 secs)
Guess.Base.......: File (rockyou.txt)
Guess.Queue......: 1/1 (100.00%)
Speed.#2.........:   786.8 kH/s (9.13ms) @ Accel:32 Loops:1 Thr:8 Vec:1
Recovered........: 1/1 (100.00%) Digests
Progress.........: 12288/14344384 (0.09%)
Rejected.........: 0/12288 (0.00%)
Restore.Point....: 0/14344384 (0.00%)
Restore.Sub.#2...: Salt:0 Amplifier:0-1 Iteration:0-1
Candidates.#2....: 123456 -> havana
```
### Hash: `1C8BFE8F801D79745C4631D09FFF36C82AA37FC4CCE4FC946683D7B336B63032`
```bash
$ hashcat -D 2 -m 1400 '1C8BFE8F801D79745C4631D09FFF36C82AA37FC4CCE4FC946683D7B336B63032"'rockyou.txt
1c8bfe8f801d79745c4631d09fff36c82aa37fc4cce4fc946683d7b336b63032:letmein

Session..........: hashcat
Status...........: Cracked
Hash.Name........: SHA2-256
Hash.Target......: 1c8bfe8f801d79745c4631d09fff36c82aa37fc4cce4fc94668...b63032
Time.Started.....: Sun May  9 12:51:34 2021 (0 secs)
Time.Estimated...: Sun May  9 12:51:34 2021 (0 secs)
Guess.Base.......: File (rockyou.txt)
Guess.Queue......: 1/1 (100.00%)
Speed.#2.........:  1016.7 kH/s (7.59ms) @ Accel:32 Loops:1 Thr:8 Vec:1
Recovered........: 1/1 (100.00%) Digests
Progress.........: 12288/14344384 (0.09%)
Rejected.........: 0/12288 (0.00%)
Restore.Point....: 0/14344384 (0.00%)
Restore.Sub.#2...: Salt:0 Amplifier:0-1 Iteration:0-1
Candidates.#2....: 123456 -> havana
```
### Hash: `$2y$12$Dwt1BZj6pcyc3Dy1FWZ5ieeUznr71EeNkJkUlypTsgbX1H68wsRom`
### Hash: `279412f945939ba78ce0758d3fd83daa`
## Level 2
### Hash: `F09EDCB1FCEFC6DFB23DC3505A882655FF77375ED8AA2D1C13F640FCCC2D0C85`
```bash
$ hashcat -D 2 -m 1400 'F09EDCB1FCEFC6DFB23DC3505A882655FF77375ED8AA2D1C13F640FCCC2D0C85' rockyou.txt
f09edcb1fcefc6dfb23dc3505a882655ff77375ed8aa2d1c13f640fccc2d0c85:paule

Session..........: hashcat
Status...........: Cracked
Hash.Name........: SHA2-256
Hash.Target......: f09edcb1fcefc6dfb23dc3505a882655ff77375ed8aa2d1c13f...2d0c85
Time.Started.....: Sun May  9 16:07:38 2021 (0 secs)
Time.Estimated...: Sun May  9 16:07:38 2021 (0 secs)
Guess.Base.......: File (rockyou.txt)
Guess.Queue......: 1/1 (100.00%)
Speed.#2.........:   726.1 kH/s (6.87ms) @ Accel:32 Loops:1 Thr:8 Vec:1
Recovered........: 1/1 (100.00%) Digests
Progress.........: 86016/14344384 (0.60%)
Rejected.........: 0/86016 (0.00%)
Restore.Point....: 73728/14344384 (0.51%)
Restore.Sub.#2...: Salt:0 Amplifier:0-1 Iteration:0-1
Candidates.#2....: college07 -> burats
```
### Hash: `1DFECA0C002AE40B8619ECF94819CC1B`
```bash
$ hashcat -D 2 -m 1000 '1DFECA0C002AE40B8619ECF94819CC1B' rockyou.txt
1dfeca0c002ae40b8619ecf94819cc1b:n63umy8lkf4i

Session..........: hashcat
Status...........: Cracked
Hash.Name........: NTLM
Hash.Target......: 1dfeca0c002ae40b8619ecf94819cc1b
Time.Started.....: Sun May  9 16:12:34 2021 (3 secs)
Time.Estimated...: Sun May  9 16:12:37 2021 (0 secs)
Guess.Base.......: File (rockyou.txt)
Guess.Queue......: 1/1 (100.00%)
Speed.#2.........:  2134.8 kH/s (6.86ms) @ Accel:128 Loops:1 Thr:8 Vec:1
Recovered........: 1/1 (100.00%) Digests
Progress.........: 5259264/14344384 (36.66%)
Rejected.........: 0/5259264 (0.00%)
Restore.Point....: 5210112/14344384 (36.32%)
Restore.Sub.#2...: Salt:0 Amplifier:0-1 Iteration:0-1
Candidates.#2....: nanayjuan5 -> myrica1
```
### Hash: `$6$aReallyHardSalt$6WKUTqzq.UQQmrm0p/T7MPpMbGNnzXPMAXi4bJMl9be.cfi3/qxIf.hsGpS41BqMhSrHVXgMpdjS6xeKZAs02.` & Salt: `aReallyHardSalt`, Rounds: 5
```bash
$ hashcat -D 2 -m 1800 '$6$aReallyHardSalt$6WKUTqzq.UQQmrm0p/T7MPpMbGNnzXPMAXi4bJMl9be.cfi3/qxIf.hsGpS41BqMhSrHVXgMpdjS6xeKZAs02.' rockyou.txt
$6$aReallyHardSalt$6WKUTqzq.UQQmrm0p/T7MPpMbGNnzXPMAXi4bJMl9be.cfi3/qxIf.hsGpS41BqMhSrHVXgMpdjS6xeKZAs02.:waka99

Session..........: hashcat
Status...........: Cracked
Hash.Name........: sha512crypt $6$, SHA512 (Unix)
Hash.Target......: $6$aReallyHardSalt$6WKUTqzq.UQQmrm0p/T7MPpMbGNnzXPM...ZAs02.
Time.Started.....: Sun May  9 13:14:12 2021 (36 mins, 27 secs)
Time.Estimated...: Sun May  9 13:50:39 2021 (0 secs)
Guess.Base.......: File (rockyou.txt)
Guess.Queue......: 1/1 (100.00%)
Speed.#2.........:     1298 H/s (5.95ms) @ Accel:32 Loops:4 Thr:8 Vec:1
Recovered........: 1/1 (100.00%) Digests
Progress.........: 2838528/14344384 (19.79%)
Rejected.........: 0/2838528 (0.00%)
Restore.Point....: 2826240/14344384 (19.70%)
Restore.Sub.#2...: Salt:0 Amplifier:0-1 Iteration:4996-5000
Candidates.#2....: walo69 -> wa7se4wss1
```
### Hash: `e5d8870e5bdd26602cab8dbe07a942c8669e56d6` & Salt: `tryhackme`
```bash
$ hashcat -D 2 -m 160 'e5d8870e5bdd26602cab8dbe07a942c8669e56d6:tryhackme' rockyou.txt
e5d8870e5bdd26602cab8dbe07a942c8669e56d6:tryhackme:481616481616

Session..........: hashcat
Status...........: Cracked
Hash.Name........: HMAC-SHA1 (key = $salt)
Hash.Target......: e5d8870e5bdd26602cab8dbe07a942c8669e56d6:tryhackme
Time.Started.....: Sun May  9 16:20:39 2021 (1 min, 12 secs)
Time.Estimated...: Sun May  9 16:21:51 2021 (0 secs)
Guess.Base.......: File (rockyou.txt)
Guess.Queue......: 1/1 (100.00%)
Speed.#2.........:   171.4 kH/s (8.33ms) @ Accel:8 Loops:1 Thr:8 Vec:1
Recovered........: 1/1 (100.00%) Digests
Progress.........: 12315648/14344384 (85.86%)
Rejected.........: 0/12315648 (0.00%)
Restore.Point....: 12312576/14344384 (85.84%)
Restore.Sub.#2...: Salt:0 Amplifier:0-1 Iteration:0-1
Candidates.#2....: 48162440 -> 4806710044
```