---
title: OverTheWire Bandit Level 15 - 16
date: 2022-07-28T15:00:00
tags: [OverTheWire, Bandit, Linux, shell, networking]
---
# Prompt
> The password for the next level can be retrieved by submitting the password of the current level to **port 30001 on `localhost`** using SSL encryption.

# Solution
```sh
$ ssh bandit15@bandit.labs.overthewire.org -p 2220
bandit15@bandit.labs.overthewire.org password: BfMYroe26WYalil77FoDi9qh59eK5xNr
bandit15@bandit:~$ echo "BfMYroe26WYalil77FoDi9qh59eK5xNr" | openssl s_client -connect localhost:30001 -quiet -verify_quiet
Correct!
cluFn7wTiGryunymYOu4RcffSxQluehd
```

# References
* [`jww`](https://stackoverflow.com/users/608639/jww), & (Farber, A.)[https://stackoverflow.com/users/165071/alexander-farber] (2014, April 28). How to send a string to server using `s_client`. Stack Overflow. <https://stackoverflow.com/a/23352363/7148921>