---
title: SHELLCTF How to Defeat a Dragon
date: 2022-08-12
tags: [SHELLCTF, reversing, linux, shell, C]
---
# Prompt
> Dragonairre,the dragon with the hexadecimal head has attacked the village to take revenge on his last defeat,we need to get the ultimate weapon.

# Analysis

```sh
$ ./vault
Help us defeat the dragon!! Enter the code:22
wron..aaaaaahhhhhhhh
```

The [decompiled code](https://dogbolt.org/?id=da50a275-02c2-4d2f-8714-982e5de0747b)

```sh
$ ./vault
Help us defeat the dragon!! Enter the code:69420
Yeahh!!,we did it,We defeated the dragon.Thanks for your help here's your reward : SHELLCTF{5348454c4c4354467b31355f523376337235316e675f333473793f7d}
```

```sh
$ echo "5348454c4c4354467b31355f523376337235316e675f333473793f7d" | unhex
SHELLCTF{15_R3v3r51ng_34sy?}
```