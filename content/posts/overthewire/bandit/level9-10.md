---
title: OverTheWire Bandit Level 9 - 10
date: 2022-07-28T09:00:00
tags: [OverTheWire, Bandit, Linux, shell, regex]
---
# Prompt
> The password for the next level is stored in the file `data.txt` in one of the few human-readable strings, preceded by several `=` characters.

# Solution
```sh
$ ssh bandit9@bandit.labs.overthewire.org -p 2220
bandit9@bandit.labs.overthewire.org password: UsvVyFSfZZWbi6wgC7dAFyFuR6jQQUhR
bandit9@bandit:~$ ls
data.txt
bandit9@bandit:~$ strings data.txt | grep -E "={2,}"
========== the*2i4
========== password
Z========== is
&========== truKLdjsbJ5g7yyJ2X2R0o3a5HQJFuLk
```

# References
* Allan. (2017, December 21). Regex character repeats $n$ or more times in line with `grep`. Stack Overflow. <https://stackoverflow.com/a/47921068/7148921>