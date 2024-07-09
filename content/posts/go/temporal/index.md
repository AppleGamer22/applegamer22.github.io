---
title: Durable Execution with Temporal in Go
description: Durable Execution with Temporal in Go
date: 2024-02-22
tags: [Temporal, Go]
draft: true
---

```go
import (
	"log/slog"
	"time"

	"github.com/charmbracelet/log"
	"go.temporal.io/sdk/client"
	tlog "go.temporal.io/sdk/log"
)

func init() {
	log.SetReportCaller(true)
	log.SetTimeFormat(time.RFC3339)
	log.SetLevel(log.DebugLevel)
}

var Options = client.Options{
	Logger: tlog.NewStructuredLogger(slog.New(log.Default())),
}
```

```go
import (
	"log"

	"go.temporal.io/sdk/client"
	"go.temporal.io/sdk/worker"
)

func main() {
	c, err := client.Dial(exercises.Options)
	if err != nil {
		log.Fatalln("Unable to create client", err)
	}
	defer c.Close()
	w := worker.New(c, pizza.TaskQueueName, worker.Options{})
	// registering workflows and activities
	if err := w.Run(worker.InterruptCh()); err != nil {
		log.Fatalln("Unable to start worker", err)
	}
}
```

```go
import (
	// ...

	"go.temporal.io/sdk/activity"
)

func GetDistance(ctx context.Context, ...) error {
	logger := activity.GetLogger(ctx)
	// ...
	logger.Info("information")
	// ...
	return nil
}
```

```go
import (
	// ...

	"go.temporal.io/sdk/temporal"
	"go.temporal.io/sdk/workflow"
)

func PizzaWorkflow(ctx workflow.Context, ...) error {
	// ...
	options := workflow.ActivityOptions{
		// ...
	}
	ctx = workflow.WithActivityOptions(ctx, options)
	logger := workflow.GetLogger(ctx)
	// ...
	logger.Error("error")
	// ...
	return nil
}
```
