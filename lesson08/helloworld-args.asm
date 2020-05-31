; Hello world program
;
; make build dir: mkdir build/
; compile with: nasm -f elf -o build/helloworld-args.o helloworld-args.asm
; Link with: ld -m elf_i386 build/helloworld-args.o -o build/helloworld-args
; Run with ./build/helloworld-args ARG1 "longer ARG2"

%include        'functions.asm'

SECTION .text
global _start

_start:
    pop     ecx             ; first value in the stack is number of arguments

nextArg:
    cmp     ecx,    0h      ; until we have arguments
    jz      noMoreArgs
    pop     eax             ; put next arg pointer in eax
    call    sprintLF        ; print it
    dec     ecx             ; we processed an arg, so we good
    jmp     nextArg

noMoreArgs:
    call    quit
