---
title: When Hugo's Cache Expires in GitHub Actions
description: When Hugo's Cache Expires in GitHub Actions
date: 2024-01-22
tags: [Hugo, GitHub, CI/CD, cache]
draft: true
---
The whole ordeal began when I updated the theme of this website to [version 2.8.0](https://github.com/jpanther/congo/releases/tag/v2.8.0), which includes useful improvements such as scrollable table contents for desktop viewports. When I tested the correctness of the rendering with the updated applied, everything seemed normal on my machine, so I pushed it to be built and published through my continuous deployment pipeline. What followed was a 4 hour journey full of local-to-CI-to-local debugging cycles, learning about the speed-ups that Hugo's cache offers and GitHub Actions' caching policy.

# Timed Out
The journey began when the CI build of this website [failed](https://github.com/AppleGamer22/applegamer22.github.io/actions/runs/7605067673/job/20708815913#step:5:14) at running `hugo --minify`.

```
hugo --minify
hugo: downloading modules …
hugo: collected modules in 4251 ms
Start building sites … 
hugo v0.121.2-6d5b44305eaa9d0a157946492a6f319da38de154+extended linux/amd64 BuildDate=2024-01-05T12:21:15Z VendorInfo=gohugoio

ERROR render of "page" failed: "/tmp/hugo_cache_runner/modules/filecache/modules/pkg/mod/github.com/jpanther/congo/v2@v2.8.0/layouts/_default/baseof.html:11:6": execute of template failed: template: _default/single.html:11:6: executing "_default/single.html" at <partial "head.html" .>: error calling partial: partial "head.html" timed out after 30s. This is most likely due to infinite recursion. If this is just a slow template, you can try to increase the 'timeout' config setting.
Total in 64847 ms
```

This was particularly odd, especially because of my experience with building and testing this website and [MonSec's website](https://monsec.io) using the `hugo server` command for a hot-reloading development server. Using the officially endorsed GitHub Actions configuration[^1], along with caching[^2] theme assets resulted in a consistent CI build times that closely resemble the snappy experience of building the website locally.

# GitHub Actions Caching Policy
<https://github.com/actions/cache?tab=readme-ov-file#cache-limits>

<https://docs.github.com/en/actions/using-workflows/caching-dependencies-to-speed-up-workflows>

# Replicating CI Conditions Locally
<https://gohugo.io/getting-started/configuration/#configure-cachedir>

<!-- ![](thumbnail.jpg "Hopefully [Mutahar](https://x.com/OrdinaryGamers/status/1591224077976764417) appreciates this meme… (made with GIMP)") -->

[^1]: Hugo. (2024, January 26). Host on GitHub Pages. `gohugo.io`. <https://gohugo.io/hosting-and-deployment/hosting-on-github/>
[^2]: `peaceiris`. (2022, October 23). `peaceiris/actions-hugo`: GitHub Actions for Hugo - Caching Hugo Modules. GitHub. <https://github.com/peaceiris/actions-hugo?tab=readme-ov-file#%EF%B8%8F-caching-hugo-modules>