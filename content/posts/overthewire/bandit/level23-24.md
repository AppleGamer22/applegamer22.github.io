---
title: OverTheWire Bandit Level 23 - 24
date: 2022-07-29T06:00:00
tags: [overthewire, bandit, linux, shell]
---
# Prompt
> A program is running automatically at regular intervals from `cron`, the time-based job scheduler. Look in `/etc/cron.d/` for the configuration and see what command is being executed.

# Solution
```sh
$ ssh bandit23@bandit.labs.overthewire.org -p 2220
bandit23@bandit.labs.overthewire.org password: jc1udXuA1tiHqjIsL8yaapX5XIAI6i0n
bandit23@bandit:~$ ls /etc/cron.d/
cronjob_bandit15_root cronjob_bandit17_root cronjob_bandit22 cronjob_bandit23 cronjob_bandit24 cronjob_bandit25_root
bandit23@bandit:~$ cat /etc/cron.d/cronjob_bandit24
@reboot bandit24 /usr/bin/cronjob_bandit24.sh &> /dev/null
* * * * * bandit24 /usr/bin/cronjob_bandit24.sh &> /dev/null
bandit23@bandit:~$ cat /usr/bin/cronjob_bandit24.sh
#!/bin/bash
myname=$(whoami)
cd /var/spool/$myname
echo "Executing and deleting all scripts in /var/spool/$myname:"
for i in * .*; do
	if [ "$i" != "." -a "$i" != ".." ]; then
		echo "Handling $i"
		owner="$(stat --format "%U" ./$i)"
		if [ "${owner}" = "bandit23" ]; then
			timeout -s 9 60 ./$i
		fi
		rm -f ./$i
	fi
done
bandit23@bandit:~$ ls -l /var/spool/
drwxrwx-wx 25 root bandit24 659456 Jul 29 04:32 bandit24
```

# References
* <https://crontab.guru/#*_*_*_*_*>