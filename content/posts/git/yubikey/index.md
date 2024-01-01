---
title: Git Commit Signing with GPG & YubiKey
description: Git Commit Signing with GPG and YubiKey
date: 2024-01-01
tags: [Git, GitHub, GPG, YubiKey]
draft: true
---

# Generate Key Pair
According to GitHub's GPG Guide[^1]:

1. Generate a key pair.
	* Make sure to specify your preferred cryptosystem algorithm and your [`gitconfig` contact details](#enable-commit-and-tag-signature)

	```
	$ gpg --full-generate-key
	```

1. Get your key ID:

	```
	$ gpg --list-secret-keys --keyid-format=long
	sec>  rsa4096/4DAFB02B4734FE52 2021-09-01 [SC]
		________________________4DAFB02B4734FE52
		# ...
	uid                 [ultimate] Omri Bornstein <omribor@gmail.com>
	ssb>  rsa4096/422B0DEA5FB23439 2021-09-01 [E]
	$ export KEY=________________________4DAFB02B4734FE52
	```

1. Print your public key:

	```
	$ gpg --export --armor $KEY
	-----BEGIN PGP PUBLIC KEY BLOCK-----
	# ...
	-----END PGP PUBLIC KEY BLOCK-----
	```

1. Copy your public key, beginning with `-----BEGIN PGP PUBLIC KEY BLOCK-----` and ending with `-----END PGP PUBLIC KEY BLOCK-----`.
1. Follow [GitHub's guide](https://docs.github.com/en/authentication/managing-commit-signature-verification/adding-a-gpg-key-to-your-github-account) to add your public key to your account.

## Back-up Your Key Pair
According to Yubico's guide[^2], you can export an ASCII text version of your private key. If you want to save a copy from your YubiKey, make sure it's plugged-in and detected before running the following command.


```sh
$ gpg --export-secret-key --armor 4DAFB02B4734FE52
-----BEGIN PGP PRIVATE KEY BLOCK-----
# ...
-----END PGP PRIVATE KEY BLOCK-----
```

# Import Key Pair to YubiKey
Tom Stuart has an awesome video on YouTube[^3] showing how ot transfer a key pair to a hardware-based security key like a YubiKey. A similar guide can be found in a written form on [`@drduh`](https://github.com/drduh)'s YubiKey guide[^4].

1. Connect your YubiKey to your machine.
1. `gpg` lists each of the keys in the key pair according to their role. The first-listed key is intended to be used for digital signatures (labeled by `[SC]`), and the second-listed key is meant to be used for encryption.

	```
	$ gpg --edit-key $KEY
	sec>  rsa4096/4DAFB02B4734FE52 2021-09-01 [SC]
		________________________4DAFB02B4734FE52
		# ...
	uid                 [ultimate] Omri Bornstein <omribor@gmail.com>
	ssb>  rsa4096/422B0DEA5FB23439 2021-09-01 [E]
	```

1. Select each key and instruct `gpg` to move it to the appropriate key slot on the YubiKey.

	```
	gpg> key 0
	gpg> keytocard
	Please select where to store the key:
	(1) Signature key
	(3) Authentication key
	Your selection? 1
	gpg> key 1
	gpg> keytocard
	Please select where to store the key:
	(2) Encryption key
	Your selection? 2
	```

1. Make sure to save the changes and exit the `gpg` command prompt.

	```
	gpg> quit
	Save changes? (y/N) y
	```

# Enable Commit and Tag Signature
After your key pair is set-up with `gpg` and your YubiKey, you can enable commit signing by default by editing your `~/.gitconfig` file. Your details must match to the details you provided when creating your key pair.

```
[user]
	name = Omri Bornstein
	email = omribor@gmail.com
[commit]
	gpgSign = true
[tag]
	gpgSign = true
```

# Add Hardware-backed Key Pair to Another Machine
In case you want to use the same YubiKey across multiple machines, [`@drduh`](https://github.com/drduh)'s YubiKey guide[^4] covers how to inform `gpg` (installed on another machine) of the key pair you already transferred to your YubiKey from a different machine.

From the original machine with your YubiKey plugged-in, you'll need to make a copy of the public key alongside a list of the trusted GPG keys.

```sh
$ gpg --export --armor $KEY > gpg-public-key-$KEY.asc
$ gpg --export-ownertrust > gpg-owner-trust.txt
```

Copy both files to the second machine (with `gpg` installed). Then, on the second machine:

1. Define your KEY. For example:

	```sh
	$ export KEY=________________________4DAFB02B4734FE52
	```

1. Import your public key:

	```sh
	$ gpg --import gpg-public-key-$KEY.asc
	```

1. Import the trust settings:

	```sh
	$ gpg --import-ownertrust < gpg-owner-trust.txt
	```

1. Insert your YubiKey into a USB port.
1. Import the private key stubs from the YubiKey:

	```sh
	$ gpg --card-status 
	# ...
	Application type .: OpenPGP
	Version ..........: 2.1
	Manufacturer .....: Yubico
	# ...
	```

Now you can use the YubiKey on your multiple machine seamlessly.

[^1]: GitHub. (2016). Generating a new GPG key. GitHub Docs. <https://docs.github.com/en/authentication/managing-commit-signature-verification/generating-a-new-gpg-key>
[^2]: Yubico. (2020, May 12). Using Your YubiKey with OpenPGP. Yubico. <https://support.yubico.com/hc/en-us/articles/360013790259-Using-Your-YubiKey-with-OpenPGP>
[^3]: Stuart, T. (2022). How to set up Git commit signing with GPG and a YubiKey on macOS [YouTube Video]. In YouTube. <https://youtu.be/7LuMTyhFA-g>
[^4]: `drduh/YubiKey-Guide` (2023). Guide to using YubiKey for GPG and SSH. (2023). GitHub. <https://github.com/drduh/YubiKey-Guide?tab=readme-ov-file#multiple-hosts>