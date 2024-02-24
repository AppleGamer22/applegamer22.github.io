.PHONY: build website cv watch clean deploy

build: cv website

cv: cv.pdf
	mv cv.pdf static

cv.pdf: cv.tex
	latexmk -pdf -lualatex -interaction=errorstopmode cv.tex

website:
	hugo --gc --minify

gh-pages:
	git clone --depth=1 --single-branch --branch gh-pages https://github.com/AppleGamer22/applegamer22.github.io.git gh-pages

deploy: website gh-pages
	cd gh-pages;\
	git rm -r --ignore-unmatch *;\
	cp -r ../public/* .;\
	git add --all;\
	git commit -m "deploy: $(shell git rev-parse HEAD)";\
	git push origin gh-pages

watch:
	hugo server --noHTTPCache --buildDrafts --buildFuture

clean:
	hugo mod clean --all
	rm -rf gh-pages public assets/jsconfig.json hugo_stats.json .hugo_build.lock cv.synctex.gz
	latexmk -C