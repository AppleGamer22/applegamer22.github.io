---
title: Handling Secrets in Go with Vault
description: Handling Secrets in Go with Vault
date: 2023-04-12
tags: [Go, HashiCorp, Vault, server]
draft: true
---
# Configuration
## HCL
```hcl
listener "tcp" {
  address = "0.0.0.0:8200"
  tls_disable = true
}

storage "file" {
  path = "/vault/file"
}

disable_mlock = true
ui = true
```

## Docker Compose
```yml
version: "3"
services:
  vault:
    container_name: vault
    image: hashicorp/vault:1.13.0
    entrypoint: ["vault", "server", "-config=/vault/config/vault.hcl"]
    environment:
      VAULT_DEV_ROOT_TOKEN_ID: applegamer22
      VAULT_TOKEN: "00000000-0000-0000-0000-000000000000"
      # VAULT_API_ADDR: http://0.0.0.0:8200
    volumes:
      - ./vault/config:/vault/config
      - ./vault/file:/vault/file
    ports:
      - 8200:8200
    cap_add:
      - IPC_LOCK
```

# Go API

```sh
go get github.com/hashicorp/vault/api
```

```go
package main

import (
	"context"
	"log"

	vault "github.com/hashicorp/vault/api"
)

func main() {
	config := vault.DefaultConfig()

	config.Address = "http://127.0.0.1:8200"

	client, err := vault.NewClient(config)
	if err != nil {
		log.Fatalf("unable to initialize Vault client: %v", err)
	}

	secretData := map[string]interface{}{"jwt": "jwt"}
	ctx := context.Background()

	// write a secret
	if _, err = client.KVv2("secret").Put(ctx, "raker", secretData); err != nil {
		log.Fatalf("unable to write secret: %v", err)
	}

	// read a secret
	secret, err := client.KVv2("secret").Get(ctx, "raker")
	if err != nil {
		log.Fatalf("unable to read secret: %v", err)
	}

	value, ok := secret.Data["password"].(string)
	if !ok {
		log.Fatalf("value type assertion failed: %[1]T %#[1]v", secret.Data["password"])
	}

	if value != "jwt" {
		log.Fatalf("unexpected password value %q retrieved from vault", value)
	}
}
```