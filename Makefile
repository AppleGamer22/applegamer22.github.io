.PHONY: build website cv watch clean

build: cv website

cv: cv.pdf
	mv cv.pdf static

cv.pdf: cv.tex
	latexmk -pdf -lualatex -interaction=errorstopmode cv.tex

website:
	hugo --minify

watch:
	hugo server --noHTTPCache --buildDrafts --buildFuture

clean:
	hugo mod clean --all
	rm -rf public assets/jsconfig.json hugo_stats.json .hugo_build.lock cv.synctex.gz
	latexmk -C