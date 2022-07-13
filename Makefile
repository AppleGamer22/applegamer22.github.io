.PHONY: build watch clean

build:
	hugo --minify

watch:
	hugo server --noHTTPCache

clean:
	rm -rf public resources/_gen assets/jsconfig.json hugo_stats.json .hugo_build.lock