---
title: When Hugo's Cache Expires in GitHub Actions
description: When Hugo's Cache Expires in GitHub Actions
date: 2024-01-22
tags: [Hugo, GitHub, CI/CD, cache]
draft: true
---
The whole ordeal began when I updated the theme of this website to [version 2.8.0](https://github.com/jpanther/congo/releases/tag/v2.8.0), which includes useful improvements such as scrollable table contents for desktop viewports. When I tested the correctness of the rendering with the updated applied, everything seemed normal on my machine, so I pushed it to be built and published through my continuous deployment pipeline. What followed was a 4 hour journey full of local-to-CI-to-local debugging cycles, learning about the speed-ups that Hugo's cache offers and GitHub Actions' caching policy.

# The Error
The journey began when the CI build of this website [failed](https://github.com/AppleGamer22/applegamer22.github.io/actions/runs/7605067673/job/20708815913#step:5:14) at running `hugo --minify`.

```
$ hugo --minify
hugo: downloading modules …
hugo: collected modules in 4251 ms
Start building sites … 
hugo v0.121.2-6d5b44305eaa9d0a157946492a6f319da38de154+extended linux/amd64 BuildDate=2024-01-05T12:21:15Z VendorInfo=gohugoio

ERROR render of "page" failed: "/tmp/hugo_cache_runner/modules/filecache/modules/pkg/mod/github.com/jpanther/congo/v2@v2.8.0/layouts/_default/baseof.html:11:6": execute of template failed: template: _default/single.html:11:6: executing "_default/single.html" at <partial "head.html" .>: error calling partial: partial "head.html" timed out after 30s. This is most likely due to infinite recursion. If this is just a slow template, you can try to increase the 'timeout' config setting.
Total in 64847 ms
```

This timeout error is a stark contrast to what is a usually snappy build on my local machine. It's expected that my local instance of Hugo already downloaded the Congo theme, but this added delay doesn't explain the difference between this CI run to the runs before it. For example here is what I'd normally expect on my local machine, which I grew to expect to be only slightly faster that the CI build times.

```
$ hugo --minify
Start building sites …
hugo v0.120.3+extended linux/amd64 BuildDate=unknown VendorInfo=nixpkgs

                   | EN
-------------------+------
  Pages            | 230
  Paginator pages  |  13
  Non-page files   |  64
  Static files     |  15
  Processed images | 156
  Aliases          |  96
  Sitemaps         |   1
  Cleaned          |   0

Total in 288 ms
```

Like any good CI error, replicating it was a classic game of elimination of variables and replication of the conditions between the CI and local environments.

## Elimination & Replication
I tried checking the effect of the following variables on the build time in the CI environment. In retrospect, some of these seem to not have as much as a profound effect on the build time, but it's worth checking all possibilities nonetheless

### Hugo Versions
The main thing I wanted to check is performance regressions in the latest version of Hugo that is used in the CI environment in comparison the slightly older version that is shipped in software distributions such as [Nix](https://nixos.org) or [Arch Linux](https://archlinux.org). The CI version of Hugo is the latest (0.121.2 at the time of writing), and is packaged by the Hugo maintainers and shipped through their website. On my local set-up I install Hugo with a package manager, but I don't believe it's fundamentally different than the first-party package.

I tested the effects of reverting to an older version of Hugo by manually defining the version in the input variables of the set-up stage.

```yml
# yaml-language-server: $schema=https://json.schemastore.org/github-workflow.json
name: GitHub Pages
# ...
jobs:
  pages:
    # ...
    steps:
      # ...
      - name: Set-up Hugo
        uses: peaceiris/actions-hugo@v2
        with:
          hugo-version: "0.120.3"
          extended: true
      # ...
```

This had no effect on the error message.

### Congo Version & Image Optimisations
Congo 2.8.0 introduced more aggressive image optimisation support by automatically converting the set source images to multiple subsets of optimised images of various sizes and formats. The main change was the addition of a [WebP](https://github.com/stereobooster/congo/blob/c8b33ae51ec3b011c9a2364ef06c525febc09aa2/layouts/partials/picture.html) image set for all source images. I wanted if the additional CPU time required to produce an additional set of optimised images is the culprit to the CI build taking too long, and luckily the Congo contributors made it easy to disable with a configuration option.

```yml
# yaml-language-server: $schema=https://json.schemastore.org/hugo.json
# ...
params:
  # ...
  enableImageWebp: false
```

While it definitely reduced to the total bundle size of the website, it didn't affect the build time.

### Expired Cache


# GitHub Actions Caching Policy
<https://github.com/actions/cache?tab=readme-ov-file#cache-limits>

<https://docs.github.com/en/actions/using-workflows/caching-dependencies-to-speed-up-workflows>

# CI Pipeline
The CI pipeline of this website has its origins in the CI infrastructure of the [MonSec website](https://monsec.io).

```yml
# yaml-language-server: $schema=https://json.schemastore.org/github-workflow.json
name: GitHub Pages
# ...
jobs:
  pages:
    # ...
    steps:
      # ...
      - name: Cache
        uses: actions/cache@v4
        with:
          path: |
            /tmp/hugo_cache_runner
            resources/_gen/images
          key: ${{runner.os}}-hugomod-${{hashFiles('**/go.sum')}}
          restore-keys: ${{runner.os}}-hugomod-
      # ...
```

# Replicating CI Conditions Locally
<https://gohugo.io/getting-started/configuration/#configure-cachedir>

<!-- ![](thumbnail.jpg "Hopefully [Mutahar](https://x.com/OrdinaryGamers/status/1591224077976764417) appreciates this meme… (made with GIMP)") -->

[^1]: Hugo. (2024, January 26). Host on GitHub Pages. `gohugo.io`. <https://gohugo.io/hosting-and-deployment/hosting-on-github/>
[^2]: `peaceiris`. (2022, October 23). `peaceiris/actions-hugo`: GitHub Actions for Hugo - Caching Hugo Modules. GitHub. <https://github.com/peaceiris/actions-hugo?tab=readme-ov-file#%EF%B8%8F-caching-hugo-modules>