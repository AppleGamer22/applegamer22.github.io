---
Title: GitHub Supply Chain Security with Dependabot
description: GitHub Supply Chain Security with Dependabot
date: 2023-04-14
tags: [GitHub, Dependabot]
---
# Pre-requisites
* Create a new `dependencies` [issue label](https://docs.github.com/en/issues/using-labels-and-milestones-to-track-work/managing-labels) on your GitHub repository.

# Ecosystems
Each package ecosystem can be added to the `updates` list in your `.github/dependabot.yml` file found at the root of your repository file tree with its own settings.

## Go
```yml
# yaml-language-server: $schema=https://json.schemastore.org/dependabot-2.0.json
version: 2
updates:
  - package-ecosystem: gomod
    directory: /
    schedule:
      interval: daily
    assignees:
      - AppleGamer22
    reviewers:
      - AppleGamer22
    commit-message:
      prefix: chore
    labels:
      - dependencies
```

## JavaScript & TypeScript
```yml
# yaml-language-server: $schema=https://json.schemastore.org/dependabot-2.0.json
version: 2
updates:
  - package-ecosystem: npm
    # ...
```

## Python
```yml
# yaml-language-server: $schema=https://json.schemastore.org/dependabot-2.0.json
version: 2
updates:
  - package-ecosystem: pip
    # ...
```

## Docker
```yml
# yaml-language-server: $schema=https://json.schemastore.org/dependabot-2.0.json
version: 2
updates:
  - package-ecosystem: docker
    # ...
```

## GitHub Actions
```yml
# yaml-language-server: $schema=https://json.schemastore.org/dependabot-2.0.json
version: 2
updates:
  - package-ecosystem: github-actions
   # ...
```

## Terraform
```yml
# yaml-language-server: $schema=https://json.schemastore.org/dependabot-2.0.json
version: 2
updates:
  - package-ecosystem: terraform
    # ...
```