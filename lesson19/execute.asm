; Count to 10 (incorrectly)
;
; make build dir: mkdir build/
; compile with: nasm -f elf -o build/execute.o execute.asm
; Link with: ld -m elf_i386 build/execute.o -o build/execute
; Run with ./build/execute

%include        'functions.asm'


SECTION .data
command     db      '/bin/sleep', 00h
arg1        db      '5', 00h
arguments   dd      command
            dd      arg1
            dd      00h
environment dd      00h


SECTION .text
global _start

_start:

    mov     edx,    environment
    mov     ecx,    arguments
    mov     ebx,    command
    mov     eax,    11              ; sys_execve - process takes over
    int     80h

