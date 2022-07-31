---
title: OverTheWire Bandit Level 13 - 14
date: 2022-07-28T13:00:00
tags: [OverTheWire, Bandit, Linux, shell]
---
# Prompt
> The password for the next level is stored in `/etc/bandit_pass/bandit14` and can only be read by user `bandit14`. For this level, you don’t get the next password, but you get a private SSH key that can be used to log into the next level.

# Solution
```sh
$ ssh bandit13@bandit.labs.overthewire.org -p 2220
bandit13@bandit.labs.overthewire.org password: 8ZjyCRiBWFYkneahHwxCv3wb2a1ORpYL
bandit13@bandit:~$ ls
sshkey.private
bandit13@bandit:~$ exit
$ scp -P 2220 bandit13@bandit.labs.overthewire.org:/home/bandit13/sshkey.private bandit14
bandit13@bandit.labs.overthewire.org password: 8ZjyCRiBWFYkneahHwxCv3wb2a1ORpYL
$ chmod 600 bandit14
$ ssh bandit14@bandit.labs.overthewire.org -p 2220 -i bandit14
bandit14@bandit:~$ cat /etc/bandit_pass/bandit14
4wcYUJFw0k0XLShlDzztnTBHiqxU3b3e
```

## References
* [Goldshteyn, M.](https://stackoverflow.com/users/473798/michael-goldshteyn) (2012, April 26). scp with port number specified. Stack Overflow. <https://stackoverflow.com/a/10341062/7148921>