---
title: OverTheWire Bandit Level 7 - 8
date: 2022-07-28T07:00:00
tags: [overthewire, bandit, linux, shell]
---
# Prompt
> The password for the next level is stored in the file `data.txt` next to the word `millionth`

# Solution
```sh
$ ssh bandit7@bandit.labs.overthewire.org -p 2220
bandit7@bandit.labs.overthewire.org password: HKBPTKQnIay4Fw76bEy8PVxKEDQRKTzs
bandit7@bandit:~$ ls
data.txt
bandit7@bandit:~$ grep millionth data.txt 
millionth cvX2JJa4CFALtqS87jk27qwqGhBM9plV
```