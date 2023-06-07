---
title: Clearing EXIF Metadata
description: Clearing EXIF metadata with exiftool
date: 2023-06-29
tags: [EXIF]
---
Do you know that your smartphone saves the location of your photos inside the file itself? Or that your image editing software declares that it processed your pictures? Even when most mainstream websites and [static site generators](https://gohugo.io/content-management/image-processing/#image-processing-methods) wipe EXIF metadata before they expose your uploaded images, it is still important to understand what metadata can be stored inside your images. When you upload unprocessed pictures to a publicly-accessible server such as a website or a public `git` repository (on GitHub, GitLab, Gitea or self-hosted), making sure that no sensitive metadata that is is left for anybody on the internet to look at.

# Command-line Interfaces
In case you want to wipe out all EXIF metadata from command-line as part of an automated image processing pipeline, or just for fun, `exiftool` is an awesome [open-source](https://github.com/exiftool/exiftool) command-line utility that makes it easy to edit EXIF (and [other formats](https://exiftool.org/TagNames/index.html)). For further details about other more granular toggles that I don't cover here, please refer to the [`exiftool` documentation](https://exiftool.org/exiftool_pod.html#Writing).

## Keeping Adobe Colour Metadata
For some reason, Adobe chose to store some colouring information in the EXIF header of files that are produced by their software. In order to maintain visual detail but still remove the rest of the EXIF header, the `-All=` toggle can be used.

```sh
# remove all EXIF data a except for the APP14 Adobe block
exiftool -All= image.jpg
```

## Removing All Metadata
If you really want to remove all metadata, the `-all=` toggle should be used for more aggressive metadata cleaning.

```sh
# remove all EXIF data
exiftool -all= image.jpg
```
# Graphical Interfaces
* [Windows](https://www.microsoft.com/en-us/microsoft-365-life-hacks/privacy-and-safety/how-to-remove-metadata-from-photos)