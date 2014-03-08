global agos

%ifdef ELF
section .data
%endif
framebuffer: dd 0
flip_func: dd 0

%assign ffh 0xff

bitmap:	db ffh, ffh, ffh, ffh, 02h, 02h, ffh, ffh, ffh, ffh
		db ffh, ffh, ffh, 02h, 03h, 03h, 02h, ffh, ffh, ffh
		db ffh, ffh, 02h, 03h, 04h, 04h, 03h, 02h, ffh, ffh
		db ffh, 02h, 03h, 04h, 05h, 05h, 04h, 03h, 02h, ffh
		db 02h, 03h, 04h, 05h, 06h, 06h, 05h, 04h, 03h, 02h
		db 02h, 03h, 04h, 05h, 06h, 06h, 05h, 04h, 03h, 02h
		db ffh, 02h, 03h, 04h, 05h, 05h, 04h, 03h, 02h, ffh
		db ffh, ffh, 02h, 03h, 04h, 04h, 03h, 02h, ffh, ffh
		db ffh, ffh, ffh, 02h, 03h, 03h, 02h, ffh, ffh, ffh
		db ffh, ffh, ffh, ffh, 02h, 02h, ffh, ffh, ffh, ffh


%ifdef ELF
section .text
%endif
agos:
		;; save the framebuffer for later, just in case.
		mov [framebuffer], edi
		mov [flip_func], ebp

		mov ecx, 200
		xor al,al
fill_screen:
		mov byte [edi], al
		inc edi
		inc al
		jnz fill_screen
		add edi, 320-256
		dec ecx
		jnz fill_screen


		mov esi, bitmap
		mov ecx, 10
		mov edx, 10
		mov ah, 10
		mov al, 20
		call compute_pos
		call put_bitmap_transp

		call [flip_func]

again:
		call scroll_up
		call [flip_func]
		jmp again

		ret

; compute a buffer position
; top eax must be zeroed
; al: x
; ah: y
; result in edi, modifications: eax and edi
compute_pos:
		movzx edi, al	; edi = x
		movzx eax, ah
		shl eax, 6
		add edi, eax	; edi = x + 64*y
		shl eax, 2
		add edi, eax	; edi = x + 64*y + 256*y
		add edi, [framebuffer]
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

; Draw a bitmap with some transparency (0xff is transparent)
; edi: bitmap destination
; esi: the bitmap
; ecx: width (pixels)
; edx: height (pixels)
put_bitmap_transp:
		mov ebp, ecx

.next_pixel:
		mov al, byte [ds:esi]
		cmp al, 0xff
		je .skip_pixel
		mov [es:edi], al
.skip_pixel:
		inc esi
		inc edi
.next:	dec ecx
		jnz .next_pixel
		mov ecx, ebp

		sub edi, ecx
		add edi, 320
		dec edx
		jnz .next_pixel

		ret

scroll_down:
		mov edi, [framebuffer]
		add edi, 320*200-4
		mov esi, edi
		sub esi, 320

		std
		mov ecx, (320*199)/4
		rep movsd
		cld

		ret

scroll_up:
		mov edi, [framebuffer]
		lea esi, [edi+320]

		mov ecx, (320*199)/4
		rep movsd

		ret