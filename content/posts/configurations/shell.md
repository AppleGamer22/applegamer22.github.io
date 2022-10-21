---
title: Command-line Shell Configuration
date: 2022-10-21
tags: [ZSH, shell, Linux, macOS, UNIX, git]
description: My ZSH configuration for Linux and macOS
---
This document summarises how I set-up my UNIX-like command-line environment (on Linux and macOS) for easier interaction with command-line interfaces (CLIs).

# ZSH
## Plug-ins

## Manual Pages Colours

## Settings

## Completions

### macOS
If you install your command-line tools with the [Homebrew](https://brew.sh/) package manager, the following code snippet from their documentation[^1] should be added to the appropriate place in `~/.zshrc`:

```shell
FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}
autoload -Uz compinit; compinit
```

#### Docker Desktop
By default, Docker Desktop doesn't install the ZSH completion scripts to where ZSH expects them to be installed on macOS. In order to resolve this, these scripts can be symbolically linked to the correct file system path, as shown on the Docker documentation[^2]:

```shell
etc=/Applications/Docker.app/Contents/Resources/etc
ln -s $etc/docker.zsh-completion $(brew --prefix)/share/zsh/site-functions/_docker
ln -s $etc/docker-compose.zsh-completion $(brew --prefix)/share/zsh/site-functions/_docker-compose
```

#### Terraform

# Core Utilities on macOS

# Prompt

# Aliases

# `git`

[^1]: <https://docs.brew.sh/Shell-Completion#configuring-completions-in-zsh>
[^2]: <https://docs.docker.com/desktop/faqs/macfaqs/#zsh>