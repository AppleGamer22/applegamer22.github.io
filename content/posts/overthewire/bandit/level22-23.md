---
title: OverTheWire Bandit Level 22 - 23
description: OverTheWire Bandit Level 22 - 23 challenge
date: 2022-07-29T05:00:00
tags: [OverTheWire, Bandit, Linux, shell]
---
# Prompt
> A program is running automatically at regular intervals from `cron`, the time-based job scheduler. Look in `/etc/cron.d/` for the configuration and see what command is being executed.

# Solution
```sh
$ ssh bandit22@bandit.labs.overthewire.org -p 2220
bandit22@bandit.labs.overthewire.org password: Yk7owGAcWjwMVRwrTesJEwB7WVOiILLI
bandit22@bandit:~$ ls /etc/cron.d/
cronjob_bandit15_root cronjob_bandit17_root cronjob_bandit22 cronjob_bandit23 cronjob_bandit24 cronjob_bandit25_root
bandit22@bandit:~$ cat /etc/cron.d/cronjob_bandit23 
@reboot bandit23 /usr/bin/cronjob_bandit23.sh &> /dev/null
* * * * * bandit23 /usr/bin/cronjob_bandit23.sh &> /dev/null
bandit22@bandit:~$ cat /usr/bin/cronjob_bandit23.sh
#!/bin/bash
myname=$(whoami)
mytarget=$(echo I am user $myname | md5sum | cut -d ' ' -f 1)
echo "Copying passwordfile /etc/bandit_pass/$myname to /tmp/$mytarget"
cat /etc/bandit_pass/$myname > /tmp/$mytarget
bandit22@bandit:~$ echo I am user bandit23 | md5sum | cut -d ' ' -f 1
8ca319486bfbbc3663ea0fbe81326349
bandit22@bandit:~$ cat /tmp/8ca319486bfbbc3663ea0fbe81326349
jc1udXuA1tiHqjIsL8yaapX5XIAI6i0n
```

# References
* <https://crontab.guru/#*_*_*_*_*>