# Developing in Golang inside Docker containers
# Copyright (c) 2017 Davide Madrisan <davide.madrisan@gmail.com>

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

help:
	@echo 'Developing in Golang inside Docker containers.'
	@echo 'Copyright (c) 2017 Davide Madrisan <davide.madrisan@gmail.com>'
	@echo
	@echo 'Usage:'
	@echo ' - Print the help message'
	@echo '    make go'
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
	@echo '    make go CROSSCOMPILE="-e GOOS=darwin -e GOARCH=amd64" build helloworld.go'
	@echo

%:
	@:

.PHONY: image
