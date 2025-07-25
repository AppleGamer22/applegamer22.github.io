FROM ghcr.io/gohugoio/hugo:v0.148.1 AS hugo
WORKDIR /hugo
RUN apk add --no-cache tzdata
COPY assets assets
COPY content content
COPY layouts layouts
COPY static static
COPY .git .git
COPY hugo.yml .
COPY go.mod .
COPY go.sum .
ARG BASE="/"
RUN hugo --minify --baseURL "$BASE"

FROM --platform=$BUILDPLATFORM caddy:2.10.0-alpine as caddy
WORKDIR /var/www/html
COPY --from=hugo /hugo/public .
EXPOSE 80
CMD caddy file-server
