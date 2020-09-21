;Name: Raunaq Kochar
;Roll No: 2232
;Group: A-3
;Assignment: Convert hex to BCD and BCD to Hex

%macro print 2
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro

%macro read 2
mov rax,0
mov rdi,2
mov rsi,%1
mov rdx,%2
syscall
%endmacro

section .data
multiplier dd 10000,1000,100,10,1

msg1 db "Menu:",0xA
len1 equ $-msg1

msg2 db "1.HEX to BCD conversion.",0xA
len2 equ $-msg2

msg3 db "2.BCD to HEX conversion.",0xA
len3 equ $-msg3

msg4 db "3.Exit.",0xA
len4 equ $-msg4

msg5 db "Enter a choice : ",0xA
len5 equ $-msg5

msg6 db "Enter input (4-digit HEX number):",
len6 equ $-msg6

msg7 db "Enter input (5-digit BCD number):",
len7 equ $-msg7

msg8 db "Corresponding BCD equivalent is:",
len8 equ $-msg8

msg9 db "Corresponding HEX equivalent is:",
len9 equ $-msg9

msg10 db "Wrong choice ! Exiting ....!",0xA
len10 equ $-msg10

newline db "",0xA
lennewline equ $-newline


section .bss
hex resb 4
bcd resb 5
eqv_bcd resb 5
eqv_hex resb 4
count resb 1
choice resb 2

section .data
global _start
_start:

menu:
print msg1,len1
print msg2,len2
print msg3,len3
print msg4,len4
print msg5,len5
read choice,2

cmp byte[choice],31h
je proc1

cmp byte[choice],32h
je proc2

cmp byte[choice],33h
je exit

print msg10,len10

exit:
mov rax,60
mov rdi,0
syscall

proc1:
call hex_to_bcd
jmp menu

proc2:
call bcd_to_hex
jmp menu

;===============hex_to_bcd===============
hex_to_bcd:
print msg6,len6
read hex,5
mov rsi,hex
mov bx,10h
mov cx,4
mov rax,0
mov dx,0
loop3:
mul bx
cmp byte[rsi],39h
jbe l1
sub byte[rsi],07h
l1:
sub byte[rsi],30h
add al,byte[rsi]
inc rsi
dec cx
jnz loop3
mov bx,0xA
mov rdi,eqv_bcd
add rdi,4
loop4:
mov dx,0
div bx
add dl,30h
mov byte[rdi],dl
dec rdi
add ax,0
jnz loop4
print msg8,len8
print eqv_bcd,5
print newline,lennewline
ret

;===============bcd_to_hex===============

bcd_to_hex:
print msg7,len7
read bcd,6
mov rdi,bcd
mov cx,5
mov rsi,multiplier
mov rbx,0
loop1:
mov ax,0
sub byte[rdi],30h
mov al,[rdi]
mov dx,[rsi]
mul dx
add rbx,rax
add rsi,4
inc rdi
dec cx 
jnz loop1
mov rdi,eqv_hex
mov cx,4
loop2:
rol bx,4
mov dl,bl
and dl,0fh
cmp dl,09h
jbe l2
add dl,07h
l2:
add dl,30h
mov [rdi],dl
inc rdi
dec cx
jnz loop2
print msg9,len9
print eqv_hex,4
print newline,lennewline
ret

 
