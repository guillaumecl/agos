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

fault_handler:
		iretd

master_irq_handler:
		push eax

		mov al, 0x20
		out 0x20, al

		pop eax
		iretd

slave_irq_handler:
		push eax

		mov al, 0x20
		out 0x20, al

		mov al, 0x20
		out 0xA0, al

		pop eax
		iretd

time_handler:
		push eax

		in al, 0x60

		mov al, 0x20
		out 0x20, al

		pop eax
		iretd

key_handler:
		push eax

		in al, 0x60

		mov al, 0x20
		out 0x20, al

		pop eax
		iretd

setup_idt:
		mov al,0xfd
		out 0x21, al

		mov al,0xff
		out 0xa1, al

		mov ecx, 256

		lidt [idtr]

		sti

		ret

idtr:	dw 16*8-1
		dd idt

%macro idt_entry 1
		dw %1
		dw 0x0008 ; code segment
		dw 0x8F00
		dw ((%1-$$+0x10200) >> 16)
%endmacro

idt:
		%rep 8
		idt_entry fault_handler
		%endrep

		; IRQ0-7 entries
		idt_entry time_handler
		idt_entry key_handler
		%rep 6
		idt_entry master_irq_handler
		%endrep

%include "agos.asm"