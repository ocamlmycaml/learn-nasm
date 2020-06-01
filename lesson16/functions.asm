;-------------------------------------------------
; String length calculation function
;   eax - pointer to string
; Returns
;   eax - length of string
slen:
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

;-------------------------------------------------
; String print function
;   eax - pointer to string
; Returns
;   eax - length of string printed (length of string usually)
sprint:
    push    edx
    push    ecx
    push    ebx
    push    eax             ; this is where the string pointer will be, we will need to
                            ; pop it after slen is called

    ;; get length of string
    call    slen            ; note: string pointer is already in eax

    ;; print string
    mov     edx,    eax     ; length of string from slen to edx
    pop     eax             ; get back the pointer to the message
    mov     ecx,    eax     ; pointer to string
    mov     ebx,    1       ; file number - in this case stdout
    mov     eax,    4       ; sys_write
    int     80h

    ;; pop all stashed values, except eax which contains the length of string printed
    mov     eax,    edx
    pop     ebx
    pop     ecx
    pop     edx
    ret

;-------------------------------------------------
; String print function with newline
;   eax - pointer to string
; Returns
;   eax - length of string printed (length of string + 1 for newline usually)
sprintLF:
    push    ebx
    call sprint

    mov     ebx,    eax     ; keep printed lengh in ebx

    mov     eax,    0Ah     ; new line character
    push    eax             ; push new line character to stack
    mov     eax,    esp     ; stack pointer is start of string to print
    call sprint
    add     ebx,    eax     ; add additional string length to ebx
    pop     eax

    ;; pop all stashed values except eax which has length of string printed
    mov     eax,    ebx
    pop     ebx
    ret

;-------------------------------------------------
; exit program
;   eax - status code
quit:
    mov     ebx,    eax     ; status code
    mov     eax,    1       ; sys_exit
    int     80h
    ret

;-------------------------------------------------
; itoa
;   eax - number to convert to string
; returns
;   eax - number of characters printed (usually log(input number))
iprint:
    push    esi
    push    ebx
    push    ecx
    push    edx

    ;; mod eax by 10 and keep pushing the remainder onto the stack
    mov     esi,    10      ; since we are printing decimal values
    mov     ecx,    0       ; counter to keep track of how many chars we collect
push_digit_into_stack:
    inc     ecx
    mov     edx,    0       ; clear remainder
    idiv    esi             ; idiv puts remainder in edx, quotient in eax
    add     edx,    48      ; ascii-ize it
    push    edx
    cmp     eax,    0
    jnz push_digit_into_stack


    mov     ebx,    0       ; counter to keep track of how many chars printed
print_char_from_stack:
    mov     eax,    esp     ; the stack pointer points to the last digit added to stack
    call sprint
    add     ebx,    eax
    dec     ecx             ; reduce the count
    pop     eax             ; pop the stack so we can rid ourselves of the last digit just printed
    cmp     ecx,    0       ; should we end?
    jnz print_char_from_stack

    ;; restore everything and return with return value
    mov     ebx,    eax     ; return printed chars here
    pop     edx
    pop     ecx
    pop     ebx
    pop     esi
    ret


;-------------------------------------------------
; itoaLF
;   eax - number to convert to string
; returns
;   eax - number of characters printed (usually log(input number) + 1 for new line)
iprintLF:
    push ecx

    call iprint
    mov eax, ecx

    push 00h

    mov eax, esp
    call sprintLF
    add ecx, eax

    pop eax
    mov eax, ecx

    pop ecx
    ret


;-------------------------------------------------
; checkNumeric
;   eax - string representation of number
; returns
;   eax - 1 if numeric, 0 if not
checkNumeric:
    push    esi

    mov     esi,    eax
    mov     eax,    1       ;; assume int until proven otherwise
.checkNextChar:
    ;; pointing to a null? end now
    cmp     byte[esi],  0
    je      .finish

    ;; num should be between 48 and 57 inclusive
    cmp     byte[esi],  48
    jl      .finishFail
    cmp     byte[esi],  57
    jg      .finishFail

    ;; move to next char and check it
    inc     esi
    jmp     .checkNextChar

.finishFail:
    mov     eax,    0
.finish:
    pop esi
    ret

;-------------------------------------------------
; atoi
;   eax - string representation of number
; returns
;   eax - int representation of number
atoi:
    push    ebx     ;; we'll be using the lower half bl
    push    ecx
    push    esi

    mov     esi,    eax
    mov     eax,    0       ; result
    mov     ecx,    10      ; multiply by this on each loop
    ;; iterate until null
.nextChar:
    ;; if char is null, end now
    cmp     byte[esi],  0
    je .finished

    ;; add next digit to int
    mov     ebx,    0       ; instructions say `xor ebx ebx`, wonder why that's preferred over setting bits to 0
    mov     bl,     [esi]
    sub     bl,     48
    mul     ecx             ; mul eax by 10
    add     eax,    ebx     ; add new num into eax

    inc     esi
    jmp .nextChar

.finished:
    pop esi
    pop ecx
    pop ebx
    ret

