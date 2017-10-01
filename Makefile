CBL=cobc
CBLFLAGS=-Wall

CBL_SOURCES=$(shell find src -type f -name '*.cbl')
CBL_OBJECTS=$(patsubst src/%.cbl,build/%.o,${CBL_SOURCES})

SERVER_SOURCE=src/server.cob
SERVER_TARGET=build/cobmud-server
SERVER_CBLFLAGS=-lzmq

all: build

build: ${SERVER_TARGET}

.PHONY: clean
clean:
	rm -rf build

${SERVER_TARGET}: ${SERVER_SOURCE} ${CBL_OBJECTS}
	mkdir -p $(dir $@)
	${CBL} ${CBLFLAGS} ${SERVER_CBLFLAGS} -x -o $@ $^

build/%.o: src/%.cbl
	mkdir -p $(dir $@)
	${CBL} ${CBLFLAGS} -o $@ -c $<
