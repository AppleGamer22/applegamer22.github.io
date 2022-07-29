---
title: OverTheWire Bandit Level 1 - 2
date: 2022-07-28T01:00:00
tags: [overthewire, bandit, linux, shell]
---

# Prompt
> The password for the next level is stored in a file called `-` located in the home directory

# Solution
```sh
$ ssh bandit1@bandit.labs.overthewire.org -p 2220
bandit1@bandit.labs.overthewire.org password: boJ9jbbUNNfktd78OOpsqOltutMc3MY1
bandit1@bandit:~$ ls
-
bandit1@bandit:~$ cat ./-
CV1DtqXWVFXTvM2F0k09SHz0YwRINYA9
```

# References
* Raj, P. (2017, February 12). How to open a `-` dashed file name using terminal? Stack Overflow. <https://stackoverflow.com/a/42187582/7148921>