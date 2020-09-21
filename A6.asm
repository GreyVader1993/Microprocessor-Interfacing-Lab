%macro print 2
mov rdx,%2			;macro for printing the results
mov rsi,%1
mov rdi,1
mov rax,1
syscall
%endmacro

%macro read 2
mov rdx,%2			;macro for reading in the data
mov rsi,%1
mov rdi,1
mov rax,0
syscall
%endmacro

SECTION .data
menu:db "Menu:",0x0A
menu_len:equ $-menu
menu_msg1:db "1.Succesive Addition Method",0x0A
menu_len1:equ $-menu_msg1
menu_msg2:db "2.Booths Algorithm",0x0A
menu_len2:equ $-menu_msg2
menu_msg3:db "3.Exit",0x0A
menu_len3:equ $-menu_msg3
menu_msg4:db "Invalid !!",0x0A
menu_len4:equ $-menu_msg4
msg:db "Enter two 8 bit numbers you want to Multiply:",0x0A
len:equ $-msg
msg_1:db "Enter the a First 2 digit Hex Number:",0x0A
len_1:equ $-msg_1
msg_2:db "Enter the a Second 2 Digit Hex Number:",0x0A
len_2:equ $-msg_2
msg_3:db "The Multiplication output is:",0x0A
len_3:equ $-msg_3

SECTION .bss
num1:resb 3
num2:resb 3
op:resb 5
count:resb 1
option:resb 2
temp:resb 1



SECTION .text
global _start:
_start:
main_loop:
print msg,len

print msg_1,len_1
mov rcx,00h		;loading rcx with 00h
read num1,3
mov rsi,num1
mov rbx,0h
call convert
mov byte[temp],bl

print msg_2,len_2		; accepting the numbers and converting 
read num2,3  			;them appropriately
mov rsi,num2
mov rbx,0h
call convert

mov rdx,00h
mov rax,00h
mov dl,byte[temp]
mov al,bl
t2:
mov ah,00h
mov bl,dl
neg bl
mov dh,bl
clc
mov r8,rax
mov r9,rdx

;dl=Multiplicand
;dh=2's complement of Multiplicand
;al=Multiplier
;ah=acuumulator
;carry flag=Q-1

main_menu:
print menu,menu_len
print menu_msg1,menu_len1
print menu_msg2,menu_len2
print menu_msg3,menu_len3
read option,02h
mov rax,r8
mov rdx,r9
mov cl,byte[option]
cmp cl,31h
je succ_add

cmp cl,32h
je booths

cmp cl,33h
je exit

print menu_msg4,menu_len4
jmp main_menu

booths:
clc
mov bx,00h
mov cl,08h

l1:
jc l2
mov bl,al
and bl,01h
jz l3

add ah,dh
jmp l3

l2:
mov bl,al
and bl,01h
jnz l3

add ah,dl
jmp l3

l3:
sar ax,01h
dec cl
jnz l1

t1:
mov bx,ax
jmp print_label

succ_add:
mov rcx,00h
mov cl,dl
mov bx,00h

l6:
add bx,ax
dec cl
jnz l6


print_label:
print msg_3,len_3
mov cx,04h
mov rsi,op
mov byte[count],04h
l8:
rol bx,cl
mov dl,bl
and dl,0Fh
cmp dl,09h
jbe l9
add dl,07h
l9:
add dl,30h
mov [rsi],dl
inc rsi
dec byte[count]
jnz l8
mov byte[rsi],0Ah
mov rsi,op
print rsi,5
jmp main_menu


convert:
mov bl,0h
mov cl,04h
mov byte[count],02h
l4:
rol bl,cl
mov ax,0h
mov al,[rsi]
cmp al,39h
jbe l5
sub al,07h
l5:
sub al,30h
add bl,al
inc rsi
dec byte[count]
jnz l4
ret

exit:
mov rdi,0
mov rax,60
syscall
