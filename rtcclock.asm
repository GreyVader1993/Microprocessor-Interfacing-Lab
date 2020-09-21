.model tiny
.code
org 0100h
start:jmp transit
      save_into dd ?
      hr db 00h
      sec db 00h
      min db 00h
resi: push ax
      push bx
      push cx
      push dx
      push si
      push di
      push bp
      push cs
      pop ds
      mov ax,0b800h
      mov es,ax
      mov di,0100h

      mov ah,02h     ;read the real time clock
      int 1ah

      mov hr,ch      ;ch:hours in bcd
      mov min,cl
      mov sec,dh
      mov bh,hr
      call dis
      mov al,3ah
      mov es:[di],al
      inc di
      inc di

      mov bh,min
      call dis

      mov al,3ah
      mov es:[di],al
      inc di
      inc di
      mov bh,sec
      call dis
      pop bp
      pop di
      pop si
      pop dx
      pop cx
      pop bx
      pop ax
      jmp cs:save_into

dis proc near
mov al,bh
and al,0f0h
mov cl,04h
shr al,cl
add al,30h

mov es:[di],al
inc di
inc di
mov al,bh
and al,0fh
add al,30h

mov es:[di],al
inc di
inc di
ret
endp

transit:
  cli
  push cs
  pop ds
  mov ax,0003h       ;get cursor position
  int 10h
  mov ah,35h          ;get interrupt vector
  mov al,1ch
  int 21h
  mov word ptr save_into,bx
  mov word ptr save_into+2,es
  mov ah,25h          ;set interrupt vector
  mov al,1ch          ;clock tick
  mov dx,offset resi
  int 21h
  mov ah,31h          ;terminate
  mov al,01h
  mov dx,offset transit
  sti
  int 21h
  end




