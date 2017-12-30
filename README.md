<img width="15%" src="https://raw.github.com/golang-samples/gopher-vector/master/gopher.png"/>

# Go without (installing) go

This small Docker project was started to run go without installing go.

Why not installing a go compiler and toolchain provided by your Linux distribution?

These are some possible reasons:

 * the compiler shipped by the distribution may not be the latest (or a recent) stable version released upstream;
 * we may want to download and build a project and all its dependencies on a clean system all the time;
 * we may want to cross compile a Go project;
 * we may want to test different versions of the Go compiler.

## Running a program in a container

    make go run /source/helloworld.go

or (because `/source` is the workdir of the Docker container)

    make go run helloworld.go

## Compiling a program in a container

    make go build helloworld.go
    ./source/helloworld

Note that [Docker-CE][docker-ce] and [Docker Compose][docker-compose] must be installed in order
the make commands to work.

If you prefer, you can define the following two command aliases (in the file `~/.bashrc` for instance)

    alias dgo="sudo docker-compose run --rm golang_alpine"
    alias dgofmt="sudo docker-compose run --rm --entrypoint gofmt golang_alpine"

and run and compile your Go project this way:

    sudo docker-compose build golang_alpine
    
    . ~/.bashrc

    dgo run helloworld.go
    
    dgo build helloworld.go
    ./souces/helloworld

or format the source code with the tool `gofmt`:

    dgofmt -w helloworld.go

[docker-ce]: https://www.docker.com/community-edition/
[docker-compose]: https://docs.docker.com/compose/
