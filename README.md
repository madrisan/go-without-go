<img width="15%" src="https://raw.github.com/golang-samples/gopher-vector/master/gopher.png"/>

# Go without (installing) go

This small Docker project was started to run go without installing go.

Why not installing a go compiler and toolchain provided by your Linux distribution?

These are some possible reasons:

 * the compiler shipped by the distribution may not be the latest (or a recent) stable version released upstream;
 * we may want to download and build a project and all its dependencies on a clean system all the time;
 * we may want to cross compile a Go project;
 * we may want to test different versions of the Go compiler.

## Pre-requirements

[Docker-CE][docker-ce] must be installed and the `docker` daemon running.

## Running a program in a container

    make go run /source/helloworld.go

or (because `/source` is the workdir of the Docker container)

    make go run helloworld.go

You can replace `make` by `make QUIET=1` to reduce the verbosity of the output messages.

## Compiling a program in a container

    make go build helloworld.go
    ./source/helloworld

    make go "get -v github.com/golang/example/hello/..."
    ./bin/hello

## Cross compilation

    make go CROSSCOMPILE="-e GOOS=darwin -e GOARCH=amd64" build helloworld.go
      >> ./source/helloworld
    make go CROSSCOMPILE="-e GOOS=darwin -e GOARCH=amd64" "get -v github.com/golang/example/hello/..."
      >> bin/darwin_amd64/hello
    file bin/darwin_amd64/hello
      >> bin/darwin_amd64/hello: Mach-O 64-bit x86_64 executable, flags:<NOUNDEFS>

## Help message

    make help

If you prefer, you can define the following two command aliases (in the file `~/.bashrc` for instance)

    alias dgo="sudo docker run -v $PWD/source:/source -v $PWD/bin:/go/bin --rm gowithoutgo_alpine"
    alias dgofmt="sudo docker run -v $PWD/source:/source -v $PWD/bin:/go/bin --rm --entrypoint gofmt gowithoutgo_alpine"

and run and compile your Go project this way:

    make image
    . ~/.bashrc

    dgo run helloworld.go
    
    dgo build helloworld.go
    ./souces/helloworld

or format the source code with the tool `gofmt`:

    dgofmt -w helloworld.go

[docker-ce]: https://www.docker.com/community-edition/

## Go language resources

Some resources for learning the Go language:

  * Tour of Go (https://tour.golang.org/welcome/1)
  * Go by Example (https://gobyexample.com/)
  * Learning Go online book (https://www.miek.nl/go/)
  *  The Go Programming Language Specification (https://golang.org/ref/spec)
