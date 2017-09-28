all: build

build: build/cobmud-server

.PHONY: clean
clean:
	rm -rf build

.PHONY: build/cobmud-server
build/cobmud-server:
	mkdir -p $(dir $@)
	cobc -Wall -x src/cobmud-server.cbl -lzmq -o $@
