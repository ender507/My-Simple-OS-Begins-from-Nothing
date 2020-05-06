org  7c00h
OffSetOfUserPrg equ 8100h
Start:
	mov	ax, cs	       ; �������μĴ���ֵ��CS��ͬ
	mov	ds, ax	       ; ���ݶ�
	;����
	mov	ax,0B800h	; �ı������Դ���ʼ��ַ
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
	
	mov	bp, Message		 ; BP=��ǰ����ƫ�Ƶ�ַ
	mov	ax, ds		 ; ES:BP = ����ַ
	mov	es, ax		 ; ��ES=DS
	mov	cx, MessageLength  ; CX = ����
	mov	ax, 1301h		 ; AH = 13h�����ܺţ���AL = 01h��������ڴ�β��
	mov	bx, 0007h		 ; ҳ��Ϊ0(BH = 0) �ڵװ���(BL = 07h)
   	mov dh, 0		       ; �к�=0
	mov	dl, 0			 ; �к�=0
	int	10h			 ; BIOS��10h���ܣ���ʾһ���ַ�
SelectProgram:
	mov ah, 0				 
	int 16H				;���ܺ�Ϊ0�����ü��̶�ȡ
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
	;���벻����Ҫ����ʾ�����������½�������
	mov	ax, cs	       ; �������μĴ���ֵ��CS��ͬ
	mov	ds, ax	       ; ���ݶ�
	mov	bp, Message2
	mov	ax, ds		 ; ES:BP = ����ַ
	mov	es, ax		 ; ��ES=DS
	mov	cx, MessageLength2  ; CX = ����
	mov	ax, 1301h		 ; AH = 13h�����ܺţ���AL = 01h��������ڴ�β��
	mov	bx, 0007h		 ; ҳ��Ϊ0(BH = 0) �ڵװ���(BL = 07h)
    mov dh, 1			; �к�=1
	mov	dl, 0			 ; �к�=0
	int	10h			 ; BIOS��10h���ܣ���ʾһ���ַ�
	jmp SelectProgram
	
opena:
	mov cl,2                 ;��ʼ������ ; ��ʼ���Ϊ1
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
;�����̻�Ӳ���ϵ����������������ڴ��ES:BX����
	mov ax,cs                ;�ε�ַ ; ������ݵ��ڴ����ַ
	mov es,ax                ;���öε�ַ������ֱ��mov es,�ε�ַ��
	mov bx, OffSetOfUserPrg  ;ƫ�Ƶ�ַ; ������ݵ��ڴ�ƫ�Ƶ�ַ
	mov ah,2                 ;���ܺ�2,��ʾ����
	mov al,1                 ;������
	mov dl,0                 ;�������� ; ����Ϊ0��Ӳ�̺�U��Ϊ80H
	mov dh,0                 ;��ͷ�� ; ��ʼ���Ϊ0
	mov ch,0                 ;����� ; ��ʼ���Ϊ0
	int 13H ;                ���ö�����BIOS��13h����
	; �û������Ѽ��ص�ָ���ڴ�������
	jmp OffSetOfUserPrg

	
AfterRun:
    jmp $                      ;����ѭ��
Message:
    db '18340057OS is running...Please Enter a,b,c or d to run different program.'
MessageLength  equ ($-Message)
Message2:
    db 'Invalid input!Please Enter a,b,c or d'
MessageLength2  equ ($-Message2)
    times 510-($-$$) db 0
    db 0x55,0xaa

