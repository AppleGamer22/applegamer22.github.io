---
title: Self-hosted DNS with NixOS, Caddy & CoreDNS
description: Self-hosted DNS with NixOS, Caddy & CoreDNS
date: 2025-07-27
tags: [Nix, NixOS, Caddy, CoreDNS]
draft: true
---

```nix
services.coredns = {
  enable = true;
  config = ''
    . {
        hosts {
            100.121.142.2 raker.nixospi.local
            fallthrough
        }
    }
  '';
};

services.caddy = {
  enable = true;
  email = "omribor@gmail.com";
  virtualHosts = {
    "raker.nixospi.local".extraConfig = ''
      tls internal
      reverse_proxy http://localhost:4100
    '';
  };
};
```