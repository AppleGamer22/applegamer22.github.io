---
title: An Overly-configured NAS with NixOS, Syncthing, SMB & Tailscale
description: An Overly-configured NAS with NixOS, Syncthing, SMB & Tailscale
date: 2025-07-30
tags: [Nix, NixOS, Syncthing, SMB, Tailscale]
---
Since discovering Tailscale, I've consolidate my storage of important files in an over-engineered and overly-configured manner using Tailscale, NixOS ~~(by the way)~~, Syncthing, and SMB. Here is how I configured everything with Nix.

# Tailscale
This is the networking backbone of my homelab. I use it for enabling private communications between the storage server and clients from outside the server's local network.

This is the Nix configuration I apply on each NixOS node in order to enable Tailscale and allow it internet access through the local firewall.

```nix
services.tailscale = {
  enable = true;
  useRoutingFeatures = "both";
};

# required per https://wiki.nixos.org/wiki/Tailscale#DNS
services.resolved = {
  enable = true;
  dnssec = "allow-downgrade";
  dnsovertls = "opportunistic";
  domains = [ "~." ];
  fallbackDns = config.networking.nameservers;
};

networking = {
  # ...
  firewall = {
    enable = true;
    allowPing = true;
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ config.services.tailscale.port ];
  };
};
```

## 3rd-Party Clients
* [Fabian Koehler](https://fkoehler.org/)'s [KTailctl](https://github.com/f-koehler/KTailctl) is excellent Tailscale GUI for KDE Plasma.

# Syncthing
Syncthing is perfect for maintaining the same folder contents across multiple peer machines as soon as they change on one of the peers.

Syncthing doesn't really have the notion of servers and clients, but I find it useful to configure the [SMB](#smb) server as a Syncthing peer with an accessible dashboard and ready to sync critical folders. The following Nix configuration is useful for such a "server" peer:

```nix
services.syncthing = {
  enable = true;
  user = "applegamer22";
  dataDir = "/mnt/hdd2/";
  configDir = "/home/applegamer22/.config/syncthing";
  overrideDevices = false;
  overrideFolders = false;
  guiAddress = "0.0.0.0:8384";
  settings.folders = {
    "Music" = {
      path = "/mnt/hdd2/Music";
      ignorePerms = true;
    };
  };
};
systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";
```

Syncthing "client" peers running on NixOS can be set-up using this configuration:

```nix
services.syncthing = {
  enable = true;
  user = "applegamer22";
  dataDir = "/home/applegamer22";
  overrideDevices = false;
  overrideFolders = false;
};
```

Once in a while I still need to approve peers after running system updates. I plan to look into [fully declarative node IDs](https://wiki.nixos.org/wiki/Syncthing#Declarative_node_IDs) within my Nix Flake, which will require me to manage the cryptographic keys through Nix.

## 3rd-Party Clients
* [`Martchus`](https://github.com/Martchus)'s [Syncthing Tray](https://martchus.github.io/syncthingtray/) is excellent Syncthing GUI for KDE Plasma.
* [`Catfriend1`](https://github.com/Catfriend1)'s [Syncthing Android client](https://f-droid.org/en/packages/com.github.catfriend1.syncthingandroid/) is an excellent fork of the [discontinued official client](https://github.com/syncthing/syncthing-android).

# SMB
A remote filesystem can be configured

```nix
services.samba-wsdd = {
  enable = true;
  openFirewall = true;
};

services.samba = {
  enable = true;
  openFirewall = true;
  settings = {
    global = {
      "security" = "user";
      #use sendfile = yes
      #max protocol = smb2
      "hosts deny" = "0.0.0.0/0";
      "interfaces" = "lo tailscale0";
      "bind interfaces only" = "yes";
      "guest account" = "nobody";
      "map to guest" = "bad user";
    };
    hdd = {
      "path" = "/mnt";
      "browseable" = "yes";
      "read only" = "no";
      "guest ok" = "no";
      "create mask" = "0644";
      "directory mask" = "0755";
      "force user" = "applegamer22";
    };
  };
};
```

```nix
environment.systemPackages = with pkgs; [ cifs-utils ];
fileSystems."/run/media/applegamer22/RPI4HDD" = {
  device = "//100.121.142.2/hdd";
  fsType = "cifs";
  # https://www.reddit.com/r/Tailscale/comments/1e672v7/use_these_options_if_you_want_to_mount_a_samba/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
  options = [
    "x-systemd.automount"
    "x-systemd.requires=tailscaled.service"
    "x-systemd.idle-timeout=60"
    "x-systemd.mount-timeout=0"
    "username=applegamer22"
    "uid=1000"
    # u=rwx,g=rx
    "file_mode=0750"
    "dir_mode=0750"
    "users"
    "exec"
    "rw"
    "suid"
    "dev"
    "noatime"
  ];
};
```