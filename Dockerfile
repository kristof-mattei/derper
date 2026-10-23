FROM golang:1.27.3-alpine@sha256:b8c9b82affbbb82a020bbcf998dad2ba9516944ac7e883524642a481a9505e9c AS builder

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
