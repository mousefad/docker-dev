FROM alpine:latest
USER root
RUN apk update
RUN apk add git fossil
RUN mkdir -p /var/fossil
CMD ["fossil", "server", "/var/fossil"]
