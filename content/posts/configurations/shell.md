---
title: Command-line Shell Configuration
date: 2022-10-21
tags: [ZSH, shell, Linux, macOS, UNIX, git]
description: My ZSH configuration for Linux and macOS
---
This document summarises how I set-up my UNIX-like command-line environment (on Linux and macOS) for easier interaction with command-line interfaces (CLIs).

# ZSH
## Plug-ins
* The [syntax highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) plug-in enables more descriptive colourings of commands, flag and strings.
* The [history substring search](https://github.com/zsh-users/zsh-history-substring-search) plug-in enables easier history substring search with less keystrokes.
	* **Note**: This is not commonly packaged in the primary repositories of Debian and Red Hat, which means that you'll need to download the source from the above-mentioned upstream GitHub repository.
* The [additional completion scripts](https://github.com/zsh-users/zsh-completions) plugin adds community-maintained ZSH [completion](#completions) scripts for programs that don't ship with them by default.
	* **Note**: This is not commonly packaged in the primary repositories of Debian and Red Hat, which means that you'll need to download the source from the above-mentioned upstream GitHub repository.

Platform | Installation Command
---|---
Arch-based | `sudo pacman -S zsh-completions zsh-history-substring-search zsh-syntax-highlighting`
Debian-based | `sudo apt install zsh-syntax-highlighting`
Red Hat-based | `sudo dnf install zsh-syntax-highlighting`
macOS | `brew install zsh-completions zsh-history-substring-search zsh-syntax-highlighting`

The following code should be added to your `~/.zshrc` in order to use the history substring search and syntax highlighting plug-ins:

```sh
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
	source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
	source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
elif [[ "$OSTYPE" == "darwin"* ]]; then
	source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
	source $(brew --prefix)/share/zsh-history-substring-search/zsh-history-substring-search.zsh
fi
```

## Manual Pages Colours

## Settings

## Completions

### macOS
If you install your command-line tools with the [Homebrew](https://brew.sh/) package manager, the following code snippet from their documentation[^1] should be added to the appropriate place in `~/.zshrc`.

In my case, the following configuration worked the best, since other tools (such as [`vagrant`](https://github.com/hashicorp/vagrant)) keep the completions in other places:

```sh
if [[ "$OSTYPE" == "darwin"* ]]; then
	FPATH="$(brew --prefix)/share/zsh/site-functions:$(brew --prefix)/share/zsh-completions:${FPATH}"
fi
```

Otherwise, this shorter `FPATH` extension would also work:

```sh
if [[ "$OSTYPE" == "darwin"* ]]; then
	FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi
```

#### Docker Desktop
By default, Docker Desktop doesn't install the ZSH completion scripts to where ZSH expects them to be installed on macOS. In order to resolve this, these scripts can be symbolically linked to the correct file system path, as shown on the Docker documentation[^2]:

```sh
etc=/Applications/Docker.app/Contents/Resources/etc
ln -s $etc/docker.zsh-completion $(brew --prefix)/share/zsh/site-functions/_docker
ln -s $etc/docker-compose.zsh-completion $(brew --prefix)/share/zsh/site-functions/_docker-compose
```

#### Terraform

# Core Utilities on macOS
I find the GNU core utilities more feature-rich than the BSD core utilities that are shipped with macOS. As a result, when I need the GNU core utilities on macOS, I install them with the [Homebrew](https://brew.sh/) package manager by running: `brew install coreutils gnu-tar gnu-sed grep`. This utilities can be enabled from your `~/.zshrc`:

```sh
if [[ "$OSTYPE" == "darwin"* ]]; then
	PATH="$(brew --prefix)/opt/coreutils/libexec/gnubin:$PATH"
	PATH="$(brew --prefix)/opt/gnu-tar/libexec/gnubin:$PATH"
	PATH="$(brew --prefix)/opt/gnu-sed/libexec/gnubin:$PATH"
	PATH="$(brew --prefix)/opt/grep/libexec/gnubin:$PATH"
fi
```

# Prompt

# Aliases
The following aliases are useful if you stick with the default BSD core utilities of macOS:

```sh
if [[ "$OSTYPE" == "darwin"* ]]; then
	alias ls='ls -G'
	alias rm='rm -i'
fi
```

These aliases are useful for a more convenient and colourful command-line experience:

```sh
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
	alias open='xdg-open $1 2> /dev/null'
elif [[ "$OSTYPE" == "darwin"* ]]; then
	alias python="$(brew --prefix)/bin/python3"
	alias python3="$(brew --prefix)/bin/python3"
	alias pip="$(brew --prefix)/bin/pip3"
	alias pip3="$(brew --prefix)/bin/pip3"
fi

alias ls='ls --color'
alias rm='rm -iI --preserve-root'
alias clear="printf '\33c\e[3J'"
alias la='ls -AlhF'
alias lh='ls -lhF'
alias mv='mv -i'
alias cp='cp -i'
alias ln='ln -i'
alias df='df -h'
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'
alias grep='grep --color=auto'
alias bc='bc -l'
alias gitkraken='git log --graph --decorate --oneline'
```

# `git`
I use a `~/.gitconfig` file to configure:

* my author details
* cryptographic signatures
* auto-push new branches
* command-line editor
* more colourful output

```
[user]
	name = Omri Bornstein
	email = omribor@gmail.com
[commit]
	gpgSign = true
[tag]
	gpgSign = true
[push]
	autoSetupRemote = true
[core]
	editor = nano
[color]
	status = auto
	branch = auto
	interactive = auto
	diff = auto
```

[^1]: <https://docs.brew.sh/Shell-Completion#configuring-completions-in-zsh>
[^2]: <https://docs.docker.com/desktop/faqs/macfaqs/#zsh>