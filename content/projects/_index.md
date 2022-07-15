---
title: Projects
date: 2022-07-02
description: A list of my open-source projects
---
## Current Projects
### Go
* [`cocainate`](https://github.com/AppleGamer22/cocainate) is a **cross-platform** re-implementation of the macOS utility [`caffeinate`](https://github.com/apple-oss-distributions/PowerManagement/tree/main/caffeinate) that keeps the screen turned on either until stopped, for a set duration of time or while another process still runs.
* [`stalk`](https://github.com/AppleGamer22/stalk) is a **cross-platform** file-watcher that can run a command after each file-system operation on a given file(s) or simply wait once until a file is changed.
* [rake](https://github.com/AppleGamer22/rake) is a social media scraper that is interfaced via a server-side rendered HTML interface (or a CLI), and is managed by a REST API and a NoSQL database.

## Other Projects
### Research
* As part of the [FIT2082 unit](https://handbook.monash.edu/2021/units/FIT2082), I contributed to an existing codebase, based on prior research by [(Gange, Harabor and Stuckey, 2021)](https://ojs.aaai.org/index.php/ICAPS/article/view/3471) about *Lazy CBS*, their Multi-Agent Path Finding (*MAPF*) algorithm. The *MAPF* problem is a subset of the path finding research field, which presents the additional requirements of multiple agents, each with a unique pair of a source and a target, such that the path between them does not intersect with another path during the same point in time. My task was to modify the *Lazy CBS* codebase such that the algorithm also outputs the final set of constraints that is used to rule out possible paths, such that the Lazy is formally an Explainable Multi-Agent Path Finding (*XMAPF*) algorithm. In addition, I added *Python*-to-*C++* bindings, such that the compiled *Lazy CBS* codebase can be used as a *Python*-facing library for future projects.

### TypeScript & JavaScript
* [scr-web](https://github.com/AppleGamer22/scr-web) (and its [scr-cli](https://github.com/AppleGamer22/scr-cli) counterpart) is my previous attempt at building a full-stack social media scraper, which was abandoned due to the excessive number of dependencies and the rather large build-size.

### Kotlin
* [sp](https://github.com/AppleGamer22/sp) is my first attempt at building a Minecraft server plugin. This plugin adds the requirement that the player supplies the password (via a server command) before proper server interaction is allowed. Until as password is provided, the currently-unauthorized player is blinded and immobile.

## Statistics
Project|Stars|Forks|Issues|PRs|Version
-|-|-|-|-|-
[cocainate](https://github.com/AppleGamer22/cocainate)|![GitHub stars](https://img.shields.io/github/stars/AppleGamer22/cocainate)|![GitHub forks](https://img.shields.io/github/forks/AppleGamer22/cocainate)|![GitHub issues](https://img.shields.io/github/issues/AppleGamer22/cocainate)|![GitHub pull requests](https://img.shields.io/github/issues-pr/AppleGamer22/cocainate)|![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/AppleGamer22/cocainate?label=version&logo=github)
[stalk](https://github.com/AppleGamer22/stalk)|![GitHub stars](https://img.shields.io/github/stars/AppleGamer22/stalk)|![GitHub forks](https://img.shields.io/github/forks/AppleGamer22/stalk)|![GitHub issues](https://img.shields.io/github/issues/AppleGamer22/stalk)|![GitHub pull requests](https://img.shields.io/github/issues-pr/AppleGamer22/stalk)|![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/AppleGamer22/stalk?label=version&logo=github)
[rake](https://github.com/AppleGamer22/rake)|![GitHub stars](https://img.shields.io/github/stars/AppleGamer22/rake)|![GitHub forks](https://img.shields.io/github/forks/AppleGamer22/rake)|![GitHub issues](https://img.shields.io/github/issues/AppleGamer22/rake)|![GitHub pull requests](https://img.shields.io/github/issues-pr/AppleGamer22/rake)|![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/AppleGamer22/rake?label=version&logo=github)
[scr-web](https://github.com/AppleGamer22/scr-web)|![GitHub stars](https://img.shields.io/github/stars/AppleGamer22/scr-web)|![GitHub forks](https://img.shields.io/github/forks/AppleGamer22/scr-web)|![GitHub issues](https://img.shields.io/github/issues/AppleGamer22/scr-web)|![GitHub pull requests](https://img.shields.io/github/issues-pr/AppleGamer22/scr-web)|![Docker Image Version (latest semver)](https://img.shields.io/docker/v/applegamer22/scr-web?logo=docker)
[scr-cli](https://github.com/AppleGamer22/scr-cli)|![GitHub stars](https://img.shields.io/github/stars/AppleGamer22/scr-cli)|![GitHub forks](https://img.shields.io/github/forks/AppleGamer22/scr-cli)|![GitHub issues](https://img.shields.io/github/issues/AppleGamer22/scr-cli)|![GitHub pull requests](https://img.shields.io/github/issues-pr/AppleGamer22/scr-cli)|![npm](https://img.shields.io/npm/v/@applegamer22/scr-cli?logo=npm)
[sp](https://github.com/AppleGamer22/sp)|![GitHub stars](https://img.shields.io/github/stars/AppleGamer22/sp)|![GitHub forks](https://img.shields.io/github/forks/AppleGamer22/sp)|![GitHub issues](https://img.shields.io/github/issues/AppleGamer22/sp)|![GitHub pull requests](https://img.shields.io/github/issues-pr/AppleGamer22/sp)|![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/AppleGamer22/sp?label=version&logo=github)
[FIT2082](https://github.com/AppleGamer22/FIT2082)|![GitHub stars](https://img.shields.io/github/stars/AppleGamer22/FIT2082)|![GitHub forks](https://img.shields.io/github/forks/AppleGamer22/FIT2082)|![GitHub issues](https://img.shields.io/github/issues/AppleGamer22/FIT2082)|![GitHub pull requests](https://img.shields.io/github/issues-pr/AppleGamer22/FIT2082)|![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/AppleGamer22/FIT2082?label=version&logo=github)

[![TryHackMe](https://tryhackme-badges.s3.amazonaws.com/AppleGamer22.png)](https://tryhackme.com/p/AppleGamer22)
[![Hack The Box](https://www.hackthebox.eu/badge/image/529539)](https://app.hackthebox.eu/users/529539)