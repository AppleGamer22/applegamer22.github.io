---
title: TryHackMe OhSINT
description: TryHackMe OhSINT open-source intelligence challenge
date: 2021-07-03
tags: [TryHackMe, OSINT, EXIF]
---
This is my attempt at TryHackMe's [OhSINT](https://tryhackme.com/room/ohsint) challenge. We are given a JPEG as a starting point.

![The provided JPEG showing the default Windows XP desktop wallpaper](WindowsXP.jpg "The provided JPEG showing the default Windows XP desktop wallpaper")


# What is this user's avatar of?
1. By running examining the picture's EXIF metadata, the following output tells that `OWoodflint` is a possible link:

	```
	$ exiftool WindowsXP.jpg
	ExifTool Version Number         : 12.16
	File Name                       : WindowsXP.jpg
	Directory                       : .
	File Size                       : 229 KiB
	File Modification Date/Time     : 2021:04:10 14:52:00+10:00
	File Access Date/Time           : 2021:04:10 14:51:59+10:00
	File Inode Change Date/Time     : 2021:04:10 14:52:08+10:00
	File Permissions                : rw-r--r--
	File Type                       : JPEG
	File Type Extension             : jpg
	MIME Type                       : image/jpeg
	XMP Toolkit                     : Image::ExifTool 11.27
	GPS Latitude                    : 54 deg 17' 41.27" N
	GPS Longitude                   : 2 deg 15' 1.33" W
	Copyright                       : OWoodflint
	Image Width                     : 1920
	Image Height                    : 1080
	Encoding Process                : Baseline DCT, Huffman coding
	Bits Per Sample                 : 8
	Color Components                : 3
	Y Cb Cr Sub Sampling            : YCbCr4:2:0 (2 2)
	Image Size                      : 1920x1080
	Megapixels                      : 2.1
	GPS Latitude Ref                : North
	GPS Longitude Ref               : West
	GPS Position                    : 54 deg 17' 41.27" N, 2 deg 15' 1.33" W
	```

2. The Twitter profile [@OWoodflint](https://twitter.com/OWoodflint) has a cat in its avatar.

**Answer**: `cat`

# What city is this person in?
* The GitHub user [@OWoodfl1nt](https://github.com/OWoodfl1nt) has a GitHub repository [OWoodfl1nt/people_finder](https://github.com/OWoodfl1nt/people_finder), and it's [README.md](https://github.com/OWoodfl1nt/people_finder/blob/master/README.md) says:

> ## `people_finder`
> Hi all, I am from London, I like taking photos and open source projects.
>
> Follow me on twitter: @OWoodflint
>
> This project is a new social network for taking photos in your home town.
>
> Project starting soon! Email me if you want to help out: `OWoodflint@gmail.com`

**Answer**: `London`

# Whats the SSID of the WAP he connected to?
1. The Twitter profile [@OWoodflint](https://twitter.com/OWoodflint) wrote in a [Twitter status](https://twitter.com/OWoodflint/status/1102220421091463168):
<blockquote class="twitter-tweet"><p lang="en" dir="ltr">From my house I can get free wifi ;D<br><br>Bssid: B4:5D:50:AA:86:41 - Go nuts!</p>&mdash; 0x00000000000000000000 (@OWoodflint) <a href="https://twitter.com/OWoodflint/status/1102220421091463168?ref_src=twsrc%5Etfw">March 3, 2019</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

2. The website <https://www.wigle.net/> tells us that the BSSID `B4:5D:50:AA:86:41` has an SSID of `UnileverWiFi`.

**Answer**: `UnileverWiFi`

# Where has he gone on holiday?
* According to Oliver Woodflint's [website](https://oliverwoodflint.wordpress.com/author/owoodflint/):

> Im in New York right now, so I will update this site right away with new photos!

**Answer**: `New York`

# What is this persons password?
* Inside to Oliver Woodflint's [website](https://oliverwoodflint.wordpress.com/author/owoodflint/) HTML code:

```html
<p style="color: #ffffff;" class="has-text-color">pennYDr0pper.!</p>
```
**Answer**: `pennYDr0pper.!`

# References
* Hammond, J. (2020). TryHackMe! OhSINT - METADATA & Research [YouTube Video]. In YouTube. <https://youtu.be/oF0TQQmFu4w>
* OWoodfl1nt. (2019, March 3). OWoodfl1nt/people_finder. GitHub. <https://github.com/OWoodfl1nt/people_finder/blob/master/README.md>
* OWoodflint. (2019, March 4). Twitter status. Twitter. <https://twitter.com/OWoodflint/status/1102220421091463168>
* WiGLE.net. (2011). WiGLE: Wireless Network Mapping. wigle.net. <https://www.wigle.net/>
* Woodflint, O. (2019, March 3). Oliver Woodflint Blog. Oliver Woodflint Blog; Oliver Woodflint Blog. <https://oliverwoodflint.wordpress.com/author/owoodflint/>