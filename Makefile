APP := go-dummy-api

.PHONY: build
build:
	@go build -o bin/${APP}

.PHONY: clean
clean:
	@rm -fr bin/*

.PHONY: deps
deps:
	@dep ensure -v

.PHONY: docker-build
docker-build:
	@docker-compose build

.PHONY: docker-start
docker-start:
	@docker-compose up -d

.PHONY: docker-stop
docker-stop:
	@docker-compose down
