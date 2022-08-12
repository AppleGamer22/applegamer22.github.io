---
title: OverTheWire Bandit Level 8 - 9
date: 2022-07-28T08:00:00
tags: [OverTheWire, Bandit, Linux, shell]
---
# Prompt
> The password for the next level is stored in the file `data.txt` and is the only line of text that occurs only once

# Solution
```sh
$ ssh bandit8@bandit.labs.overthewire.org -p 2220
bandit8@bandit.labs.overthewire.org password: cvX2JJa4CFALtqS87jk27qwqGhBM9plV
bandit8@bandit:~$ ls
data.txt
bandit8@bandit:~$ sort data.txt | uniq -c | sort | tail -1
1 UsvVyFSfZZWbi6wgC7dAFyFuR6jQQUhR
```

## References
* Reinhart, J. (2014, November 26). `sort` and count number of occurrence of lines. Unix & Linux Stack Exchange. <https://unix.stackexchange.com/a/170044/232245>