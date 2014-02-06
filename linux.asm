extern agos
global _start

%include "linux.inc"

section .data
fb_name:	db "/dev/fb0"
fd:			dd 0
fb:			dd 0

section .text
_start:
		open fb_name, 2, 0		; O_RDWR, don't care about flags anyway

		test eax, eax
		js error

		mov DWORD [fd], eax

		call agos

		close [fd]			; close the saved fd

		jmp end
error:


end:
		mov al, 1 				; exit on linux
		mov ebx, 0				; retcode is 0
		int 0x80
