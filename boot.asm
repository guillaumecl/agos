		;; aim: load some code, jump to protected mode, then execute agos.
org 0x7c00

bits 16
		jmp 0x0000:start
start:

reset_drive:
		xor ah,ah
		int 13h
		jc reset_drive

read_program:
		mov ax, 0x1000
		mov es, ax
		xor bx, bx
		mov ah, 0x02 ; read sector
		mov al, 0x10 ; number of sec*tors to read
		mov ch, 0x00 ; cylinder = 0
		mov cl, 0x01 ; first sector to read is the second
		mov dh, 0    ; head = 0
		int 13h
		jc read_program

		; Use 0 for DS as well
		xor ax, ax
		mov ds, ax

		;; switch to mode 13h, since we don't want to do this after
		;; going to protected mode.
		mov ax, 13h
		int 10h

		cli
		lgdt [gdtr]

		mov eax, cr0
		or eax, 1
		mov cr0,eax

		mov ax, 0x10
		mov ds, ax
		mov es, ax
		mov fs, ax
		mov gs, ax
		mov ss, ax

		jmp 0x8:dword 0x10200

gdtr:
		dw gdt_end - gdt - 1
		dd gdt
gdt:
		db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  ; first segment is reserved, we use it to store the address of gdtr

		db 0xff, 0xff, 0x00, 0x00, 0x00, 0x9a, 0xcf, 0x00  ; flat code segment
		db 0xff, 0xff, 0x00, 0x00, 0x00, 0x92, 0xcf, 0x00  ; flat data segment
gdt_end:

		; insert some bytes until we have a 510 bytes file
		times 510-($-$$) db 0

		; last 2 bytes of the sector is the bootable disk signature
		db 0x55
		db 0xAA
