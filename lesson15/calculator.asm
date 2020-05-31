; Count to 10 (incorrectly)
;
; make build dir: mkdir build/
; compile with: nasm -f elf -o build/calculator.o calculator.asm
; Link with: ld -m elf_i386 build/calculator.o -o build/calculator
; Run with ./build/calculator

%include        'functions.asm'


SECTION .data
remainder   db      ' remainder '   ; what it is


SECTION .text
global _start

_start:

    mov     eax,    90
    mov     ebx,    9
    div     ebx
    call iprint

    mov     eax,    remainder
    call sprint
    mov     eax,    edx         ; div puts the remainder here
    call iprintLF

    ;; quit with status of number of digits last printed
    call    quit


