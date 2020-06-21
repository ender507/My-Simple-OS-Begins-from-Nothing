org 7c00h
kernelSeg equ 100h
kernelOff equ 100h
start:
	mov ax,cs
	mov es,ax		; ES = 0
	mov ds,ax		; DS = CS
	mov es,ax		; ES = CS
	
	mov ax,kernelSeg	     ;段地址,存放数据的内存基地址
	mov es,ax                ;设置段地址（不能直接mov es,段地址）
	mov bx,kernelOff		 ;偏移地址, 存放数据的内存偏移地址
	mov ah,2                 ;功能号2,表示读入
	mov al,5                 ;扇区数
	mov dl,0                 ;驱动器号 ; 软盘为0，硬盘和U盘为80H
	mov dh,0                 ;磁头号 ; 起始编号为0
	mov ch,0                 ;柱面号 ; 起始编号为0
	mov cl,2				 ;2号扇区，即监控程序位置
	int 13H 				 ;调用读磁盘BIOS的13h功能,将监控程序读入
	jmp kernelSeg:kernelOff
	
afterRun:
	jmp $
