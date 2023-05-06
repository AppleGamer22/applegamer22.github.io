---
title: TUI Components in Go with Bubble Tea
description: TUI Components in Go with Bubble Tea
date: 2023-04-16
draft: true
tags: [Go, Charm, CLI]
---
# Timed Progress Bar

## Required Packages & Constants
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

func New(duration time.Duration) *model {
	return &model{
		duration:   duration,
		amount:     1 / duration.Seconds(),
		percentage: 0,
		p:          progress.New(progress.WithSolidFill("#FFFFFF")),
	}
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