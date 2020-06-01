; Count to 10 (incorrectly)
;
; make build dir: mkdir build/
; compile with: nasm -f elf -o build/fizzbuzz.o fizzbuzz.asm
; Link with: ld -m elf_i386 build/fizzbuzz.o -o build/fizzbuzz
; Run with ./build/fizzbuzz

%include        'functions.asm'


SECTION .data
fizz    db      'Fizz', 00h
buzz    db      'Buzz', 00h


SECTION .text
global _start

_start:

    mov     esi,    0   ; check fizz boolean
    mov     edi,    0   ; check buzz boolean
    mov     ecx,    0   ; counter

.nextNumber:
    inc     ecx

.checkFizz:
    mov     edx,    0   ; clear the remainder register
    mov     eax,    ecx
    mov     ebx,    3   ; divisor
    div     ebx
    mov     esi,    edx

    cmp     esi,    0
    jne     .checkBuzz
    mov     eax,    fizz
    call    sprint

.checkBuzz:
    mov     edx,    0   ; clear the remainder register
    mov     eax,    ecx
    mov     ebx,    5   ; divisor
    div     ebx
    mov     edi,    edx

    cmp     edi,    0
    jne     .checkInt
    mov     eax,    buzz
    call    sprint

.checkInt:
    cmp     esi,    0
    je      .continue
    cmp     edi,    0
    je      .continue
    mov     eax,    ecx
    call    iprint

.continue:
    mov     eax,    00h
    push    eax
    mov     eax,    esp
    call    sprintLF
    pop     eax

    cmp     ecx,    1000000
    jne     .nextNumber

    mov     eax,    0
    call    quit

