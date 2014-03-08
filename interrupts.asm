
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
		; mask all pic0 interrupts except the keyboard
		mov al,0xfd
		out 0x21, al

		; mask all pic1 interrupts except the keyboard
		mov al,0xff
		out 0xa1, al

		lidt [idtr]

		; now we can have interrupts
		sti

		ret


%macro idt_entry 1
		dw %1
		dw 0x0008 ; code segment
		dw 0x8F00
		dw ((%1-$$+0x10200) >> 16)
%endmacro

%macro idt_entry 2
%rep %1
		idt_entry %2
%endrep
%endmacro

idt:
		idt_entry 8, fault_handler

		; IRQ0-7 entries
		idt_entry time_handler
		idt_entry key_handler
		idt_entry 6, master_irq_handler

idtr:	dw idtr-idt-1
		dd idt
