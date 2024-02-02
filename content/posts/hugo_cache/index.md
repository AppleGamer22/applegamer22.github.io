---
title: When Hugo's Cache Expires in GitHub Actions
description: When Hugo's Cache Expires in GitHub Actions
date: 2024-02-02
tags: [Hugo, GitHub, CI/CD, cache, Mutahar]
---
The whole ordeal began when I updated the theme of this website to [version 2.8.0](https://github.com/jpanther/congo/releases/tag/v2.8.0), which includes useful improvements such as scrollable table contents for desktop viewports. When I tested the correctness of the rendering with the updated applied, everything seemed normal on my machine, so I pushed it to be built and published through my continuous deployment pipeline. What followed was a 4 hour journey full of local-to-CI-to-local debugging cycles, learning about the speed-ups that Hugo's cache offers and GitHub Actions' caching policy.

# The Error
The journey began when the CI build of this website [failed](https://github.com/AppleGamer22/applegamer22.github.io/actions/runs/7605067673/job/20708815913#step:5:14) at running `hugo --minify`, which converts the website's source code of Markdown files into a complete tree of static web pages comprised of vanilla HTML, CSS and JavaScript files alongside the relevant media assets displayed at each static page.

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
The main thing I wanted to check is performance regressions in the latest version of Hugo that is used in the CI environment in comparison the slightly older version that is shipped in software distributions such as [Nix](https://nixos.org) or [Arch Linux](https://archlinux.org). The CI version of Hugo is the latest (`0.121.2` at the time of writing), and is packaged by the Hugo maintainers and shipped through their website. On my local set-up I install Hugo with a package manager, but I don't believe it's fundamentally different than the first-party package.

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
  # ...
```

While it definitely reduced to the total bundle size of the website, it didn't affect the build time.

### Expired Cache
I think I explored this possibility last because Hugo abstract its caching mechanism so well. Regardless, here is my reasoning as to how the caching discrepancy occurred:

1. With each change, Hugo only updated the changed pages and using the cache for the rest of the pages, thus keeping the build times snappy.
1. The CI workflow that builds and deploys the website after every commit pushed into the `master` branch has its own Hugo cache that closely follows the local one on my machine. As long as the CI cache as maintained, the build times should roughly match between the local and CI environments.
1. Due to an older Hugo update and [GitHub's cache expiry policy](#github-actions-caching-policy), the local and CI caches diverted out of sync, with the local cache remaining and the CI cache no longer available.
1. With the CI cache expired, building the website in the current and more resource heavy form proved to take more than the default timeout[^1] of 30 seconds.

#### Hugo's Cache
From researching the relevant documentation of Hugo[^2] and the Hugo set-up GitHub Actions module[^3] I understood that in [version `0.116.0`](https://github.com/gohugoio/hugo/releases/tag/v0.116.0), the default path of the cache directory was updated (from `/tmp/hugo_cache_runner` to `/home/runner/.cache/hugo_cache`) in order to be more appropriate to each supported operating system. With this path being missing from the CI cache, it was bound to get expired at some point.

#### GitHub Actions Caching Policy
GitHub [encourages](https://docs.github.com/en/actions/using-workflows/caching-dependencies-to-speed-up-workflows) the use of their caching system for developer that use GitHub Actions to continuously build their software with third-party dependencies and want to save some on downloading their dependencies. In order for this feature to be financially viable, old cache entries should be evicted, especially since newer entries will be used more often. Through this experience, I learnt this about GitHub Actions caching[^4]:

* Cache entries that have not been accessed in over 7 days will be evicted.
* Regardless of cache entry age, once a repository reaches the maximum cache size of 10 GB, the oldest cache entry in the repository will be deleted.

# Replicating CI Conditions Locally
After I realised the culprit for the build time issue, I wanted to debug the building process of the website locally with the added condition of unavailable cached resources. Luckily Hugo has the `--ignoreCache` flag, which I toggled on and off as I observed its effects and verified my caching hypothesis. Moreover, I increased the timeout value to 2 minutes in order to allow the website to fully build with no cache, which might happen if I don't update it often and the CI cache expires. In this case, the CI workflow will take more time to successfully finish, but it will generate a new cache entry for the next time it runs.

# Lessons Learned
1. If a software like [Hugo](https://gohugo.io) exhibits unusually optimised performance compared to other offerings in its class, make sure to study it and appreciate the effort its contributors put into making it.
1. Make sure you understand how caching policies affect your build procedure in CI-like conditions before you opt into using caches.
1. Make sure to update caching paths in CI:

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
	      /home/runner/.cache/hugo_cache
	      /tmp/hugo_cache_runner
	      resources/_gen/images
	    key: ${{runner.os}}-hugomod-${{hashFiles('**/go.sum')}}
	    restore-keys: ${{runner.os}}-hugomod-
	  # ...
	```

<details>
<summary>For the meme connoisseurs out there...</summary>

![](thumbnail.jpg "Hopefully [Mutahar](https://x.com/OrdinaryGamers/status/1591224077976764417) appreciates this meme… (made with GIMP)")
</details>


[^1]: Hugo Contributors. (2024, February 1). Configure Hugo: `timeout`. `gohugo.io`. <https://gohugo.io/getting-started/configuration/#timeout>
[^2]: Hugo Contributors. (2024, February 1). Configure Hugo: `cacheDir`. `gohugo.io`. <https://gohugo.io/getting-started/configuration/#configure-cachedir>
[^3]: `peaceiris`. (2022, October 23). `peaceiris/actions-hugo`: GitHub Actions for Hugo - Caching Hugo Modules. GitHub. <https://github.com/peaceiris/actions-hugo?tab=readme-ov-file#%EF%B8%8F-caching-hugo-modules>
[^4]: GitHub. (2024). Caching dependencies to speed up workflows - Usage limits and eviction policy. GitHub Documentation. <https://docs.github.com/en/actions/using-workflows/caching-dependencies-to-speed-up-workflows#usage-limits-and-eviction-policy>
