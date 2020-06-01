; Managing files
;
; make build dir: mkdir build/
; compile with: nasm -f elf -o build/file_management.o file_management.asm
; Link with: ld -m elf_i386 build/file_management.o -o build/file_management
; Run with ./build/file_management

%include        'functions.asm'


SECTION .data
filename    db      'test.txt', 00h


SECTION .text
global _start

_start:

    mov     ebx,    filename
    mov     eax,    10      ; sys_unlink
    int     80h

    cmp     eax,    0
    call    quit
