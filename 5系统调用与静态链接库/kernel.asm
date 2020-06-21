BITS 16

global _start
global cls
global getChar
global putChar
global load
global go
global _end

extern cmain
extern _ch
extern row
extern col
extern _es
extern _ds
extern _di
extern _si
extern _bp
extern _sp
extern _dx
extern _cx
extern _bx
extern _ax
extern _ss
extern userPro
extern proSize

_start:
	mov	ax, cs
	mov 	es, ax		; ES = CS
	mov	ds, ax		; DS = CS
	mov 	ss, ax		; SS = CS
	mov	sp, 0FFFFh 	
	
	mov	bx, es
	mov	ax, 0
	mov	es, ax
	mov 	word[es:20h],wheel	; 设置时钟中断向量的偏移地址
	mov	word[es:80h],int20h	; 设置20号中断的中断向量的偏移地址,之后两句同理
	mov	word[es:84h],int21h
	mov	word[es:88h],int22h
	mov 	ax,cs 
	mov 	word[es:22h],ax		; 设置时钟中断向量的段地址=CS
	mov	word[es:82h],ax		;设置20号中断的中断向量的段地址,之后两句同理
	mov	word[es:86h],ax
	mov	word[es:8ah],ax
	mov	es, bx
; 在屏幕右下角初始化风火轮开始的字符'-'	
	mov	ax,0B800h		; 文本窗口显存起始地址
	mov	gs,ax			; GS = B800h
	mov 	ah,0Fh			; 0000：黑底、1111：亮白字
	mov 	al, '-'			; AL = 显示字符值'-'
	mov 	[gs:((80*24+79)*2)],ax	; 屏幕第 24 行, 第 79 列
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

int20h:
	call 	save
	jmp	100h:100h

int21h:
	call	save
   	mov	dh, ah
	dec	dh
	jz	getTime 		; ah = 1
	dec	dh
	jz	getDate			; ah = 2
	dec	dh
	jz	itoa			; ah = 3
int21hEnd:
   	call 	restart
	jmp	intEnd
getTime:
	mov	ah,2h
	int	1Ah
	mov	ax, 0B800h		; 文本窗口显存起始地址
	mov	gs, ax			; GS = B800h
	mov 	ah, 0Fh			; 0000：黑底、1111：亮白字
	mov 	al, ch
	shr	al, 4
	and	al, 0Fh
	add	al, 48
	mov 	[gs:((80*23+0)*2)], ax	; 屏幕第 24 行, 第 1 列
	mov 	al, ch
	and	al, 0Fh
	add	al, 48
	mov 	[gs:((80*23+1)*2)], ax	; 屏幕第 24 行, 第 2 列
	mov 	al, ':'
	mov 	[gs:((80*23+2)*2)], ax	; 屏幕第 24 行, 第 3 列
	mov 	al, cl
	shr	al, 4
	and	al, 0Fh
	add	al, 48
	mov 	[gs:((80*23+3)*2)], ax	; 屏幕第 24 行, 第 4 列
	mov	al, cl
	and	al, 0Fh
	add	al, 48
	mov 	[gs:((80*23+4)*2)], ax	; 屏幕第 24 行, 第 5 列
	mov 	al, ':'
	mov 	[gs:((80*23+5)*2)], ax	; 屏幕第 24 行, 第 6 列
	mov 	al, dh
	shr	al, 4
	and	al, 0Fh
	add	al, 48
	mov 	[gs:((80*23+6)*2)], ax	; 屏幕第 24 行, 第 7 列
	mov 	al, dh
	and	al, 0Fh
	add	al, 48
	mov 	[gs:((80*23+7)*2)], ax	; 屏幕第 24 行, 第 8 列
	jmp	int21hEnd
getDate:
	mov	ah,4h
	int	1Ah
	mov	ax, 0B800h		; 文本窗口显存起始地址
	mov	gs, ax			; GS = B800h
	mov 	ah, 0Fh			; 0000：黑底、1111：亮白字
	mov 	al, ch
	shr	al, 4
	and	al, 0Fh
	add	al, 48
	mov 	[gs:((80*22+0)*2)], ax	; 屏幕第 23 行, 第 1 列
	mov 	al, ch
	and	al, 0Fh
	add	al, 48
	mov 	[gs:((80*22+1)*2)], ax	; 屏幕第 23 行, 第 2 列
	mov 	al, cl
	shr	al, 4
	and	al, 0Fh
	add	al, 48
	mov 	[gs:((80*22+2)*2)], ax	; 屏幕第 23 行, 第 3 列
	mov	al, cl
	and	al, 0Fh
	add	al, 48
	mov 	[gs:((80*22+3)*2)], ax	; 屏幕第 23 行, 第 4 列
	mov 	al, '-'
	mov 	[gs:((80*22+4)*2)], ax	; 屏幕第 23 行, 第 5 列
	mov 	al, dh
	shr	al, 4
	and	al, 0Fh
	add	al, 48
	mov 	[gs:((80*22+5)*2)], ax	; 屏幕第 23 行, 第 6 列
	mov 	al, dh
	and	al, 0Fh
	add	al, 48
	mov 	[gs:((80*22+6)*2)], ax	; 屏幕第 23 行, 第 7 列
	mov 	al, '-'
	mov 	[gs:((80*22+7)*2)], ax	; 屏幕第 23 行, 第 8 列
	mov 	al, dl
	shr	al, 4
	and	al, 0Fh
	add	al, 48
	mov 	[gs:((80*22+8)*2)], ax	; 屏幕第 23 行, 第 9 列
	mov 	al, dl
	and	al, 0Fh
	add	al, 48
	mov 	[gs:((80*22+9)*2)], ax	; 屏幕第 23 行, 第 10 列
	jmp	int21hEnd
