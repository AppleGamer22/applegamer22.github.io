---
title: CI/CD with GoReleaser
description: Go (Programming Language) Continuous Integration/Deployment with GoReleaser
date: 2023-02-12
tags: [GoReleaser, Go, Docker, GitHub, CI/CD, SBoM]
---
This document summarises how I set-up [GoReleaser](https://goreleaser.com) Continuous Integration/Deployment (CI/CD) for my [Go (Programming Language)](/tags/go/) projects, such that I have a portable configuration for compilation, packaging and releasing settings. This is especially useful for projects that ship a software package with several files and need a portable way to define how it should be build based on operating system, processor architecture and environment (development, testing or production).

# Global Hooks
GoReleaser [supports](https://goreleaser.com/customization/hooks/) a list of commands that should be run in order before every other task in the build process. I use this feature to automatically generate user manuals and command completion scripts for most of [my projects with a command-line interface](/tags/cli/).

```yml
# yaml-language-server: $schema=https://goreleaser.com/static/schema.json
project_name: cocainate
before:
  hooks:
    - make completion manual
```

# Builds
The Go compiler supports defining compilation parameters such as:

* Root-level package, which is usually where the `main` function is.
* Oerating system (via the `GOOS` environment variable) and processor architecture (via the `GOARCH` environment variable) for compilation target.
* Linker toggles (via `-ldflags` in the `go build` command), which I mainly use to set the constants that store the program's [version](https://semver.org) and [`git`'s commit hash](https://git-scm.com/book/en/v2/Git-Basics-Viewing-the-Commit-History), such the correct values are set for each build.

Depending on the complexity of the build process, it might be easier to [define these parameters](https://goreleaser.com/customization/builds/) in a `.goreleaser.yml` file than writing a less maintainable shell script. The portability of GoReleaser really shines when its [its templating system](https://goreleaser.com/customization/templates/) used, which makes it easier to grab relevant metadata variables during the build process.

```yml
# yaml-language-server: $schema=https://goreleaser.com/static/schema.json
builds:
  - id: linux
    goos:
      - linux
    goarch:
      - amd64
      - arm64
      - riscv64
    ldflags:
      - "-X 'github.com/AppleGamer22/{{.ProjectName}}/commands.Version={{.Version}}'"
      - "-X 'github.com/AppleGamer22/{{.ProjectName}}/commands.Hash={{.FullCommit}}'" 
      # variables defined in the main package don't require their module + package path as a prefix
      - "-X 'main.Production={{.Version}}'"
  - id: mac
    # a specific sub-directory for your .go files can be specified
    dir: cli
    # a specific sub-directory for your main Go package can specified
    main: ./cli
    goos:
      - darwin
    goarch:
      - amd64
      - arm64
```

# Archive Packages
After the builds are complete, each of them can be referenced to be packaged differently. In the following example, Linux and macOS builds are to packaged as a `gzip` archive (due to its availability in these environment), along with command completion scripts for command-line shells that usually ship with these environments. On the other hand, Windows doesn't normally ship the same archive format compatibility, which is why it is packaged using `zip`, along a PowerShell completion script. I also like to define the template for the archive, such that it includes the project name, package version, operating system and processor architecture. For better clarity for macOS users, I like to utilise the name template for the package in order to substitute the substring `darwin` (the name of macOS's kernel) with `mac`.

```yml
# yaml-language-server: $schema=https://goreleaser.com/static/schema.json
archives:
  - id: unix
    builds:
    - linux
    - mac
    name_template: >-
      {{- .ProjectName}}_
      {{- .Version}}_
      {{- if eq .Os "darwin"}}mac{{else}}
        {{- .Os}}
      {{- end}}_
      {{- .Arch}}
    files:
      - "{{.ProjectName}}.*sh"
      - "{{.ProjectName}}.1"
  - id: windows
    builds:
      - windows
    format_overrides:
      - goos: windows
        format: zip
    name_template: "{{.ProjectName}}_{{.Version}}_{{.Os}}_{{.Arch}}"
    files:
      - "{{.ProjectName}}.ps1"
```

# Linux Packages
GoReleaser also integrate its [in-house Linux packager](https://nfpm.goreleaser.com) directly into the `.goreleaser.yml` configuration file. This can used to produce native packages for Alpine-based, Debian-based, RHEL-based and Arch-based Linux distributions from a Go binary. For maximum utility, additional files (and where they should be installed) and dependencies can also be defined.

```yml
# yaml-language-server: $schema=https://goreleaser.com/static/schema.json
nfpms:
  - vendor: AppleGamer22
    maintainer: Omri Bornstein <omribor@gmail.com>
    homepage: https://github.com/AppleGamer22/{{.ProjectName}}
    license: GPL-3.0
    description: a description
    file_name_template: "{{.ProjectName}}_{{.Version}}_{{.Os}}_{{.Arch}}"
    builds:
      - linux
    dependencies:
      # if the distribution names a dependency's package differently, an additional separate nfpms entry would be required
      - dbus
    formats:
      - apk
      - deb
      - rpm
      - archlinux
    contents:
      - src: "{{.ProjectName}}.1"
        dst: /usr/share/man/man1/{{.ProjectName}}.1
      - src: "{{.ProjectName}}.bash"
        dst: /usr/share/bash-completion/completions/{{.ProjectName}}
      - src: "{{.ProjectName}}.fish"
        dst: /usr/share/fish/completions/{{.ProjectName}}.fish
      - src: "{{.ProjectName}}.zsh"
        dst: /usr/share/zsh/site-functions/_{{.ProjectName}}
```

# Checksums

```yml
# yaml-language-server: $schema=https://goreleaser.com/static/schema.json
checksum:
  extra_files:
    - glob: "{{.ProjectName}}.*sh"
    - glob: "{{.ProjectName}}.*1"
```

# Changelog
If you find it tedious to manually write a changelog for your latest release by reading all of the relevant code commits (and their already-written description and metadata), and compiling a detailed changelog, GoReleaser has got you [covered](https://goreleaser.com/customization/changelog/). Assuming the commit messages are well-formatted and descriptive, GoReleaser can compile a neat changelog for you, with commits sorted into groups, and accompanying metadata for each commit. It's worth taking in mind that this won't work as well for unformatted existing commits, and that in order for GoReleaser to sort your future commit messages into groups, they should have a consistent format.

```yml
# yaml-language-server: $schema=https://goreleaser.com/static/schema.json
changelog:
  use: github
  filters:
    # regular expression syntax: https://github.com/google/re2/wiki/Syntax
    exclude:
    - '^docs:'
    - '^test:'
    - '^chore:'
    - typo
    - Merge pull request
    - Merge remote-tracking branch
    - Merge branch
    - go mod tidy
  groups:
    - title: 'New Features'
      regexp: "^.*feat[(\\w)]*:+.*$"
      order: 0
    - title: 'Bug fixes'
      regexp: "^.*fix[(\\w)]*:+.*$"
      order: 10
    - title: Other work
      order: 999
```

# Release

## GitHub

## Arch User Repository

## Homebrew Tap

## Container Images

# Software Bill of Materials

```yml
# yaml-language-server: $schema=https://goreleaser.com/static/schema.json
sboms:
  - artifacts: source
  - artifacts: package
  - artifacts: archive
  - artifacts: binary
```

# CI/CD
## GitHub Actions