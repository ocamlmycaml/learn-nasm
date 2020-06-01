; Managing files
;
; make build dir: mkdir build/
; compile with: nasm -f elf -o build/file_management.o file_management.asm
; Link with: ld -m elf_i386 build/file_management.o -o build/file_management
; Run with ./build/file_management

%include        'functions.asm'


SECTION .data
filename    db      'somefile.txt', 00h


SECTION .text
global _start

_start:
    mov     ecx,    0777    ; set the permissions to read, write, execute
    mov     ebx,    filename
    mov     eax,    8       ; sys_creat - create a file
    int     80h

    cmp     eax,    0
    call    quit
