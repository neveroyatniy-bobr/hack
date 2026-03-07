.model tiny
locals @@
.code
org 100h

start proc
    call hash_func

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

correct_password_msg db "ai tigr", 0ah, "$"
  wrong_password_msg db "nonono" , 0ah, "$"

hash_const db 67h

end start