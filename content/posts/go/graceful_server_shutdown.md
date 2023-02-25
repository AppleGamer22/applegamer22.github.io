---
title: Graceful Server Shutdown in Go
description: Graceful Server Shutdown in Go
date: 2023-02-26
tags: [Go, server]
---
Shutting servers gracefully is beneficial for maintaining data integrity in relations to modifying file system data or database entries such that the server isn't shutdown in the middle of a transaction. In this document, I show how I set-up a Go-based HTTP server to shutdown gracefully upon an interruption signal.

For the purposes of simplicity, I assume that all of the code snippets shown here are part of the `main` package. However, I recommend authors of large codebases to employ a multi-package taxonomy, such that their code is more organised and maintainable.

# Required Packages
* `context` for restricting the amount the server had to shutdown gracefully.
* `errors` for checking the error type in the case of a server crush.
* `fmt` for printing a `\r` to the console in order to not show `^C` when sending interrupting the server.
* `net/http` for initialising and configuring an HTTP server.
* `os` and `syscall` for accessing interruption signal codes specific to the process' operating system.
* `os/signal` for overriding the default behaviour of the program when an interruption signal is received.

```go
import (
	"context"
	"errors"
	"fmt"
	"log"
	"net/http"
	"os"
	"os/signal"
	"syscall"
)
```

# Server
Go's HTTP Library requires a custom `http.Server` object because the `net/http` package doesn't provide a shutdown method for the globally available default server object. An `http.ServeMux` multiplexer object can be used as the server's `Handler` property and further customise it's HTTP scheme.

```go
mux := http.NewServeMux()
// ... configure routes
server := http.Server{
	Addr:    ":8080",
	Handler: mux,
}
```

# Signal Channel Override
In order to override the process' interruption behaviour, a signal channel should be created such that incoming signals can be processed before the operating system takes over.

```go
signals := make(chan os.Signal, 1)
signal.Notify(signals, os.Interrupt)
```

# Threads
Multiple threads are required in order to both run the server and wait for the interruption signal.

## Server
Normally, when you type <kbd>Control</kbd>+<kbd>C</kbd> the main thread and its HTTP server are shutdown non-gracefully by the operating system, which can lead to data loss/corruption. However in the following example, the server's thread runs the HTTP server (in parallel to the main thread) and listens for network requests until stopped, which makes it a blocking operation. If the server crushes, an interrupt signal is sent the the channel such that the program can exit as fast as possible in order to not waste any more computational resources.

```go
go func() {
	if err := server.ListenAndServe(); err != nil && !errors.Is(err, http.ErrServerClosed) {
		log.Println(err)
		signals <- os.Interrupt
	}
}()
```

## Main
While the server runs on a separate thread, the main thread listens for incoming interruption signals, and uses the build-in graceful `Shutdown` method when such a signal is received. If the graceful shutdown failed to execute correctly, the program panics in order to fulfil the interruption request as soon as possible.

```go
<-signals
// optional: clear line in order to hide ^C
fmt.Print("\r")
log.Println("shutting down server...")
// context.WithTimeout(context.Background(), 5 * time.Second) can be used for a 5s time limit
if err := server.Shutdown(context.Background()); err != nil {
	panic(err)
}
```