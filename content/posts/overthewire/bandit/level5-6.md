---
title: OverTheWire Bandit Level 5 - 6
date: 2022-07-28T05:00:00
tags: [overthewire, bandit, linux, shell]
---
# Prompt
> The password for the next level is stored in a file somewhere under the `inhere` directory and has all of the following properties:
> * human-readable
> * 1033 bytes in size
> * not executable

# Solution
```sh
$ ssh bandit5@bandit.labs.overthewire.org -p 2220
bandit5@bandit.labs.overthewire.org password: koReBOKuIDDepwhWk7jZC0RTdopnAYKh
bandit5@bandit:~$ ls
inhere
bandit5@bandit:~$ ls inhere/
maybehere00 maybehere02 maybehere04 maybehere06 maybehere08 maybehere10 maybehere12 maybehere14 maybehere16 maybehere18
maybehere01 maybehere03 maybehere05 maybehere07 maybehere09 maybehere11 maybehere13 maybehere15 maybehere17 maybehere19
bandit5@bandit:~$ find inhere -type f -size 1033c -exec file {} \; | grep ":.* ASCII text"
inhere/maybehere07/.file2: ASCII text, with very long lines
bandit5@bandit:~$ cat inhere/maybehere07/.file2
DXjZPULLxYr17uwoI01bNLQbtFemEgo7
```