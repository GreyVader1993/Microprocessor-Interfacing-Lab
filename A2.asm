%macro print 2
mov eax,4
mov ebx,1
mov ecx,%1
mov edx,%2
int 0x80
%endmacro

%macro read 2
mov eax,3
mov ebx,2
mov ecx,%1
mov edx,%2
int 0x80
%endmacro

%macro refresh_all 0
xor eax,eax
xor ebx,ebx
xor ecx,ecx
xor edx,edx
xor esi,esi
xor edi,edi
%endmacro

section .data
msg1 db "Menu :",0xA
len1 equ $-msg1

msg2 db "1.Overlapped/Non-overlapped data transfer w/o using string instructions.",0xA
len2 equ $-msg2

msg3 db "2.Overlapped/Non-overlapped data transfer using string instructions.",0xA
len3 equ $-msg3

msg4 db "Enter a choice :",0xA
len4 equ $-msg4

msg5 db "Enter a string :",
len5 equ $-msg5

msg6 db "Enter displacement :",
len6 equ $-msg6

msg7 db "Initial addresses are:",0xA
len7 equ $-msg7

msg8 db "Final addresses after displacement are:",0xA
len8 equ $-msg8

msg9 db "Wrong choice entered ! Exiting .... !",0xA
len9 equ $-msg9

nl db "",0xA
nlen equ $-nl

blankspace db "            ",
blen equ $-blankspace

section .bss
space1 resb 50
choice resb 2
disp resb 1
tempdisp resb 1
count resb 1
result resb 8
strlen resb 1

section .text
global _start
_start:
print msg1,len1
print msg2,len2
print msg3,len3
print msg4,len4
read choice,2

cmp byte[choice],31h
je proc1

cmp byte[choice],32h
je proc2

print msg9,len9

exit:
mov eax,1
mov ebx,0
int 0x80

proc1:
call without_instructions
jmp exit

proc2:
call with_instructions
jmp exit

;==============================

without_instructions:

call refreshspace
refresh_all

print msg5,len5
read space1,50

print msg7,len7
xor eax,eax
mov eax,space1

call show_address

print msg6,len6
read disp,1

cmp byte[disp],'a'
jb capital
sub byte[disp],20h

capital:
cmp byte[disp],'A'
jb sub
sub byte[disp],7h

sub:
sub byte[disp],30h

print msg8,len8
call shift_forward

call show_address

ret

;==============================

with_instructions:       
call refreshspace
refresh_all

print msg5,len5
read space1,50

mov [strlen],al

print msg7,len7

xor eax,eax
mov eax,space1

call show_address

mov esi,eax

print msg6,len6
read disp,1

cmp byte[disp],'a'
jb capital2
sub byte[disp],20h

capital2:
cmp byte[disp],'A'
jb sub2
sub byte[disp],7h

sub2:
sub byte[disp],30h

mov edi,esi
mov al,byte[disp]
mov byte[tempdisp],al

loop2:
cmp byte[tempdisp],0h
je next
inc edi
dec byte[tempdisp]
jmp loop2

next:
xor ecx,ecx
std
mov ecx,[strlen]
rep movsb

print msg8,len8
mov eax,esi
inc eax

mov cl,byte[disp]
mov byte[tempdisp],cl

loop3:
cmp byte[tempdisp],0h
je next2
inc eax
dec byte[tempdisp]
jmp loop3

next2:
call show_address

ret

;==============================

show_address:     ;Procedure to show addresses

again2:
mov esi,result
mov edi,eax
mov byte[count],8

loop1:
rol eax,4
mov dl,al
and dl,0Fh
cmp dl,09h
jbe add30
add dl,07h

add30:
add dl,30h
mov byte[esi],dl
inc esi 
dec byte[count]
cmp byte[count],0
jne loop1

mov ecx,edi
print ecx,1
print blankspace,blen
print result,8
print nl,nlen

mov eax,edi
inc eax
cmp byte[eax],0xA
jne again2
ret

;==============================

shift_forward:         ; Procedure to shift data forward

mov eax,edi
inc eax
mov edi,space1
mov esi,eax

xor ecx,ecx
xor ebx,ebx

mov cl,byte[disp]
mov byte[tempdisp],cl

loop4:
cmp byte[tempdisp],0h
je next3
inc esi
dec byte[tempdisp]
jmp loop4

next3:
cmp eax,edi
jb next4
mov bl,byte[eax]
mov byte[esi],bl
dec eax
dec esi
jmp next3

next4:
inc eax

mov cl,byte[disp]
mov byte[tempdisp],cl

loop5:
cmp byte[tempdisp],0h
je next5
inc eax
dec byte[tempdisp]
jmp loop5

next5:
ret

;==============================

refreshspace:          ;procedure to refresh input space

mov byte[count],50
mov esi,space1

again:
mov byte[esi],0
inc esi
dec byte[count]
cmp byte[count],0
jne again 
ret
