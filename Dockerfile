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

FROM --platform=$BUILDPLATFORM caddy:2.6.2-alpine as caddy
WORKDIR /var/www/html
COPY --from=hugo /hugo/public .
EXPOSE 80
CMD caddy file-server