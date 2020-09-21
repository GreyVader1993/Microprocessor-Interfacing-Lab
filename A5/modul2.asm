 
;Module 2:

SECTION .data
global hex_to_ascii
global find_substring
global concatenate_string
global exit
extern llen1
extern llen2
extern str1
extern str2
extern str3

SECTION .bss
count2 resb 10


SECTION .text
_start:
;--------exit definition---------
exit:
	mov rax,60	;system call for exit
	mov rdi,0
	syscall
	ret

;---------hex to ascii conversion---------
hex_to_ascii:
	mov byte[count2], 10h

loop_hta:
	rol rbx, 04
	mov al, bl
	and al, 0Fh
	cmp al, 09h
	jbe add30
	add al, 07h

add30:
	add al, 30h

	mov [rsi],al
	inc rsi
	dec byte[count2]
	jnz loop_hta
	ret

;-------to find substring-------
find_substring:

	mov rsi,str1
	mov rdi,str2
	cld
	xor r8,r8	;counter
	xor r9,r9	;resetter

compare:
	cmpsb		; compares byte by byte
	je increment
	mov rdi,str2
	cmp byte[rsi],10
	je return
	cmp r9,0
	jne reset
	jmp compare

increment:
	inc r9
	cmp byte[rdi],10
	je inc_cnt
back:
	cmp byte[rsi],10
	je return
	jmp compare

inc_cnt:
	inc r8		; final result
	sub rsi,r14
	add rsi,1
	mov rdi,str2
	xor r9,r9
	jmp back

reset:
	sub rsi,r9
	xor r9,r9
	jmp compare

return:
	ret

;----------to concatenate strings----------
concatenate_string:
	mov rsi,str1
	mov rdi,str3
	cld

loop11:
	movsb		; moves str1 to str3
	cmp byte[rsi],10
	jne loop11
	
	mov rsi,str2
	
loop22:
	movsb		; moves str2 to str3
	cmp byte[rsi],10
	jne loop22
	ret
	

