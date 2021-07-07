APP_NAME = gcr-cleaner-cli
VERSION ?= SNAPSHOT

GOENV = CGO_ENABLED=0 GOOS=linux GOARCH=amd64
LDFLAGS = -ldflags "-X main.version=$(VERSION)"
PACKAGES := $(shell go list ./... | grep -v /vendor/)

.DEFAULT_GOAL := help

.PHONY: build
build: ## Build the binary
	@echo "Building binary"
	$(GOENV) go build $(LDFLAGS) -a -installsuffix cgo \
	-o $(APP_NAME) ./cmd/$(APP_NAME)

.PHONY: test
test: ## Run Tests into the packages
	@echo "Running tests"
	go test -v -covermode=atomic -coverpkg=./... -coverprofile=cover.out ./...

.PHONY: integration
integration: ## Run Tests into the packages
	@echo "Running integration tests"
	go test -v -tags integration -covermode=atomic -coverpkg=./... -coverprofile=cover.out ./...

.PHONY: all
all: test build ## Run the tests, build the binary and push the docker image

.PHONY: help
help: ## Help
	@echo "Please use 'make <target>' where <target> is ..."
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
