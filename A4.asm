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

%macro refresh_all 0
xor rax,rax
xor rbx,rbx
xor rcx,rcx
xor rdx,rdx
xor rsi,rsi
xor rdi,rdi
%endmacro

section .data
msg1 db "Menu:",0xA
len1 equ $-msg1

msg2 db "1.Find length of a string.",0xA
len2 equ $-msg2

msg3 db "2.Compare two strings.",0xA
len3 equ $-msg3

msg4 db "3.Concatenate two strings.",0xA
len4 equ $-msg4

msg5 db "4.Find palindrome.",0xA
len5 equ $-msg5

msg6 db "5.Reverse a string.",0xA
len6 equ $-msg6

msg7 db "6.Change string to uppercase.",0xA
len7 equ $-msg7

msgexit db "7.Exit.",0xA
lenexit equ $-msgexit

msg8 db "Enter a choice : ",0xA
len8 equ $-msg8

msg9 db "Enter 1st string :",0xA
len9 equ $-msg9

msg10 db "Length of the string (in hex) is :",
len10 equ $-msg10

msg11 db "Wrong choice entered ! Existing .... !",0xA
len11 equ $-msg11

msg12 db "Enter 2nd string :",0xA
len12 equ $-msg12

msg13 db "Result : Both strings are equal !",0xA
len13 equ $-msg13

msg14 db "Result : Both strings are not equal !",0xA
len14 equ $-msg14

msg15 db "Concatenated string is : ",0xA
len15 equ $-msg15

msg16 db "This string is a palindrome !",0xA
len16 equ $-msg16

msg17 db "This string is not a palindrome !",0xA
len17 equ $-msg17

msg18 db "Reverse of the string is :",0xA
len18 equ $-msg18

msg19 db "Resultant string is :",0xA
len19 equ $-msg19

newline db "",0xA
lennewline equ $-newline

section .bss
space1 resb 50
space2 resb 50
templen resb 1
len resb 2
count resb 1
choice resb 2
strlen1 resb 1
strlen2 resb 1
status resb 1
temp resb 1

section .text
global _start
_start:
menu:
print msg1,len1
print msg2,len2
print msg3,len3
print msg4,len4
print msg5,len5
print msg6,len6
print msg7,len7
print msgexit,lenexit
print msg8,len8
read choice,2

cmp byte[choice],31h
je proc1
cmp byte[choice],32h
je proc2
cmp byte[choice],33h
je proc3
cmp byte[choice],34h
je proc4
cmp byte[choice],35h
je proc5
cmp byte[choice],36h
je proc6
cmp byte[choice],37h
je exit
print msg11,len11

exit:
mov rax,60
mov rdi,0
syscall

proc1:
call find_length
jmp menu

proc2:
call compare
jmp menu

proc3:
call concatenate
jmp menu

proc4:
call palindrome
jmp menu

proc5:
call reverse
jmp menu

proc6:
call changecase
jmp menu

;===============proc1===============

find_length:
refresh_all
call refreshspace
print msg9,len9
read space1,50

mov rsi,space1
mov byte[templen],0h
mov byte[count],2h
mov rbx,len 

loop:
cmp byte[rsi],0xA
je next
inc byte[templen]
inc rsi
jmp loop

next:
xor rax,rax
xor rdx,rdx

mov al,[templen]
rotate:
rol al,4
mov dl,al
and dl,0Fh
cmp dl,9h
jbe add30
add dl,7h

add30:
add dl,30h
mov byte[rbx],dl
inc rbx
dec byte[count]
cmp byte[count],0h
jne rotate

print msg10,len10
print len,2
print newline,lennewline
ret

;===============proc2===============

compare:
print msg9,len9
read space1,50
mov rbx,rax

print msg12,len12
read space2,50
mov rcx,rax

xor rsi,rsi
xor rdi,rdi

mov rsi,space1
mov rdi,space2
cmp rbx,rcx
jge cont
mov rcx,rbx
cont:
cld
repe cmpsb
je equal
print msg14,len14 
jmp next1

equal:
print msg13,len13

next1:
print newline,lennewline
ret

;===============proc3===============

concatenate:
refresh_all
call refreshspace

print msg9,len9
read space1,50

print msg12,len12
read space2,50

mov rsi,space1
mov rdi,space2

loop2:
cmp byte[rsi],0xA
je next2
inc rsi
jmp loop2

next2:
cmp byte[rdi],0xA
je nextagain
mov bl,byte[rdi]
mov byte[rsi],bl
inc rsi
inc rdi
jmp next2

nextagain:
mov byte[rsi],0xA
print msg15,len15
print space1,50
print newline,lennewline
ret

;===============proc4===============

palindrome:
refresh_all
call refreshspace
print msg9,len9
read space1,50
mov rsi,space1
mov rdi,space1
mov bl,2h
div bl
mov byte[count],al

loop3:
cmp byte[rdi],0xA
je next3
inc rdi
jmp loop3

next3:
dec rdi
mov byte[status],1h

loop4:
mov bl,byte[rsi]
mov cl,byte[rdi]
cmp bl,cl
je status1
and byte[status],0h
jmp next4
status1:
and byte[status],1h

next4:
inc rsi
dec rdi
dec byte[count]
cmp byte[count],0h
jne loop4

cmp byte[status],0h
je not_palindrome
print msg16,len16
jmp next5
not_palindrome:
print msg17,len17
next5:
print newline,lennewline
ret

;===============proc5===============

reverse:
refresh_all
call refreshspace
print msg9,len9
read space1,50
mov rsi,space1
mov rdi,space1
mov bl,2h
div bl
mov byte[count],al

loop5:
cmp byte[rdi],0xA
je next6
inc rdi
jmp loop5

next6:
dec rdi

loop6:
mov bl,byte[rsi]
mov cl,byte[rdi]

mov byte[temp],bl
mov bl,cl
mov cl,byte[temp]

mov byte[rsi],bl
mov byte[rdi],cl

inc rsi
dec rdi
dec byte[count]
cmp byte[count],0h
jne loop6

print msg18,len18
print space1,50
print newline,lennewline
ret

;===============proc6===============

changecase:
refresh_all
call refreshspace
print msg9,len9
read space1,50

mov rsi,space1

again2:
mov byte[status],1h
cmp byte[rsi],0xA
je break
cmp byte[rsi],61h
jge status_true1
mov byte[status],0h
jmp forward
status_true1:
mov byte[status],1h

cmp byte[rsi],7Ah
jbe status_true2
mov byte[status],0h
jmp forward
status_true2:
mov byte[status],1h

forward:
cmp byte[status],0h
je forward2
sub byte[rsi],20h

forward2:
inc rsi
jmp again2
break:
print msg19,len19
print space1,50
print newline,lennewline
ret

;=======================================

refreshspace:
mov byte[count],50
mov rsi,space1

again:
mov byte[rsi],0
inc rsi
dec byte[count]
cmp byte[count],0
jne again 
ret
