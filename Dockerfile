FROM golang:1.14.7 as builder

RUN mkdir -p /go/src/nukegara
WORKDIR /go/src/nukegara

COPY ./go.mod ./go.sum /go/src/nukegara/
RUN go mod tidy

COPY ./main.go /go/src/nukegara/

RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o bin/nukegara \
  && cp bin/nukegara /usr/local/bin/nukegara \
  && chmod +x /usr/local/bin/nukegara

FROM alpine:3.8 as runner

ENV TZ Asia/Tokyo
RUN apk add --update --no-cache ca-certificates tzdata bash jq && \
    cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

COPY --from=builder /usr/local/bin/nukegara /usr/local/bin/nukegara
COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN adduser -u 1000 -s /sbin/nologin -D www-data && \
    chown www-data /usr/local/bin/nukegara && \
    chmod +x /usr/local/bin/nukegara && \
    chmod +x /usr/local/bin/docker-entrypoint.sh
USER www-data

EXPOSE 1323

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["/usr/local/bin/nukegara"]
