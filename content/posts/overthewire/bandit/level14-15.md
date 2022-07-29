---
title: OverTheWire Bandit Level 14 - 15
date: 2022-07-28T14:00:00
tags: [overthewire, linux, shell]
---
# Prompt
> The password for the next level can be retrieved by submitting the password of the current level to **port 30000 on `localhost`**.

# Solution
```sh
$ ssh bandit14@bandit.labs.overthewire.org -p 2220
bandit14@bandit.labs.overthewire.org password: 4wcYUJFw0k0XLShlDzztnTBHiqxU3b3e
bandit14@bandit:~$ curl localhost:30000
Wrong! Please enter the correct current password
bandit14@bandit:~$ echo "4wcYUJFw0k0XLShlDzztnTBHiqxU3b3e" | nc localhost 30000
Correct!
BfMYroe26WYalil77FoDi9qh59eK5xNr
```