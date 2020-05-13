BITS 16
UserProPos equ 1000h		;将用户程序载入此地址
extern _choosePro
global _start
extern  _input

_start:
	mov ax,cs
	mov es,ax		; ES = 800h
	mov ds,ax		; DS = CS
	mov es,ax		; ES = CS
	jmp print
	
;清屏
clearScreen:	
	mov	ax,0B800h	; 文本窗口显存起始地址
	mov	gs,ax		; GS = B800h
	mov ax,0
	mov bp,ax		; BP = 0
cls:
	mov byte[gs:bp], ' '
	inc bp
	mov byte[gs:bp], 0fh
	inc bp
	mov ax, bp
	xor ax, 7000h
	jnz cls
	
print:
	;打印提示信息
	mov	bp, MonitorSWMes		; BP=当前串的偏移地址
	mov	ax, ds					; ES:BP = 串地址
	mov	es, ax		 			; 置ES=DS
	mov	cx, MesLength  			; CX = 串长
	mov	ax, 1301h		 		; AH = 13h（功能号）、AL = 01h（光标置于串尾）
	mov	bx, 0007h		 		; 页号为0(BH = 0) 黑底白字(BL = 07h)
   	mov dh, 6		       		; 行号=0
	mov	dl, 0			 		; 列号=0
	int	10h			 			; 打印提示信息
	
	;读入键盘，选择用户程序
SelectProgram:
	mov ah, 0				 
	int 16H				;功能号为0，调用键盘读取
	mov byte[_input],al
	call _choosePro
	
	mov ah,0
	mov bx,ax
	sub bx,1
	jz clearScreen		;调用清屏功能
	mov bx,ax
	sub bx,0
	jz WrongInput		;输入不合法
	
;启动用户程序
	mov cl,al
	mov ax,cs                ;段地址,存放数据的内存基地址
	mov es,ax                ;设置段地址（不能直接mov es,段地址）
	mov bx, UserProPos		 ;偏移地址; 存放数据的内存偏移地址
	mov ah,2                 ;功能号2,表示读入
	mov al,1                 ;扇区数
	mov dl,0                 ;驱动器号 ; 软盘为0，硬盘和U盘为80H
	mov dh,0                 ;磁头号 ; 起始编号为0
	mov ch,0                 ;柱面号 ; 起始编号为0
	int 13H ;                调用读磁盘BIOS的13h功能
	; 用户程序已加载到指定内存区域中
	jmp UserProPos
	
;输入错误
WrongInput:
	mov	bp, ErrorMes			; BP=当前串的偏移地址
	mov	ax, ds					; ES:BP = 串地址
	mov	es, ax		 			; 置ES=DS
	mov	cx, ErrorLen  			; CX = 串长
	mov	ax, 1301h		 		; AH = 13h（功能号）、AL = 01h（光标置于串尾）
	mov	bx, 0007h		 		; 页号为0(BH = 0) 黑底白字(BL = 07h)
   	mov dh, 7		       		; 行号=0
	mov	dl, 0			 		; 列号=0
	int	10h			 			; 打印提示信息
	jmp SelectProgram
	
_end:
	jmp $

MonitorSWMes:
    db 'Enter a, b, c or d to run user program or enter p to clear screen.'
MesLength  equ ($-MonitorSWMes)
ErrorMes:
    db 'Invalid input!Please enter a,b,c,d or p.'
ErrorLen  equ ($-ErrorMes)