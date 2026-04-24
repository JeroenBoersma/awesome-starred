FROM docker.io/library/golang:alpine

RUN go install github.com/juev/starred@latest

ENTRYPOINT ["/go/bin/starred"]

