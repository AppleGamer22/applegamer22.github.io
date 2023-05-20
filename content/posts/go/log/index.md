---
title: Colourful Logging in Go
description: Colourful Logging in Go
date: 2023-05-20
tags: [Go, Charm, CLI]
---
# Why?
Whenever you debug a program that produces a large amount of logs, sifting through them when a bug arises is only a matter of time. This tasks becomes more annoying when there is no consistent pattern you focus on with `grep`, especially you want to find a pattern between related logs that aren't immediately next to each other in the log file. When I resort to manually looking through logs of programs I'm debugging, having colour-coded logs tends to make the experience more fun.

![An r/ProgrammerHumor post describing the lack of colour in logs](https://i.redd.it/93th0rq0y1h81.jpg "An [r/ProgrammerHumor post](https://www.reddit.com/r/ProgrammerHumor/comments/spdvag/thank_you_ide_for_bringing_in_colors_in_my_life/) describing the lack of colour in logs")

# How?
## Custom Logger
For my personal project, I override the default package settings with the following:

* Each log line reports what source code line printed it.
* RFC 3339 timestamp format
* In order to show debugging logs by default, the default debugging level should be set to `log.DebugLevel`.

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

## Result
### Information/Success
Regular logs are shown with a green-coloured `INFO` prefix.

```go
log.Info("Hi there!", "version", runtime.Version())
log.Infof("%d + 0x%x = 0b%b", 22, 0x56, 22+0x56)
```

![](info.png)

### Debugging
Debug logs are shown with a blue-coloured `DEBU` prefix.

```go
log.Debug("Hi there!", "version", runtime.Version())
log.Debugf("%d + 0x%x = 0b%b", 22, 0x56, 22+0x56)
```

![](debug.png)

### Warning
Warning logs are shown with a yellow-coloured `WARN` prefix.

```go
log.Warn("Hi there!", "version", runtime.Version())
log.Warnf("%d + 0x%x = 0b%b", 22, 0x56, 22+0x56)
```

![](warn.png)

### Error & Fatal
* Error logs are shown with a red-coloured `ERRO` prefix.
* Fatal logs are shown with a purple-coloured `FATA` prefix.
	* Any call to `log.Fatal` or to `log.Fatalf` will result in the program exiting immediately with code 1.

```go
log.Error("Hi there!", "version", runtime.Version())
log.Errorf("%d + 0x%x = 0b%b", 22, 0x56, 22+0x56)
log.Fatal("goodbye")
```

![](error_fatal.png)
