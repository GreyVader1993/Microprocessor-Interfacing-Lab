
section .data
    numbers: db "The numbers are: 102.59,198.21,100.67,230.78,67.93",10
    len equ $-numbers
    meanmsg db 10,"CALCULATED MEAN IS:-"
    meanmsg_len equ $-meanmsg
    sdmsg db 10,"CALCULATED STANDARD DEVIATION IS:-"
    sdmsg_len equ $-sdmsg
    varmsg db 10,"CALCULATED VARIANCE IS:-"
    varmsg_len equ $-varmsg
    array dd 102.56,198.21,100.67,230.78,67.93
    arraycnt dw 05

    dot :db "."
    dotlen : equ $-dot
    hdec dd 100
                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
section .bss
intval rest 01
decval rest 01
cwreg resb 01
stde resd 1
    dispbuff resb 1
    result rest 1

	mean resd 1
	variance resd 1
    %macro linuxsyscall 4
        mov rax,%1
        mov rdi,%2
        mov rsi,%3	
        mov rdx,%4
        syscall
    %endmacro   


section .text
   global _start
_start:

    
	linuxsyscall 01,01,numbers,len
	finit
	fldz
	mov rbx,array
	mov rsi,00
	xor rcx,rcx
	mov cx,[arraycnt]
up:	fadd dword[RBX]
	add rbx,04h
	inc rsi
	loop up

	fidiv word[arraycnt]
	fst dword[mean]
	linuxsyscall 01,01,meanmsg,meanmsg_len	
	;call dispres
;-------------------------
fstcw word[cwreg]
mov ax,[cwreg]
or ax,0C00h
mov [cwreg],ax
fldcw word[cwreg]

;----------------display mean---------------------
fld dword[mean]
;frndint
fbstp tword[intval]
fbld tword[intval]
fld dword[mean]
fsub st0,st1
fimul dword[hdec]
;frndint
fbstp tword[decval]
call convert



	MOV RCX,00
	MOV CX,[arraycnt]
	MOV RBX,array
	MOV RSI,00
	FLDZ
up1:	FLDZ
	FLD DWORD[RBX+RSI*4]
	FSUB DWORD[mean]
	FST ST1
	FMUL
	FADD
	INC RSI
	LOOP up1
	FIDIV word[arraycnt]
	FST dWORD[variance]
	FSQRT
	fst dword[stde]
	linuxsyscall 01,01,sdmsg,sdmsg_len
	;CALL disp
fld dword[stde]
fbstp tword[intval]
fbld tword[intval]
fld dword[stde]
fsub st0,st1
fimul dword[hdec]
fbstp tword[decval]
call convert
	

;---------------------display variance----------------------

q:
	linuxsyscall 01,01,varmsg,varmsg_len	
fld dword[variance]
fbstp tword[intval]
fbld tword[intval]
fld dword[variance]
fsub st0,st1
fimul dword[hdec]
fbstp tword[decval]
call convert
	
	
exit: mov rax,60
      mov rdi,0
      syscall

convert:
mov rbx,[intval]
call convhta
linuxsyscall 01,01,result,10h
linuxsyscall 01,01,dot,dotlen

mov rbx,[decval]
call convdta
linuxsyscall 01,01,result,02

ret

convdta:
mov rsi,result
mov rcx,02

up2:
rol bl,04
mov al,bl
and al,0Fh
cmp al,09
jbe add301
add al,07

add301:
add al,30h

mov [rsi],al
inc rsi

loop up2

ret


convhta:
mov rsi,result
mov rcx,10h


up12:
rol rbx,04
mov al,bl
and al,0Fh
cmp al,09
jbe add30
add al,07

add30:
add al,30h

mov [rsi],al
inc rsi

loop up12


ret

