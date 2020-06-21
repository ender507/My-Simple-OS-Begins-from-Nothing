BITS 16

global _start
global putchar
global getchar
global back
global row
global col
global _end

extern main
extern gets
extern puts
extern str
extern off
extern _ch


_start:
	mov	ax,cs
	mov	es,ax		; ES = CS
	mov	ds,ax		; DS = CS
	mov	ss,ax		; SS = CS
	mov	sp, 0FFFFh 
	call 	main
	jmp	_end

endl:
	mov word[col], 0
	inc word[row]
	ret

putchar:
	mov	al, 10
	mov	bl, byte[_ch]
	sub	al, bl
	jz	endl
	mov	ax, 0B800h	; 文本窗口显存起始地址
	mov	gs, ax		; GS = B800h
	mov 	ax, word[row]
	mov	bx, 80
	mul	bx
	add	ax, word[col]
	inc	word[col]
	mov 	bx, 2
	mul 	bx
	mov 	bp, ax
	mov 	ah, 0Fh
	mov 	al, byte[_ch]
	mov 	word[gs:bp], ax
	ret

getchar:
	mov	ah, 0	
	int 	16h 		;0号功能调用从键盘读入一个字符放入al中
	mov 	byte[_ch], al
	mov	bl, 13
	sub	al, bl
	jz	endl
	mov	ax, 0B800h	; 文本窗口显存起始地址
	mov	gs, ax		; GS = B800h
	mov 	ax, word[row]
	mov	bx, 80
	mul	bx
	add	ax, word[col]
	inc	word[col]
	mov 	bx, 2
	mul 	bx
	mov 	bp, ax
	mov 	ah, 0Fh
	mov 	al, byte[_ch]
	mov 	word[gs:bp], ax
	ret

back:
	jmp	100h:100h

_end:
	ret

col dw 0 
row dw 1
