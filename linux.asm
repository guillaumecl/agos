extern agos
global _start

%include "linux.inc"
%include "sdl.inc"

extern SDL_Flip
extern SDL_Quit

section .data
surface: dd 0

section .text
_start:
		SDL_init SDL_INIT_VIDEO

		SDL_set_video_mode 320, 200, 8, SDL_FULLSCREEN

		mov [surface], eax

		lea eax, [eax+20]
		mov edi, [eax]

		mov ebp, flip
		call agos

		mov ecx, 0
loopp:
		dec ecx
		jnz loopp

		call SDL_Quit

end:
		exit 0

flip:
		push dword [surface]
		call SDL_Flip
		add esp, 4
		ret
