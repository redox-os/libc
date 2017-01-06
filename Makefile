export PATH := build/prefix/bin:$(PATH)
TARGET=x86_64-elf-redox

all: \
	libc \
	tests

clean:
	rm -rf artifacts/bin artifacts/lib

libc: \
	artifacts/lib/crt0.o \
	artifacts/lib/libc.a \
	artifacts/lib/libm.a \
	artifacts/lib/libgcc.a

tests: \
	artifacts/bin/c-test \
	artifacts/bin/ed \
	artifacts/bin/sdl-test \
	artifacts/bin/sdl2-test \
	artifacts/bin/thread-test

artifacts/bin/c-test: tests/c-test.c
	mkdir -p artifacts/bin
	$(TARGET)-gcc -Os -static -o $@ $<

artifacts/bin/ed: tests/ed.c
	mkdir -p artifacts/bin
	$(TARGET)-gcc -Os -static -o $@ $<

artifacts/bin/sdl-test: tests/sdl-test.c
	mkdir -p artifacts/bin
	$(TARGET)-gcc -Os -static -o $@ $< -lSDL

artifacts/bin/sdl2-test: tests/sdl2-test.c
	mkdir -p artifacts/bin
	$(TARGET)-gcc -Os -static -o $@ $< -lSDL2

artifacts/bin/thread-test: tests/thread-test.c
	mkdir -p artifacts/bin
	$(TARGET)-gcc -Os -static -o $@ $<

artifacts/lib/libgcc.a: build/prefix/lib/gcc/$(TARGET)/*/libgcc.a
	mkdir -p artifacts/lib
	cp $< $@

artifacts/lib/%: build/prefix/$(TARGET)/lib/%
	mkdir -p artifacts/lib
	cp $< $@
