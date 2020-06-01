; Creating and using network sockets
;
; make build dir: mkdir build/
; compile with: nasm -f elf -o build/socketing.o socketing.asm
; Link with: ld -m elf_i386 build/socketing.o -o build/socketing
; Run with ./build/socketing

%include        'functions.asm'


SECTION .text
global _start

_start:
    ;; clean up registers to make sure
    xor     eax,    eax
    xor     ebx,    ebx
    xor     edi,    edi
    xor     esi,    esi

_socket:
    push    byte    6       ; IPPROTO_TCP
    push    byte    1       ; SOCK_STREAM
    push    byte    2       ; PF_INET
    mov     ecx,    esp     ; socket call needs a struct of args in ecx
    mov     ebx,    1       ; sys_socketcall modifier SOCKET
    mov     eax,    102     ; sys_socketcall
    int     80h

_bind:
    mov     edi,    eax     ; move return value of sys_socketcall into edi
    push    dword   0h      ; push IP address (0.0.0.0) onto stack
    push    word    0x2923  ; push PORT (9001) in reverse byte order onto stack
    push    word    2       ; AF_INET
    mov     ecx,    esp
    push    byte    16      ; arguments length in bytes (dword + word + word = 16 bytes)
    push    ecx             ; address of args on stack
    push    edi             ; move file descriptor onto stack
    mov     ecx,    esp     ; pointer to arguments (fd, pointer to args, length of args)
    mov     ebx,    2       ; sys_socketcall modifier BIND
    mov     eax,    102     ; sys_socketcall
    int     80h

_exit:
    cmp     eax,    0
    call    quit
