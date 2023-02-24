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
	Database:    "raker",
	Storage:     ".",
	Directories: false,
	Port:        4100,
}
```

# Initialising Viper
```go
import "github.com/spf13/viper"

func init() {
	// viper.SetEnvPrefix("raker")
	viper.AutomaticEnv()
	viper.BindEnv("SECRET")
	viper.BindEnv("URI")
	viper.BindEnv("DATABASE")
	viper.BindEnv("STORAGE")
	viper.BindEnv("DIRECTORIES")
	viper.BindEnv("PORT")
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
	viper.AutomaticEnv()
	viper.BindEnv("instagram.session", "SESSION_IG")
	viper.BindEnv("instagram.user", "USER")
	viper.BindEnv("instagram.fbsr", "FBSR")
	viper.BindEnv("tiktok.session", "SESSION_TT")
	viper.BindEnv("tiktok.chain", "TIKTOK_CT")
	viper.BindEnv("tiktok.guard", "GUARD")
	viper.SetConfigName(".raker")
	viper.SetConfigType("yaml")

	directory, err := os.UserHomeDir()
	if err != nil {
		log.Fatal(err)
	}
	viper.AddConfigPath(directory)

	viper.ReadInConfig()
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

