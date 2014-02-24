global agos
org 0x10200
bits 32
		mov edi, 0xA0000
		mov ebp, dummy_flip
		call agos

stop:	hlt
		jmp stop

dummy_flip:
		ret

%include "agos.asm"