itoa:
	add	bx, '0'
	mov	word[_bx], bx
	jmp	int21hEnd

int22h:
   	call	save
	mov 	ax,cs           ;段地址 ; 存放数据的内存基地址
     	mov 	es,ax           ;设置段地址（不能直接mov es,段地址）
	mov	bp, int22hMes	; BP=当前串的偏移地址
	mov	ax, ds		; ES:BP = 串地址
	mov	es, ax		; 置ES=DS
	mov	cx, int22hMesLen; CX = 串长
	mov	ax, 1301h	; AH = 13h（功能号）、AL = 01h（光标置于串尾）
	mov	bh, 00h		; 页号为0(BH = 0)
	mov 	bl, 0Fh
   	mov 	dh, 24		; 行号=24
	mov	dl, 0		; 列号=0
	int	10h		; 打印提示信息
	call	restart 
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
	mov 	[gs:((80*24+79)*2)], ax	; 屏幕第 24 行, 第 79 列
	ret

getChar:
	mov	ah, 0
	int 	16h 		;0号功能调用从键盘读入一个字符放入al中
	mov 	byte[_ch], al
	ret

putChar:
	mov	ax, 0B800h	; 文本窗口显存起始地址
	mov	gs, ax		; GS = B800h
	mov 	ax, word[row]
	mov	bx, 80
	mul	bx
	add	ax, word[col]
	mov 	bx, 2
	mul 	bx
	mov 	bp, ax
	mov 	ah, 0Fh
	mov 	al, byte[_ch]
	mov 	word[gs:bp], ax
	;置光标位置
	mov	ah, 2
	mov	bh, 0
	mov	dh, byte[row]
	mov	dl, byte[col]
	inc	dl
	int	10h
	ret

load:
	mov	cl, byte[userPro]
	mov 	ax, cs		;段地址,存放数据的内存基地址
	mov 	es, ax		;设置段地址（不能直接mov es,段地址）
	mov 	bx, 1000h	;偏移地址; 存放数据的内存偏移地址
	mov 	ah, 2		;功能号2,表示读入
	mov 	al, proSize		;扇区数
	mov 	dl, 0		;驱动器号 ; 软盘为0，硬盘和U盘为80H
	mov 	dh, 0		;磁头号 ; 起始编号为0
	mov 	ch, 0		;柱面号 ; 起始编号为0
	int 	13H		;调用读磁盘BIOS的13h功能
	call	1000h
afterUser:
	jmp	go

intEnd:
	mov 	al,20h		; AL = EOI
	out 	20h,al		; 发送EOI到主8529A
	out 	0A0h,al		; 发送EOI到从8529A
	iret			; 从中断返回

save:
	; 调用中断时会先将FLAGS，CS，IP入栈
	mov	word[_ss], ss
	mov	word[_ax], ax
    	mov	word[_bx], bx
	mov	word[_cx], cx
	mov	word[_dx], dx
	mov	word[_sp], sp
	mov	word[_bp], bp
	mov	word[_si], si
	mov	word[_di], di
	mov	word[_ds], ds
	mov	word[_es], es
	ret
restart:
	mov ax, cs
	mov ds, ax
	mov es, ax
; 执行iret后会把SP,SP+2,SP+4分别出栈到IP,CS,FLAGS寄存器
	mov	ss, word[_ss]
	mov	ax, word[_ax]
    	mov	bx, word[_bx]
	mov	cx, word[_cx]
	mov	dx, word[_dx]
	mov	sp, word[_sp]
	mov	bp, word[_bp]
	mov	si, word[_si]
	mov	di, word[_di]
	mov	ds, word[_ds]
	mov	es, word[_es]
	ret

_end:
	jmp $

int22hMes:
	db 'INT22H'
int22hMesLen equ ($-int22hMes)

