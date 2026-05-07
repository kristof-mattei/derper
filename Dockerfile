FROM golang:1.26.3-alpine@sha256:91eda9776261207ea25fd06b5b7fed8d397dd2c0a283e77f2ab6e91bfa71079d AS builder

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
