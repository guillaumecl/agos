global agos
org 0x10200
bits 32
		call setup_idt

		mov edi, 0xA0000
		mov ebp, dummy_flip
		call agos

stop:	hlt
		jmp stop

dummy_flip:
		hlt
		ret

%include "agos.asm"
%include "interrupts.asm"
