---
title: OverTheWire Bandit Level 17 - 18
description: OverTheWire Bandit Level 17 - 18 challenge
date: 2022-07-29T00:00:00
tags: [OverTheWire, Bandit, Linux, shell]
---
# Prompt
> There are 2 files in the home directory: `passwords.old` and `passwords.new`. The password for the next level is in `passwords.new` and is the only line that has been changed between `passwords.old` and `passwords.new`

# Solution
```sh
$ ssh bandit17@bandit.labs.overthewire.org -p 2220
bandit17@bandit.labs.overthewire.org password: xLYVMN9WE5zQ5vHacb0sZEVqbrp7nBTn
bandit17@bandit:~$ ls
passwords.new  passwords.old
bandit17@bandit:~$ ls -l
-rw-r----- 1 bandit18 bandit17 3300 May  7  2020 passwords.new
-rw-r----- 1 bandit18 bandit17 3300 May  7  2020 passwords.old
bandit17@bandit:~$ diff passwords.old passwords.new 
42c42
< w0Yfolrc5bwjS4qw5mq1nnQi6mF03bii
---
> kfBf3eYk5BPBRzwjqutbbfE887SVc5Yd
```