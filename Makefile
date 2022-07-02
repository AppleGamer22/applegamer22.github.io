.PHONY: build watch clean

build:
	hugo --minify

watch:
	hugo server --baseURL http://localhost:1313

clean:
	rm -rf public .hugo_build.lock