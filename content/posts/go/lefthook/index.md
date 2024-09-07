---
title: Sensible Git Hooks with Lefthook and golangci-lint
descriptions: Sensible Git Hooks with Lefthook and golangci-lint
date: 2024-09-03
tags: [go, git, lefthook, TruffleHog, golangci-lint]
draft: true
---
<!--
https://github.com/golangci/golangci-lint/blob/master/docs/src/%40rocketseat/gatsby-theme-docs/src/components/logo.svg
https://github.com/evilmartians/lefthook/blob/master/logo_sign.svg
https://storage.googleapis.com/trufflehog-static-sources/pixel_pig.png
-->
```yml
# yaml-language-server: $schema=https://json.schemastore.org/lefthook.json
# https://github.com/evilmartians/lefthook/issues/66#issuecomment-1313279972
pre-commit:
  piped: true
  commands:
    fmt:
      glob: "*.go"
      run: gofmt -l -w {staged_files}
      stage_fixed: true
      priority: 1
    fmt:
      run: LEFTHOOK_QUIET=meta,success lefthook run lint-test
      priority: 2
list-test:
  parallel: true
  commands:
    lint:
      glob: "*.go"
      run: golangci-lint run {staged_files}
    test:
      glob: "*.go"
      run: go test -cpu 24 -race -count=1 -timeout=30s .
    hog:
      run: trufflehog filesystem --no-update {staged_files}
```
