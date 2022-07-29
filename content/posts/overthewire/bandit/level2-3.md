---
title: OverTheWire Bandit Level 2 - 3
date: 2022-07-28T02:00:00
tags: [overthewire, linux, shell, cryptography, web]
---
# Prompt
> The password for the next level is stored in a file called `spaces in this filename` located in the home directory

# Solution
```sh
$ ssh bandit2@bandit.labs.overthewire.org -p 2220
bandit2@bandit.labs.overthewire.org password: CV1DtqXWVFXTvM2F0k09SHz0YwRINYA9
bandit2@bandit:~$ ls
spaces in this filename
bandit2@bandit:~$ cat spaces\ in\ this\ filename 
UmHadQclWmgdLOKQ3YNgjWxGoRMb5luK
```