---
title: Git Commit Signing with Sigstore & Gitsign
date: 2023-09-14
tags: [Git, Sigstore, Gitsign]
draft: true
---

```
[commit]
	gpgSign = true
[tag]
	gpgSign = true
[gpg]
	format = x509
[gpg "x509"]
	program = gitsign
[gitsign]
	connectorID = https://github.com/login/oauth
```