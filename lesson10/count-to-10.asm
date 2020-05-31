; Count to 10 (incorrectly)
;
; make build dir: mkdir build/
; compile with: nasm -f elf -o build/count-to-10.o count-to-10.asm
; Link with: ld -m elf_i386 build/count-to-10.o -o build/count-to-10
; Run with ./build/count-to-10

%include        'functions.asm'


SECTION .text
global _start

_start:
    mov     ecx,    0   ;; start with 0

printNextNumber:
    inc     ecx
    mov     eax,    ecx     ; push the ascii version of ecx onto stack
    add     eax,    48
    push    eax
    mov     eax,    esp
    call sprintLF
    pop     eax
    cmp     ecx,    10
    jne printNextNumber

    ;; quit with status 0
    mov     eax,    0
    call    quit


