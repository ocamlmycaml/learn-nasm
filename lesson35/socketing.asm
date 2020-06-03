; Creating and using network sockets
;
; make build dir: mkdir build/
; compile with: nasm -f elf -o build/socketing.o socketing.asm
; Link with: ld -m elf_i386 build/socketing.o -o build/socketing
; Run with ./build/socketing

%include        'functions.asm'


SECTION .data
response db 'HTTP/1.1 200 OK', 0Dh, 0Ah, 'Content-Type: text/html', 0Dh, 0Ah, 'Content-Length: 14', 0Dh, 0Ah, 0Dh, 0Ah, 'Hello World!', 0Dh, 0Ah, 0h

SECTION .bss    ; blocks of storage by symbol (i think)
    buffer  resb    255


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

_listen:
    push    byte    1       ; max queue length of 1
    push    edi             ; file descriptor of socket boi
    mov     ecx,    esp
    mov     ebx,    4       ; sys_socketcall modifier LISTEN
    mov     eax,    102     ; sys_socketcall
    int     80h

_accept:
    push    byte    0       ; address length argument
    push    byte    0       ; address argument
    push    edi             ; file descriptor of socket
    mov     ecx,    esp     ; point to struct
    mov     ebx,    5       ; sys_socketcall modifier ACEPT
    mov     eax,    102     ; sys_socketcall
    int     80h

_fork:
    mov     esi,    eax     ; file descriptor of socket we are accepting from
    mov     eax,    2       ; sys_fork
    int     80h

    cmp     eax,    0       ; if sys_fork returned 0, we are in the child
    jz      _read

    jmp     _accept         ; we are still in parent, continue accepting

_read:
    mov     edx,    255     ; number of bytes to read (we will only read the first 255 lines coz fuck iiiit
    mov     ecx,    buffer
    mov     ebx,    esi
    mov     eax,    3       ; sys_read
    int     80h

    mov     eax,    buffer
    call    sprintLF

_write:
    mov     eax,    response
    call    slen

    mov     edx,    eax     ; length in bytes to write
    mov     ecx,    response
    mov     ebx,    esi     ; socket number
    mov     eax,    4       ; sys_write
    int     80h

_close:
    mov     ebx,    esi
    mov     eax,    6       ; sys_close
    int     80h

_exit:
    cmp     eax,    0
    call    quit

