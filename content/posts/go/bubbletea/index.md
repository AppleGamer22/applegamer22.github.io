---
title: TUI Components in Go with Bubble Tea
description: TUI Components in Go with Bubble Tea
date: 2023-05-20
tags: [Go, Charm, CLI]
---
In this document, I summarise what [Bubble Tea](https://pkg.go.dev/github.com/charmbracelet/bubbletea) components (colloquially named [bubbles](https://pkg.go.dev/github.com/charmbracelet/bubbles)) I use for my personal projects, as I find more uses for them.

# Timed Progress Bar
![cocainate -d 5s](cocainate_d_5s.gif "running `cocainate -d 5s` with a timed progress bar")

## Required Packages & Constants
The following packages are required in oder to access the Bubble Tea interfaces, component logic and styling functionality. In addition, I defined some utility variables for functions I use throughout the display logic.

```go
import (
	"fmt"
	"time"

	// progress bar rendering
	"github.com/charmbracelet/bubbles/progress"
	// shared functions & typing definitions
	tea "github.com/charmbracelet/bubbletea"
	// colour support
	"github.com/charmbracelet/lipgloss"
)

var (
	quitMessage   = tea.Sequence(tea.ShowCursor, tea.Quit)
	renderMessage = tea.Sequence(tea.ShowCursor, tickCommand())
	helpStyle     = lipgloss.NewStyle().Foreground(lipgloss.Color("#FFFFFF")).Render
)
```

## Model
Initialising a new progress bar requires the time it takes to complete, and a channel for termination signals. The initialisation function returns a reference to a `tea.Program` object that can be forcefully terminated when required.

```go
type model struct {
	// display the total duration below the progress bar
	duration   time.Duration
	// percentage amount to increase the progress on each second
	amount     float64
	// current percentage
	percentage float64
	// progress bar type from Bubble Tea
	p          progress.Model
}

func New(duration time.Duration, signals chan os.Signal) *tea.Program {
	m := &model{
		duration:   duration,
		amount:     1 / duration.Seconds(),
		percentage: 0,
		p:          progress.New(progress.WithSolidFill("#FFFFFF")),
	}

	program := tea.NewProgram(m)
	go func() {
		program.Run()
		signals <- os.Interrupt
	}()
	return program
}
```

## Initialisation
In order for our progress bar `model` to comply with the `tea.Model` interface, it must have an `Init`, `Update` and `View` methods. The `tickCommand` function is shared between the `Init` and `Update` methods, and is used just to return the current time, such that the progress bar is initialised correctly and updated every second.

```go
func tickCommand() tea.Cmd {
	return tea.Tick(time.Second, func(t time.Time) tea.Msg {
		return t
	})
}

func (m model) Init() tea.Cmd {
	return tickCommand()
}
```

## Updating
The `Update` method runs every second, and increments the progress bar with the previously-set `amount` variable. The first time it runs, it records the width of the terminal window, such that the progress bar's width is appropriate to the window size. When any key press is detected, the progress bar is signaled to stop.

```go
func (m model) Update(message tea.Msg) (tea.Model, tea.Cmd) {
	switch message := message.(type) {
	case tea.KeyMsg:
		return m, quitMessage
	case tea.WindowSizeMsg:
		m.p.Width = message.Width
		return m, nil
	case time.Time:
		m.percentage += m.amount
		if m.percentage >= 1.0 {
			return m, quitMessage
		}
		return m, tickCommand()
	default:
		return m, nil
	}
}
```

The `View` method simply returns a string representation of the progress bar after every time it updates. In this version, I also chose to display the current and total time below the progress bar, such that the current time can be read even if the progress bar has not updated graphically.

```go
func (m model) View() string {
	return fmt.Sprintf("%s\n%s/%s\n%s",
		m.p.ViewAs(m.percentage),
		time.Duration(float64(m.duration)*m.percentage).Round(time.Second),
		m.duration, helpStyle("Press any key to quit"),
	)
}
```

## Usage
In the following example from the [`cocainate` source code](https://github.com/AppleGamer22/cocainate/blob/master/session/session.go), a new progress bar program is initialised. It can either terminate naturally when it's time is up, or it can terminate forcefully when the user stops the process.

```go
program := progress_bar.New(s.Duration, s.Signals)
timer := time.NewTimer(s.Duration)
select {
case <-timer.C:
case <-s.Signals:
	timer.Stop()
	program.Kill()
}
```