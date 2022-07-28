---
title: OverTheWire Bandit
date: 2022-07-27
description: My attempt at OverTheWire's Bandit challenges
tags: [overthewire, linux]
---
# Level 0 - 1
> The host to which you need to connect is `bandit.labs.overthewire.org`, on port 2220. The username is `bandit0` and the password is `bandit0`.
>
> The password for the next level is stored in a file called `readme` located in the home directory. Use this password to log into bandit1 using SSH.

```sh
$ ssh bandit0@bandit.labs.overthewire.org -p 2220
bandit0@bandit.labs.overthewire.org password: bandit0
bandit0@bandit:~$ ls
readme
bandit0@bandit:~$ cat readme
boJ9jbbUNNfktd78OOpsqOltutMc3MY1
```

# Level 1 - 2
> The password for the next level is stored in a file called `-` located in the home directory

```sh
$ ssh bandit1@bandit.labs.overthewire.org -p 2220
bandit1@bandit.labs.overthewire.org password: boJ9jbbUNNfktd78OOpsqOltutMc3MY1
bandit1@bandit:~$ ls
-
bandit1@bandit:~$ cat ./-
CV1DtqXWVFXTvM2F0k09SHz0YwRINYA9
```

## References
* Raj, P. (2017, February 12). How to open a `-` dashed file name using terminal? Stack Overflow. <https://stackoverflow.com/a/42187582/7148921>

# Level 2 - 3
> The password for the next level is stored in a file called `spaces in this filename` located in the home directory

```sh
$ ssh bandit2@bandit.labs.overthewire.org -p 2220
bandit2@bandit.labs.overthewire.org password: CV1DtqXWVFXTvM2F0k09SHz0YwRINYA9
bandit2@bandit:~$ ls
spaces in this filename
bandit2@bandit:~$ cat spaces\ in\ this\ filename 
UmHadQclWmgdLOKQ3YNgjWxGoRMb5luK
```

# Level 3 - 4
> The password for the next level is stored in a hidden file in the `inhere` directory.

```sh
$ ssh bandit3@bandit.labs.overthewire.org -p 2220
bandit3@bandit.labs.overthewire.org password: UmHadQclWmgdLOKQ3YNgjWxGoRMb5luK
bandit3@bandit:~$ ls -l
inhere
bandit3@bandit:~$ ls -a inhere
.hidden
bandit3@bandit:~$ cat inhere/.hidden
pIwrPrtPN36QITSp3EQaw936yaFoFgAB
```

# Level 4 - 5
> The password for the next level is stored in the only human-readable file in the `inhere` directory.

```sh
$ ssh bandit4@bandit.labs.overthewire.org -p 2220
bandit4@bandit.labs.overthewire.org password: pIwrPrtPN36QITSp3EQaw936yaFoFgAB
bandit4@bandit:~$ ls -l
inhere
bandit4@bandit:~$ ls inhere
-file00 -file01 -file02 -file03 -file04 -file05 -file06 -file07 -file08 -file09
bandit4@bandit:~$ find inhere -type f -exec file {} \; | grep ":.* ASCII text"
inhere/-file07: ASCII text
bandit4@bandit:~$ cat inhere/-file07
koReBOKuIDDepwhWk7jZC0RTdopnAYKh
```

## References
* `baeldung`. (2021, August 20). How To Find Only Text Files in a Directory in Linux. Baeldung on Linux. <https://www.baeldung.com/linux/seach-text-files-in-directory>

‌

# Level 5 - 6
> The password for the next level is stored in a file somewhere under the `inhere` directory and has all of the following properties:
> * human-readable
> * 1033 bytes in size
> * not executable

