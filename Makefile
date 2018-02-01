# Developing in Golang inside Docker containers
# Copyright (c) 2017 Davide Madrisan <davide.madrisan@gmail.com>

DOCKER = $(shell command -v docker 2>/dev/null)
ifndef DOCKER
        $(error "please install docker-ce or adjust the PATH environment")
endif

IMAGE = gowithoutgo_alpine
PWD = $(shell pwd)
VOLUMES = -v $(PWD)/source:/source -v $(PWD)/bin:/go/bin

ifdef QUIET
        DOCKER_OPTS += --quiet
endif

GOFMT = /usr/local/bin/gofmt

image: $(DOCKER)
	@sudo $(DOCKER) build -t $(IMAGE) $(DOCKER_OPTS) alpine

go: image
	@args='$(filter-out $@,$(MAKECMDGOALS))'; \
	sudo $(DOCKER) run $(GOENV) $(VOLUMES) --rm $(IMAGE) $$args

gofmt: image
	@args='$(filter-out $@,$(MAKECMDGOALS))'; \
	sudo $(DOCKER) run $(VOLUMES) --rm --entrypoint=$(GOFMT) $(IMAGE) $$args

help:
	@echo 'Developing in Golang inside Docker containers.'
	@echo 'Copyright (c) 2017 Davide Madrisan <davide.madrisan@gmail.com>'
	@echo
	@echo 'Usage:'
	@echo ' - Build the Docker container for Go development'
	@echo '    make image'
	@echo
	@echo ' - Print the go help message'
	@echo '    make go'
	@echo
	@echo ' - Go environment'
	@echo '    make go env'
	@echo '    make go GOENV="-e CGO_ENABLED=0" env'
	@echo
	@echo ' - Go run / build / get commands'
	@echo '    make go run helloworld.go'
	@echo '    make go build helloworld.go && ./source/helloworld'
	@echo '    make go "get -v github.com/golang/example/hello/..." && ./bin/hello'
	@echo
	@echo ' - Execute the code formatter "gofmt"'
	@echo '    make gofmt helloworld.go'
	@echo
	@echo ' - Cross compilation:'
	@echo '    make go GOENV="-e GOOS=darwin -e GOARCH=amd64" build helloworld.go'
	@echo '     # --> ./source/helloworld'
	@echo '    make go GOENV="-e GOOS=darwin -e GOARCH=amd64" "get -v github.com/golang/example/hello/..."'
	@echo '     # --> ./bin/darwin_amd64/hello'
	@echo
	@echo ' Run in quiet mode'
	@echo '    You can replace "make" by "make QUIET=1" to reduce the output verbosity.'

%:
	@:

.PHONY: image
