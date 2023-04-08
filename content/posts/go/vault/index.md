---
title: Handling Secrets in Go with Vault
description: Handling Secrets in Go with Vault
date: 2023-04-12
tags: [Go, HashiCorp, Vault, server]
draft: true
roundedCorners: false
---
# Server Configuration
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
    image: hashicorp/vault:1.13.1
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

# Go Client API

```sh
go get github.com/hashicorp/vault-client-go
```

```go
package main

import (
	"context"
	"log"
	"time"

	vault "github.com/hashicorp/vault-client-go"
	"github.com/hashicorp/vault-client-go/schema"
)

func main() {
	client, err := vault.New(
		vault.WithAddress("http://127.0.0.1:8200"),
		vault.WithRequestTimeout(30*time.Second),
	)
	if err != nil {
		log.Fatalf("unable to initialize Vault client: %v", err)
	}

	// authenticate with a root token (insecure)
	if err := client.SetToken("00000000-0000-0000-0000-000000000000"); err != nil {
		log.Fatal(err)
	}

	secretData := map[string]interface{}{"jwt": "jwt"}
	ctx := context.Background()

	// write a secret
	_, err = client.Secrets.KVv2Write(ctx, "secret", schema.KVv2WriteRequest{Data: secretData})
	if err != nil {
		log.Fatalf("unable to write secret: %v", err)
	}

	// read a secret
	secret, err := client.Secrets.KVv2Read(ctx, "secret")
	if err != nil {
		log.Fatalf("unable to read secret: %v", err)
	}

	value, ok := secret.Data["jwt"].(string)
	if !ok {
		log.Fatalf("value type assertion failed: %[1]T %#[1]v", secret.Data["password"])
	}

	if value != "jwt" {
		log.Fatalf("unexpected password value %q retrieved from vault", value)
	}
}
```