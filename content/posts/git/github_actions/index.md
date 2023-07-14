---
title: GitHub Actions
date: 2023-07-14
tags: [GitHub, CI/CD]
---
# Deploying Hugo to GitHub Pages
## Event Definitions
For my use case of deploying this website, I deploy on commits/PRs from the `master` branch, manual triggers and in the beginning of the year (Melbourne time).

```yml
# yaml-language-server: $schema=https://json.schemastore.org/github-workflow.json
name: GitHub Pages
on:
  workflow_dispatch:
    inputs: {}
  push:
    branches: [master]
  pull_request:
    branches: [master]
  schedule:
    # Melbourne new year converted to UTC
    - cron: 1 13 31 12 *
```

## Workflow
The core part of the workflow is pretty simple and consist of:

1. Pulling the code for the corresponding commit.
1. Installing the `hugo` CLI on the workflow's environment.
1. Restoring Hugo caches if necessary.
1. Building the website into raw HTML, CSS, JavaScript and media assets.
1. Uploading the assets to the `gh-pages` branch on GitHub.

```yml
# yaml-language-server: $schema=https://json.schemastore.org/github-workflow.json
jobs:
  pages:
    runs-on: ubuntu-latest
    concurrency:
      group: ${{github.workflow}}-${{github.ref}}
    steps:
      - name: Pull Source Code
        uses: actions/checkout@v3
        with:
          submodules: true
          fetch-depth: 0
      - name: Set-up Hugo
        uses: peaceiris/actions-hugo@v2
        with:
          hugo-version: latest
          extended: true
      - name: Cache
        uses: actions/cache@v3
        with:
          path: /tmp/hugo_cache
          key: ${{runner.os}}-hugomod-${{hashFiles('**/go.sum')}}
          restore-keys: ${{runner.os}}-hugomod-
      - name: Build
        run: make website
      - name: Deploy
        uses: peaceiris/actions-gh-pages@v3
        if: github.ref == 'refs/heads/master'
        with:
          github_token: ${{secrets.GITHUB_TOKEN}}
          publish_dir: ./public
```

# Testing Go
## Event Definitions
```yml
# yaml-language-server: $schema=https://json.schemastore.org/github-workflow.json
name: Test
on:
  pull_request:
    types:
      - opened
      - closed
      - reopened
  workflow_dispatch:
    inputs: {}
```

## Workflow
```yml
# yaml-language-server: $schema=https://json.schemastore.org/github-workflow.json
jobs:
  test:
    strategy:
      fail-fast: false
      matrix:
        os:
          - ubuntu-latest
          - macos-latest
          - windows-latest
    runs-on: ${{matrix.os}}
    steps:
      - name: Pull Source Code
        uses: actions/checkout@v3.5.2
      - name: Set-up Go
        uses: actions/setup-go@v4.0.1
        with:
          go-version: stable
      - name: Test
        run: |
          go clean -testcache
          go test -v -race -cover ./...
```