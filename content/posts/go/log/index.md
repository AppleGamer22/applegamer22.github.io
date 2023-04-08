---
title: Colourful Logging in Go
description: Colourful Logging in Go
date: 2023-03-18
tags: [Go, Charm, CLI]
draft: true
---
# Why?
Whenever you debug a program that produces a large amount of logs, sifting through them when a bug arises is only a matter of time. This tasks becomes more annoying when there is no consistent pattern you focus on with `grep`, especially you want to find a pattern between related logs that aren't immediately next to each other in the log file. When I resort to manually looking through logs of programs I'm debugging, having colour-coded logs tends to make the experience more fun.

![An r/ProgrammerHumor post describing the lack of colour in logs](https://i.redd.it/93th0rq0y1h81.jpg "An [r/ProgrammerHumor post](https://www.reddit.com/r/ProgrammerHumor/comments/spdvag/thank_you_ide_for_bringing_in_colors_in_my_life/) describing the lack of colour in logs")

# How?
## Custom Logger

```go
import (
	"time"
	"github.com/charmbracelet/log"
)

func init() {
	log.SetReportCaller(true)
	log.SetTimeFormat(time.RFC3339)
	log.SetLevel(log.DebugLevel)
}
```

## Debugging
## Warning
## Error & Fatal
