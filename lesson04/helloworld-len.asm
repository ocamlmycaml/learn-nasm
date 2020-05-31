; Hello world program
;
; make build dir: mkdir build/
; compile with: nasm -f elf -o build/helloworld-len.o helloworld-len.asm
; Link with: ld -m elf_i386 build/helloworld-len.o -o build/helloworld-len
; Run with ./build/helloworld-len

SECTION .data
msg     db      'Hello, World! I am a long and long long string to print', 0Ah


SECTION .text
global _start

_start:
    ;; find length of msg string
    mov     eax,    msg     ; strlen looks in eax for pointer to start of string
    call    strlen

    ;; print hello world
    mov     edx,    eax     ; number of bytes to write - originally put into eax by strlen
    mov     ecx,    msg     ; move the memory address of our message string into ecx
    mov     ebx,    1       ; file number - in this case stdout
    mov     eax,    4       ; sys_write
    int     80h

    ;; exit
    mov     ebx,    0       ; return - exit status 0
    mov     eax,    1       ; sys_exit
    int     80h

strlen:
    ;; find length of string by incrementing ebx until it refers to `null`
    push    ebx             ; need ebx as a variable
    mov     ebx,    eax
nextchar:
    cmp     byte[eax], 0    ; compare the byte POINTED TO BY EAX with 0
    jz      finished        ; jump if the zero flag is set in the processor
    inc     eax             ; increment the address of eax by 1
    jmp     nextchar
finished:
    sub     eax,    ebx     ; ebx is starting address, we need to subtract it from eax
    pop     ebx             ; put back original ebx
    ret

