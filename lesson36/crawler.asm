; Creating and using network sockets
;
; make build dir: mkdir build/
; compile with: nasm -f elf -o build/crawler.o crawler.asm
; Link with: ld -m elf_i386 build/crawler.o -o build/crawler
; Run with ./build/crawler

%include        'functions.asm'


SECTION .data
request db  'GET / HTTP/1.1', 0Dh, 0Ah, 'Host: 139.162.39.66:80', 0Dh, 0Ah, 0Dh, 0Ah, 0h

SECTION .bss    ; blocks of storage by symbol (i think)
buffer  resb    1


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

_connect:
    mov     edi,    eax     ; move return value of sys_socketcall into edi
    push    dword   0x4227a28b      ; push IP address (0.0.0.0) onto stack
    push    word    0x5000  ; push PORT (9001) in reverse byte order onto stack
    push    word    2       ; AF_INET
    mov     ecx,    esp
    push    byte    16      ; arguments length in bytes (dword + word + word = 16 bytes)
    push    ecx             ; address of args on stack
    push    edi             ; move file descriptor onto stack
    mov     ecx,    esp     ; pointer to arguments (fd, pointer to args, length of args)
    mov     ebx,    3       ; sys_socketcall modifier CONNECT
    mov     eax,    102     ; sys_socketcall
    int     80h

_write:
    mov     edx,    43
    mov     ecx,    request
    mov     ebx,    edi     ; fd from socket connection
    mov     eax,    4
    int     80h

_read:
    mov     edx,    1       ; number of bytes to read (we will only read 1 byte at a time)
    mov     ecx,    buffer
    mov     ebx,    edi
    mov     eax,    3       ; sys_read
    int     80h

    cmp     eax,    0
    jz      _close

    mov     eax,    buffer
    call    sprint
    jmp     _read

_close:
    mov     ebx,    edi
    mov     eax,    6       ; sys_close
    int     80h

_exit:
    cmp     eax,    0
    call    quit

