---
title: OverTheWire Bandit Level 18 - 19
date: 2022-07-29T01:00:00
tags: [OverTheWire, Bandit, Linux, shell]
---
# Prompt
> The password for the next level is stored in a file `readme` in the home directory. Unfortunately, someone has modified `.bashrc` to log you out when you log in with SSH.

# Solution
```sh
$ ssh bandit18@bandit.labs.overthewire.org -p 2220 -t 'cat readme'
bandit18@bandit.labs.overthewire.org password: kfBf3eYk5BPBRzwjqutbbfE887SVc5Yd
IueksS7Ubh8G3DCwVzrTd8rAVOwq3M5x
```

# References
* [`fons`](https://superuser.com/users/238773/fons), & [`Raystafarian`](https://superuser.com/users/116196/raystafarian). (2011, July 5). Run Remote `ssh` command with Full Login Shell. Super User. https://superuser.com/questions/306530/run-remote-ssh-command-with-full-login-shell