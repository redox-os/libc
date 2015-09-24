NEWLIB=newlib-2.2.0.20150824

test.bin: test.c ../src/program.ld
	gcc-4.6 -m32 -Os -nostdlib -static -ffreestanding -fno-builtin -fno-stack-protector \
		-T ../src/program.ld -Wl,--build-id=none \
		-o $@ "build/build-$(NEWLIB)/i386-elf-redox/newlib/crt0.o" $< \
		-I "build/$(NEWLIB)/newlib/include" -L "build/build-$(NEWLIB)/i386-elf-redox/newlib" -lc -lm

test.list: test.bin
	objdump -C -M intel -d $< > $@

libc:
	./setup.sh

clean:
	rm -f *.bin *.list *.o
