---
title: CLIs in Go with Cobra
date: 2023-02-26
tags: [Go, CLI]
---
# Parent-level Commands
```go
import "github.com/spf13/cobra"

var (
	ParentCommand = cobra.Command{
		Use:     "parent",
		Short:   "parent command",
		Long:    "parent command",
		Version: Version,
	},
	PreRunE: func(cmd *cobra.Command, args []string) error {
		// prepare environment (such as files) and return error or nil
	},
	Args: func(cmd *cobra.Command, args []string) error {
		// check command input and return error or nil
	},
	RunE: func(cmd *cobra.Command, args []string) error {
		// do your thing and return error or nil
	},
)

func init() {
	ParentCommand.SetVersionTemplate("{{.Version}}\n")
}
```

# Child-level Commands

```go
import "github.com/spf13/cobra"

var (
	Version = "development"
	Hash    = "development"
	childCommand = cobra.Command{
		Use:     "child ARG1 ARG2",
		Short:   "child command",
		Long:    "child command",
		Version: Version,
	},
	PreRunE: func(cmd *cobra.Command, args []string) error {
		// prepare environment (such as files) and return error or nil
	},
	Args: func(cmd *cobra.Command, args []string) error {
		// check command input and return error or nil
	},
	RunE: func(cmd *cobra.Command, args []string) error {
		// do your thing and return error or nil
	},
)

func init() {
	ParentCommand.AddCommand(&childCommand)
}
```

# Execution

```go
import "os"

func main() {
	if err := RootCommand.Execute(); err != nil {
		os.Exit(1)
	}
}
```

# Manual Page

```go
package commands

import (
	"fmt"

	mango "github.com/muesli/mango-cobra"
	"github.com/muesli/roff"
	"github.com/spf13/cobra"
)

var manualCommand = &cobra.Command{
	Use:   "manual",
	Short: "print manual page",
	Long:  "print manual page to standard output",
	RunE: func(cmd *cobra.Command, args []string) error {
		manualPage, err := mango.NewManPage(1, ParentCommand)
		if err != nil {
			return err
		}

		manualPage.WithSection("Bugs", fmt.Sprintf("Please report bugs to our GitHub page https://github.com/AppleGamer22/%s/issues", manualPage.Root.Name))
		manualPage.WithSection("Authors", "Omri Bornstein <omribor@gmail.com>")
		manualPage.WithSection("Copyright", `cocainate is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3, or (at your option) any later version.
cocainate is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.`)

		_, err = fmt.Println(manualPage.Build(roff.NewDocument()))
		return err
	},
}

func init() {
	RootCommand.AddCommand(manualCommand)
}
```