export PATH := build/prefix/bin:$(PATH)

all: bin/c-test bin/ed bin/lua bin/luac bin/nasm bin/ndisasm bin/pcc bin/sdl-test bin/thread-test lib/libc.a lib/libm.a lib/libpng.a lib/libz.a

binutils: bin/addr2line bin/ar bin/as bin/c++filt bin/elfedit bin/gprof bin/ld bin/ld.bfd bin/nm bin/objcopy bin/objdump bin/ranlib bin/readelf bin/size bin/strings bin/strip

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
