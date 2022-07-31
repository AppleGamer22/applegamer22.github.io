---
title: OverTheWire Bandit Level 21 - 22
date: 2022-07-29T04:00:00
tags: [OverTheWire, Bandit, Linux, shell]
---
# Prompt
> A program is running automatically at regular intervals from `cron`, the time-based job scheduler. Look in `/etc/cron.d/` for the configuration and see what command is being executed.

# Solution
```sh
$ ssh bandit21@bandit.labs.overthewire.org -p 2220
bandit21@bandit.labs.overthewire.org password: gE269g2h3mw3pwgrj0Ha9Uoqen1c9DGr
bandit21@bandit:~$ ls /etc/cron.d/
cronjob_bandit15_root cronjob_bandit17_root cronjob_bandit22 cronjob_bandit23 cronjob_bandit24 cronjob_bandit25_root
bandit21@bandit:~$ cat /etc/cron.d/cronjob_bandit22
@reboot bandit22 /usr/bin/cronjob_bandit22.sh &> /dev/null
* * * * * bandit22 /usr/bin/cronjob_bandit22.sh &> /dev/null
bandit21@bandit:~$ cat /usr/bin/cronjob_bandit22.sh
#!/bin/bash
chmod 644 /tmp/t7O6lds9S0RqQh9aMcz6ShpAoZKF7fgv
cat /etc/bandit_pass/bandit22 > /tmp/t7O6lds9S0RqQh9aMcz6ShpAoZKF7fgv
bandit21@bandit:~$ cat /tmp/t7O6lds9S0RqQh9aMcz6ShpAoZKF7fgv
Yk7owGAcWjwMVRwrTesJEwB7WVOiILLI
```

# References
* <https://crontab.guru/#*_*_*_*_*>