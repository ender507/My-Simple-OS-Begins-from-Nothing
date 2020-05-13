org 7c00h
MonitorSWPos equ 8100h		;将监控程序载入此地址
start:
	mov ax,cs
	mov es,ax		; ES = 0
	mov ds,ax		; DS = CS
	mov es,ax		; ES = CS
	
	mov	bp, Message		 		; BP=当前串的偏移地址
	mov	ax, ds					; ES:BP = 串地址
	mov	es, ax		 			; 置ES=DS
	mov	cx, MessageLength  		; CX = 串长
	mov	ax, 1301h		 		; AH = 13h（功能号）、AL = 01h（光标置于串尾）
	mov	bx, 0007h		 		; 页号为0(BH = 0) 黑底白字(BL = 07h)
   	mov dh, 0		       		; 行号=0
	mov	dl, 0			 		; 列号=0
	int	10h			 			; 打印提示信息
	
	mov ax,cs                ;段地址,存放数据的内存基地址
	mov es,ax                ;设置段地址（不能直接mov es,段地址）
	mov bx, MonitorSWPos	 ;偏移地址, 存放数据的内存偏移地址
	mov ah,2                 ;功能号2,表示读入
	mov al,1                 ;扇区数
	mov dl,0                 ;驱动器号 ; 软盘为0，硬盘和U盘为80H
	mov dh,0                 ;磁头号 ; 起始编号为0
	mov ch,0                 ;柱面号 ; 起始编号为0
	mov cl,2				 ;1号扇区，即监控程序位置
	int 13H 				 ;调用读磁盘BIOS的13h功能,将监控程序读入
	
	jmp 0x800:0x100
	
afterRun:
	jmp $

Message:
    db '18340057OS is running.Open Monitor Software...'
MessageLength  equ ($-Message)