```sh
$ ssh bandit5@bandit.labs.overthewire.org -p 2220
bandit5@bandit.labs.overthewire.org password: koReBOKuIDDepwhWk7jZC0RTdopnAYKh
bandit5@bandit:~$ ls
inhere
bandit5@bandit:~$ ls inhere/
maybehere00 maybehere02 maybehere04 maybehere06 maybehere08 maybehere10 maybehere12 maybehere14 maybehere16 maybehere18
maybehere01 maybehere03 maybehere05 maybehere07 maybehere09 maybehere11 maybehere13 maybehere15 maybehere17 maybehere19
bandit5@bandit:~$ find inhere -type f -size 1033c -exec file {} \; | grep ":.* ASCII text"
inhere/maybehere07/.file2: ASCII text, with very long lines
bandit5@bandit:~$ cat inhere/maybehere07/.file2
DXjZPULLxYr17uwoI01bNLQbtFemEgo7
```

# Level 6 - 7
> The password for the next level is stored **somewhere on the server** and has all of the following properties:
>
> * owned by user `bandit7`
> * owned by group `bandit6`
> * 33 bytes in size

```sh
$ ssh bandit6@bandit.labs.overthewire.org -p 2220
bandit6@bandit.labs.overthewire.org password: DXjZPULLxYr17uwoI01bNLQbtFemEgo7
bandit6@bandit:~$ find / -user bandit7 -group bandit6 -size 33c 2> /dev/null
/var/lib/dpkg/info/bandit7.password
bandit6@bandit:~$ cat /var/lib/dpkg/info/bandit7.password
HKBPTKQnIay4Fw76bEy8PVxKEDQRKTzs
```

# Level 7 - 8
> The password for the next level is stored in the file `data.txt` next to the word `millionth`

```sh
$ ssh bandit7@bandit.labs.overthewire.org -p 2220
bandit7@bandit.labs.overthewire.org password: HKBPTKQnIay4Fw76bEy8PVxKEDQRKTzs
bandit7@bandit:~$ ls
data.txt
bandit7@bandit:~$ grep millionth data.txt 
millionth cvX2JJa4CFALtqS87jk27qwqGhBM9plV
```

# Level 8 - 9
> The password for the next level is stored in the file `data.txt` and is the only line of text that occurs only once

```sh
$ ssh bandit8@bandit.labs.overthewire.org -p 2220
bandit8@bandit.labs.overthewire.org password: cvX2JJa4CFALtqS87jk27qwqGhBM9plV
bandit8@bandit:~$ ls
data.txt
bandit8@bandit:~$ sort data.txt | uniq -c | sort | tail -1
1 UsvVyFSfZZWbi6wgC7dAFyFuR6jQQUhR
```

## References
* Reinhart, J. (2014, November 26). `sort` and count number of occurrence of lines. Unix & Linux Stack Exchange. <https://unix.stackexchange.com/a/170044/232245>

# Level 9 - 10
> The password for the next level is stored in the file `data.txt` in one of the few human-readable strings, preceded by several `=` characters.

```sh
$ ssh bandit9@bandit.labs.overthewire.org -p 2220
bandit9@bandit.labs.overthewire.org password: UsvVyFSfZZWbi6wgC7dAFyFuR6jQQUhR
bandit9@bandit:~$ ls
data.txt
bandit9@bandit:~$ strings data.txt | grep -E "={2,}"
========== the*2i4
========== password
Z========== is
&========== truKLdjsbJ5g7yyJ2X2R0o3a5HQJFuLk
```

## References
* Allan. (2017, December 21). Regex character repeats $n$ or more times in line with `grep`. Stack Overflow. <https://stackoverflow.com/a/47921068/7148921>

# Level 10 - 11
> The password for the next level is stored in the file `data.txt`, which contains Base64-encoded data

```sh
$ ssh bandit10@bandit.labs.overthewire.org -p 2220
bandit10@bandit.labs.overthewire.org password: truKLdjsbJ5g7yyJ2X2R0o3a5HQJFuLk
bandit10@bandit:~$ ls
data.txt
bandit10@bandit:~$ cat data.txt | base64 -d
The password is IFukwKGsFW8MOq3IRFqrxE1hxTNEbUPR
```

