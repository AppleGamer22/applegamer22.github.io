.PHONY: build website cv watch clean

build: cv website

cv:
	latexmk -pdf -lualatex cv.tex
	mv cv.pdf static

website:
	hugo --minify

watch:
	hugo server --noHTTPCache

clean:
	rm -rf public resources/_gen assets/jsconfig.json hugo_stats.json .hugo_build.lock
	latexmk -c