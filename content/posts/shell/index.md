---
title: Command-line Shell Configuration
date: 2022-10-21
tags: [ZSH, shell, Linux, macOS, UNIX, Git, VHS]
description: My zsh configuration for Linux and macOS
---
This document summarises how I set-up my UNIX-like command-line environment (on Linux and macOS) for easier interaction with command-line interfaces (CLIs).

# `zsh`
## Plug-ins
* The [syntax highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) plug-in enables more descriptive colourings of commands, flag and strings.
* The [history substring search](https://github.com/zsh-users/zsh-history-substring-search) plug-in enables easier history substring search with less keystrokes.
	* **Note**: This is not commonly packaged in the primary repositories of Debian and Red Hat, which means that you'll need to download the source from the above-mentioned upstream GitHub repository.
* The [additional completion scripts](https://github.com/zsh-users/zsh-completions) plugin adds community-maintained `zsh` [completion](#completions) scripts for programs that don't ship with them by default.
	* **Note**: This is not commonly packaged in the primary repositories of Debian and Red Hat, which means that you'll need to download the source from the above-mentioned upstream GitHub repository.

Platform | Installation Command
---|---
Arch-based | `sudo pacman -S zsh-completions zsh-history-substring-search zsh-syntax-highlighting`
Debian-based | `sudo apt install zsh-syntax-highlighting`
Red Hat-based | `sudo dnf install zsh-syntax-highlighting`
macOS | `brew install zsh-completions zsh-history-substring-search zsh-syntax-highlighting`

The following code should be added to your `~/.zshrc` file in order to use the history substring search and syntax highlighting plug-ins:

```sh
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
	source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
	source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
elif [[ "$OSTYPE" == "darwin"* ]]; then
	source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
	source $(brew --prefix)/share/zsh-history-substring-search/zsh-history-substring-search.zsh
fi
```

## Manual Page Colours
My manual page colour configuration is inspired by [Kali's default `~/.zshrc` file](https://gitlab.com/kalilinux/packages/kali-defaults/-/blob/kali/master/etc/skel/.zshrc):

```sh
export LESS_TERMCAP_mb=$'\E[1;31m'
export LESS_TERMCAP_md=$'\E[1;36m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;33m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_us=$'\E[1;32m'
export LESS_TERMCAP_ue=$'\E[0m'

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
ZSH_HIGHLIGHT_STYLES[default]=none
ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=red,bold
ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=cyan,bold
ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=green,underline
ZSH_HIGHLIGHT_STYLES[global-alias]=fg=magenta
ZSH_HIGHLIGHT_STYLES[precommand]=fg=green,underline
ZSH_HIGHLIGHT_STYLES[commandseparator]=fg=blue,bold
ZSH_HIGHLIGHT_STYLES[autodirectory]=fg=green,underline
ZSH_HIGHLIGHT_STYLES[path]=underline
ZSH_HIGHLIGHT_STYLES[path_pathseparator]=
ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]=
ZSH_HIGHLIGHT_STYLES[globbing]=fg=blue,bold
ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=blue,bold
ZSH_HIGHLIGHT_STYLES[command-substitution]=none
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]=fg=magenta
ZSH_HIGHLIGHT_STYLES[process-substitution]=none
ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]=fg=magenta
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=magenta
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=magenta
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]=fg=blue,bold
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=yellow
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=yellow
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]=fg=yellow
ZSH_HIGHLIGHT_STYLES[rc-quote]=fg=magenta
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=magenta
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=magenta
ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]=fg=magenta
ZSH_HIGHLIGHT_STYLES[assign]=none
ZSH_HIGHLIGHT_STYLES[redirection]=fg=blue,bold
ZSH_HIGHLIGHT_STYLES[comment]=fg=black,bold
ZSH_HIGHLIGHT_STYLES[named-fd]=none
ZSH_HIGHLIGHT_STYLES[numeric-fd]=none
ZSH_HIGHLIGHT_STYLES[arg0]=fg=green
ZSH_HIGHLIGHT_STYLES[bracket-error]=fg=red,bold
ZSH_HIGHLIGHT_STYLES[bracket-level-1]=fg=blue,bold
ZSH_HIGHLIGHT_STYLES[bracket-level-2]=fg=green,bold
ZSH_HIGHLIGHT_STYLES[bracket-level-3]=fg=magenta,bold
ZSH_HIGHLIGHT_STYLES[bracket-level-4]=fg=yellow,bold
ZSH_HIGHLIGHT_STYLES[bracket-level-5]=fg=cyan,bold
ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]=standout
```

## Settings
The following commands set:

* number of commands saved to the history file.
* ability to use the up and down arrow keys
	* to access the history interactively, like in BASH
	* and to search for a prefix in history
* menu-style command completion
* the tab character is displayed as 4 spaces
* the cursor is displayed as a `|` character

```sh
HISTSIZE=1000
SAVEHIST=1000
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
HISTFILE=~/.zsh_history

autoload -Uz compinit && compinit -i
autoload -Uz bashcompinit && bashcompinit -i
zstyle ':completion:*' menu select
if [[ "$OSTYPE" == "darwin"* ]]; then
	zstyle ':completion:*:*:-command-:*:*' ignored-patterns 'clean-diff'
fi

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
touch ~/.hushlogin
tabs -4
echo -e -n "\x1b[\x35 q"
```

## Completions
### Azure CLI
[Azure CLI](https://learn.microsoft.com/en-us/cli/azure/)'s and [`kompose`](https://kompose.io)'s Linux installation requires the following command to be added to `~/.zshrc` file in order to enable command completion:

```sh
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
	source /etc/bash_completion.d/azure-cli
elif [[ "$OSTYPE" == "darwin"* ]]; then
	source $(brew --prefix)/etc/bash_completion.d/az
fi
```

### HashiCorp CLIs
HashiCorp's programs (excluding [`vagrant`](https://www.vagrantup.com)) require a set-up script to be run before their completions are exposed to the shell. Since `terraform`'s completion scripts are already shipped by default on Arch-based Linux distributions, I specifically run its completion script only on macOS.

```sh
if [[ "$OSTYPE" == "darwin"* ]]; then
	complete -o nospace -C $(which terraform) terraform
fi
complete -o nospace -C $(which vault) vault
complete -o nospace -C $(which nomad) nomad
complete -o nospace -C $(which consul) consul
```

### macOS
If you install your command-line tools with the [Homebrew](https://brew.sh) package manager, the following code snippet from their documentation[^1] should be added to the appropriate place in `~/.zshrc` file.

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
By default, [Docker Desktop](https://www.docker.com/products/docker-desktop/) doesn't install the completion scripts to where `zsh` expects them to be installed on macOS. In order to resolve this, these scripts can be symbolically linked to the correct file system path, as shown on the Docker documentation[^2]:

```sh
etc=/Applications/Docker.app/Contents/Resources/etc
ln -s $etc/docker.zsh-completion $(brew --prefix)/share/zsh/site-functions/_docker
ln -s $etc/docker-compose.zsh-completion $(brew --prefix)/share/zsh/site-functions/_docker-compose
```

## Command History Search
[`fzf`](https://github.com/junegunn/fzf) provides an interactive TUI for searching through your command history, invoked with the default <kbd>ctrl</kbd>+<kbd>R</kbd> keyboard shortcut. After [installing](https://github.com/junegunn/fzf?tab=readme-ov-file#linux-packages), the utility can be enabled by adding the following to your `.zshrc` file:

```sh
source <(fzf --zsh)
```

# Core Utilities on macOS
I find the GNU core utilities more feature-rich than the BSD core utilities that are shipped with macOS. As a result, when I need the GNU core utilities on macOS, I install them with the [Homebrew](https://brew.sh) package manager by running: `brew install coreutils binutils gnu-tar gnu-sed grep gawk make bison flex`. These utilities can be enabled from your `~/.zshrc` file:

```sh
if [[ "$OSTYPE" == "darwin"* ]]; then
	PATH="$(brew --prefix)/opt/coreutils/libexec/gnubin:$PATH"
	PATH="$(brew --prefix)/opt/binutils/bin:$PATH"
	PATH="$(brew --prefix)/opt/gnu-tar/libexec/gnubin:$PATH"
	PATH="$(brew --prefix)/opt/gnu-sed/libexec/gnubin:$PATH"
	PATH="$(brew --prefix)/opt/grep/libexec/gnubin:$PATH"
	PATH="$(brew --prefix)/opt/gawk/libexec/gnubin:$PATH"
	PATH="$(brew --prefix)/opt/make/libexec/gnubin:$PATH"
	PATH="$(brew --prefix)/opt/flex/bin:$PATH"
	PATH="$(brew --prefix)/opt/bison/bin:$PATH"
fi
```

# Prompt
I use the prompt program [Starship](https://starship.rs), which enables my prompt to display additional information based on the files in the current directory, such as:

* Git branch
* Git status
* programming language version
* package version

Starships displays the prompt based on a TOML configuration file stored at `~/.config/starship.toml`[^3]. This file defines in which order the information is displayed in the prompt, and also how that information is displayed.

```toml
format = """\
	$time\
	$username\
	$hostname\
	$directory\
	$git_branch\
	$git_commit\
	$git_state\
	$git_status\
	$package\
	$nodejs\
	$python\
	$golang\
	$java\
	$line_break\
	$cmd_duration\
	$character\
"""

add_newline = false
[time]
format = "[$time]($style) "
disabled = false
use_12hr = true
style = "blue bold"
[character]
success_symbol = "[\\$](bold green)"
error_symbol = "[\\$](bold red) "
[cmd_duration]
format = "[$duration](bold yellow) "
[hostname]
format = "on [$hostname]($style) "
ssh_only = false
disabled = false
style = "green bold"
[username]
format = "via [$user]($style) "
disabled = false
show_always = true
style_user = "red bold"
style_root = "red bold"
[directory]
format = "in [$path]($style) "
disabled = false
style = "yellow bold"
```

Don't forget to append Starship's initialisation command to your `~/.zshrc` file:

```sh
eval "$(starship init zsh)"
```

## GIF Demonstration
The following GIF was made using [`vhs`](https://github.com/charmbracelet/vhs) with [this hyperlinked `.tape` file](https://gist.github.com/AppleGamer22/f638088e41dd8195c9d4a0322af5604e):

![A GIF showing my command-line shell prompt configuration](starship.gif "A GIF showing my command-line shell prompt configuration")

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
	alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
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
I use a `~/.gitconfig`[^4] file to configure:

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

# Font
* [Fira Code](https://github.com/tonsky/FiraCode) for programming-related ligatures.
* [Nerd Fonts](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/FiraCode) as fallback for specialised icons.

My Visual Studio Code font family settings are descried below, with the integrated terminal's font set to follow the editor's:

```jsonc
{
	// ...
	"editor.fontFamily": "'Fira Code', 'FiraCode Nerd Font', 'Cascadia Code', 'JetBrains Mono', Menlo, Monaco, 'Courier New', monospace",
	"editor.fontLigatures": true,
	"terminal.integrated.fontFamily": "",
	// ...
}
```

[^1]: <https://docs.brew.sh/Shell-Completion#configuring-completions-in-zsh>
[^2]: <https://docs.docker.com/desktop/faqs/macfaqs/#zsh>
[^3]: <https://starship.rs/config/>
[^4]: <https://git-scm.com/docs/git-config>