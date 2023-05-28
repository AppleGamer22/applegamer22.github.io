---
title: Watching for File Changes in Go
description: Watching for File Changes in Go with FSnotify
date: 2023-06-29
tags: [Go]
draft: true
---
# Required Packages
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
```go
watcher, err := fsnotify.NewWatcher()
if err != nil {
	return err
}
defer watcher.Close()
// global error channel
errs := make(chan error, 1)
```

# Watching for Events
```go
go func() {
	for {
		select {
		case event := <-watcher.Events:
			if event.Name == "" || (event.Op != fsnotify.Write && event.Op != fsnotify.Create) || time.Since(lastEventTime) <= time.Second/10 {
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
```go
go func() {
	for _, path := range args {
		if err := watcher.Add(path); err != nil {
			// handle file system error
		}
	}
}()
```

# Termination
```go
signals := make(chan os.Signal, 1)
signal.Notify(signals, os.Interrupt, syscall.SIGINT, syscall.SIGQUIT)
select {
case <-signals:
	// respond to user-issued termination signal
case err := <-errs:
	// respond to error
}
```