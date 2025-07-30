---
title: An Overly-configured NAS with NixOS, Syncthing, SMB & Tailscale
description: An Overly-configured NAS with NixOS, Syncthing, Samba & Tailscale
date: 2025-07-30
tags: [Nix, NixOS, Syncthing, SMB, Tailscale]
---
# Tailscale
```nix
services.tailscale = {
  enable = true;
  package = pkgs.unstable.tailscale;
  useRoutingFeatures = "both";
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

# Syncthing
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

# SMB
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
      # note: localhost is the ipv6 localhost ::1
      "hosts allow" = "100.98.193.61 100.69.46.114 100.125.192.26 100.84.43.97 127.0.0.1 localhost";
      "hosts deny" = "0.0.0.0/0";
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