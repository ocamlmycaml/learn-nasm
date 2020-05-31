; Count to 10 (incorrectly)
;
; make build dir: mkdir build/
; compile with: nasm -f elf -o build/calculator.o calculator.asm
; Link with: ld -m elf_i386 build/calculator.o -o build/calculator
; Run with ./build/calculator

%include        'functions.asm'


SECTION .text
global _start

_start:

    mov     eax,    90
    mov     ebx,    9
    add     eax,    ebx
    call    iprintLF

    ;; quit with status of number of digits last printed
    call    quit


