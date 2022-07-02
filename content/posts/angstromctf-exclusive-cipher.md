---
title: ångstromCTF Exclusive Cipher
date: 2021-05-31
description: My attempt at the XOR cipher question from the 2021 ångstromCTF
tags: [cryptography, python]
---
# Prompt
> Clam decided to return to classic cryptography and revisit the XOR cipher! Here's some hex encoded cipher text:
> ```
> ae27eb3a148c3cf031079921ea3315cd27eb7d02882bf724169921eb3a469920e07d0b883bf63c018869a5090e8868e331078a68ec2e468c2bf13b1d9a20ea0208882de12e398c2df60211852deb021f823dda35079b2dda25099f35ab7d2182> 27e17d0a982bee7d098368f13503cd27f135039f68e62f1f9d3cea7c
> ```
> The key is 5 bytes long, and the flag is somewhere in the message.

# Analysis
Assuming 2 hexadecimal digits are equivalent to 1 ASCII characters, a possible key can be found by XORing the ciphertext with the known 5-bytes long substring `actf{`.
# Solution
In an XOR Cipher, it is known that `possible_key = ciphertext ^ known_cleartext`. The python script attached:
1. slices the ciphertext to all possible 5 characters-long (assuming 2 hexadecimal digits are equivalent to 1 ASCII characters) sections,
2. computes `possible_key = ciphertext ^ known_cleartext`, for a known substring of `actf{`,
3. expands the key to the ASCII length of the message,
4. rotates the key to deal with cases where the known clear text is not in an index that is a multiple of the key length.
   * Thanks to [@Levon](https://hashnode.com/@Levon) for this suggestion.
5. recomputes the XOR to possibly decode the message
6. and prints the possible message as ASCII.

## Initial Python Code
```python
from typing import List
from doctest import testmod
from textwrap import wrap

def xor(s: List[int], t: List[int]) -> List[int]:
	"""
	:param s: list of non-negative integers
	:param t: list of non-negative integers
	:return: XOR of the ith number of both lists
	"""
	return [a ^ b for a, b in zip(s, t)]


def expand_key(short_key: List[int], size: int) -> List[int]:
	"""
	:param short_key: list of non-negative integers
	:param size: positive integer
	:return: short_key * (size // len(short_key)) + short_key[:size - len(key_expanded)]

	>>> expand_key([1, 2, 3, 4, 5], 9)
	[1, 2, 3, 4, 5, 1, 2, 3, 4]
	"""
	assert size > len(short_key)
	key_expanded = short_key * (size // len(short_key))
	for ii in range(size - len(key_expanded)):
		key_expanded.append(short_key[ii])
	return key_expanded


ciphertext_text = input("hex-encoded ciphertext: ")
known_cleartext = input("known cleartext (with length of key): ")
hint = input("hint (such as 'flag'): ")

cipher_ascii = [int(letter, 16) for letter in wrap(ciphertext_text, 2)]
known_cleartext_ascii = [ord(letter) for letter in known_cleartext]

for i in range(len(cipher_ascii) - len(known_cleartext)):
	key = xor(cipher_ascii[i:i + len(known_cleartext)], known_cleartext_ascii)
	expanded_key = expand_key(key, len(cipher_ascii))
	message_ascii = xor(cipher_ascii, expanded_key)
	message_text = "".join(map(chr, message_ascii))
	if known_cleartext in message_text and hint in message_text:
		print(f"key: {key} ('{''.join(map(chr, key))}')")
		print(f"message: {message_text}")
		print()
```
## Improved Python Code
```python
from typing import TypedDict, List
from textwrap import wrap
from pwn import xor

class XORSolution(TypedDict):
	key: List[int]
	cleartext: str


def decode_xor(ciphertext_hex: str, known_cleartext: str, hint: str) -> List[XORSolution]:
	output = []
	cipher_ascii = bytes(int(letter, 16) for letter in wrap(ciphertext_hex, 2))
	for i in range(len(cipher_ascii)):
		key = list(xor(cipher_ascii[i:i + len(known_cleartext)], known_cleartext.encode()))
		for ii in range(len(key)):
			rotated_key = key[-ii:] + key[:-ii]
			cleartext = str(xor(cipher_ascii, rotated_key))[2:-1]
			if known_cleartext in cleartext and hint in cleartext:
				output.append({"key": rotated_key, "cleartext": cleartext})
	return output
```

## Python Script Output
* A Python script that prints all valid solutions for the full ciphertext and the ciphertext without the first character:

```python
ciphertext_hex1 = "ae27eb3a148c3cf031079921ea3315cd27eb7d02882bf724169921eb3a469920e07d0b883bf63c018869a5090e8868e331078a68ec2e468c2bf13b1d9a20ea0208882de12e398c2df60211852deb021f823dda35079b2dda25099f35ab7d218227e17d0a982bee7d098368f13503cd27f135039f68e62f1f9d3cea7c"
known_cleartext1 = "actf{"
hint1 = "flag"

for solution in decode_xor(ciphertext_hex1, known_cleartext1, hint1):
	print(f"key: {solution['key']})")
	print(f"message: {solution['cleartext']}")

for solution in decode_xor(ciphertext_hex1[2:], known_cleartext1, hint1):
	print(f"key: {solution['key']})")
	print(f"message: {solution['cleartext']}")
```
* The output of the screen described immediately above:

```
key: [237, 72, 133, 93, 102])
message: Congratulations on decrypting the message! The flag is actf{who_needs_aes_when_you_have_xor}. Good luck on the other crypto!
key: [72, 133, 93, 102, 237])
message: ongratulations on decrypting the message! The flag is actf{who_needs_aes_when_you_have_xor}. Good luck on the other crypto!
```
**Flag**: `actf{who_needs_aes_when_you_have_xor}`

# References
* Szymański, Ł. (2021). ångstromCTF 2021: Exclusive Cipher. szymanski.ninja. https://szymanski.ninja/en/ctfwriteups/2021/angstromctf/exclusive-cipher/