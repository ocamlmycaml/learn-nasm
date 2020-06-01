; Count to 10 (incorrectly)
;
; make build dir: mkdir build/
; compile with: nasm -f elf -o build/fork.o fork.asm
; Link with: ld -m elf_i386 build/fork.o -o build/fork
; Run with ./build/fork

%include        'functions.asm'


SECTION .data
childMsg    db      'This is the child process', 00h
parentMsg   db      'This is the parent process', 00h


SECTION .text
global _start

_start:

    mov     eax,    2              ; sys_fork
    int     80h

    cmp     eax,    0
    jz      child

.parent:
    mov     eax,    parentMsg
    call    sprintLF
    call    quit

child:
    mov     eax,    childMsg
    call    sprintLF
    call    quit

