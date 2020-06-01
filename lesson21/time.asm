; Count to 10 (incorrectly)
;
; make build dir: mkdir build/
; compile with: nasm -f elf -o build/time.o time.asm
; Link with: ld -m elf_i386 build/time.o -o build/time
; Run with ./build/time

%include        'functions.asm'


SECTION .data
msg         db      'Seconds since Jan 01 1970: ', 00h


SECTION .text
global _start

_start:
    mov     eax,    msg
    call    sprint

    mov     eax,    13              ; sys_time - returns a timestamp
    int     80h
    call    iprintLF
    cmp     eax,    0
    call    quit
