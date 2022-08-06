# applegamer22.github.io
My [personal website](https://applegamer22.github.io), built with [Hugo](https://gohugo.io) and [Congo](https://jpanther.github.io/congo/).

# Additions to Congo
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
{{ $katexFonts := resources.Match "lib/katex/fonts/*" }}
{{ range $katexFonts }}
	<!-- {{ .RelPermalink }} -->
{{ end }}
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

Due to Hugo use of the `\`  character for text escaping, The sequence `\\\` is required instead of `\\` (at the source-code level) in order to correctly render a line break. This change does not seem tp affect $\TeX$ rendering in other platforms.

## Technical Diagrams
The following `layouts/partials/extend-head.html` code is based on [Docsy's diagram support](https://www.docsy.dev/docs/adding-content/diagrams-and-formulae/#diagrams-with-mermaid), and implemented similarly to [Docsy's implementation](https://github.com/google/docsy/blob/main/assets/js/mermaid.js), and [Congo's implementation](https://github.com/jpanther/congo/blob/stable/assets/js/mermaid.js), the theme settings are based on [Mermaid's documentation](https://mermaid-js.github.io/mermaid/#/theming).

```html
{{$mermaidLib := resources.Get "lib/mermaid/mermaid.min.js"}}
{{$mermaidConfig := resources.Get "js/mermaid.js"}}
{{$mermaidConfig := $mermaidConfig | resources.Minify}}
{{$mermaidJS := slice $mermaidLib $mermaidConfig | resources.Concat "js/mermaid.bundle.js" | resources.Fingerprint "sha512"}}
<script defer type="text/javascript" src="{{$mermaidJS.RelPermalink}}" integrity="{{$mermaidJS.Data.Integrity}}"></script>

<script>
	/**
	 * @type {string} color an RGB tuple that represents a colour in CSS
	 * @returns an RGB CSS function form of the variable
	*/
	function tuple2RGB(color) {
		return `rgb(${getComputedStyle(document.documentElement).getPropertyValue(color)})`;
	}
	/** @returns text colour appropriate for colour theme */
	function textColor() {
		switch (document.documentElement.classList.contains("dark")) {
		case true:
			return "white";
		case false:
			return "black";
		}
	}
	document.addEventListener("DOMContentLoaded", () => {
		for (const diagram of document.querySelectorAll("code.language-mermaid")) {
			const text = diagram.textContent;
			const pre = document.createElement("pre");
			pre.classList.add("mermaid");
			pre.textContent = text;
			diagram.parentElement.replaceWith(pre);
		}
		mermaid.initialize({
			theme: "base",
			themeVariables: {
				background: tuple2RGB("--color-neutral"),
				primaryColor: tuple2RGB("--color-primary-200"),
				secondaryColor: tuple2RGB("--color-secondary-200"),
				tertiaryColor: tuple2RGB("--color-neutral-100"),
				primaryBorderColor: tuple2RGB("--color-primary-400"),
				secondaryBorderColor: tuple2RGB("--color-secondary-400"),
				tertiaryBorderColor: tuple2RGB("--color-neutral-400"),
				lineColor: tuple2RGB("--color-neutral-600"),
				textColor: textColor(),
				loopTextColor: textColor(),
				primaryTextColor: "black",
				fontFamily: "ui-sans-serif,system-ui,-apple-system,BlinkMacSystemFont,segoe ui,Roboto,helvetica neue,Arial,noto sans,sans-serif",
				fontSize: "16px"
			}
		});
	});
</script>
```

The following CSS was added to `assets/css/custom.css`, in order to make the diagram's background colour transparent.

```css
pre.mermaid {
	background-color: transparent !important;
}
```

# Changes to Congo
## CSS
### Horizontal Scrolling
The following CSS was added to `assets/css/custom.css` in order to disable horizontal scrolling.

* The single-line width of HTML `a` tags HTML tags is capped at the screen width.
* Horizontal scroll is disabled on the HTML `body` scope.

```css
body {
	overflow-x: hidden;
}

a {
	max-width: 100vw !important;
	word-wrap: break-word !important;
}
```

In order to render multi-line [math expressions](#katex) correctly in small-width screens, the following CSS code was added to `assets/css/custom.css`:

```css
@media (max-width: 640px) {
	span.katex-display > * {
		font-size: 0.65rem !important;
	}
}
```

In order to ensure search results don't overflow the [intended width](https://github.com/jpanther/congo/blob/stable/assets/css/compiled/main.css), the maximum width is restricted accordingly.

```css
#search-results > li > a > * {
	max-width: calc(100% - 1.5rem) !important;
	word-wrap: break-word !important;
}
```

### Fixed-Width Font
The following CSS was added to `assets/css/custom.css` (based on [this Stack Overflow comment](https://stackoverflow.com/a/68522798/7148921)) in order to set [Fira Code](https://github.com/tonsky/FiraCode)/[Cascadia Code](https://github.com/microsoft/cascadia-code) (or the OS's default) as the fixed-width font, used in code snippets.

```css
@font-face {
	font-family: 'Fira Code';
	src: local('FiraCode-Regular'), url('/FiraCode-Regular.ttf') format('truetype');
}
code {
	font-family: 'Cascadia Code', 'Fira Code', monospace !important;
}
```

### Backtick-less Inline Code Snippets
The following CSS was added to `assets/css/custom.css` in order to revert [Congo Theme's `main.css`](https://github.com/jpanther/congo/blob/stable/assets/css/compiled/main.css) that surrounds inline code snippets with backtick symbols.

```css
.prose :where(code):not(:where([class~="not-prose"] *))::before {
	content: unset !important;
}
.prose :where(code):not(:where([class~="not-prose"] *))::after {
	content: unset !important;
}
```

### Quote-less Block Quote
The following CSS was added to `assets/css/custom.css` in order to revert [Congo Theme's `main.css`](https://github.com/jpanther/congo/blob/stable/assets/css/compiled/main.css) that surrounds block quote with literal quotes.

```css
.prose :where(blockquote p:first-of-type):not(:where([class~="not-prose"] *))::before {
	content: unset !important;
}

.prose :where(blockquote p:last-of-type):not(:where([class~="not-prose"] *))::after {
	content: unset !important;
}
```

### Content Width
The following CSS was added to `assets/css/custom.css` in order to increase the content width. Based on [Congo Theme's `main.css`](https://github.com/jpanther/congo/blob/stable/assets/css/compiled/main.css).

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