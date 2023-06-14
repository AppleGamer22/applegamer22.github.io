{ config, pkgs, ... }:

{
  imports = [./hardware-configuration.nix];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nixos";
  networking.wireless.enable = true;
  networking.networkmanager.enable = true;

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
        # "lp"
      ];
      packages = with pkgs; [
        firefox
        kate
        # thunderbird
      ];
    };
  };

  nixpkgs.config.allowUnfree = true;

  environment.shells = [pkgs.zsh];
  environment.systemPackages = [];

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
      character = {
        success_symbol = "[\\$](bold green)";
        error_symbol = "[\\$](bold red) ";
      };
      add_newline = false;
      format = ''\
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
      '';
    };
  };
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableBashCompletion = true;
    setOptions = [
      "INC_APPEND_HISTORY"
      "SHARE_HISTORY"
      "HIST_IGNORE_DUPS"
      "HIST_IGNORE_ALL_DUPS"
      "HIST_SAVE_NO_DUPS"
      "HIST_REDUCE_BLANKS"
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
      clear = "printf '\33c\e[3J'";
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
    };
    interactiveShellInit = ''
      source ${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh
      bindkey '^[[A' history-substring-search-up
      bindkey '^[[B' history-substring-search-down
      touch ~/.hushlogin
      tabs -4
      echo -e -n "\x1b[\x35 q"
    '';
    promptInit = ''eval "$(starship init zsh)"'';
  };

  system.stateVersion = "23.05";
}