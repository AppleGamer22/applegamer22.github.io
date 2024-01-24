---
title: When Hugo's Cache Expires in GitHub Actions
description: When Hugo's Cache Expires in GitHub Actions
date: 2024-01-22
tags: [Hugo, GitHub, CI/CD, cache]
draft: true
---
The whole ordeal began when I updated the theme of this website to [version 2.8.0](https://github.com/jpanther/congo/releases/tag/v2.8.0), which includes useful improvements such as scrollable table contents for desktop viewports. When I tested the correctness of the rendering with the updated applied, everything seemed normal on my machine, so I pushed it to be built and published through my continuous deployment pipeline. What followed was a 4 hour journey full of local-to-CI-to-local debugging cycles, learning about Hugo's cache and GitHub Actions' caching policy.

<https://github.com/actions/cache?tab=readme-ov-file#cache-limits>

<https://docs.github.com/en/actions/using-workflows/caching-dependencies-to-speed-up-workflows>

<https://gohugo.io/getting-started/configuration/#configure-cachedir>

<https://x.com/OrdinaryGamers/status/1591224077976764417>