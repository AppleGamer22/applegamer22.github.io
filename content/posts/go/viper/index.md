---
title: Environment Variables in Go with Viper
date: 2023-02-26
tags: [Go, CLI, server]
---
# Data Structure
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

# Default Values
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
```go
import "github.com/spf13/viper"

func init() {
	// optional environment variable name prefix
	viper.SetEnvPrefix("raker")
	viper.AutomaticEnv()
	viper.SetConfigName(".raker")
	viper.SetConfigType("yaml")
	viper.AddConfigPath(".")
}
```

# Environment Variables
```go
import (
	"log"
	"os"

	"github.com/spf13/viper"
)

func init() {
	viper.BindEnv("SECRET")
	viper.BindEnv("URI")
	viper.BindEnv("DATABASE")
	viper.BindEnv("STORAGE")
	viper.BindEnv("DIRECTORIES")
	viper.BindEnv("PORT")
	// properties of nested structures can be set via environment variables by providing their before the to-be-bound environment variable's name
	viper.BindEnv("parent.child", "ENV_VAR")
}
```

# Invalid Values
```go
import (
	"log"
	"os"

	"github.com/spf13/viper"
)

func main() {
	if err1 := viper.ReadInConfig(); err1 != nil {
		if _, err := os.Stat("/.dockerenv"); err != nil {
			// if running in a Docker container, a missing configuration might prevent correct behaviour (depending on core functionality)
			log.Println(err1)
		}
	}

	if err := viper.Unmarshal(&configuration); err != nil {
		log.Fatal(err)
	}

	if configuration.Secret == "" && !viper.IsSet("secret") {
		log.Fatal("A JWT secret must be set via a config file or an environment variable")
	}
}
```

