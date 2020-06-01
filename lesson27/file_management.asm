; Managing files
;
; make build dir: mkdir build/
; compile with: nasm -f elf -o build/file_management.o file_management.asm
; Link with: ld -m elf_i386 build/file_management.o -o build/file_management
; Run with ./build/file_management

%include        'functions.asm'


SECTION .data
filename    db      'test.txt', 00h
contents    db      '-updated-', 00h


SECTION .text
global _start

_start:
    mov     ecx,    1       ; 'r' mode to read file
    mov     ebx,    filename
    mov     eax,    5       ; sys_open
    int     80h

    mov     edx,    2       ; whence argument (SEEK_END)
    mov     ecx,    0       ; 0 bytes from <whence>
    mov     ebx,    eax
    mov     eax,    19      ; sys_lseek
    int     80h

    mov     edx,    9       ; number of bytes to write
    mov     ecx,    contents
    ;mov     ebx,    ebx     ; just the file descriptor again
    mov     eax,    4       ; sys_write
    int     80h

    cmp     eax,    0
    call    quit
