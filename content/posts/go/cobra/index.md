---
title: CLIs in Go with Cobra
description: CLIs in Go with Cobra
date: 2023-02-25
tags: [Go, CLI]
---
In this document, I'll demonstrate how I use [Steve Francia's `cobra` library](https://pkg.go.dev/github.com/spf13/cobra), which enables the interchangeable usage of environment variable and a configuration file for the same Go program.

For the purposes of simplicity, I assume that all of the code snippets shown here are part of the `main` package. However, I recommend authors of large codebases to employ a multi-package taxonomy, such that their code is more organised and maintainable.

# Parent-level Commands
The parent level is the command that is in the root of the CLI command tree or any command with sub-commands registered to it. In Cobra command can have separate functions for its set-up, validation an execution stages, along with metadata about it that can be used to print support documentation.

```go
import "github.com/spf13/cobra"

var (
	Version = "development"
	ParentCommand = cobra.Command{
		Use:     "parent",
		Short:   "parent command",
		Long:    "parent command",
		Version: Version,
		PreRunE: func(cmd *cobra.Command, args []string) error {
			// prepare environment (such as files) and return error/nil ...
		},
		Args: func(cmd *cobra.Command, args []string) error {
			// check command input and return error/nil ...
		},
		RunE: func(cmd *cobra.Command, args []string) error {
			// do your thing and return error/nil ...
		},
	}
)

func init() {
	ParentCommand.SetVersionTemplate("{{.Version}}\n")
}
```

The version template is overridden in order to print just the version (when using the `--version` flag), thus allowing easier parsing of the version by other programs.

## Version Command
I like to include a custom `version` sub-command that can include more information such as [commit hash](https://git-scm.com/book/en/v2/Git-Basics-Viewing-the-Commit-History) and platform when using the `--verbose`/`-v` flag.

```go
package commands

import (
	"fmt"
	"runtime"
	"github.com/spf13/cobra"
)

var (
	Hash           = "development"
	verbose        bool
	versionCommand = &cobra.Command{
		Use:   "version",
		Short: "print version",
		Long:  "print version",
		Run: func(cmd *cobra.Command, args []string) {
			if verbose {
				if Version != "development" {
					fmt.Printf("version: \t%s\n", Version)
				}
				if Hash != "development" {
					fmt.Printf("commit: \t%s\n", Hash)
				}
				fmt.Printf("compiler: \t%s (%s)\n", runtime.Version(), runtime.Compiler)
				fmt.Printf("platform: \t%s/%s\n", runtime.GOOS, runtime.GOARCH)
			} else {
				fmt.Println(Version)
			}
		},
	}
)

func init() {
	versionCommand.Flags().BoolVarP(&verbose, "verbose", "v", false, "version, git commit hash, compiler version & platform")
	ParentCommand.AddCommand(versionCommand)
}
```

If you want to inject release-specific values to Go's global memory during build time, I [wrote](/posts/go/goreleaser/#builds) about using [GoReleaser](https://goreleaser.com) for this purpose, and how I integrate it to my continuous integration pipeline.

# Child-level Commands
Some CLIs (such as [`git`](https://git-scm.com)) require multiple sub-commands, each with different functionality in order to maintain usability. This can be achieved by initialising a new `cobra.Command` object and registering as a sub-command to its parent in an `init` function. In addition, flags that accept more complex data types (such as [duration](https://pkg.go.dev/time#Duration)) can be integrated with a given command by binding it to a variable (ideally in the same `init` function mentioned above).

```go
import "github.com/spf13/cobra"

var (
	duration time.Duration
	childCommand = cobra.Command{
		Use:   "child",
		Short: "child command",
		Long:  "child command",
		// ...
	}
)

func init() {
	childCommand.Flags().DurationVarP(&duration, "duration", "d", 0, "duration with units ns, us (or µs), ms, s, m, h")
	ParentCommand.AddCommand(&childCommand)
}
```

# Execution
In order to parse and execute any Cobra command or its children, it can be executed in any stage of the program's runtime. Most CLI-type application would execute their root-level command directly from the `main` function. For a clearer user experience, a the execution function of a command prints the error to standard output (if it's non-`nil`) before returning it to be examined and to be dealt with.

```go
package main

import "os"

func main() {
	if err := ParentCommand.Execute(); err != nil {
		os.Exit(1)
	}
}
```

# Additional Resources
[Before](/posts/goreleaser/#global-hooks) building and packaging the CLI, I tend to run the following commands and append their output to a text files, which are automatically packaged with the binary later in the continuous integration process.

## Manual Page
With [Christian Muehlhaeuser's `mango` library](https://github.com/muesli/mango-cobra), a user manual page can be generated for a Cobra command and all of its child commands. I tend to this by defining a new `cobra.Command` object that reads the root command and uses the above-mentioned library to print the manual page to standard output (which can be tested by piping the output to `man -l -`).

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

## Shell Completion Scripts
Cobra also [ships](https://github.com/spf13/cobra/blob/main/completions.go) with a `completion` sub-command for generating completion scripts for `bash`, `zsh`, `fish` and PowerShell, which enables the user to discover and understand your CLI more quickly.