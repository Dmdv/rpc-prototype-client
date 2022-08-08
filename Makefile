GOPATH:=$(shell go env GOPATH)

.PHONY: prerequisites
prerequisites:
	@brew install helm
	@brew install skaffold
#	@curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
#	@chmod 700 get_helm.sh
#	@./get_helm.sh

.PHONY: update
update:
	@go get -u

.PHONY: tidy
tidy:
	@go mod tidy

.PHONY: build
build:
	@CGO_ENABLED=0 go build -ldflags "-s -w" -trimpath -o rpcx-client *.go

.PHONY: test
test:
	@go test -v ./... -cover

.PHONY: docker
docker:
	@docker build -t rpcx-client:latest .
