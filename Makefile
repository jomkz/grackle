.PHONY: build

DOCKER_IP  ?= 172.17.0.1
IMAGE_REPO ?= quay.io/jmckind
IMAGE_NAME ?= grackle
IMAGE_TAG  ?= latest
IMAGE_URL  := $(IMAGE_REPO)/$(IMAGE_NAME):$(IMAGE_TAG)
GO_CMD ?= GO111MODULE=on go

build: build-ingest build-web

build-ingest:
	mkdir -p build
	$(GO_CMD) build -a -o build/grackle-ingest cmd/ingest/main.go

build-web:
	mkdir -p build
	$(GO_CMD) build -a -o build/grackle-web cmd/web/main.go

clean:
	rm -fr build

docker-image:
	docker build -t $(IMAGE_URL) .

docker-push:
	docker push $(IMAGE_URL)

run-docker-grackle-web:
	docker run -it -p 8000:8000 $(IMAGE_URL) /grackle-web --rethinkdb-host $(DOCKER_IP) --log-level debug

run-local-ingest:
	$(GO_CMD) run cmd/ingest/main.go

run-local-web:
	$(GO_CMD) run cmd/web/main.go

run-local-rethinkdb:
	docker run -d -p 28015:28015 -p 29015:29015 -p 8080:8080 rethinkdb:2.3.6
