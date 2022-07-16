.PHONY: build website cv watch clean

build: cv website

cv:
	lualatex cv.tex
	lualatex cv.tex
	mv cv.pdf static

website:
	hugo --minify

watch:
	hugo server --noHTTPCache

clean:
	rm -rf public resources/_gen assets/jsconfig.json hugo_stats.json .hugo_build.lock *.aux *.log *.out *.synctex.gz *.toc *.pdf