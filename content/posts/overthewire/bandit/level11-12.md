---
title: OverTheWire Bandit Level 11 - 12
date: 2022-07-28T11:00:00
tags: [OverTheWire, Bandit, Linux, shell, cryptography]
---
# Prompt
> The password for the next level is stored in the file data.txt, where all lowercase and uppercase letters have been rotated by 13 positions

# Solution
![ROT13](https://upload.wikimedia.org/wikipedia/commons/thumb/3/33/ROT13_table_with_example.svg/475px-ROT13_table_with_example.svg.png?20070909030930)


```sh
$ ssh bandit11@bandit.labs.overthewire.org -p 2220
bandit11@bandit.labs.overthewire.org password: IFukwKGsFW8MOq3IRFqrxE1hxTNEbUPR
bandit11@bandit:~$ cat data.txt | tr 'A-Za-z' 'N-ZA-Mn-za-m'
The password is 5Te8Y4drgCRfCx8ugdwuEX8KFC6k2EUu
```

# References
* Esham, B. (2007, September 8). ROT13 Table with Example. Wikimedia Commons. <https://commons.wikimedia.org/wiki/File:ROT13_table_with_example.svg>
* [Mullen, S.](https://stackoverflow.com/users/154573/samullen), & [Ross, C.](https://stackoverflow.com/users/9388567/charlie-ross) (2011, March 26). using ROT13 and `tr` command for having an encrypted email address. Stack Overflow. <https://stackoverflow.com/a/5442495/7148921>