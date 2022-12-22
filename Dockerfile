FROM --platform=$BUILDPLATFORM golang:1.19.4-alpine AS hugo
WORKDIR /hugo
RUN apk add --no-cache tzdata hugo git
COPY assets assets
COPY content content
COPY layouts layouts
COPY static static
COPY .git .git
COPY config.yml .
COPY go.mod .
COPY go.sum .
ARG BASE="/"
RUN hugo --minify --baseURL "$BASE"

# https://www.docker.com/blog/how-to-use-the-apache-httpd-docker-official-image/
FROM --platform=$BUILDPLATFORM httpd:alpine3.17 AS httpd
COPY --from=hugo /hugo/public /usr/local/apache2/htdocs/