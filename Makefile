# Developing in Golang inside Docker containers
# Copyright (c) 2017 Davide Madrisan <davide.madrisan@gmail.com>
#
# Usage:
#    make go
#    make go run helloworld.go
#    make go build helloworld.go && ./source/helloworld
#    make go "get -v github.com/golang/example/hello/..." && ./bin/hello
#    make gofmt helloworld.go

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
	sudo $(DOCKER) run $(VOLUMES) --rm $(IMAGE) $$args

gofmt: image
	@args='$(filter-out $@,$(MAKECMDGOALS))'; \
	sudo $(DOCKER) run $(VOLUMES) --rm --entrypoint=$(GOFMT) $(IMAGE) $$args

%:
	@:

.PHONY: image
