---
title: UACTF Sanity Check
date: 2022-07-30
draft: true
tags: [UACTF, reversing, linux, shell, C]
---
# Prompt
> I didn't know that `strings` was a command until way later LMAO. `¯\_(ツ)_/¯`

# Solution
As the name suggests, this challenge's purpose is to jump-start the reversing category. I decided to start the challenge by following the prompt and printing the ASCII strings the binary contains, and filter for the flag format.

```sh
$ strings sanity-check | grep "UACTF"
UACTF{N3V3R_G0NN4_L37_Y0U_D0WN}
```

# Binary Decompilation
Using [Decompiler Explorer](https://dogbolt.org), I wanted to find what the binary does since running it with no argument or standard input produces no obvious results. The following decompiled code is my adaptation of [Ghidra](https://ghidra-sre.org)'s and [BinaryNinja](https://binary.ninja)'s decompiler output.

The `main` function's only purpose seems to call the `do_stuff` function.

```c
int main() {
	do_stuff();
	return 0;
}
```

```c
#include <string.h>

void do_stuff() {
	size_t sVar1;
	long in_FS_OFFSET;
	char local_118[6];
	char auStack274[7];
	char auStack267[7];
	char auStack260[244];

	long local_10 = *(long *)(in_FS_OFFSET + 0x28);
	sVar1 = strlen(flag);
	strncpy(local_118, flag, sVar1);
	int local_130 = 0x525230245f4d7c;
	int local_128 = 0x37334c5f7c5f59;
	int local_120 = 0x30445f5530595f;
	char local_133 = 'W';
	char local_132 = 'N';

	memcpy(auStack274, &local_130, 7);
	memcpy(auStack260, &local_120, 7);
	memcpy(auStack267, &local_128, 7);

	sVar1 = strlen(flag);
	local_118[sVar1 - 2] = '!';
	sVar1 = strlen(flag);
	local_118[sVar1 - 4] = local_133;
	sVar1 = strlen(flag);
	local_118[sVar1 - 3] = local_132;

	if (local_10 != *(long *)(in_FS_OFFSET + 0x28)) {
		__stack_chk_fail();
	}
}
```

```c
void __stack_chk_fail() {
	__stack_chk_fail();
}
```
