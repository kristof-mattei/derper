FROM golang:1.27.1-alpine@sha256:cf6fca6641884b8433441b2b0652976f975e1d0fdd26d177eaaf8596087f3125 AS builder

RUN apk add --no-cache git

ENV CGO_ENABLED=0 GOOS=linux

RUN go install tailscale.com/cmd/derper@latest

FROM alpine:3.20@sha256:a4f4213abb84c497377b8544c81b3564f313746700372ec4fe84653e4fb03805

RUN apk add --no-cache ca-certificates \
    && addgroup -S derper \
    && adduser -S -G derper derper

COPY --from=builder /go/bin/derper /usr/local/bin/derper

USER derper

EXPOSE 443 80 3478/udp

ENTRYPOINT ["/usr/local/bin/derper"]
