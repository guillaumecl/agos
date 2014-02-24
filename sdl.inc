; -*- mode:nasm; -*-

%assign SDL_INIT_VIDEO	0x20

%assign SDL_HWSURFACE	0x1
%assign SDL_NOFRAME		0x20
%assign SDL_FULLSCREEN	0x80000000

extern SDL_Init
extern SDL_SetVideoMode

%macro SDL_init 1
		push %1
		call SDL_Init
		add esp, 4
%endmacro

		; set_video_mode width height bpp flags
%macro SDL_set_video_mode 4
		push dword %4
		push dword %3
		push dword %2
		push dword %1
		call SDL_SetVideoMode
		add esp, 16
%endmacro