; Count to 10 (incorrectly)
;
; make build dir: mkdir build/
; compile with: nasm -f elf -o build/calculator.o calculator.asm
; Link with: ld -m elf_i386 build/calculator.o -o build/calculator
; Run with ./build/calculator

%include        'functions.asm'


SECTION .data
arg_num     db      'Argument number ', 00h
with_value  db      ' with value ', 00h
is_not_num  db      ' is not number', 00h


SECTION .text
global _start


;; quit with status of number of digits last printed
nonNumericError:
    mov     eax,    arg_num
    call sprint
    mov     eax,    ecx
    call iprint
    mov     eax,    with_value
    call sprint
    mov     eax,    esi
    call sprint
    mov     eax,    is_not_num
    call sprintLF

    mov     eax,    ecx
    call quit


finish:
    mov     eax,    ebx
    call    iprintLF
    call    quit


_start:
    mov     ebx,    0           ; result

    ;; get number of arguments into ecx
    pop     ecx

    ;; clear the program name from the args
    pop     esi                 ; program name
    dec     ecx

.getNextStringValue:
    ;; no more args? let's end
    cmp     ecx,    0
    jz finish

    ;; move string rep of number
    pop     esi

    ;; validate
    mov     eax,    esi
    call checkNumeric
    cmp     eax,    0
    jz nonNumericError

    ;; add
    mov     eax,    esi
    call atoi
    add     ebx,    eax

    ;; get next arg
    dec     ecx
    jmp .getNextStringValue

