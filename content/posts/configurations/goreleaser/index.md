---
title: Continuous Integration with GoReleaser
description: Go (Programming Language) Continuous Integration with GoReleaser
date: 2023-02-19
tags: [GoReleaser, Go, Docker, Git, GitHub, CI/CD, SBoM]
---
This document summarises how I set-up [GoReleaser](https://goreleaser.com) Continuous Integration/Deployment (CI/CD) for my [Go (Programming Language)](/tags/go/) projects, such that I have a portable configuration for compilation, packaging and releasing settings. This is especially useful for projects that ship a software package with several files and need a portable way to define how it should be build based on operating system, processor architecture and environment (development, testing or production).

# Pre-requisites
## Software
* [`go`](http://go.dev) command-line interface for the Go programming language
* [`git`](https://git-scm.com) version control system
* [`goreleaser`](https://goreleaser.com) command-line interface
* [`docker`](https://docs.docker.com/engine/) container build system
* [`syft`](https://github.com/anchore/syft) Software Bill of Materials generator

## Online Accounts
* [GitHub](https://github.com) or [GitLab](https://gitlab.com)
	* A remote `git` repository for the source code
	* A remote repository for the [Homebrew Tap](#homebrew-tap) with a separate access token[^1] [^2] with sufficient permissions.
* [Docker Hub](https://hub.docker.com)
	* An [access token](https://docs.docker.com/docker-hub/access-tokens/) with sufficient permissions.
* [Arch User Repository](https://aur.archlinux.org)
	* A public-private [SSH key pair](https://wiki.archlinux.org/title/SSH_keys#Generating_an_SSH_key_pair)

# Global Hooks
GoReleaser [supports](https://goreleaser.com/customization/hooks/) a list of commands that should be run in order before every other task in the build process. I use this feature to automatically generate user manuals and command completion scripts for most of [my projects with a command-line interface](/tags/cli/).

```yml
# yaml-language-server: $schema=https://goreleaser.com/static/schema.json
project_name: {{.ProjectName}}
before:
  hooks:
    - make completion manual
```

The `Makefile` used to define the commands to generate the shell completion scripts and user manuals is listed below. [Cobra library](https://cobra.dev) is used to set-up the CLI and the shell completion generation, and [Mango](https://github.com/muesli/mango-cobra) is used to generate a user manual from the object-oriented definitions of the commands.

```makefile
# assuming the current module has a main function that calls Cobra
.PHONY: completion manual

completion:
	go run . completion bash > cocainate.bash
	go run . completion fish > cocainate.fish
	go run . completion zsh > cocainate.zsh
	go run . completion powershell > cocainate.ps1

# assuming a manual command (that prints the user manual page) exists
manual:
	# test with `go run . manual | man -l -`
	go run . manual > cocainate.1
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
In order to help users verify (cryptographically) the integrity of the software they just downloaded, a checksum file can be made to have the SHA-256 hash value of [selected files](https://goreleaser.com/customization/checksum/). In this example I just left most settings as their default, and added the completion scripts and user manual as extra files to be reflected in the checksum.

```yml
# yaml-language-server: $schema=https://goreleaser.com/static/schema.json
checksum:
  extra_files:
    - glob: "{{.ProjectName}}.*sh"
    - glob: "{{.ProjectName}}.*1"
```

# Changelog
If you find it tedious to manually write a changelog for your latest release by reading all of the relevant code commits (and their already-written description and metadata), and compiling a detailed changelog, GoReleaser has got you [covered](https://goreleaser.com/customization/changelog/). Assuming the commit messages are well-formatted and descriptive, GoReleaser can compile a neat changelog for you, with commits sorted into groups, and accompanying metadata for each commit. It's worth taking in mind that this won't work as well for unformatted existing commits, and that in order for GoReleaser to sort your future commit messages into groups, they should have a consistent format.

The grouping rules for the changelog are defined by [regular expression patterns](https://github.com/google/re2/wiki/Syntax) for the commit messages, such that certain commits are included or excluded from the changelog. I like to define these rules based on a keyword prefix, such as `feat:` for feature commits or `fix:` for bug fixes.

```yml
# yaml-language-server: $schema=https://goreleaser.com/static/schema.json
changelog:
  use: github
  filters:
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
When GoReleaser is run with a current and tagged commit, it can upload the files it generated in the build and archive process to a various distribution platforms such as GitHub and GitLab.

## GitHub
As far as I have been able to check in the [documentation](https://goreleaser.com/customization/release/#github), the GitHub username and repository names cannot be used with the above-mentioned templating system, which means these parameters should be declared explicitly. The following configuration also creates a new [GitHub Discussions](https://github.com/features/discussions) thread after the release has been successfully published to GitHub.

```yml
# yaml-language-server: $schema=https://goreleaser.com/static/schema.json
release:
  # no templates available
  github:
    owner: AppleGamer22
    name: raker
  discussion_category_name: General
  prerelease: auto
  footer: |
    ## Installation
    ### Arch Linux Distributions
    * [`yay`](https://github.com/Jguer/yay):
    ```bash
    yay -S {{.ProjectName}}-bin
    ```
    * [`paru`](https://github.com/morganamilo/paru):
    ```bash
    paru -S {{.ProjectName}}-bin
    ```
    ### macOS
    * [Homebrew Tap](https://github.com/AppleGamer22/homebrew-{{.ProjectName}}):
    ```bash
    brew install AppleGamer22/tap/{{.ProjectName}}
    ```
```

## Arch User Repository
The [AUR](http://aur.archlinux.org) is repository with a wide range of installation scripts that are not available in the official Arch Linux distribution through the official package manager. After releasing to [GitHub](#github) or GitLab, your [custom](https://goreleaser.com/customization/aur/) installation script can be uploaded to the AUR, thus allowing Arch Linux user of [`yay`](https://github.com/Jguer/yay) or [`paru`](https://github.com/Morganamilo/paru) to get your software more easily.


```yml
# yaml-language-server: $schema=https://goreleaser.com/static/schema.json
aurs:
    # no templates available
  - homepage: https://github.com/AppleGamer22/raker
    description: description
    license: GPL3
    maintainers:
      - Omri Bornstein <omribor@gmail.com>
    contributors:
      - Omri Bornstein <omribor@gmail.com>
    private_key: "{{.Env.AUR_SSH_PRIVATE_KEY}}"
    # no templates available
    git_url: ssh://aur@aur.archlinux.org/raker-bin.git
    depends:
      - dbus
    optdepends:
      - bash
      - fish
      - zsh
    # no templates available
    package: |
      install -Dm755 raker "${pkgdir}/usr/bin/{{.ProjectName}}"
      install -Dm644 raker.1 "${pkgdir}/usr/share/man/man1/{{.ProjectName}}.1"
      install -Dm644 raker.bash "${pkgdir}/usr/share/bash-completion/completions/{{.ProjectName}}"
      install -Dm644 raker.fish "${pkgdir}/usr/share/fish/vendor_completions.d/{{.ProjectName}}.fish"
      install -Dm644 raker.zsh "${pkgdir}/usr/share/zsh/site-functions/_{{.ProjectName}}"
    commit_author:
      name: Omri Bornstein
      email: omribor@gmail.com
```

## Homebrew Tap
[Homebrew](https://brew.sh) is a popular package repository among macOS users, which allows the additions of third-party repositories, colloquially known as Taps. Similarly to the AUR, tap repositories host installation scripts that the `brew` CLI can understand.  After releasing to [GitHub](#github) or GitLab, your [custom](https://goreleaser.com/customization/homebrew/) installation script can be uploaded to your tab repository on **GitHub**.

```yml
# yaml-language-server: $schema=https://goreleaser.com/static/schema.json
brews:
  - tap:
      owner: AppleGamer22
      name: homebrew-tap
      token: "{{.Env.TAP_GITHUB_TOKEN}}"
    download_strategy: CurlDownloadStrategy
    commit_author:
      name: Omri Bornstein
      email: omribor@gmail.com
    homepage: https://github.com/AppleGamer22/{{.ProjectName}}
    description: description
    license: GPL-3.0
    install: |
      bin.install "{{.ProjectName}}"
      man1.install "{{.ProjectName}}.1"
      bash_completion.install "{{.ProjectName}}.bash" => "{{.ProjectName}}"
      fish_completion.install "{{.ProjectName}}.fish"
      zsh_completion.install "{{.ProjectName}}.zsh" => "_{{.ProjectName}}"
```

## Container Images
A lot of projects written in Go are meant to run as a server with corresponding TCP or UDP port(s), and the standard for packaging such software is the [Open Container Initiative](https://opencontainers.org). If you have never heard of this standard, you might have heard of [Docker](https://docker.com), which is the first implementation of this standard's specification. [Configuring](https://goreleaser.com/customization/docker/) GoReleaser to build and publish OCI-compliant container images allows easier multi-registry publishing, enabling multi-platform builds, and injecting environment variables to linker flags.

```yml
# yaml-language-server: $schema=https://goreleaser.com/static/schema.json
dockers:
  - use: buildx
    image_templates:
      # Docker Hub
      - "docker.io/applegamer22/{{.ProjectName}}:{{.Version}}"
      - "docker.io/applegamer22/{{.ProjectName}}:latest"
      # GitHub Container Registry
      - "ghcr.io/applegamer22/{{.ProjectName}}:{{.Version}}"
      - "ghcr.io/applegamer22/{{.ProjectName}}:latest"
    build_flag_templates:
      - "--pull"
      - "--platform=linux/amd64,linux/arm64"
      - "--label=org.opencontainers.image.created={{.Date}}"
      - "--label=org.opencontainers.image.title={{.ProjectName}}"
      - "--label=org.opencontainers.image.revision={{.FullCommit}}"
      - "--label=org.opencontainers.image.version={{.Version}}"
      # imitating linker flags
      - "--build-arg VERSION={{.Version}}"
      - "--build-arg HASH={{.FullCommit}}"
    extra_files:
      - templates
      - assets
```

# Software Bill of Materials
In order to allow easier automated security analysis by third-parties, GoReleaser can [create](https://goreleaser.com/customization/sbom/) a Software Bill of Materials (SBoM) for other people to analyse and potentially find issues your software's dependencies more easily. In the following example, a separate SBoM for each package binary (and the source code) is made, and uploaded to your preferred publishing channel.

[`syft`](https://github.com/anchore/syft) is required as a dependency of GoReleaser for this feature to work.

```yml
# yaml-language-server: $schema=https://goreleaser.com/static/schema.json
sboms:
  - artifacts: source
  - artifacts: package
  - artifacts: archive
  - artifacts: binary
```

# Continuous Integration
Since GoReleaser is published as a [CLI](https://goreleaser.com/cmd/goreleaser/), its highly-programmable nature allows easy [integration](https://goreleaser.com/ci/) into custom automated workflows.

## GitHub Actions
I use GoReleaser [GitHub Actions integration](https://goreleaser.com/ci/actions/) to build, package and release my open-source projects automatically after a stable [semantic version](https://goreleaser.com/limitations/semver/) `git` tag is pushed to GitHub. The above-mentioned [access tokens](#online-accounts) are injected into the appropriate workflow steps as [workflow secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets).

```yml
# yaml-language-server: $schema=https://json.schemastore.org/github-workflow.json
name: Release
on:
  push:
    tags: 
      - 'v*'
      - '!*alpha*'
      - '!*beta*'
      - '!*rc*'
permissions:
  contents: write
  packages: write
jobs:
  github_release:
    runs-on: ubuntu-latest
    steps:
      - name: Pull Source Code
        uses: actions/checkout@v3
        with:
          fetch-depth: 0
      - name: Fetch All Tags
        run: git fetch --force --tags
      - name: Set-up Go
        uses: actions/setup-go@v3
        with:
          go-version: stable
      - name: Set-up QEMU
        uses: docker/setup-qemu-action@v2.1.0
      - name: Set-up Docker BuildX
        uses: docker/setup-buildx-action@v2.4.1
      - name: Sign-in to Docker Container Registry
        uses: docker/login-action@v2
        with:
          username: ${{secrets.DOCKER_USERNAME}}
          password: ${{secrets.DOCKER_TOKEN}}
      - name: Set-up Syft
        uses: anchore/sbom-action/download-syft@v0.13.3
      - name: Build, Package & Distribute
        uses: goreleaser/goreleaser-action@v4
        with:
          distribution: goreleaser
          version: latest
          args: release --clean
        env:
          GITHUB_TOKEN: ${{secrets.GITHUB_TOKEN}}
          TAP_GITHUB_TOKEN: ${{ secrets.TAP_GITHUB_TOKEN }}
          AUR_SSH_PRIVATE_KEY: ${{secrets.AUR_SSH_PRIVATE_KEY}}
```

[^1]: GitHub Access Token: <https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token>
[^2]: GitLab Access Token: <https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html>