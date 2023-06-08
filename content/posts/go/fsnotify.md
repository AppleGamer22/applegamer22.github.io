---
title: Watching for File Changes in Go
description: Watching for File Changes in Go with FSnotify
date: 2023-06-08
tags: [Go]
math: true
---
In numerous cases, such as my general-purpose file watcher [`stalk`](https://github.com/AppleGamer22/stalk), software needs to be aware of changes in files in near-real-time and respond to them. Luckily, the [`fsnotify`](https://pkg.go.dev/github.com/fsnotify/fsnotify) library implements a Go-native channel-based interface that works seamlessly across operating systems that enables Go developers to tap into the host machine's file system based on [specific events](https://pkg.go.dev/github.com/fsnotify/fsnotify#Op).

# Required Packages
The following packages are required for time measurements, OS-level APIs and user signal handling.

```go
import (
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/fsnotify/fsnotify"
)
```

# Initialising Watcher
Firstly, the file watcher has to be initialised, and while I'm at it, I'll also create a fatal errors channel for the termination logic I'll discuss later.

```go
watcher, err := fsnotify.NewWatcher()
if err != nil {
	return err
}
defer watcher.Close()
// fatal error channel
errs := make(chan error, 1)
```

# Watching for Events
In **a separate thread**, the file watcher listens to its multiplexed events and errors channels. For the events channel I found that sometimes more than one write events are received every time I save a file (from a text editor), which is why I choose to ignore subsequent events that are less than 10th of a second from their predecessor. In addition, I found some [events](https://pkg.go.dev/github.com/fsnotify/fsnotify#Event) had an empty `Name` property, which is probably related to a write event on one of the root directories the file watcher is assigned to. At present, I filter out the above-mentioned subset of events because this subset of events has no meaning for a general file watcher like `stalk`, but **you should decide for your use case** how much filtering your code should perform.

After filtering out unwanted events, you can write custom code that handles this events as per your use case.

```go
go func() {
	lastEventTime := time.Unix(0, 0)
	for {
		select {
		case event := <-watcher.Events:
			eventType := event.Op != fsnotify.Write && event.Op != fsnotify.Create
			eventTime := time.Since(lastEventTime) <= time.Second/10
			if event.Name == "" || eventType || eventTime {
				continue
			}
			// do something in a thread-safe manner
		case err := <-watcher.Errors:
			// deal with error, can either stop watching by breaking from the loop
			// can report error by pushing to global error channel
		}
	}
}()
```

# Adding Files to Watch
While the file watcher waits for events, **a separate thread** adds the files to be watched in parallel. These files can be obtained from command-line arguments, an external file, an array/slice, an network request or any other method that enables you to iterate over a file path list.

```go
go func() {
	// assuming a files array/slice is available
	for _, path := range files {
		if err := watcher.Add(path); err != nil {
			// handle file system error
		}
	}
}()
```

# Termination
In order to enable clean termination upon request or fatal error such that the file watcher is closed correctly, I tend to wait to either for a user-issued signal (sent by the `signals` channel), or to a fatal error (sent by the logic shown above through the `errs` channel). Assuming the file watcher initialisation and termination logic are in the same function, any return statement after the file watcher's creation will trigger its `defer` statement, thus exiting cleanly. If this is not the case, the file watcher's `Close` method can be called without `defer`ring.

```go
signals := make(chan os.Signal, 1)
signal.Notify(signals, os.Interrupt, syscall.SIGINT, syscall.SIGQUIT)
select {
case <-signals:
	// respond to user-issued termination signal
case err := <-errs:
	// respond to error
}
// triggering the defer statement shown above
return
```

# My Use Cases
My [general-purpose file watcher](https://github.com/AppleGamer22/stalk) implements a variation of the above-mentioned logic in two ways:

* `stalk wait` waits for a single file system event that applies to its set of paths, supplied by its command arguments.
* `stalk watch` continuously watches for file system events that applies to its set of paths (supplied by its command arguments), and runs a shell command for each until stopped by a fatal error or the user.

I use it for observing live changes in my Pandoc-$\LaTeX$ files, and live-reloading my HTTP server code as I edit and re-save it, all across both Linux and macOS systems.