# Level 11 -12
> The password for the next level is stored in the file data.txt, where all lowercase and uppercase letters have been rotated by 13 positions

```sh
$ ssh bandit11@bandit.labs.overthewire.org -p 2220
bandit11@bandit.labs.overthewire.org password: IFukwKGsFW8MOq3IRFqrxE1hxTNEbUPR
bandit11@bandit:~$ cat data.txt | tr 'A-Za-z' 'N-ZA-Mn-za-m'
The password is 5Te8Y4drgCRfCx8ugdwuEX8KFC6k2EUu
```

## References
* Mullen, S., & Ross, C. (2011, March 26). using ROT13 and `tr` command for having an encrypted email address. Stack Overflow. <https://stackoverflow.com/a/5442495/7148921>

# Level 12 - 13
> The password for the next level is stored in the file `data.txt`, which is a hexadecimal dump of a file that has been repeatedly compressed. For this level it may be useful to create a directory under `/tmp` in which you can work using `mkdir`.

```sh
$ ssh bandit12@bandit.labs.overthewire.org -p 2220
bandit12@bandit.labs.overthewire.org password: 5Te8Y4drgCRfCx8ugdwuEX8KFC6k2EUu
bandit12@bandit:~$ ls
data.txt
bandit12@bandit:~$ mkdir /tmp/bandit12
bandit12@bandit:~$ cp data.txt /tmp/bandit12
bandit12@bandit:~$ cd /tmp/bandit12
bandit12@bandit:/tmp/bandit12$ xxd -r data.txt data
bandit12@bandit:/tmp/bandit12$ file data
data: gzip compressed data, was "data2.bin", last modified: Thu May 7 18:14:30 2020, max compression, from Unix
bandit12@bandit:/tmp/bandit12$ mv data data.gz
bandit12@bandit:/tmp/bandit12$ gunzip data.gz
bandit12@bandit:/tmp/bandit12$ ls
data  data.txt
bandit12@bandit:/tmp/bandit12$ file data
data: bzip2 compressed data, block size = 900k
bandit12@bandit:/tmp/bandit12$ mv data data.bz2
bandit12@bandit:/tmp/bandit12$ bzip2 -d data.bz2
bandit12@bandit:/tmp/bandit12$ ls
data  data.txt
bandit12@bandit:/tmp/bandit12$ file data
data: gzip compressed data, was "data4.bin", last modified: Thu May 7 18:14:30 2020, max compression, from Unix
bandit12@bandit:/tmp/bandit12$ mv data data.gz
bandit12@bandit:/tmp/bandit12$ gunzip data.gz
bandit12@bandit:/tmp/bandit12$ ls
data  data.txt
bandit12@bandit:/tmp/bandit12$ file data
data: POSIX tar archive (GNU)
bandit12@bandit:/tmp/bandit12$ tar -xvf data
data5.bin
bandit12@bandit:/tmp/bandit12$ file data5.bin
data5.bin: POSIX tar archive (GNU)
bandit12@bandit:/tmp/bandit12$ tar -xvf data5.bin
data6.bin
bandit12@bandit:/tmp/bandit12$ file data6.bin
data6.bin: bzip2 compressed data, block size = 900k
bandit12@bandit:/tmp/bandit12$ mv data6.bin data6.bz2
bandit12@bandit:/tmp/bandit12$ bzip2 -d data6.bz2
bandit12@bandit:/tmp/bandit12$ ls
data  data5.bin  data6  data.txt
bandit12@bandit:/tmp/bandit12$ file data6
data6: POSIX tar archive (GNU)
bandit12@bandit:/tmp/bandit12$ tar -xvf data6
data8.bin
bandit12@bandit:/tmp/bandit12$ file data8.bin
data8.bin: gzip compressed data, was "data9.bin", last modified: Thu May  7 18:14:30 2020, max compression, from Unix
bandit12@bandit:/tmp/bandit12$ mv data8.bin data8.gz
bandit12@bandit:/tmp/bandit12$ gunzip data8.gz
bandit12@bandit:/tmp/bandit12$ ls
data data5.bin data6 data8 data.txt
bandit12@bandit:/tmp/bandit12$ file data8
data8: ASCII text
bandit12@bandit:/tmp/bandit12$ cat data8
The password is 8ZjyCRiBWFYkneahHwxCv3wb2a1ORpYL
```

