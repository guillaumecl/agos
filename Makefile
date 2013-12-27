AS=nasm
LD=ld
LDFLAGS=-nostdlib -nodefaultlibs -m32
EXEC=agos

agos:agos.o linux.o
	$(CC) -o $@ $^ $(LDFLAGS)

boot.bin:boot.asm
	$(AS) -f bin -o $@ $<

%.o: %.asm
	$(AS) -f elf -o $@  $<

.PHONY: clean all

clean:
	rm -rf *.o
	rm -rf $(EXEC) boot.bin
