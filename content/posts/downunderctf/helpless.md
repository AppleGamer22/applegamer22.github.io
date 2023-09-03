---
title: DownUnderCTF helpless
description: DownUnderCTF 2023 helpless challenge
date: 2023-09-03
tags: [DownUnderCTF, MonSec, UNIX]
---
# Prompt
> I accidentally set my system shell to the Python [`help()`](https://www.digitalocean.com/community/tutorials/python-help-function) function! Help!!
>
> The flag is at `/home/ductf/flag.txt`.
>
> The password for the `ductf` user is `ductf`.
>
> `ssh ductf@2023.ductf.dev -p 30022`

# Solution
After connecting to the target, the following shell is spawned:

```
$ ssh ductf@2023.ductf.dev -p 30022
ductf@2023.ductf.dev's password: ductf

Last login: Sun Sep  3 09:24:32 2023 from 10.152.0.19

Welcome to Python 3.10's help utility!

If this is your first time using Python, you should definitely check out
the tutorial on the internet at https://docs.python.org/3.10/tutorial/.

Enter the name of any module, keyword, or topic to get help on writing
Python programs and using Python modules.  To quit this help utility and
return to the interpreter, just type "quit".

To get a list of available modules, keywords, symbols, or topics, type
"modules", "keywords", "symbols", or "topics".  Each module also comes
with a one-line summary of what it does; to list the modules whose name
or summary contain a given string such as "spam", type "modules spam".

help>
```

This is a Python feature of an interactive help shell, which spawns a `less` child process of the documentation for known objects. You can enter to a `less` by entering a name of a Python object you know, such as `True`.

According to the awesome resource [GTFOBins](https://gtfobins.github.io/gtfobins/less/#file-read), `less` can switch the file shown on screen without having to kill the main process. This can be done by typing `:e /home/ductf/flag.txt` into the current `less` session, which would display the flag `DUCTF{sometimes_less_is_more}` in a child `less` process.