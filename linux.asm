extern agos
global _start
_start:
		call agos
		mov al, 1 				; exit on linux
		mov ebx, 0				; retcode is 0
		int 0x80
