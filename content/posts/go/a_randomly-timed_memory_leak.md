---
title: A Randomly-Timed Memory Leak
date: 2023-01-14
tags: [Go, CLI]
description: A memory leak I found in my Go project (named cocainate), and how I fixed it...
diagrams: true
---
# Background
This problem was found in my command-line interface (CLI) screensaver inhibitor project, named [`cocainate`](https://github.com/AppleGamer22/cocainate) and written in Go. The screensaver inhibitor can wait for either a termination signal, or for an [optionally-provided duration](https://github.com/AppleGamer22/cocainate/wiki/Functionality#root--d--duration-flag). The screensaver inhibitor's session is tracked by a data structure with the specified duration, and a termination signals channel, [linked](https://pkg.go.dev/os/signal#Notify) to the process' signal buffer.

```go
s := Session{
	Duration: duration,
	Signals:  make(chan os.Signal, 1),
}
signal.Notify(s.Signals, os.Interrupt, syscall.SIGTERM, syscall.SIGQUIT)
```

The part of the code shown below is how I used to implement the CLI functionality that waits for either:

* a timer (with user-specified duration) to end. This is triggered by a `time.Time` object sent to the channel returned by the `time.After` function, which occurs after the duration specified in the function's input,
* or for the user to manually stop the screensaver inhibitor. This is triggered by a channel that [listens](https://pkg.go.dev/os/signal#Notify) for terminations signals sent to the programs by either the operating system, or the user via the command-line shell.

```go
select {
	case <-time.After(s.Duration):
	case <-s.Signals:
}
```

# Potential Channel Leaks
The issue starts when the user terminates the screen inhibitor session before the timer (with the duration specified in the CLI's arguments) ends. According to the documentation of [`time.After`](https://pkg.go.dev/time#After)[^1]:

> [`After`](https://pkg.go.dev/time#After) waits for the duration to elapse and then sends the current time on the returned channel. It is equivalent to `NewTimer(d).C`. The underlying [`Timer`](https://pkg.go.dev/time#Timer) is not recovered by the garbage collector until the timer fires. If efficiency is a concern, use [`NewTimer`](https://pkg.go.dev/time#NewTimer) instead and call [`Timer.Stop`](https://pkg.go.dev/time#Timer.Stop) if the timer is no longer needed.

```mermaid
%%{init: {"sequence": {"mirrorActors": false}}}%%
sequenceDiagram
	participant CLI
	actor User
	participant Timer
	par CLI to User
		loop
			CLI->>User: check for termination signal
			activate User
		end
		User->>CLI: terminate session 
		deactivate User
		Note over User,Timer: Timer's channel still exists
	and CLI to Timer
		loop
			CLI->>Timer: check for duration end signal
		end
	end
```

Therefore, in this case, if the user sends a termination signal, the timer's channel continues to exists in the heap until its duration is over, because it's [not stopped](#background) manually. Over the course of time between the receiving of the termination signal to the end of the timer's duration, the timer's channel is still accessible despite no longer being read by the program, which constitutes a [memory leak](https://en.wikipedia.org/wiki/Memory_leak)[^2], which may lead to performance and reliability issues. I should also note that this is an issue only when [`cocainate`](https://github.com/AppleGamer22/cocainate)'s code is imported as a [Go module](https://go.dev/blog/using-go-modules)[^3] to other codebases that don't immediately terminate the entire process upon receiving a termination signal.

# How I Fixed It
In [this `git` commit](https://github.com/AppleGamer22/cocainate/pull/34/commits/d93f63defa73cc01d245e7db5a1a53e477245742) (shown below), I use a a complete `time.Timer` object rather than just its channel (as advised by Go's [standard library documentation](#potential-channel-leaks)), which allows me to close its channel after a termination signal is received. Since now the timer's channel is closed when it's no longer necessary, it allows Go's garbage collector to clean it sooner, thus preventing the memory leak and the problems it can cause down the line.


```go
timer := time.NewTimer(s.Duration)
select {
	case <-timer.C:
	case <-s.Signals:
		timer.Stop()
}
```

[^1]: `time.After`'s Function Documentation (<https://pkg.go.dev/time#After>)
[^2]: Memory Leak Wikipedia article (<https://en.wikipedia.org/wiki/Memory_leak>)
[^3]: Bui-Palsulich, T., & Compton, E. (2019, March 19). Using Go Modules. The Go Programming Language Blog. <https://go.dev/blog/using-go-modules>
