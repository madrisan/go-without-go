FROM golang:alpine as compiler
FROM alpine:latest

MAINTAINER "Davide Madrisan" <d.madrisan@gmail.com>

WORKDIR /usr/local
COPY --from=compiler /usr/local/go .

ENV PATH $GOPATH/bin:$PATH
RUN mkdir -p \
    "$GOPATH/bin" \
    "$GOPATH/pkg" \
    "$GOPATH/src"

RUN set -eux; \
    apk add --no-cache --virtual .build-deps \
        git

WORKDIR /source

ENTRYPOINT ["/usr/local/bin/go"]
CMD ["help"]
