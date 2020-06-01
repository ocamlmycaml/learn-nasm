; Count to 10 (incorrectly)
;
; make build dir: mkdir build/
; compile with: nasm -f elf -o build/namespace.o namespace.asm
; Link with: ld -m elf_i386 build/namespace.o -o build/namespace
; Run with ./build/namespace

%include        'functions.asm'


SECTION .data
sjumping    db      'Jumping to finished label.', 00h
ssubroutine db      'Inside subroutine number: ', 00h
sfinished   db      'Inside subroutine "finished".', 00h


SECTION .text
global _start

subroutineOne:
    mov     eax,    sjumping
    call    sprintLF
    jmp     .finished

.return:
    ret

.finished:
    mov     eax,    ssubroutine
    call    sprint
    mov     eax,    1
    call    iprintLF
    jmp     .return

subroutineTwo:
    mov     eax,    sjumping
    call    sprintLF
    jmp     .finished

.finished:
    mov     eax,    ssubroutine
    call    sprint
    mov     eax,    2
    call    iprintLF

    mov     eax, sjumping
    call    sprintLF
    jmp     finished

finished:
    mov     eax,    sfinished
    call    sprintLF
    mov     eax,    0
    call    quit

_start:
    call subroutineOne
    call subroutineTwo

