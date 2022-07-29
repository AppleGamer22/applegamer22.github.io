---
title: OverTheWire Bandit Level 16 - 17
date: 2022-07-28T16:00:00
tags: [overthewire, bandit, linux, shell, networking]
---
# Prompt
> The credentials for the next level can be retrieved by submitting the password of the current level to **a port on `localhost` in the range 31000 to 32000**. First find out which of these ports have a server listening on them. Then find out which of those speak SSL and which don’t. There is only 1 server that will give the next credentials, the others will simply send back to you whatever you send to it.

# Solution
```sh
$ ssh bandit16@bandit.labs.overthewire.org -p 2220
bandit16@bandit.labs.overthewire.org password: cluFn7wTiGryunymYOu4RcffSxQluehd
bandit16@bandit:~$ nmap --script ssl-cert -p 31000-32000 localhost
PORT      STATE    SERVICE
31046/tcp open     unknown
31518/tcp filtered unknown
31691/tcp open     unknown
31790/tcp open     unknown
31960/tcp open     unknown
# trial and error
bandit16@bandit:~$ echo "cluFn7wTiGryunymYOu4RcffSxQluehd" | openssl s_client -connect localhost:31790 -quiet -verify_quiet
Correct!
-----BEGIN RSA PRIVATE KEY-----
...
-----END RSA PRIVATE KEY-----
bandit16@bandit:~$ exit
# ... == SSH private key
$ echo "..." > bandit17
$ chmod 600 bandit17
$ ssh bandit17@bandit.labs.overthewire.org -p 2220 -i bandit17
bandit17@bandit:~$ cat /etc/bandit_pass/bandit17
xLYVMN9WE5zQ5vHacb0sZEVqbrp7nBTn
```

# References
* Cordero, K. (2020, August 14). `nmap` - Enumerating SSL. Kerry Cordero. <https://cordero.me/nmap-enumerating-ssl/>