.PHONY: all build website cv pdf watch clean

all: build clean

build: cv website

cv: pdf
	mv cv.pdf static

pdf: cv.tex
	latexmk -pdf -lualatex -interaction=errorstopmode cv.tex

website:
	hugo --minify

watch:
	hugo server --noHTTPCache --buildDrafts

clean:
	rm -rf public resources/_gen assets/jsconfig.json hugo_stats.json .hugo_build.lock cv.synctex.gz cv.pdf
	latexmk -c