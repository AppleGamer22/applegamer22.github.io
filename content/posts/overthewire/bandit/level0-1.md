---
title: OverTheWire Bandit Level 0 - 1
description: OverTheWire Bandit Level 0 - 1 challenge
date: 2022-07-28T00:00:00
tags: [OverTheWire, Bandit, Linux, shell]
---
This is my attempt at [OverTheWire's Bandit](https://overthewire.org/wargames/bandit/bandit0.html) challenges.

# Prompt
> The host to which you need to connect is `bandit.labs.overthewire.org`, on port 2220. The username is `bandit0` and the password is `bandit0`.
>
> The password for the next level is stored in a file called `readme` located in the home directory. Use this password to log into bandit1 using SSH.

# Solution

```sh
$ ssh bandit0@bandit.labs.overthewire.org -p 2220
bandit0@bandit.labs.overthewire.org password: bandit0
bandit0@bandit:~$ ls
readme
bandit0@bandit:~$ cat readme
boJ9jbbUNNfktd78OOpsqOltutMc3MY1
```