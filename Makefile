export PATH := build/prefix/bin:$(PATH)

all: bin/c-test bin/sdl-test bin/sdl-ttf-test

bin/c-test: c-test.c
	i386-elf-redox-gcc -Os -static -o $@ $<

bin/sdl-test: sdl-test.c
	i386-elf-redox-gcc -Os -static -o $@ $< -lSDL

bin/sdl-ttf-test: sdl-ttf-test.c
	i386-elf-redox-gcc -Os -static -o $@ $< -lSDL_ttf -lSDL_image -lSDL -lfreetype -lpng -lz -lm

install: all
	mkdir -p ../filesystem/bin/
	cp bin/* ../filesystem/bin/

libc:
	./libc.sh

clean:
	rm -f bin/* *.list *.o
