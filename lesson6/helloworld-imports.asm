; Hello world program
;
; make build dir: mkdir build/
; compile with: nasm -f elf -o build/helloworld-imports.o helloworld-imports.asm
; Link with: ld -m elf_i386 build/helloworld-imports.o -o build/helloworld-imports
; Run with ./build/helloworld-imports

%include        'functions.asm'

SECTION .data
msg1    db      'Hello, brave new World!', 0Ah, 00h
msg2    db      'This is how we recycle code in NASM.', 0Ah, 00h


SECTION .text
global _start

_start:
    mov     eax,    msg1    ; sprint needs message in eax
    call    sprint

    mov     eax,    msg2    ; sprint needs message in eax
    call    sprint

    call    quit            ; status code will be length of last string
