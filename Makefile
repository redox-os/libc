export PATH := build/prefix/bin:$(PATH)

all: bin/c-test bin/ed bin/dosbox bin/lua bin/luac bin/sdl-test bin/tar bin/thread-test lib/libc.a lib/libm.a lib/libpng.a lib/libz.a

bin/c-test: c-test.c
	i386-elf-redox-gcc -Os -static -o $@ $<

bin/ed: ed.c
	i386-elf-redox-gcc -Os -static -o $@ $<

bin/sdl-test: sdl-test.c
	i386-elf-redox-gcc -Os -static -o $@ $< -lSDL

bin/thread-test: thread-test.c
	i386-elf-redox-gcc -Os -static -o $@ $<

bin/%: build/sysroot/usr/bin/%
	cp $< $@

lib/libpng.a: build/sysroot/usr/lib/libpng.a
	cp $< $@

lib/libz.a: build/sysroot/usr/lib/libz.a
	cp $< $@

lib/%: build/prefix/i386-elf-redox/lib/%
	cp $< $@

install: all
	mkdir -p ../filesystem/bin/
	cp bin/* ../filesystem/bin/

libc:
	./libc.sh

clean:
	rm -f bin/* *.list *.o
