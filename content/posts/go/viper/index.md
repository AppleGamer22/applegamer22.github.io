---
title: Environment Settings in Go with Viper
description: Environment Settings in Go with Viper
date: 2023-02-25
tags: [Go, CLI, server]
---
For many projects, additional configuration is required in order to ensure correct behaviour. Whether its [JSON Web Token](https://jwt.io) secrets, database/personal credentials or other customisable settings, reliable and flexible configuration schemes are dependent upon during all stages of software development. In this document, I'll demonstrate how I use [Steve Francia's `viper` library](https://github.com/spf13/viper), which enables the interchangeable usage of environment variable and a configuration file for the same Go program.

For the purposes of simplicity, I assume that all of the code snippets shown here are part of the `main` package. However, I recommend authors of large codebases to employ a multi-package taxonomy, such that their code is more organised and maintainable.

# Data Structure
In order to parse and validate the current environment settings, Viper requires a data structure that describes all the properties you require. I usually parse/serialise and validate the current state (as set at during start-up) into a data structure in the [`main` function](#invalid-values).

```go
type Configuration struct {
	Secret      string
	URI         string
	Database    string
	Storage     string
	Directories bool
	Port        uint
}
```

By default, Viper supports parsing/serialising a YAML file (or other common formats of your choice) that matches the data structure semantics:

```yml
secret: your_secret
uri: "mongodb://localhost:27017"
database: mongo
storage: .
directories: false
port: 4100
```

## Default Values
The variable that stores the parsed/serialised state of the settings can be initialised with default values that correspond to unset fields. These default values should be clearly documented to users in order to reduce potential friction that might arise with configuring an unfamiliar program.

```go
var configuration = Configuration{
	URI:         "mongodb://localhost:27017",
	Database:    "mongo",
	Storage:     ".",
	Directories: false,
	Port:        4100,
}
```

# Initialising Viper
I like to include the Viper initialisation code in an `init` function in the `main` package or in a package that is loaded by it, such that non-changing behaviour is set before the `main` function runs.

```go
import "github.com/spf13/viper"

func init() {
	// ...
	// optional environment variable name prefix
	viper.SetEnvPrefix("raker")
	// enabling the use of environment variables within viper
	viper.AutomaticEnv()
	// Setting name and file type for configuration file
	viper.SetConfigName(".raker")
	viper.SetConfigType("yaml")
	viper.AddConfigPath(".")
	// ...
}
```

## Environment Variables
From my experience, Viper can handle environment variables whose names maintain common practices while keeping the parsing/serialising code at minimum by explicitly binding variable names to Viper internal storage. In addition, since environment variables are an in-memory key-value store accessible by the shell and the running process, they cannot be mapped easily to a tree data structure implicitly. This means nested data structure properties must be explicitly bound to an environment variable using the same method.

```go
import (
	"log"
	"os"
	"github.com/spf13/viper"
)

func init() {
	// ...
	viper.BindEnv("SECRET")
	viper.BindEnv("URI")
	viper.BindEnv("DATABASE")
	viper.BindEnv("STORAGE")
	viper.BindEnv("DIRECTORIES")
	viper.BindEnv("PORT")
	/*
	properties of nested structures can be set via environment variables by
	providing their before the to-be-bound environment variable's name
	*/
	viper.BindEnv("parent.child", "ENV_VAR")
	// ...
}
```

## Invalid Values
Viper's parsing/serialising function supports type mismatches between the expected data structure and the inspected configuration state. However invalid values with values with valid types should be checked for after successful parsing/serialising. It might be possible to offload most of this validation to Viper by utilising its [dependency](https://pkg.go.dev/github.com/mitchellh/mapstructure)'s custom data structure tags, but I haven't looked into it yet.

```go
package main

import (
	"log"
	"os"
	"github.com/spf13/viper"
)

func main() {
	// ...
	if err1 := viper.ReadInConfig(); err1 != nil {
		// configuration file not found errors should be handled differently for each application
		if _, err := os.Stat("/.dockerenv"); err != nil {
			/*
			if running in a Docker container, a missing configuration might prevent
			correct behaviour (depending on core functionality and lack of environment variable usage)
			*/
			log.Println(err1)
		}
	}

	if err := viper.Unmarshal(&configuration); err != nil {
		log.Fatal(err)
	}

	// checking for invalid empty strings for JWT secret
	if configuration.Secret == "" && !viper.IsSet("secret") {
		log.Fatal("A JWT secret must be set via a config file or an environment variable")
	}
	// ...
}
```

