---
title: Nix Configuration
date: 2023-06-10
tags: [Nix, NixOS, Linux, macOS, ZSH, Git]
draft: true
---
# Unstable Packages
```nix
{ config, pkgs, ... }:
let
  # ...
  unstablePackages = builtins.fetchTarball "https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz";
  # ...
in
{
  # ...
  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: with pkgs; {
      unstable = import unstablePackages {
        config = config.nixpkgs.config;
      };
    };
  };
  # ...
}
```

# Networking
```nix
networking.hostName = "nixos";
networking.wireless.enable = true;
networking.networkmanager.enable = true;
networking.nameservers = ["1.1.1.1" "8.8.8.8" "9.9.9.9"];
```
# Localization
```nix
time.timeZone = "Australia/Melbourne";
i18n.defaultLocale = "en_GB.UTF-8";
i18n.extraLocaleSettings = {
  LC_ADDRESS = "en_AU.UTF-8";
  LC_IDENTIFICATION = "en_AU.UTF-8";
  LC_MEASUREMENT = "en_AU.UTF-8";
  LC_MONETARY = "en_AU.UTF-8";
  LC_NAME = "en_AU.UTF-8";
  LC_NUMERIC = "en_AU.UTF-8";
  LC_PAPER = "en_AU.UTF-8";
  LC_TELEPHONE = "en_AU.UTF-8";
  LC_TIME = "en_AU.UTF-8";
};
```

# Virtualisation
```nix
virtualisation.docker.enable = true;
virtualisation.virtualbox.host.enable = true;
virtualisation.virtualbox.host.enableExtensionPack = true;
virtualisation.libvirtd.enable = true;
virtualisation.libvirtd.qemu.swtpm.enable = true;
```

# Shell

```nix
programs.zsh = {
  enable = true;
  enableBashCompletion = true;
  setOptions = [
    "INC_APPEND_HISTORY"
    "SHARE_HISTORY"
    "HIST_IGNORE_DUPS"
    "HIST_IGNORE_ALL_DUPS"
    "HIST_SAVE_NO_DUPS"
    "HIST_REDUCE_BLANKS"
    "HIST_IGNORE_SPACE"
  ];
  syntaxHighlighting = {
    enable = true;
    highlighters = ["main" "brackets" "pattern"];
    styles = {
      "default" = "none";
      "unknown-token" = "fg=red,bold";
      "reserved-word" = "fg=cyan,bold";
      "suffix-alias" = "fg=green,underline";
      "global-alias" = "fg=magenta";
      "precommand" = "fg=green,underline";
      "commandseparator" = "fg=blue,bold";
      "autodirectory" = "fg=green,underline";
      "path" = "underline";
      "path_pathseparator" = "";
      "path_prefix_pathseparator" = "";
      "globbing" = "fg=blue,bold";
      "history-expansion" = "fg=blue,bold";
      "command-substitution" = "none";
      "command-substitution-delimiter" = "fg=magenta";
      "process-substitution" = "none";
      "process-substitution-delimiter" = "fg=magenta";
      "single-hyphen-option" = "fg=magenta";
      "double-hyphen-option" = "fg=magenta";
      "back-quoted-argument" = "none";
      "back-quoted-argument-delimiter" = "fg=blue,bold";
      "single-quoted-argument" = "fg=yellow";
      "double-quoted-argument" = "fg=yellow";
      "dollar-quoted-argument" = "fg=yellow";
      "rc-quote" = "fg=magenta";
      "dollar-double-quoted-argument" = "fg=magenta";
      "back-double-quoted-argument" = "fg=magenta";
      "back-dollar-quoted-argument" = "fg=magenta";
      "assign" = "none";
      "redirection" = "fg=blue,bold";
      "comment" = "fg=black,bold";
      "named-fd" = "none";
      "numeric-fd" = "none";
      "arg0" = "fg=green";
      "bracket-error" = "fg=red,bold";
      "bracket-level-1" = "fg=blue,bold";
      "bracket-level-2" = "fg=green,bold";
      "bracket-level-3" = "fg=magenta,bold";
      "bracket-level-4" = "fg=yellow,bold";
      "bracket-level-5" = "fg=cyan,bold";
      "cursor-matchingbracket" = "standout";
    };
  };
  shellAliases = {
    open = "xdg-open $1 2> /dev/null";
    ls = "ls --color";
    rm = "rm -iI --preserve-root";
    la = "ls -AlhF";
    lh = "ls -lhF";
    mv = "mv -i";
    cp = "cp -i";
    ln = "ln -i";
    df = "df -h";
    chown = "chown --preserve-root";
    chmod = "chmod --preserve-root";
    chgrp = "chgrp --preserve-root";
    grep = "grep --color=auto";
    bc = "bc -l";
    gitkraken = "git log --graph --decorate --oneline";
    incognito = " unset HISTFILE";
    mongoexport = "me() {mongoexport -d $1 -c $2 -o $2.json; unset -f me}; me";
  };
  promptInit = ''
    source ${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh
    bindkey "$terminfo[kcuu1]" history-substring-search-up
    bindkey "$terminfo[kcud1]" history-substring-search-down
    zstyle ":completion:*" menu select
    touch ~/.hushlogin
    touch ~/.zshrc
    tabs -4
  '';
};
```

