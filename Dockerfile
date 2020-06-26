FROM scratch
FROM golang:1.11-alpine3.8 AS build-env

RUN apk update && apk upgrade && \
   apk add --no-cache bash git gcc musl-dev

ENV GO111MODULE=on

WORKDIR /go/src/server

ADD . /go/src/server

#disable crosscompiling
ENV CGO_ENABLED=1

#compile linux only
ENV GOOS=linux

#build the binary with debug information removed
RUN go build -ldflags '-w -s' -a -installsuffix cgo -o /aws-s3-proxy

FROM alpine:3.8
WORKDIR /
ENV PATH=/

ENV AWS_REGION=us-east-1 \
    APP_PORT=80 \
    ACCESS_LOG=false \
    CONTENT_ENCODING=false \
    DISABLE_COMPRESSION=true

COPY --from=1 /aws-s3-proxy /aws-s3-proxy
ENTRYPOINT ["/aws-s3-proxy"]
