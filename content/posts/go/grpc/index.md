---
title: gRPC with Go & Buf
description: gRPC with Go and Buf
date: 2023-09-19
tags: [gRPC, Buf, Go]
draft: true
---

```yaml
# yaml-language-server: $schema=https://json.schemastore.org/buf.json
version: v1
breaking:
  use:
    - FILE
lint:
  use:
    - DEFAULT
  except:
    - ENUM_VALUE_PREFIX
    - ENUM_ZERO_VALUE_SUFFIX
    - SERVICE_SUFFIX
    - RPC_REQUEST_STANDARD_NAME
    - RPC_RESPONSE_STANDARD_NAME
    - RPC_REQUEST_RESPONSE_UNIQUE
deps:
  - buf.build/googleapis/googleapis
  - buf.build/grpc-ecosystem/grpc-gateway
```

```yaml
# yaml-language-server: $schema=https://json.schemastore.org/buf.work.json
version: v1
directories:
  - proto
```

```yaml
# yaml-language-server: $schema=https://json.schemastore.org/buf.gen.json
version: v1
plugins:
  - plugin: buf.build/protocolbuffers/go
    out: gen/go
    opt: paths=source_relative
  - plugin: buf.build/grpc/go
    out: gen/go
    opt: paths=source_relative
  - plugin: buf.build/grpc-ecosystem/gateway
    out: gen/go
    opt:
      - paths=source_relative
      - generate_unbound_methods=true
  - plugin: buf.build/grpc-ecosystem/openapiv2
    out: gen/openapiv2
```

```yaml
# yaml-language-server: $schema=https://json.schemastore.org/buf.gen.json
version: v1
plugins:
  - plugin: go
    out: gen/go
    opt: paths=source_relative
  - plugin: go-grpc
    out: gen/go
    opt: paths=source_relative
  - plugin: grpc-gateway
    out: gen/go
    opt:
      - paths=source_relative
      - generate_unbound_methods=true
  - plugin: openapiv2
    out: gen/openapiv2
```