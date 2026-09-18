FROM golang:1.27.1-alpine@sha256:4cb7ac979db5fcc41cae44b2227ba5ab8a51e8807f40d9ba4dee20a0ad960b5b AS builder

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
