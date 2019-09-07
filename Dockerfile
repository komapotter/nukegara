FROM golang:1.13 as builder

RUN mkdir -p /go/src/go-dummy-api
WORKDIR /go/src/go-dummy-api

COPY ./go.mod ./go.sum /go/src/go-dummy-api/
RUN go mod tidy

COPY ./main.go /go/src/go-dummy-api/

RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o bin/go-dummy-api \
  && cp bin/go-dummy-api /usr/local/bin/go-dummy-api \
  && chmod +x /usr/local/bin/go-dummy-api

FROM alpine:3.8 as runner

ENV TZ Asia/Tokyo
RUN apk add --update --no-cache ca-certificates tzdata bash jq && \
    cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

COPY --from=builder /usr/local/bin/go-dummy-api /usr/local/bin/go-dummy-api
COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN adduser -u 1000 -s /sbin/nologin -D www-data && \
    chown www-data /usr/local/bin/go-dummy-api && \
    chmod +x /usr/local/bin/go-dummy-api && \
    chmod +x /usr/local/bin/docker-entrypoint.sh
USER www-data

EXPOSE 1323

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["/usr/local/bin/go-dummy-api"]
