FROM --platform=$BUILDPLATFORM golang:1.23.0-alpine AS hugo
WORKDIR /hugo
RUN apk add --no-cache tzdata hugo git
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

FROM --platform=$BUILDPLATFORM caddy:2.8.4-alpine as caddy
WORKDIR /var/www/html
COPY --from=hugo /hugo/public .
EXPOSE 80
CMD caddy file-server
