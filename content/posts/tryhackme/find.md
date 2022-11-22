# TryHackMe [The `find` Command](https://www.tryhackme.com/room/thefindcommand)
### References
* Ahamed, I. (2020, May 13). The find command ~ THM Writeup. Medium; Medium. https://irshadahamedpro.medium.com/the-find-command-thm-writeup-10dba7722261
* GNU. (2021). Findutils 4.8.0. GNU. https://www.gnu.org/software/findutils/manual/html_mono/find.html
## Be more specific
### Find all files whose name ends with `.xml`
* `find /` to search for items in the root directory
* `-type f` to filter for files
* `-name "*.xml"` to filter for items with a `.xml` as a suffix

**Answer**: `find / -type f -name "*.xml"`
### Find all files in the `/home` directory (recursive) whose name is `user.txt` (case insensitive)
* `find /home` to search for items in the `/home` directory
* `-type f` to filter for files
* `-iname user.txt` to filter for case insensitive name pattern of `user.txt`

**Answer**: `find /home -type f -iname user.txt`
### Find all directories whose name contains the word `exploits`:
* `find /` to search for items in the root directory
* `-type d` to filter for directories
* `-name "*exploits*"` to filter for items with `exploits` substring in their name

**Answer**: `find / -type d -name "*exploits*"`
## Know exactly what you're looking for
### Find all files owned by the user `kittycat`
* `find /` to search for items in the root directory
* `-type f` to filter for files
* `-user kittycat` to filter for items owned by the user `kittycat`

**Answer**: `find / -type f -user kittycat`
### Find all files that are exactly 150 bytes in size
* `find /` to search for items in the root directory
* `-type f` to filter for files
* `-size 150c` to filter for items of size 150 bytes

**Answer**: `find / -type f -size 150c`
### Find all files in the `/home` directory (recursive) with size less than 2 KiB and extension `.txt`
* `find /home` to search for items in the `/home` directory
* `-type f` to filter for files
* `-size -2k` to filter items of size less than 2 KiB
* `-name "*.txt"` to filter for items with a `.txt` as a suffix

**Answer**: `find /home -type f -size -2k -name "*.txt"`
### Find all files that are exactly readable and writeable by the owner, and readable by everyone else (use octal format)
* `find /` to search for items in the root directory
* `-type f` to filter for files
* `-perm 644` (octal format) to filter for items that are exactly readable and writeable by the owner, and readable by everyone else

**Answer**: `find / -type f -perm 644`
### Find all files that are **only** readable by anyone (use octal format)
* `find /` to search for items in the root directory
* `-type f` to filter for files
* `-perm /444` (octal format) to filter for items that are **only** readable by anyone

**Answer**: `find / -type f -perm /444`
### Find all files with write permission for the group `others`, regardless of any other permissions, with extension `.sh` (use symbolic format)
* `find /` to search for items in the root directory
* `-type f` to filter for files
* `-perm -o=w` (symbolic format) to filter items write permission for the group `others`, regardless of any other permissions
* `-name "*.sh"` to filter for items with a `.sh` as a suffix

**Answer**: `find / -type f -perm -o=w -name "*.sh"`
### Find all files in the `/usr/bin` directory (recursive) that are owned by root and have at least the SUID permission (use symbolic format)
* `find /usr/bin` to search for items in the `/usr/bin` directory
* `-type f` to filter for files
* `-user root` to filter for items owned by the user `root`
* `-perm -u=s` (symbolic format) to filter for items that have at least the SUID permission

**Answer**: `find /usr/bin -type f -user root -perm -u=s`
### Find all files that were not accessed in the last 10 days with extension `.png`
* `find /usr/bin` to search for items in the root directory
* `-type f` to filter for files
* `-atime +10` to filter for  items that were not accessed in the last 10 days
* * `-name "*.png"` to filter for items with a `.png` as a suffix

**answer**: `find / -type f -atime +10 -name "*.png"`
### Find all files in the `/usr/bin` directory (recursive) that have been modified within the last 2 hours
* `find /usr/bin` to search for items in the `/usr/bin` directory
* `-type f` to filter for files
* `-mmin -120` to filter for items that have been modified within the last 2 hours (120 minutes)

**Answer**: `find /usr/bin -type f -mmin -120`