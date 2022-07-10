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
### Colour Scheme
The following CSS was added to `assets/css/schemes/fruit.css` (based on Congo's [`congo.css`](https://github.com/jpanther/congo/blob/stable/assets/css/schemes/congo.css) and [`fire.css`](https://github.com/jpanther/congo/blob/stable/assets/css/schemes/fire.css)) change the colour scheme primary and secondary colours from violate-fuchsia to orange-red.

```css
:root {
	--color-neutral: 255, 255, 255;
	/* Gray */
	--color-neutral-50: 250, 250, 250;
	--color-neutral-100: 244, 244, 245;
	--color-neutral-200: 228, 228, 231;
	--color-neutral-300: 212, 212, 216;
	--color-neutral-400: 161, 161, 170;
	--color-neutral-500: 113, 113, 122;
	--color-neutral-600: 82, 82, 91;
	--color-neutral-700: 63, 63, 70;
	--color-neutral-800: 39, 39, 42;
	--color-neutral-900: 24, 24, 27;
	/* Orange */
	--color-primary-50: 255, 247, 237;
	--color-primary-100: 255, 237, 213;
	--color-primary-200: 254, 215, 170;
	--color-primary-300: 253, 186, 116;
	--color-primary-400: 251, 146, 60;
	--color-primary-500: 249, 115, 22;
	--color-primary-600: 234, 88, 12;
	--color-primary-700: 194, 65, 12;
	--color-primary-800: 154, 52, 18;
	--color-primary-900: 124, 45, 18;
	/* Rose */
	--color-secondary-50: 255, 241, 242;
	--color-secondary-100: 255, 228, 230;
	--color-secondary-200: 254, 205, 211;
	--color-secondary-300: 253, 164, 175;
	--color-secondary-400: 251, 113, 133;
	--color-secondary-500: 244, 63, 94;
	--color-secondary-600: 225, 29, 72;
	--color-secondary-700: 190, 18, 60;
	--color-secondary-800: 159, 18, 57;
	--color-secondary-900: 136, 19, 55;
}
```