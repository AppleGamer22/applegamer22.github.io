---
title: Handling Secrets in Go with Vault
description: Handling Secrets in Go with Vault
date: 2023-04-12
tags: [Go, HashiCorp, Vault, server]
draft: true
---

```hcl
listener "tcp" {
  address = "0.0.0.0:8200"
  tls_disable = "true"
}

storage "raft" {
  path = "/vault/file"
  node_id = "raft_node1"
}

plugin_directory = "/vault/plugins"
cluster_addr = "http://127.0.0.1:8201"
disable_mlock = "true"
ui = "true"
```

```yml
version: "3"
services:
  vault:
    container_name: vault
    image: vault:1.13.0
    entrypoint: vault server -config=/vault/config/vault-config.hcl
    environment:
      VAULT_DEV_ROOT_TOKEN_ID: applegamer22
      VAULT_API_ADDR: http://0.0.0.0:8200
    volumes:
      - ./configs:/vault/config
      - ./plugins:/vault/plugins
    ports:
      - 8200:8200
      - 8201:8201
    cap_add:
      - IPC_LOCK
```