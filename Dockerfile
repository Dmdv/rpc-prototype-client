FROM golang:1.18-alpine AS builder

ARG GOPROXY
ARG BUILD_TARGET
ARG BUILD_ENVIRONMENT

ENV GO111MODULE=on
ENV CGO_ENABLED=0 GOOS=linux

WORKDIR /go/src/rpcx-client

RUN apk --update --no-cache add ca-certificates tzdata git bash curl linux-headers libtool make protoc

COPY Makefile go.mod go.sum ./

RUN go mod download
COPY . .
RUN make tidy build

FROM alpine:latest as production

COPY --from=builder /etc/ssl/certs /etc/ssl/certs
COPY --from=builder /go/src/rpcx-client/rpcx-client /rpcx-client
ENTRYPOINT ["/rpcx-client"]
CMD []
