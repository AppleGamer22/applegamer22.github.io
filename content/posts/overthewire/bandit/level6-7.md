---
title: OverTheWire Bandit Level 6 - 7
date: 2022-07-28T06:00:00
tags: [OverTheWire, Bandit, Linux, shell]
---
# Prompt
> The password for the next level is stored **somewhere on the server** and has all of the following properties:
>
> * owned by user `bandit7`
> * owned by group `bandit6`
> * 33 bytes in size

# Solution
```sh
$ ssh bandit6@bandit.labs.overthewire.org -p 2220
bandit6@bandit.labs.overthewire.org password: DXjZPULLxYr17uwoI01bNLQbtFemEgo7
bandit6@bandit:~$ find / -user bandit7 -group bandit6 -size 33c 2> /dev/null
/var/lib/dpkg/info/bandit7.password
bandit6@bandit:~$ cat /var/lib/dpkg/info/bandit7.password
HKBPTKQnIay4Fw76bEy8PVxKEDQRKTzs
```