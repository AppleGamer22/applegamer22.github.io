---
title: Capturing Commands as GIFs with VHS
description: Capturing Commands as GIFs with VHS
date: 2023-03-12
tags: [VHS, Charm, CLI]
---
This document summarises how I use [Charm's `vhs`](https://github.com/charmbracelet/vhs) to capture and document command-line interactions.

# General Configuration
I tend to like capturing my preferred [shell](/posts/shell/#zsh), [prompt](/posts/shell/#prompt) and [font](/posts/shell/#font), all of which can be [configured](https://github.com/charmbracelet/vhs#vhs-command-reference) in the header of a `.tape` file.

```elixir
Output command.gif

Set FontSize 18
Set Shell zsh
# or "FiraCode Nerd Font"
Set FontFamily "Fira Code"
# Set Margin 1

# time for the shell to load
Hide
Type eval "$(starship init zsh)"
Enter
Sleep 1s
Show
# or any other command
Type neofetch
Sleep 500ms
Enter
# more time might be required for more time-consuming processes
Sleep 500ms
```

Before generating the GIF, you need to have [FFmpeg](https://ffmpeg.org) and [`ttyd`](https://tsl0922.github.io/ttyd/) installed.

```sh
vhs < cassette.tape
```

# Examples
## Tab Completion
Since `vhs` requires the pauses between operation to be precise, this assumption also applies in waiting for [tab completions](/posts/shell/#completions) to appear on the screen. It is important to ensure that each operation is clearly captured, by having an appropriate amount of time where `vhs` waits for the shell to respond to the key presses.

```elixir
Output starship.gif

Set FontSize 18
Set Shell zsh
Set FontFamily "Fira Code"

Hide
Type eval "$(starship init zsh)"
Enter
Sleep 1s
Show
Type ls
Enter
Sleep 500ms
Type hu
Tab
Sleep 1000ms
Tab
Sleep 500ms
Enter
Sleep 500ms
Tab
Sleep 500ms
Tab
Sleep 500ms
Up
Sleep 500ms
Enter
Sleep 500ms
Enter
Sleep 1000ms
Type cat starship.tape
Enter
Sleep 1000ms
```

![My command-line prompt with tab completion](/posts/shell/starship.gif "My command-line [prompt](/posts/shell/) with tab completion")

## Character Escaping
Commands with more arguments and special character should be surrounded by quotes to ensure correct parsing and execution by `vhs`.

```elixir
Output starship.gif

Set FontSize 18
Set Shell zsh
Set FontFamily "Fira Code"

Hide
Type eval "$(starship init zsh)"
Enter
Sleep 1s
Show
Type "goreleaser release --clean --snapshot --skip-publish"
Enter
Sleep 5s
Type tree dist
Enter
Sleep 500ms
```

![GoReleaser running a non-production build](/posts/go/goreleaser/goreleaser_build_publish.gif "[GoReleaser](/posts/go/goreleaser/) running a non-production build")