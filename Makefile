.PHONY: build website cv watch clean

build: website cv

cv:
	lualatex cv.tex
	mv cv.pdf static

website:
	hugo --minify

watch: cv
	hugo server --noHTTPCache

clean:
	rm -rf public resources/_gen assets/jsconfig.json hugo_stats.json .hugo_build.lock *.aux *.log *.out *.synctex.gz *.toc *.pdf