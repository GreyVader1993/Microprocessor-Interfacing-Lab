SECTION .data
msg:db "enter number : ",10
l1:equ $-msg
msg2:db "Enter count : ",10
l2:equ $-msg2
msg1:db "Addition is : "
l3:equ $-msg1

SECTION .bss
buffer resb 20
result resb 2 
count resq 1

%macro read 2
mov rax,0
mov rdi,0
mov rsi,%1
mov rdx,%2
syscall
%endmacro

%macro print 2
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro

SECTION .text
global _start
_start:
print msg2,l2
read buffer,11h
call hex
mov [count],rbx
accept:
print msg,l1
read buffer,11H
call hex
add [result],rbx
dec byte[count]
jnz accept

mov rbx,[result]
call ascii
print msg1,l3
print result,10H

exit:
mov rax,60
mov rsi,0
syscall

hex:
xor rbx,rbx
mov rsi,buffer
mov rcx,rax
sub rcx,1
xor rax,rax
p1:
	rol rbx,04H
	mov al,[rsi]
	cmp al,39h
	jbe sub30
	sub al ,07H
sub30:	sub al,30H
	add rbx,rax
	inc rsi
	loop p1
ret

ascii:
mov rsi,result
mov cl,10H
xor rax,rax
q1:
rol rbx,04H
mov al,bl
and al,0FH
cmp al,09H
jbe add30
add al,07H
add30:
add al,30H
mov [rsi],al
inc rsi
loop q1
ret
