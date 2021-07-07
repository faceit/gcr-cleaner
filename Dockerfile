FROM gcr.io/faceit-general/alpine-base:3 AS builder

RUN apk add binutils upx

ADD gcr-cleaner-cli /tmp/gcr-cleaner-cli

RUN strip /tmp/gcr-cleaner-cli
RUN upx -q -9 /tmp/gcr-cleaner-cli

FROM scratch
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /tmp/gcr-cleaner-cli /usr/local/bin/gcr-cleaner-cli

ENTRYPOINT ["/usr/local/bin/gcr-cleaner-cli"]
