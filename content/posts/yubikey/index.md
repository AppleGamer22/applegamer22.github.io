---
title: YubiKey for GPG & SSH
description: YubiKey for GPG & SSH
date: 2024-01-01
tags: [Git, GitHub, GPG, SSH, YubiKey, Nix]
---
After learning about how GitHub displays names and profile pictures next to commits, and how this mechanism can be [abused](https://dev.to/martiliones/how-i-got-linus-torvalds-in-my-contributors-on-github-3k4g) rather easily, I decided to enhance the integrity of my public-facing activity on GitHub by attaching digital signatures to my commits.

This document is a summary of all of the online resources I used to set-up my GPG key pair to work seamless across my machines, my [YubiKey hardware-based security key](#import-key-pair-to-yubikey) and on GitHub. I used my name and email for demo purposes only, which means that if you copy **my** details and use them in **your** key pair, it will look **goofy** in your commit log.

# Pre-requisites
1. Install the following software packages on your machine:
	* [`git`](https://git-scm.com)
	* [`gpg`](https://www.gnupg.org)
	* [`ssh`](https://www.openssh.com)
	* [Yubico Authenticator](https://www.yubico.com/products/yubico-authenticator/) and/or [`ykman`](https://docs.yubico.com/software/yubikey/tools/ykman/Using_the_ykman_CLI.html)
1. Authenticate to your [GitHub](https://github.com) account.
1. Set-up PIN codes for the functionalities you need in your YubiKey. Daniel Bucy from Yubico wrote an article[^0] explaining the default PINS.

# Git Commit Signing
## Generate Key Pair
The key pair first has to be generated on your local machine, such that its metadata is associated to your GitHub account's public-facing details, and its cryptographic algorithm is suitable to your requirements.

According to GitHub's GPG keys Guide[^1]:

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

### Back-up Your Key Pair
You can export an ASCII text version of your private key in case you wish to have a back-up version available at a **secure location**.

```sh
$ gpg --export-secret-key --armor $KEY
-----BEGIN PGP PRIVATE KEY BLOCK-----
# ...
-----END PGP PRIVATE KEY BLOCK-----
```

## Enable Commit and Tag Signature
You can enable commit signing by default by editing your `~/.gitconfig` file. Your details must match to the details you provided when creating your key pair.

```
[user]
	name = Omri Bornstein
	email = omribor@gmail.com
[commit]
	gpgSign = true
[tag]
	gpgSign = true
```

### Graphical PIN Entry
By default, `gpg` asks for your key's PIN to be entered to its command-line prompt before the private key is used for signing. In case you want to use GPG from a non-TUI environment, the [Arch Linux wiki](https://wiki.archlinux.org/title/GnuPG#pinentry) covers how to enable PIN entry from a graphical interface.

## Import Key Pair to YubiKey
At this point, you can utilise your key pair from your local machine with `git` perfectly fine in such a way that GitHub will display a [*verified* badge](https://docs.github.com/en/authentication/managing-commit-signature-verification/about-commit-signature-verification) next to your commit messages. In case you have a OpenPGP-capable hardware-based security key, you can optionally move your key pair to it, such that it can be used seamlessly and securely across machines.

Tom Stuart has an awesome video on YouTube[^2] showing how ot transfer a key pair to a hardware-based security key like a YubiKey. A similar guide can be found in a written form on [`@drduh`](https://github.com/drduh)'s YubiKey guide[^3].

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

## Add YubiKey-backed Key Pair to Another Machine
In case you want to use the same YubiKey across multiple machines, [`@drduh`](https://github.com/drduh)'s YubiKey guide[^3] covers how to inform `gpg` (installed on another machine) of the key pair you already transferred to your YubiKey from a different machine.

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

## Result
Git will now use the key pair stored on your YubiKey, and attach a digital signature to all future commits issues from your machine. As a result, GitHub will show a verified badge in the commit's details page, showing your fellow contributors the integrity of the identity shown in relation to the changes you made (like in [commit `74f9009`](https://github.com/AppleGamer22/raker/commit/74f90090539057313d56c2d0d679fa651bd7708b) from [`raker`](https://github.com/AppleGamer22/raker)). Similarly, the `git verify-commit` and `git verify-tag` commands can be used locally to ensure your digital signature is recognised as valid by Git.

```
$ git verify-commit 74f9009
gpg: Signature made Sat 30 Dec 2023 20:48:50 AEDT
gpg:                using RSA key ________________________4DAFB02B4734FE52
gpg:                issuer "omribor@gmail.com"
gpg: Good signature from "Omri Bornstein <omribor@gmail.com>" [ultimate]
```

# SSH Key Storage
Yubico has a great guide[^4] on how to add a hardware-compatible keypair onto a YubiKey FIDO2-compatible model.

1. Connect the YubiKey to your local machine.
1. Generate an [Ed25519](https://en.wikipedia.org/wiki/EdDSA#Ed25519) SSH key pair and follow the prompt to add it to your yubikey.

	```sh
	$ ssh-keygen -t ed25519-sk -O resident -O verify-required
	```

1. Copy to contents of the public key (stored at `~/.ssh/id_ed25519_sk.pub`) to the remote machine.
	* Mainstream Linux distributions would support the use of `ssh-copy-id -i ~/.ssh/id_ed25519_sk.pub user@host` to achieve this.
	* Manually Appending the key to a new line on the remote machine's `~/.ssh/authorized_keys`.
	* [NixOS configuration](#ssh-public-key).

If you want to use the SSH key from your YubiKey on a new machine in order to connect to the remote machine that has the corresponding SSH public key, you would need to register it with SSH with a few simple commands.

1. Insert the key and open a terminal.
1. Change to the SSH directory and regenerate key files from the security key:

	```sh
	$ cd ~/.ssh
	$ ssh-keygen -K
	```

# NixOS Configuration
NixOS can be configured to install all of packages in order to be able to utilise your yubikey for signing and authenticating.

```nix
services = {
  udev.packages = with pkgs; [ yubikey-personalization ];
  pcscd.enable = true;
};
environment.systemPackages = with pkgs; [ pinentry-qt yubikey-manager yubioath-flutter ];
programs.gnupg.agent = {
  enable = true;
  enableSSHSupport = true;
};
```

## Home Folder Configuration Files
Matthew Legitt from Yubico wrote a guide[^5] that specifies some additional configurations that helps to ensure the YubiKey will always be available to GPG as a signing source. I've adapted his recommendations to a [Nix Home Manager](https://nix-community.github.io/home-manager/) configuration.

```nix
home.file = {
  ".gnupg/scdaemon.conf" = {
    text = "disable-ccid";
    executable = false;
  };
};
```

In addition, Home Manager can also set your contact details for Git to include in commits and to choose the appropriate GPG Key for signing them.

```nix
programs.git = {
  userName = "Omri Bornstein";
  userEmail = "omribor@gmail.com";
};
```

## Git Commit Signing
NixOS can be use to configure the global `/etc/gitconfig` file such that Git is able to sign commits and tags.

```nix
programs.git = {
  enable = true;
  config = {
    commit.gpgSign = true;
    tag.gpgSign = true;
  };
};
```

## SSH Public Key
NixoS can also be used to neatly configure [SSH public keys](#ssh-key-storage) for each user.

```nix
users.users.applegamer22.openssh.authorizedKeys.keys = [
  "sk-ssh-ed25519@openssh.com pubic key goes here"
];
```

[^0]: Bucy, D. (2021, June 24). Understanding YubiKey PINs. Yubico. <https://support.yubico.com/hc/en-us/articles/4402836718866-Understanding-YubiKey-PINs>
[^1]: GitHub. (2016). Generating a new GPG key. GitHub Docs. <https://docs.github.com/en/authentication/managing-commit-signature-verification/generating-a-new-gpg-key>
[^2]: Stuart, T. (2022). How to set up Git commit signing with GPG and a YubiKey on macOS [YouTube Video]. In YouTube. <https://youtu.be/7LuMTyhFA-g>
[^3]: `drduh/YubiKey-Guide` (2023). Guide to using YubiKey for GPG and SSH. (2023). GitHub. <https://github.com/drduh/YubiKey-Guide?tab=readme-ov-file#multiple-hosts>
[^4]: Yubico. (2025). Securing SSH with FIDO2. Yubico. <https://developers.yubico.com/SSH/Securing_SSH_with_FIDO2.html>
[^5]: Legitt, M. (2022, May 5). Resolving GPG’s CCID conflicts. Yubico. <https://support.yubico.com/hc/en-us/articles/4819584884124-Resolving-GPG-s-CCID-conflicts>


