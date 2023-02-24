---
title: Graceful Server Shutdown in Go
date: 2023-02-26
tags: [Go, server]
---

# Required Modules
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
```go
mux := http.NewServeMux()
// ... configure routes
server := http.Server{
	Addr:    fmt.Sprintf(":%d", configuration.Port),
	Handler: handlers.Log(mux),
}
```

# Signal Channel Override
```go
signals := make(chan os.Signal, 1)
signal.Notify(signals, os.Interrupt, syscall.SIGTERM, syscall.SIGQUIT)
```

# Threads
## Server
```go
go func() {
	if err := server.ListenAndServe(); err != nil && !errors.Is(err, http.ErrServerClosed) {
		log.Println(err)
		signals <- os.Interrupt
	}
}()
```

## Main
```go
<-signals
// optional: clear line in order to hide ^C
fmt.Print("\r")
log.Println("shutting down server...")
if err := server.Shutdown(context.Background()); err != nil {
	log.Println(err)
}
```