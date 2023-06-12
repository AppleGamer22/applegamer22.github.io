---
title: Nix Configuration
date: 2023-06-10
tags: [Nix, NixOS]
draft: true
---
# KDE Plasma Desktop
```nix
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

  users.users.applegamer22 = {
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

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = [];

  system.stateVersion = "23.05";

}
```

# Server