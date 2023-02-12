---
title: OverTheWire Bandit Level 19 - 20
description: OverTheWire Bandit Level 19 - 20 challenge
date: 2022-07-29T02:00:00
tags: [OverTheWire, Bandit, Linux, shell]
---
# Prompt
> To gain access to the next level, you should use the `setuid` binary in the home directory. Execute it without arguments to find out how to use it. The password for this level can be found in the usual place (`/etc/bandit_pass`), after you have used the `setuid` binary.

# Solution
```sh
$ ssh bandit19@bandit.labs.overthewire.org -p 2220
bandit19@bandit.labs.overthewire.org password: IueksS7Ubh8G3DCwVzrTd8rAVOwq3M5x
bandit19@bandit:~$ ls -l
-rwsr-x--- 1 bandit20 bandit19 7296 May  7  2020 bandit20-do
bandit19@bandit:~$ ./bandit20-do 
Run a command as another user.
  Example: ./bandit20-do id
bandit19@bandit:~$ ./bandit20-do cat /etc/bandit_pass/bandit20
GbKksEFF4yrVs6il55v6gwY5aVje5f0j
```

# References
* <https://en.wikipedia.org/wiki/Setuid>