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
