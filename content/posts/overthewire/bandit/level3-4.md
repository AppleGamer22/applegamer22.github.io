---
title: OverTheWire Bandit Level 3 - 4
date: 2022-07-28T03:00:00
tags: [overthewire, linux, shell]
---
# Prompt
> The password for the next level is stored in a hidden file in the `inhere` directory.

# Solution
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