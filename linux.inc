; -*- mode:nasm; -*-

%assign	stdin	0
%assign	stdout	1
%assign	stderr	2

%assign sys_exit 1
%assign sys_read 3
%assign sys_write 4
%assign sys_open 5
%assign sys_close 6
%assign sys_mmap 0x5a

%assign O_RDONLY 0
%assign O_WRONLY 1
%assign O_RDWR 2

%assign PROT_READ 0x1
%assign PROT_WRITE 0x2
%assign PROT_EXEC 0x4

%assign PROT_RW PROT_READ|PROT_WRITE
%assign PROT_RWX PROT_READ|PROT_WRITE|PROT_EXEC

%assign MAP_SHARED 0x1
%assign MAP_PRIVATE 0x2

%macro sys_call 1
		mov eax, %1
		int 0x80
%endmacro

;; open has 3 parameters: filename, flags(O_RDONLY and friends), creation mode
;; modified registers are: eax,ebx,ecx,edx
;; after open, eax contains the file descriptor or a negative error
%macro exit 1
		mov ebx, %1
		sys_call sys_exit
%endmacro


;; open has 3 parameters: filename, flags(O_RDONLY and friends), creation mode
;; modified registers are: eax,ebx,ecx,edx
;; after open, eax contains the file descriptor or a negative error
%macro open 3
		mov ebx, %1
		mov ecx, %2
		mov edx, %3
		sys_call sys_open
%endmacro

;; close has 1 parameters: filename, flags(O_RDONLY and friends), creation mode
;; modified registers are: eax,ebx
;; after close, eax contains an error code
%macro close 1
		mov ebx, %1
		sys_call sys_close
%endmacro

;; mmap(addr, length, prot, flags, fd, offset)
;; return in eax, -1 in case of errors.
%macro mmap 6
		mov	dword [esp], %1	   	; addr (usually 0)
		mov	dword [esp+4], %2  	; length (in bytes)
		mov	dword [esp+8], %3 	; prot (ex PROT_READ)
		mov	dword [esp+12], %4	; flags (ex MAP_SHARED)
		mov	dword [esp+16], %5	; fd
		mov dword [esp+20], %6  ; offset in file
		mov ebx, esp
		sys_call sys_mmap
%endmacro

;;  basic version of mmap that maps in rw at offset 0
;; arguments: length, fd
;; return: pointer or -1 if error
%macro mmap_basic 2
		mmap 0, %1, PROT_READ|PROT_WRITE, MAP_SHARED, %2, 0
%endmacro


%macro read 3
	mov	ebx, %1
	mov	ecx, %2
	mov	edx, %3
	sys_call sys_readf
%endmacro

%macro write 3
	mov	ebx, %1
	mov	ecx, %2
	mov	edx, %3
	sys_call sys_write
%endmacro
