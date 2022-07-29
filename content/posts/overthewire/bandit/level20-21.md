---
title: OverTheWire Bandit Level 20 - 21
date: 2022-07-29T03:00:00
tags: [overthewire, bandit, linux, shell, networking]
---
# Prompt
> There is a `setuid` binary in the home directory that does the following:
> 1. It makes a connection to `localhost` on the port you specify as a command line argument.
> 1. It then reads a line of text from the connection and compares it to the password in the previous level (`bandit20`). If the password is correct, it will transmit the password for the next level (`bandit21`).

```sh
$ ssh bandit20@bandit.labs.overthewire.org -p 2220
bandit20@bandit.labs.overthewire.org password: GbKksEFF4yrVs6il55v6gwY5aVje5f0j
bandit20@bandit:~$ ls -l
-rwsr-x--- 1 bandit21 bandit20 12088 May 7 2020 suconnect
bandit20@bandit:~$ echo -n "GbKksEFF4yrVs6il55v6gwY5aVje5f0j" | nc -lp 2222 &
[1] 1145
bandit20@bandit:~$ ./suconnect 2222
bandit20@bandit:~$ ./suconnect 2222
Read: GbKksEFF4yrVs6il55v6gwY5aVje5f0j
Password matches, sending next password
gE269g2h3mw3pwgrj0Ha9Uoqen1c9DGr
[1]+ Done echo -n "GbKksEFF4yrVs6il55v6gwY5aVje5f0j" | nc -lp 2222
```

## References
* MayADevBe. (2022, May 2). OverTheWire Bandit Level 20 - 21. MayADevBe Blog. <https://mayadevbe.me/posts/overthewire/bandit/level21/>