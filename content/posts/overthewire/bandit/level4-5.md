---
title: OverTheWire Bandit Level 4 - 5
date: 2022-07-28T04:00:00
tags: [overthewire, linux, shell]
---
# Prompt
> The password for the next level is stored in the only human-readable file in the `inhere` directory.

# Solution
```sh
$ ssh bandit4@bandit.labs.overthewire.org -p 2220
bandit4@bandit.labs.overthewire.org password: pIwrPrtPN36QITSp3EQaw936yaFoFgAB
bandit4@bandit:~$ ls -l
inhere
bandit4@bandit:~$ ls inhere
-file00 -file01 -file02 -file03 -file04 -file05 -file06 -file07 -file08 -file09
bandit4@bandit:~$ find inhere -type f -exec file {} \; | grep ":.* ASCII text"
inhere/-file07: ASCII text
bandit4@bandit:~$ cat inhere/-file07
koReBOKuIDDepwhWk7jZC0RTdopnAYKh
```

# References
* `baeldung`. (2021, August 20). How To Find Only Text Files in a Directory in Linux. Baeldung on Linux. <https://www.baeldung.com/linux/seach-text-files-in-directory>