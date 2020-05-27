BITS 16
UserProPos equ 1000h		;将用户程序载入此地址
global _start
global cmdStr
global errorCmd
global cls
global getChar
global putChar
global load
global go
global _end

extern cmain
extern _ch
extern pos
extern userPro
extern color

_start:
	mov	ax, cs
	mov 	es, ax		; ES = CS
	mov	ds, ax		; DS = CS
	mov 	ss, ax		; SS = CS
	mov	sp, 100h 	
	
	mov	bx, es
	mov	ax, 0
	mov	es, ax
	mov 	word[es:20h],wheel	; 设置时钟中断向量的偏移地址
	mov 	ax,cs 
	mov 	word[es:22h],ax	; 设置时钟中断向量的段地址=CS
	mov	es, bx
; 在屏幕右下角初始化风火轮开始的字符'-'	
	mov	ax,0B800h		; 文本窗口显存起始地址
	mov	gs,ax			; GS = B800h
	mov 	ah,0Fh			; 0000：黑底、1111：亮白字
	mov 	al, '-'			; AL = 显示字符值'-'
	mov 	[gs:((80*24+79)*2)],ax	; 屏幕第 24 行, 第 79 列

;对键盘中断原有的代码位置的保存
	mov	bx, es
	xor	ax, ax
	mov	es, ax
	cli
	push	word[es:24h]
	pop 	word[es:200h]
	push 	word[es:26h]
        pop 	word[es:202h]
	sti
	mov	es, bx
	jmp	go
; 时钟中断处理程序
	delay 	equ 4			; 计时器延迟计数
	count 	db delay		; 计时器计数变量，初值=delay

wheel:
	dec	byte[count]		; 递减计数变量
	jnz 	intEnd			; >0：跳转
	mov 	byte[count],delay	; 重置计数变量=初值delay
	mov 	al,byte[gs:((80*24+79)*2)]
	sub 	al,'-'
	jz	lu2rd
	mov 	al,byte[gs:((80*24+79)*2)]
	sub 	al,'\'
	jz	vtc
	mov al,byte[gs:((80*24+79)*2)]
	sub al,'|'
	jz	ru2ld

hrz:	;现在字符为'/'，改为'-'
	mov 	byte[gs:((80*24+79)*2)],'-'
	jmp 	intEnd
lu2rd:	;现在字符为'-'，改为'\'
	mov 	byte[gs:((80*24+79)*2)],'\'
	jmp 	intEnd
vtc:	;现在字符为'\'，改为'|'
	mov	 byte[gs:((80*24+79)*2)],'|'
	jmp 	intEnd
ru2ld:	;现在字符为'|'，改为'/'
	mov 	byte[gs:((80*24+79)*2)],'/'
	jmp 	intEnd

Ouch:
	mov	bp, OuchMes	; BP=当前串的偏移地址
	mov	ax, ds		; ES:BP = 串地址
	mov	es, ax		; 置ES=DS
	mov	cx, OuchMesLen ; CX = 串长
	mov	ax, 1301h	; AH = 13h（功能号）、AL = 01h（光标置于串尾）
	mov	bh, 00h		; 页号为0(BH = 0)
	mov 	bl, byte[color]
	inc	byte[color]
   	mov 	dh, 24		; 行号=24
	mov	dl, 0		; 列号=0
	int	10h		; 打印提示信息
	in 	al, 60h	
	jmp	intEnd


go:
	call 	cmain
	jmp	go

;clear the whole screen	
cls:
	mov	ax, 0600h	; AH = 6,  AL = 0				
	mov	bx, 0700h	; 黑底白字(BL = 7)
	mov	cx, 0		; 左上角: (0, 0)
	mov	dx, 184fh	; 右下角: (24, 79)	
	int	10h		; 显示中断
				; AH=06H表示将cx（左上角）dx（右下角）的矩形区域向上移动
	;wheel
	mov	ax, 0B800h		; 文本窗口显存起始地址
	mov	gs, ax			; GS = B800h
	mov 	ah, 0Fh			; 0000：黑底、1111：亮白字
	mov 	al, '-'			; AL = 显示字符值'-'
	mov [gs:((80*24+79)*2)], ax	; 屏幕第 24 行, 第 79 列

cmdStr:
	mov	bp, cmdMes	; BP=当前串的偏移地址
	mov	ax, ds		; ES:BP = 串地址
	mov	es, ax		; 置ES=DS
	mov	cx, cmdMesLen  	; CX = 串长
	mov	ax, 1301h	; AH = 13h（功能号）、AL = 01h（光标置于串尾）
	mov	bx, 0007h	; 页号为0(BH = 0) 黑底白字(BL = 07h)
   	mov 	dh, 0		; 行号=0
	mov	dl, 0		; 列号=0
	int	10h		; 打印提示信息	
	ret

errorCmd:
	mov	bp, errorMes	; BP=当前串的偏移地址
	mov	ax, ds		; ES:BP = 串地址
	mov	es, ax		; 置ES=DS
	mov	cx, errorMesLen ; CX = 串长
	mov	ax, 1301h	; AH = 13h（功能号）、AL = 01h（光标置于串尾）
	mov	bx, 0007h	; 页号为0(BH = 0) 黑底白字(BL = 07h)
   	mov 	dh, 1		; 行号=1
	mov	dl, 0		; 列号=0
	int	10h		; 打印提示信息	
	ret

getChar:
	mov	ah, 0
	int 	16h 		;0号功能调用从键盘读入一个字符放入al中
	mov 	byte[_ch], al
	ret

putChar:
	mov	ax, 0B800h	; 文本窗口显存起始地址
	mov	gs, ax		; GS = B800h
	mov 	ax, 3
	mov	bx, 80
	mul	bx
	add	ax, word[pos]
	mov 	bx, 2
	mul 	bx
	mov 	bp, ax
	mov 	ah, 0Fh
	mov 	al, byte[_ch]
	mov 	word[gs:bp], ax
	ret

load:
	mov	bx, es
	xor	ax, ax
	mov	es, ax
	cli	
	mov 	word[es:24h],Ouch
	mov 	ax,cs 
	mov 	word[es:26h],ax	
	sti
	mov	es, bx

	mov	cl, byte[userPro]
	mov 	ax, cs		;段地址,存放数据的内存基地址
	mov 	es, ax		;设置段地址（不能直接mov es,段地址）
	mov 	bx, UserProPos  ;偏移地址; 存放数据的内存偏移地址
	mov 	ah, 2		;功能号2,表示读入
	mov 	al, 1		;扇区数
	mov 	dl, 0		;驱动器号 ; 软盘为0，硬盘和U盘为80H
	mov 	dh, 0		;磁头号 ; 起始编号为0
	mov 	ch, 0		;柱面号 ; 起始编号为0
	int 	13H		;调用读磁盘BIOS的13h功能
	call 	UserProPos

afterUser:
	mov	bx, es
	xor	ax, ax
	mov	es, ax
	cli	
        mov	ax, word[es:200h]
        mov 	word[es:24h], ax
        mov	ax, word[es:202h]
        mov	word[es:26h],ax
	sti	
	mov	es, bx
	jmp	go

intEnd:
	mov 	al,20h		; AL = EOI
	out 	20h,al		; 发送EOI到主8529A
	out 	0A0h,al		; 发送EOI到从8529A
	iret			; 从中断返回

_end:
	jmp $

cmdMes:
    db 'please enter command'
cmdMesLen  equ ($-cmdMes)
errorMes:
    db 'Wrong command!'
errorMesLen  equ ($-errorMes)
OuchMes:
    db 'Ouch!Ouch!'
OuchMesLen  equ ($-OuchMes)
