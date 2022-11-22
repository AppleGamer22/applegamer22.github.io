# TryHackMe [`tmux`](https://tryhackme.com/room/rptmux)
### References
* DarkSec. (2021). TryHackMe Tmux Official Walkthrough [YouTube Video]. In YouTube. https://youtu.be/vAZSyC1nh3c
* Krout, E. (2016, August 31). `tmux` Cheat Sheet. In A Cloud Guru. https://acloudguru.com/blog/engineering/tmux-cheat-sheet
![`tmux` cheat sheet](https://linuxacademy.com/site-content/uploads/2016/08/tmux.png)
## What command do we use to launch a new session without a custom name?
**Answer**: `tmux`
## What is the first key in the `tmux` keyboard button combination?
**Answer**: `Control`
## What is the second key in the `tmux` keyboard button combination?
**Answer**: `B`
## What key do we need to add to the combo in order to detach?
**Answer**: `D`
## How do we list all of our sessions?
**Answer**: `tmux ls`
## What did our session name default to when we created one without a set name?
**Answer**: `0`
## How do we attach to a named `tmux` session?
**Answer**: `tmux a -t 0`
## What key do we add to the combo in order to make a new window in the current session?
**Answer**: `C`
## What key do we add to the combo to enter copy mode?
**Answer**: `[`
## What if we want to go up to the very top?
**Answer**: `g`
## How about the bottom?
**Answer**: `G`
## What key do we press to exit copy mode?
**Answer**: `q`
## What key do we add to the combo to split the window vertically?
**Answer**: `%`
## How about horizontally?
**Answer**: `"`
## What key do we add to the combo to kill the pane?
**Answer**: `X`
## What can we type to close the session?
**Answer**: `exit`
## How do we spawn a named tmux session named `neat`?
**Answer**: `tmux new -s neat`