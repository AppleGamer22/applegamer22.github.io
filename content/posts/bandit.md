---
title: OverTheWire Bandit
date: 2022-07-27
description: My attempt at OverTheWire's Bandit challenges
tags: [overthewire, linux]
---
# Level 0 - 1
> The host to which you need to connect is `bandit.labs.overthewire.org`, on port `2220`. The username is `bandit0` and the password is `bandit0`.
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
* Raj, P. (2017, February 12). How to open a "-" dashed filename using terminal? Stack Overflow. <https://stackoverflow.com/a/42187582/7148921>

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
* Reinhart, J. (2014, November 26). Sort and count number of occurrence of lines. Unix & Linux Stack Exchange. <https://unix.stackexchange.com/a/170044/232245>

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
* Allan. (2017, December 21). Regex character repeats n or more times in line with grep. Stack Overflow. <https://stackoverflow.com/a/47921068/7148921>

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