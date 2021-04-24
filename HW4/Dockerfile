FROM alpine:3
RUN apk update && apk add iputils
ENTRYPOINT ["/bin/ping", "-c", "5"]
CMD ["localhost"]
