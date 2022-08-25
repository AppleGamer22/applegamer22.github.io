---
title: SHELL CTF How to Defeat a Dragon
date: 2022-08-12
tags: [SHELL_CTF, reversing, linux, shell, C]
---
# Prompt
> Dragonairre, the dragon with the hexadecimal head has attacked the village to take revenge on his last defeat, we need to get the ultimate weapon.

# Analysis

```sh
$ ./vault
Help us defeat the dragon!! Enter the code:22
wron..aaaaaahhhhhhhh
```

The [decompiled code](https://dogbolt.org/?id=da50a275-02c2-4d2f-8714-982e5de0747b) reveals that the hexadecimal number `0x10f2c`, or the decimal number `69420` (~~nice~~) is the code the program requires. My attempt at rewriting the `main` function based on the above-mentioned decompilation is shown below:

```c
int main() {
	printf("Help us defeat the dragon!! Enter the code:");
	int code;
	scanf("%d", &code);
	if (code == 0x10f2c) {
		printf("Yeahh!!,we did it,We defeated the dragon.Thanks for your help here's your reward : %s", flag);
	} else if (code == 0x45) {
		printf("Nice,but this is not the code :(.");
	} else if (code != 0x1a4) {
		printf("wron..aaaaaahhhhhhhh");
	} else {
		printf("Bruh!! Seriously?");
	}
	return 0;
}
```

# Solution
After the supplying the expected code in decimal form, a flag-like output is introduced:

```sh
$ ./vault
Help us defeat the dragon!! Enter the code:69420
Yeahh!!,we did it,We defeated the dragon.Thanks for your help here's your reward : SHELLCTF{5348454c4c4354467b31355f523376337235316e675f333473793f7d}
```

However, the real flag is hexadecimally-encoded within the fake one, which is decoded with [`pwn unhex`](https://docs.pwntools.com/en/latest/commandline.html#pwn-unhex) below:

```sh
$ echo "5348454c4c4354467b31355f523376337235316e675f333473793f7d" | pwn unhex
SHELLCTF{15_R3v3r51ng_34sy?}
```