extern agos
global _start

%include "linux.inc"

section .data
fb_name:			db "/dev/fb0",0
fb:					dd 0

section .text
_start:
		open fb_name, O_RDWR, 0

		test eax, eax
		js error

		; save the fd for later
		push eax

		mmap_basic 0x258000, eax
		mov dword [fb], eax

		;;  the file is mmapped, the fd is not needed anymore
		pop eax
		close eax

		mov edi, dword [fb]
		cmp edi, 0xffffffff
		je error

		mov ebx, 600
		mov eax, 0
		mov edx, 0

		mov ebp, 400

loop:	mov ecx, 1024
		inc al
		inc ah
		rep stosd
		dec ebx
		jnz loop

		add dl, 10
		add dh, 10
		mov eax, edx

		mov ebx, 600
		mov edi,[fb]
		dec ebp
		jnz loop

		mov eax, 400
		mov ebx, 10
		call scroll_up

		call agos

		;; unmap [fb], 0x258000
		jmp end
error:


end:
		exit 0

;; scroll_up: scrolls the screen up by ebx lines eax times
scroll_up:
		; convert number of lines to bytes (1024x4)
		shl ebx, 12

		; edx contains the number of dwords to write at each iteration
		mov edx, 0x258000
		sub edx, ebx
		shr edx, 2

scroll_up_loop:
		mov edi, dword [fb]
		lea esi, [edi+ebx]
		mov ecx, edx
		rep movsd

		dec eax
		jnz scroll_up_loop


		ret
