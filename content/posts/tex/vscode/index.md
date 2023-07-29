---
title: LaTeX Settings for VSCode
description: LaTeX Settings for VSCode
date: 2023-05-13
tags: [TeX, LaTeX, VSCode]
---
# Pre-requisites
* [VSCode](https://code.visualstudio.com) (or any other compatible fork)
	* James Yu's [LaTeX Workshop](https://marketplace.visualstudio.com/items?itemName=James-Yu.latex-workshop) extension
* An installation of a LaTeX distribution (such as [TeXLive](https://www.tug.org/texlive/))
	* [LuaLaTeX/LuaTeX](https://www.luatex.org) (or your preferred LaTeX compiler)
	* [`latexmk`](https://ctan.org/pkg/latexmk/)

# Settings
The following JSON code can be added to either the projects settings at `.vscode/settings.json`, or to the global settings at `~/.config/Code/User/settings.json` such that LuaLaTeX is used to compile `.tex` files every time they are saved within VSCode.
```json
{
	// ...
	"latex-workshop.latex.tools": [
		{
			"name": "lualatexmk",
			"command": "latexmk",
			"args": [
				"-synctex=1",
				"-interaction=nonstopmode",
				"-file-line-error",
				"-lualatex",
				"-outdir=%OUTDIR%",
				"%DOC%"
			]
		}
	],
	"latex-workshop.latex.recipes": [
		{
			"name": "lualatexmk",
			"tools": [
				"lualatexmk",
			]
		}
	],
	// ...
}
```

These settings can be further modified if you need to use multiple compilation steps in sequence, or if you want to use different compilation settings. I found `latexmk` to be immensely useful when a document should be compiled multiple times, especially when a single compilation produces metadata for a subsequent compilation.


## Disabling Automatic Compilation
In case you want to work on a `.tex` document, but you don't VSCode to compile it for you every time you save it, you can override the global settings with the following JSON code, added to `.vscode/settings.json`.

```json
{
	// ...
	"latex-workshop.latex.recipes": [],
	"latex-workshop.latex.autoBuild.run": "never",
	// ...
}
```