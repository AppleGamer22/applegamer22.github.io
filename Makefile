.PHONY: build watch

build:
	hugo --minify

watch:
	hugo server