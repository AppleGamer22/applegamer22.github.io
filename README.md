# applegamer22.github.io
My [personal website](https://applegamer22.github.io), built with [Hugo](http://gohugo.io/) and [Congo](https://jpanther.github.io/congo/).

# Changes to Default Congo Theme
## KaTeX
The following `layouts/partials/extend-head.html` code is based [this comment](https://github.com/jpanther/congo/discussions/23#discussioncomment-1550774) from the Congo Theme discussion board, and [this file](https://github.com/jpanther/congo/blob/stable/layouts/partials/vendor.html) from Congo Theme's codebase.

```html
{{$katexCSS := resources.Get "lib/katex/katex.min.css"}}
{{$katexCSS := $katexCSS | resources.Fingerprint "sha512"}}
<link type="text/css" rel="stylesheet" href="{{$katexCSS.RelPermalink}}" integrity="{{$katexCSS.Data.Integrity}}">
{{$katexJS := resources.Get "lib/katex/katex.min.js"}}
{{$katexJS := $katexJS | resources.Fingerprint "sha512"}}
<script defer src="{{$katexJS.RelPermalink}}" integrity="{{$katexJS.Data.Integrity}}"></script>
{{$katexRenderJS := resources.Get "lib/katex/auto-render.min.js"}}
{{$katexRenderJS := $katexRenderJS | resources.Fingerprint "sha512"}}
<script defer src="{{$katexRenderJS.RelPermalink}}" integrity="{{$katexRenderJS.Data.Integrity}}"></script>
<script>
	document.addEventListener("DOMContentLoaded", () => {
		renderMathInElement(document.body, {
			delimiters: [
				{
					left: '$$',
					right: '$$',
					display: true
				},
				{
					left: '$',
					right: '$',
					display: false
				},
			],
			throwOnError: false
		});
	});
</script>
```

This change makes the KaTeX CSS and JavaScript files to load by default, and it also enables the single `$` delimiter to be used with less future configuration.

## CSS
### Horizontal Scroll on Small-Width Screens
The following CSS was added to `assets/css/custom.css` (based on [Congo Theme's `main.css`](https://github.com/jpanther/congo/blob/dev/assets/css/compiled/main.css#L72856)) in order to disable horizontal scrolling in small-width screens.

```css
@media (max-width: 640px) {
	body, html {
		max-width: 100% !important;
		overflow-x: hidden !important;
	}
}
```

### Default Fixed-Width Font
The following CSS was added to `assets/css/custom.css` in order to set [Fira Code](https://github.com/tonsky/FiraCode) (or the default) as the default fixed-width font, used in code snippets.

```css
code {
	font-family: 'Fira Code', monospace !important;
}
```

### Backtick-less Inline Code Snippets
The following CSS was added to `assets/css/custom.css` in order to revert [Congo Theme's `main.css`](https://github.com/jpanther/congo/blob/dev/assets/css/compiled/main.css#L745-L751) that surrounds inline code snippets with backtick symbols.

```css
.prose :where(code):not(:where([class~="not-prose"] *))::before {
	content: unset !important;
}

.prose :where(code):not(:where([class~="not-prose"] *))::after {
	content: unset !important;
}
```

### Content Width
The following CSS was added to `assets/css/custom.css` in order to increase the content width. Based on [Congo Theme's `main.css`](https://github.com/jpanther/congo/blob/dev/assets/css/compiled/main.css#L1946-L1956).

```css
.max-w-7xl {
	max-width: 100rem !important;
}

.max-w-prose {
	max-width: 100ch !important;
}
```
