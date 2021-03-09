# Go parameters
GOCMD := go
GOFMT := $(GOCMD) fmt
GOMOD := $(GOCMD) mod
GOBUILD := $(GOCMD) build

# App parameters
APP_NAME := nvidia_gpu_prometheus_exporter
APP_VERSION := $(shell git describe --always --tag)

BUILD_OPTION := -ldflags="\
	-X 'main.Version=$(APP_VERSION)' -s -w"

fmt:
		$(GOFMT) ./...

vendor:
		$(GOMOD) vendor

docker_build: fmt vendor
		CGO_ENABLED=1 GOOS=linux GOARCH=amd64 $(GOBUILD) $(BUILD_OPTION) -o /$(APP_NAME) -v ./main.go
