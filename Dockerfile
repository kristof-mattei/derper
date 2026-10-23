FROM golang:1.26.1-alpine@sha256:2389ebfa5b7f43eeafbd6be0c3700cc46690ef842ad962f6c5bd6be49ed82039 AS builder

RUN apk add --no-cache git

ENV CGO_ENABLED=0 GOOS=linux

RUN go install tailscale.com/cmd/derper@latest

FROM alpine:3.24@sha256:be2656061b536c1883c4034790e21d0a09c5aaaf51968b89368a3c0371ea2c9a

RUN apk add --no-cache ca-certificates \
    && addgroup -S derper \
    && adduser -S -G derper derper

COPY --from=builder /go/bin/derper /usr/local/bin/derper

USER derper

EXPOSE 443 80 3478/udp

ENTRYPOINT ["/usr/local/bin/derper"]
