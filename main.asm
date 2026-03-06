.model tiny
locals @@
.code
org 100h

start proc
    call correct_password_proc

    call wrong_password_proc

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

correct_password_msg db "ai tigr", 0ah, "$"
  wrong_password_msg    db "nonono" , 0ah, "$"

end start