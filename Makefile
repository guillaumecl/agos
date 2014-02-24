NASM=nasm -w+orphan-labels
STRIP=strip -R .note -R .comment


all: agos boot.bin agos.img

agos:linux.o agos.o
	${LD} -melf_i386 -dynamic-linker /lib/ld-linux.so.2 -lSDL -o $@ $^
	${STRIP} $@

boot.bin:boot.asm
	$(NASM) -f bin -o $@ $<

agos.bin:agos_bin.asm
	$(NASM) -f bin -o $@ agos_bin.asm

boot.o:boot.asm
	$(NASM) -f elf -DELF -o $@ $<

# agos.img is a floppy-looking file. Fill unused data with random stuff.
agos.img:boot.bin agos.bin rand.bin
	cat boot.bin agos.bin rand.bin > agos.tmp
	dd if=agos.tmp of=agos.img bs=1024 count=1440
	rm agos.tmp

rand.bin:
	dd if=/dev/urandom of=rand.bin bs=1024 count=1440

qemu: agos.img
	qemu-system-$(shell uname -m) -fda agos.img -m 32

debug: agos.img
	qemu-system-$(shell uname -m) -s -S -fda agos.img -m 32

%.o: %.asm linux.inc
	${NASM} -f elf -DELF -o $@ $<

.PHONY: clean all

clean:
	rm -rf *.o *.bin *.img
	rm -rf agos


.PHONY: all  clean