## References
* Rosenfield, A. (2011, October 19). Transform hexadecimal information to binary using a Linux command. Stack Overflow. <https://stackoverflow.com/a/7826789/7148921>
* Tucakov, D. (2019, November 14). How To Extract / Unzip `.tar.gz` Files From Linux Command Line. Knowledge Base by PhoenixNAP. <https://phoenixnap.com/kb/extract-tar-gz-files-linux-command-line>

# Level 13 - 14
> The password for the next level is stored in `/etc/bandit_pass/bandit14` and can only be read by user `bandit14`. For this level, you don’t get the next password, but you get a private SSH key that can be used to log into the next level.


```sh
$ ssh bandit13@bandit.labs.overthewire.org -p 2220
bandit13@bandit.labs.overthewire.org password: 8ZjyCRiBWFYkneahHwxCv3wb2a1ORpYL
bandit13@bandit:~$ ls
sshkey.private
bandit13@bandit:~$ exit
$ $ scp -P 2220 bandit13@bandit.labs.overthewire.org:/home/bandit13/sshkey.private bandit14
bandit13@bandit.labs.overthewire.org password: 8ZjyCRiBWFYkneahHwxCv3wb2a1ORpYL
sshkey.private
$ ssh bandit14@bandit.labs.overthewire.org -p 2220 -i bandit14
bandit14@bandit:~$ cat /etc/bandit_pass/bandit14
4wcYUJFw0k0XLShlDzztnTBHiqxU3b3e
```

## References
* Goldshteyn, M. (2012, April 26). scp with port number specified. Stack Overflow. <https://stackoverflow.com/a/10341062/7148921>

# Level 14 - 15
> The password for the next level can be retrieved by submitting the password of the current level to **port 30000 on `localhost`**.

```sh
$ ssh bandit14@bandit.labs.overthewire.org -p 2220
bandit14@bandit.labs.overthewire.org password: 4wcYUJFw0k0XLShlDzztnTBHiqxU3b3e
bandit14@bandit:~$ curl localhost:30000
Wrong! Please enter the correct current password
bandit14@bandit:~$ echo "4wcYUJFw0k0XLShlDzztnTBHiqxU3b3e" | nc localhost 30000
Correct!
BfMYroe26WYalil77FoDi9qh59eK5xNr
```

# Level 15 - 16
> The password for the next level can be retrieved by submitting the password of the current level to **port 30001 on `localhost`** using SSL encryption.

```sh
$ ssh bandit15@bandit.labs.overthewire.org -p 2220
bandit15@bandit.labs.overthewire.org password: BfMYroe26WYalil77FoDi9qh59eK5xNr
bandit15@bandit:~$ echo "BfMYroe26WYalil77FoDi9qh59eK5xNr" | openssl s_client -connect localhost:30001 -ign_eof
Correct!
cluFn7wTiGryunymYOu4RcffSxQluehd
```

## References
* jww, & Farber, A. (2014, April 28). How to send a string to server using `s_client`. Stack Overflow. <https://stackoverflow.com/a/23352363/7148921>

# Level 16 - 17
> The credentials for the next level can be retrieved by submitting the password of the current level to **a port on `localhost` in the range 31000 to 32000**. First find out which of these ports have a server listening on them. Then find out which of those speak SSL and which don’t. There is only 1 server that will give the next credentials, the others will simply send back to you whatever you send to it.

```sh
$ ssh bandit16@bandit.labs.overthewire.org -p 2220
bandit16@bandit.labs.overthewire.org password: cluFn7wTiGryunymYOu4RcffSxQluehd
```
