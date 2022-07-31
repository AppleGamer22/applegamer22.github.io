---
title: OverTheWire Bandit Level 12 - 13
date: 2022-07-28T12:00:00
tags: [OverTheWire, Bandit, Linux, shell]
---
# Prompt
> The password for the next level is stored in the file `data.txt`, which is a hexadecimal dump of a file that has been repeatedly compressed. For this level it may be useful to create a directory under `/tmp` in which you can work using `mkdir`.

# Solution
```sh
$ ssh bandit12@bandit.labs.overthewire.org -p 2220
bandit12@bandit.labs.overthewire.org password: 5Te8Y4drgCRfCx8ugdwuEX8KFC6k2EUu
bandit12@bandit:~$ ls
data.txt
bandit12@bandit:~$ mkdir /tmp/bandit12
bandit12@bandit:~$ cp data.txt /tmp/bandit12
bandit12@bandit:~$ cd /tmp/bandit12
bandit12@bandit:/tmp/bandit12$ xxd -r data.txt data
bandit12@bandit:/tmp/bandit12$ file data
data: gzip compressed data, was "data2.bin", last modified: Thu May 7 18:14:30 2020, max compression, from Unix
bandit12@bandit:/tmp/bandit12$ mv data data.gz
bandit12@bandit:/tmp/bandit12$ gunzip data.gz
bandit12@bandit:/tmp/bandit12$ ls
data data.txt
bandit12@bandit:/tmp/bandit12$ file data
data: bzip2 compressed data, block size = 900k
bandit12@bandit:/tmp/bandit12$ mv data data.bz2
bandit12@bandit:/tmp/bandit12$ bzip2 -d data.bz2
bandit12@bandit:/tmp/bandit12$ ls
data data.txt
bandit12@bandit:/tmp/bandit12$ file data
data: gzip compressed data, was "data4.bin", last modified: Thu May 7 18:14:30 2020, max compression, from Unix
bandit12@bandit:/tmp/bandit12$ mv data data.gz
bandit12@bandit:/tmp/bandit12$ gunzip data.gz
bandit12@bandit:/tmp/bandit12$ ls
data data.txt
bandit12@bandit:/tmp/bandit12$ file data
data: POSIX tar archive (GNU)
bandit12@bandit:/tmp/bandit12$ tar -xvf data
data5.bin
bandit12@bandit:/tmp/bandit12$ file data5.bin
data5.bin: POSIX tar archive (GNU)
bandit12@bandit:/tmp/bandit12$ tar -xvf data5.bin
data6.bin
bandit12@bandit:/tmp/bandit12$ file data6.bin
data6.bin: bzip2 compressed data, block size = 900k
bandit12@bandit:/tmp/bandit12$ mv data6.bin data6.bz2
bandit12@bandit:/tmp/bandit12$ bzip2 -d data6.bz2
bandit12@bandit:/tmp/bandit12$ ls
data data5.bin data6 data.txt
bandit12@bandit:/tmp/bandit12$ file data6
data6: POSIX tar archive (GNU)
bandit12@bandit:/tmp/bandit12$ tar -xvf data6
data8.bin
bandit12@bandit:/tmp/bandit12$ file data8.bin
data8.bin: gzip compressed data, was "data9.bin", last modified: Thu May 7 18:14:30 2020, max compression, from Unix
bandit12@bandit:/tmp/bandit12$ mv data8.bin data8.gz
bandit12@bandit:/tmp/bandit12$ gunzip data8.gz
bandit12@bandit:/tmp/bandit12$ ls
data data5.bin data6 data8 data.txt
bandit12@bandit:/tmp/bandit12$ file data8
data8: ASCII text
bandit12@bandit:/tmp/bandit12$ cat data8
The password is 8ZjyCRiBWFYkneahHwxCv3wb2a1ORpYL
```

# References
* [Rosenfield, A.](https://stackoverflow.com/users/9530/adam-rosenfield) (2011, October 19). Transform hexadecimal information to binary using a Linux command. Stack Overflow. <https://stackoverflow.com/a/7826789/7148921>
* Tucakov, D. (2019, November 14). How To Extract / Unzip `.tar.gz` Files From Linux Command Line. Knowledge Base by PhoenixNAP. <https://phoenixnap.com/kb/extract-tar-gz-files-linux-command-line>