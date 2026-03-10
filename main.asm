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
    call correct_password_proc
    @@enfif:

    mov ax, 4C00h
    int 21h
endp

correct_password_proc proc
    ;Вывожу сообщение о том что пароль правильный
    mov ah, 09h
    push cs
    pop ds
    mov dx, offset correct_password_msg
    int 21h

    ret
endp

wrong_password_proc proc
    ;Вывожу сообщение о том что пароль неправильный
    mov ah, 09h
    push cs
    pop ds
    mov dx, offset wrong_password_msg
    int 21h

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
correct_hash_len db 10
    correct_hash db 10h, 14h, 11h, 13h, 17h, 14h, 16h, 1ah, 17h

end start