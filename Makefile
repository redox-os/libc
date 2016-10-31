export PATH := build/prefix/bin:$(PATH)
TARGET=x86_64-elf-redox

all: binutils bin/c-test bin/ed bin/lua bin/luac bin/nasm bin/ndisasm bin/pcc bin/sdl-test bin/thread-test lib/crt0.o lib/libc.a lib/libm.a lib/libgcc.a lib/libpng.a lib/libz.a

binutils: bin/addr2line bin/ar bin/as bin/c++filt bin/elfedit bin/gprof bin/ld bin/ld.bfd bin/nm bin/objcopy bin/objdump bin/ranlib bin/readelf bin/size bin/strings bin/strip

bin/c-test: tests/c-test.c
	$(TARGET)-gcc -Os -static -o $@ $<

bin/ed: tests/ed.c
	$(TARGET)-gcc -Os -static -o $@ $<

bin/sdl-test: tests/sdl-test.c
	$(TARGET)-gcc -Os -static -o $@ $< -lSDL

bin/thread-test: tests/thread-test.c
	$(TARGET)-gcc -Os -static -o $@ $<

bin/%: build/sysroot/usr/bin/%
	cp $< $@

lib/libgcc.a: build/prefix/lib/gcc/$(TARGET)/*/libgcc.a
	cp $< $@

lib/libpng.a: build/sysroot/usr/lib/libpng.a
	cp $< $@

lib/libz.a: build/sysroot/usr/lib/libz.a
	cp $< $@

lib/%: build/prefix/$(TARGET)/lib/%
	cp $< $@

install: all
	mkdir -p ../filesystem/bin/
	cp bin/* ../filesystem/bin/

libc:
	./libc.sh

clean:
	rm -f bin/* *.list *.o
