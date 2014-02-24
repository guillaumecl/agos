global agos

%ifdef ELF
section .data
%endif
framebuffer: dd 0
flip_func: dd 0

bitmap:	db 0, 0, 0, 0, 2, 2, 0, 0, 0, 0
		db 0, 0, 0, 2, 3, 3, 2, 0, 0, 0
		db 0, 0, 2, 3, 4, 4, 3, 2, 0, 0
		db 0, 2, 3, 4, 5, 5, 4, 3, 2, 0
		db 2, 3, 4, 5, 6, 6, 5, 4, 3, 2
		db 2, 3, 4, 5, 6, 6, 5, 4, 3, 2
		db 0, 2, 3, 4, 5, 5, 4, 3, 2, 0
		db 0, 0, 2, 3, 4, 4, 3, 2, 0, 0
		db 0, 0, 0, 2, 3, 3, 2, 0, 0, 0
		db 0, 0, 0, 0, 2, 2, 0, 0, 0, 0


%ifdef ELF
section .text
%endif
agos:
		;; save the framebuffer for later, just in case.
		mov [framebuffer], edi
		mov [flip_func], ebp

		;; fill the screen with a 02 color
		cld
		mov ecx, 320*200/4
		mov eax, 0x00000000
		rep stosd

		mov esi, bitmap
		mov ecx, 10
		mov edx, 10
		mov edi, [framebuffer]
		add edi, 320*90+150
		call put_bitmap

		call [flip_func]

		ret



; edi: bitmap destination
; esi: the bitmap
; ecx: width (pixels)
; edx: height (pixels)
put_bitmap:
		mov ebp, ecx

.line_loop:
		rep movsb
		mov ecx, ebp

		sub edi, ecx
		add edi, 320
		dec edx
		jnz .line_loop

		ret
