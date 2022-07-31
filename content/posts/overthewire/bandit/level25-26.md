---
title: OverTheWire Bandit Level 25 - 26
date: 2022-07-29T08:00:00
tags: [OverTheWire, Bandit, Linux, shell]
---
# Prompt
> Logging in to `bandit26` from `bandit25` should be fairly easy The shell for user `bandit26` is not `/bin/bash`, but something else. Find out what it is, how it works and how to break out of it.

# Solution
```sh
$ ssh bandit25@bandit.labs.overthewire.org -p 2220
bandit25@bandit.labs.overthewire.org password: uNG9O58gUE7snukf3bvZ0rxhtnjzSGzG
bandit25@bandit:~$ ls
bandit26.sshkey
bandit25@bandit:~$ cat /etc/passwd | grep bandit26
bandit26:x:11026:11026:bandit level 26:/home/bandit26:/usr/bin/showtext
bandit25@bandit:~$ cat /usr/bin/showtext
#!/bin/sh
export TERM=linux
more ~/text.txt
exit 0
bandit25@bandit:~$ exit
$ scp -P 2220 bandit25@bandit.labs.overthewire.org:/home/bandit25/bandit26.sshkey bandit26
bandit25@bandit.labs.overthewire.org password: uNG9O58gUE7snukf3bvZ0rxhtnjzSGzG
$ chmod 600 bandit26
$ ssh bandit26@bandit.labs.overthewire.org -p 2220 -i bandit26
 _
| |                   | (_) | |__ \ / /
| |__   __ _ _ __   __| |_| |_   ) / /_
| '_ \ / _` | '_ \ / _` | | __| / / '_ \
| |_) | (_| | | | | (_| | | |_ / /| (_) |
|_.__/ \__,_|_| |_|\__,_|_|\__|____\___/
```

1. Make terminal window smaller.
1. Connect to `bandit26` again.
1. Issue a `v` command to open a `vim` session from the `more` text viewer
1. Issue a `:e /etc/bandit\_pass/bandit26` command to open the password file from the current `vim` session: `5czgV9L3Xx8JPOyRbXh6lQbmIOWvPT6Z`

# References
* MayADevBe. (2022, June 6). OverTheWire Bandit Level 25 - 26. MayADevBe. <https://mayadevbe.me/posts/overthewire/bandit/level26/>
