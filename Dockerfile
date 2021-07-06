FROM gcr.io/faceit-general/alpine-base:3

ADD gcr-cleaner-cli /usr/local/bin/gcr-cleaner-cli

CMD ["/usr/local/bin/gcr-cleaner-cli"]
