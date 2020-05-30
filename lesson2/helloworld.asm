; Hello world program
;
; make build dir: mkdir build/
; compile with: nasm -f elf -o build/helloworld.o helloworld.asm
; Link with: ld -m elf_i386 build/helloworld.o -o build/helloworld
; Run with ./build/helloworld

SECTION .data
msg     db      'Hello, World!', 0Ah


SECTION .text
global _start

_start:

    ;; print hello world
    mov eax,    4   ; sys_write
    mov ebx,    1   ; file number - in this case stdout
    mov ecx,    msg ; move the memory address of our message string into ecx
    mov edx,    14  ; number of bytes to write - one for each letter plus 0Ah (line feed character)
    int 80h

    ;; exit
    mov eax,    1   ; sys_exit
    mov ebx,    0   ; return - exit status 0
    int 80h
