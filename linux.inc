
%define	stdin	0
%define	stdout	1
%define	stderr	2

%define sys_open 5
%define sys_close 6

%define O_RDONLY 0
%define O_WRONLY 1
%define O_RDWR 2

%macro open 3
		mov eax, sys_open
		mov ebx, %1
		mov ecx, %2
		mov edx, %3
		int 0x80
%endmacro

%macro close 1
		mov eax, sys_close
		mov ebx, %1
		int 0x80
%endmacro