## Prompt
```nix
programs.starship = {
  enable = true;
  settings = {
    time = {
      format = "[$time]($style) ";
      disabled = false;
      use_12hr = true;
      style = "blue bold";
    };
    username = {
      format = "via [$user]($style) ";
      disabled = false;
      show_always = true;
      style_user = "red bold";
      style_root = "red bold";
    };
    hostname = {
      format = "on [$hostname]($style) ";
      ssh_only = false;
      disabled = false;
      style = "green bold";
    };
    directory = {
      format = "in [$path]($style) ";
      disabled = false;
      style = "yellow bold";
    };
    nix_shell.style = "bold cyan";
    cmd_duration.format = "[$duration](bold yellow) ";
    character = {
      success_symbol = "[\\$](bold green)";
      error_symbol = "[\\$](bold red) ";
    };
    add_newline = false;
    format = "$time$username$hostname$directory$git_branch$git_commit$git_state$git_status$package$nodejs$python$golang$java$line_break$cmd_duration$character";
  };
};
```
# User
```nix
users = {
  defaultUserShell = pkgs.zsh;
  users.applegamer22 = {
    isNormalUser = true;
    description = "applegamer22";
    extraGroups = [
      "networkmanager" 
      "wheel"
      "vboxusers"
      "wireshark"
      "libvirt"
      "docker"
    ];
    # packages = with pkgs; [];
  };
};
```

## `git`
```nix
{ config, pkgs, ... }:
let
  # ...
  home-manager = builtins.fetchTarball "https://github.com/rycee/home-manager/archive/release-23.05.tar.gz";
  # ...
in
{
  # ...
  imports = [
    # ...
    (import "${home-manager}/nixos")
    # ...
  ];
 home-manager.useUserPackages = true;
 home-manager.useGlobalPkgs = true;
 home-manager.users.applegamer22 = {
   home.stateVersion = "23.05";
   home.programs.git = {
     enable = true;
     lfs.enable = true;
     userName  = "Omri Bornstein";
     userEmail = "omribor@gmail.com";
     extraConfig = {
       commit.gpgSign = true;
       tag.gpgSign = true;
       push.autoSetupRemote = true;
       # credential.helper = "store";
       core.editor = "nano";
       color = {
         status = "auto";
         branch = "auto";
         interactive = "auto";
         diff = "auto";
       };
     };
   };
 };
  #  ...
}
```

# Desktop
```nix
services.xserver.enable = true;
services.xserver.displayManager.sddm.enable = true;
services.xserver.desktopManager.plasma5.enable = true;
services.xserver = {
  layout = "us";
  xkbVariant = "";
};
services.printing.enable = true;
sound.enable = true;
hardware.pulseaudio.enable = false;
security.rtkit.enable = true;
services.pipewire = {
  enable = true;
  alsa.enable = true;
  alsa.support32Bit = true;
  pulse.enable = true;
};
```

## Fonts
```nix
fonts = {
  enableDefaultFonts = true;
  fontDir.enable = true;
  fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    fira-code
    (nerdfonts.override {
      fonts = ["FiraCode"];
    })
  ];
  fontconfig.defaultFonts.monospace = ["Fira Code"];
};
```

# Server
```nix
networking.firewall.allowedTCPPorts = [];
networking.firewall.allowedUDPPorts = [];
services.openssh.enable = true;
services.openssh.settings.PermitRootLogin = "no";
services.openssh.settings.PasswordAuthentication = false;
users.users.applegamer22.openssh.authorizedKeys.keys = [];
```