AS=nasm
CC=cc
LDFLAGS=-nostdlib -nodefaultlibs -m32
EXEC=agos

agos:agos.o
	$(CC) -o $@ $^ $(LDFLAGS)

%.o: %.s
	$(AS) -f elf -o $@  $<

.PHONY: clean all

clean:
	rm -rf *.o
	rm -rf $(EXEC)
