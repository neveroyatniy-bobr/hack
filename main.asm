.model tiny
locals @@
.code
org 100h

start proc
    call hash_func
    call hash_cmp

    ;если ax == 0 то выполняется процедура правильного пароля, иначе неправильного
    cmp ax, 0
    je @@if_correct
    call wrong_password_proc
    jmp @@enfif
    @@if_correct:
    mov si, offset start_decode
    mov di, offset end_decode
    call decode_code

    call correct_password_proc
    @@enfif:

    mov ax, 4C00h
    int 21h
endp

decode_code proc
    push ax bx cx bp

    mov bx, si
    mov cx, 0
    jmp @@loop_symbol_cond
    @@loop_symbol:
        mov al, cs:[82h + bp]
        xor cs:[bx], al

        inc bx
        inc bp

        inc bp
        mov cl, cs:[80h]
        cmp bp, cx
        jne @@no_end_pass
            mov bp, 1
        @@no_end_pass:
        dec bp
    @@loop_symbol_cond:
        cmp bx, di
        jl @@loop_symbol

    pop bp cx bx ax
    ret
endp

correct_password_proc proc
    start_decode:
    db  48h, 0eh,  72h, 0b3h, 02h, 16h, 0fh,  9ah
    db 0d7h, 0ah, 0d5h,  31h, 7ah, 18h, 53h, 0dbh
    end_decode:
endp

;-----------------------
;закодированный кусок
;push ax ds dx

;Вывожу сообщение о том что пароль правильный
;mov ah, 09h
;push cs
;pop ds
;mov dx, offset correct_password_msg
;int 21h

;pop dx ds ax

;ret

;------------

wrong_password_proc proc
    push ax ds dx

    ;Вывожу сообщение о том что пароль неправильный
    mov ah, 09h
    push cs
    pop ds
    mov dx, offset wrong_password_msg
    int 21h

    pop dx ds dx

    ret
endp

hash_func proc
    push cx ax bx

    mov bx, 82h
    mov cl, 1
    jmp @@loop_symbol_cond
    @@loop_symbol:
        mov al, cs:[bx]
        xor al, cs:[hash_const]
        add al, cl
        mov cs:[bx], al
        
        inc bx
        inc cl
    @@loop_symbol_cond:
        cmp cl, cs:80h
        jl @@loop_symbol

    pop bx ax cx

    ret
endp

hash_cmp proc
    push cx bx bp

    ;если длины хешей не совпали тогда возвращаю 1 через ax
    mov bl, cs:[80h]
    cmp bl, cs:[correct_hash_len]
    mov ax, 1
    jne @@end_cmp

    mov bx, 82h
    mov bp, offset correct_hash
    mov cl, 1
    jmp @@loop_symbol_cond
    @@loop_symbol:
        ;если не равны возвращаю 1 через ax
        mov al, cs:[bx]
        cmp al, cs:[bp]
        mov ax, 1
        jne @@end_cmp
        
        inc bx
        inc bp
        inc cl
    @@loop_symbol_cond:
        cmp cl, cs:[80h]
        jl @@loop_symbol

    mov ax, 0

    @@end_cmp:

    pop bp bx cx

    ret
endp 

correct_password_msg db "ai tigr", 0ah, "$"
  wrong_password_msg db "nonono" , 0ah, "$"

      hash_const db 67h
correct_hash_len db 6
    correct_hash db 18h, 10h, 20h, 07h, 0bh

end start