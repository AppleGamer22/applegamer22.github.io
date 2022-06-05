.PHONY: build watch clean

build:
	hugo --minify

watch:
	hugo server

clean:
	rm -rf public .hugo_build.lock