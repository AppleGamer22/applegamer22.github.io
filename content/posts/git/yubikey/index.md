---
title: Git Commit Signing with GPG & YubiKey
date: 2023-09-14
tags: [Git, GitHub, GPG, YubiKey]
draft: true
---

# Generate Key Pair
According to GitHub's GPG Guide[^1]:

1. Generate a key pair.
	* Make sure to specify your preferred cryptosystem algorithm and your [`gitconfig` contact details](#/posts/shell/#git)

	```sh
	$ gpg --full-generate-key
	```

1. Get your key ID:

	```sh
	$ gpg --list-secret-keys --keyid-format=long
	/home/applegamer22/.gnupg/pubring.kbx
	-------------------------------------
	sec>  rsa4096/4DAFB02B4734FE52 2021-09-01 [SC]
		________________________4DAFB02B4734FE52
		# ...
	uid                 [ultimate] Omri Bornstein <omribor@gmail.com>
	ssb>  rsa4096/422B0DEA5FB23439 2021-09-01 [E]
	```

1. Print your public key:

	```sh
	$ gpg --export --armor 4DAFB02B4734FE52
	-----BEGIN PGP PUBLIC KEY BLOCK-----
	# ...
	-----END PGP PUBLIC KEY BLOCK-----
	```

1. Copy your public key, beginning with `-----BEGIN PGP PUBLIC KEY BLOCK-----` and ending with `-----END PGP PUBLIC KEY BLOCK-----`.
1. Follow [GitHub's guide](https://docs.github.com/en/authentication/managing-commit-signature-verification/adding-a-gpg-key-to-your-github-account) to add your public key to your account.

# Back-up Your Private Key
According to Yubico's guide[^2], you can export an ASCII text version of your private key. If you want to save a copy from your YubiKey, make sure it's plugged-in and detected before running the following command.


```sh
$ gpg --export-secret-key --armor 4DAFB02B4734FE52
-----BEGIN PGP PRIVATE KEY BLOCK-----
	# ...
-----END PGP PRIVATE KEY BLOCK-----
```

# Import Key Pair to YubiKey
[^3]

# Add Key Pair Another Machine
According to [`@drduh`](https://github.com/drduh)'s YubiKey guide[^4]:

```sh
$ export KEY=________________________4DAFB02B4734FE52
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

[^1]: GitHub. (2016). Generating a new GPG key. GitHub Docs. <https://docs.github.com/en/authentication/managing-commit-signature-verification/generating-a-new-gpg-key>
[^2]: Yubico. (2020, May 12). Using Your YubiKey with OpenPGP. Yubico. <https://support.yubico.com/hc/en-us/articles/360013790259-Using-Your-YubiKey-with-OpenPGP>
[^3]: Stuart, T. (2022). How to set up Git commit signing with GPG and a YubiKey on macOS [YouTube Video]. In YouTube. <https://youtu.be/7LuMTyhFA-g>
[^4]: `drduh/YubiKey-Guide` (2023). Guide to using YubiKey for GPG and SSH. (2023). GitHub. <https://github.com/drduh/YubiKey-Guide?tab=readme-ov-file#multiple-hosts>