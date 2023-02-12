---
title: OverTheWire Bandit Level 10 - 11
description: OverTheWire Bandit Level 10 - 11 challenge
date: 2022-07-28T10:00:00
tags: [OverTheWire, Bandit, Linux, shell]
---
# Prompt
> The password for the next level is stored in the file `data.txt`, which contains Base64-encoded data

# Solution
```sh
$ ssh bandit10@bandit.labs.overthewire.org -p 2220
bandit10@bandit.labs.overthewire.org password: truKLdjsbJ5g7yyJ2X2R0o3a5HQJFuLk
bandit10@bandit:~$ ls
data.txt
bandit10@bandit:~$ cat data.txt | base64 -d
The password is IFukwKGsFW8MOq3IRFqrxE1hxTNEbUPR
```