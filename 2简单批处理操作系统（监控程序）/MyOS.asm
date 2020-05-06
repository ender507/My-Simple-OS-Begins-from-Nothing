org  7c00h
OffSetOfUserPrg equ 8100h
Start:
	mov	ax, cs	       ; 置其他段寄存器值与CS相同
	mov	ds, ax	       ; 数据段
	;清屏
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
	
	mov	bp, Message		 ; BP=当前串的偏移地址
	mov	ax, ds		 ; ES:BP = 串地址
	mov	es, ax		 ; 置ES=DS
	mov	cx, MessageLength  ; CX = 串长
	mov	ax, 1301h		 ; AH = 13h（功能号）、AL = 01h（光标置于串尾）
	mov	bx, 0007h		 ; 页号为0(BH = 0) 黑底白字(BL = 07h)
   	mov dh, 0		       ; 行号=0
	mov	dl, 0			 ; 列号=0
	int	10h			 ; BIOS的10h功能：显示一行字符
SelectProgram:
	mov ah, 0				 
	int 16H				;功能号为0，调用键盘读取
	mov ah, 0
	mov bx, ax
	sub bx, 97
	jz opena
	mov bx, ax
	sub bx, 98
	jz openb
	mov bx, ax
	sub bx, 99
	jz openc
	mov bx, ax
	sub bx, 100
	jz opend
	;输入不满足要求，提示输入有误并重新进行输入
	mov	ax, cs	       ; 置其他段寄存器值与CS相同
	mov	ds, ax	       ; 数据段
	mov	bp, Message2
	mov	ax, ds		 ; ES:BP = 串地址
	mov	es, ax		 ; 置ES=DS
	mov	cx, MessageLength2  ; CX = 串长
	mov	ax, 1301h		 ; AH = 13h（功能号）、AL = 01h（光标置于串尾）
	mov	bx, 0007h		 ; 页号为0(BH = 0) 黑底白字(BL = 07h)
    mov dh, 1			; 行号=1
	mov	dl, 0			 ; 列号=0
	int	10h			 ; BIOS的10h功能：显示一行字符
	jmp SelectProgram
	
opena:
	mov cl,2                 ;起始扇区号 ; 起始编号为1
	jmp LoadnEx
openb:	
	mov cl,3
	jmp LoadnEx
openc:
	mov cl,4
	jmp LoadnEx
opend:	
	mov cl,5
	jmp LoadnEx
	
LoadnEx:
;读软盘或硬盘上的若干物理扇区到内存的ES:BX处：
	mov ax,cs                ;段地址 ; 存放数据的内存基地址
	mov es,ax                ;设置段地址（不能直接mov es,段地址）
	mov bx, OffSetOfUserPrg  ;偏移地址; 存放数据的内存偏移地址
	mov ah,2                 ;功能号2,表示读入
	mov al,1                 ;扇区数
	mov dl,0                 ;驱动器号 ; 软盘为0，硬盘和U盘为80H
	mov dh,0                 ;磁头号 ; 起始编号为0
	mov ch,0                 ;柱面号 ; 起始编号为0
	int 13H ;                调用读磁盘BIOS的13h功能
	; 用户程序已加载到指定内存区域中
	jmp OffSetOfUserPrg

	
AfterRun:
    jmp $                      ;无限循环
Message:
    db '18340057OS is running...Please Enter a,b,c or d to run different program.'
MessageLength  equ ($-Message)
Message2:
    db 'Invalid input!Please Enter a,b,c or d'
MessageLength2  equ ($-Message2)
    times 510-($-$$) db 0
    db 0x55,0xaa

