# Developing in Golang inside Docker containers
# Copyright (c) 2017 Davide Madrisan <davide.madrisan@gmail.com>
#
# Usage:
#  - Help message
#     make go
#  - Go run / build / get commands
#     make go run helloworld.go
#     make go build helloworld.go && ./source/helloworld
#     make go "get -v github.com/golang/example/hello/..." && ./bin/hello
#  - Run the go code formatter 'gofmt'
#     make gofmt helloworld.go
#  - Cross compile a source code:
#     make go CROSSCOMPILE='-e GOOS=darwin -e GOARCH=amd64' build helloworld.go
#     file source/helloworld
#       # source/helloworld: Mach-O 64-bit x86_64 executable, flags:<NOUNDEFS>

DOCKER = $(shell command -v docker 2>/dev/null)
ifndef DOCKER
        $(error "please install docker-ce or adjust the PATH environment")
endif

IMAGE = gowithoutgo_alpine
PWD = $(shell pwd)
VOLUMES = -v $(PWD)/source:/source -v $(PWD)/bin:/go/bin

GOFMT = /usr/local/bin/gofmt

image: $(DOCKER)
	@sudo $(DOCKER) image build -t $(IMAGE) alpine

go: image
	@args='$(filter-out $@,$(MAKECMDGOALS))'; \
	sudo $(DOCKER) run $(CROSSCOMPILE) $(VOLUMES) --rm $(IMAGE) $$args

gofmt: image
	@args='$(filter-out $@,$(MAKECMDGOALS))'; \
	sudo $(DOCKER) run $(VOLUMES) --rm --entrypoint=$(GOFMT) $(IMAGE) $$args

%:
	@:

.PHONY: image
