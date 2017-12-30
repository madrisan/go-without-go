# Developing in Golang inside Docker containers
# Copyright (c) 2017 Davide Madrisan <davide.madrisan@gmail.com>
#
# Usage:
#    make go
#    make go run /source/helloworld.go
#    make go build /source/helloworld.go
#    make gofmt /source/helloworld.go

COMPOSE = $(shell command -v docker-compose 2>/dev/null)
ifndef COMPOSE
        $(error "please install docker-compose or adjust the PATH environment")
endif
IMAGE = golang_alpine
GOFMT = /usr/local/bin/gofmt

dockerbuild: $(COMPOSE)
	@sudo $(COMPOSE) build $(IMAGE)

go: dockerbuild
	@args='$(filter-out $@,$(MAKECMDGOALS))'; \
	sudo $(COMPOSE) run --rm $(IMAGE) $$args

gofmt: dockerbuild
	@args := $(filter-out $@,$(MAKECMDGOALS)); \
	sudo $(COMPOSE) run --rm --entrypoint $(GOFMT) $(IMAGE) $$args

%:
	@:

.PHONY: dockerbuild
