; Hello world program
;
; make build dir: mkdir build/
; compile with: nasm -f elf -o build/helloworld-input.o helloworld-input.asm
; Link with: ld -m elf_i386 build/helloworld-input.o -o build/helloworld-input
; Run with ./build/helloworld-input

%include        'functions.asm'

SECTION .data
prompt      db      'Please enter your name: ', 00h
hello_tpl   db      'Hello, ', 00h


SECTION .bss
;; _b_lock of memory _s_tarted by _s_ymbol
sinput      resb    256     ; 255 byte space in memory for users input string


SECTION .text
global _start

_start:
print_prompt:
    ;; print prompt
    mov     eax,    prompt
    call    sprint

    ;; wait for user input using sys_read
    mov     edx,    254     ; number of bytes to read
    mov     ecx,    sinput  ; reserved space to store out input (known as a buffer)
    mov     ebx,    0       ; read from the stdin file
    mov     eax,    3       ; sys_read
    int     80h
    mov     ebx,    eax     ; stash away the number of chars read

    ;; make sure the last two chars of sinput is newline and null for memory safety's sake
    mov     byte[sinput + 254], 0Ah
    mov     byte[sinput + 255], 00h

    ;; check length of string
    mov     eax,    sinput
    call    slen
    cmp     eax,    1
    jz print_prompt
    cmp     eax,    0
    jz exit

    ;; print hello back
    mov     eax,    hello_tpl
    call sprint

    ;; fill in name
    mov     eax,    sinput  ; pointer to _b_lock of memory _s_tarted by _s_ymbol "sinput"
    call sprint             ; note this already has a newline char and null at the end

exit:
    ;; exit out length of name
    mov     eax,    ebx
    call quit
