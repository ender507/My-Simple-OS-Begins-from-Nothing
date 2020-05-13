BITS 16
global _str
global _start
extern _countChar
extern _ch
	
_start:
    mov ax,cs
    mov ds,ax
    mov es,ax
    mov ss,ax
	
	mov	bp, _str		 ; BP=当前串的偏移地址
	mov	ax, ds			 ; ES:BP = 串地址
	mov	es, ax			 ; 置ES=DS
	mov	cx, 21	 		 ; CX = 串长
	mov	ax, 1301h		 ; AH = 13h（功能号）、AL = 01h（光标置于串尾）
	mov	bx, 0007h		 ; 页号为0(BH = 0) 黑底白字(BL = 07h)
   	mov dh, 0		       ; 行号=0
	mov	dl, 0			 ; 列号=0
	int	10h			 ; BIOS的10h功能：显示一行字符
	
go:	
	;读取要计数的字符
	mov ah, 0				 
	int 16H			;调用无回显的键盘读取，读入字符存入al
	mov byte[_ch],al
    call _countChar
	
	mov dx,ax
	
	mov	ax,0B800h	; 文本窗口显存起始地址
	mov	gs,ax		; GS = B800h
	mov bp,0100h
	mov ah,0Fh
	mov al,dl
	mov word[gs:bp],ax
	inc bp
	inc bp
	mov al,byte[_ch]
	mov word[gs:bp],ax
_end:
    jmp go

_str:
    db 'abbcccddddeeeeeffffff'
