    Dn_Rt equ 1     ;D-Down,U-Up,R-right,L-Left
    Up_Rt equ 2
    Up_Lt equ 3
    Dn_Lt equ 4
    delay equ 50000 ;计时器延迟计数,用于控制画框的速度
    ddelay equ 580  ;计时器延迟计数,用于控制画框的速度
    org 8100h       ;程序加载到该位置
	home equ 7c00h
start:
	mov cl,0Fh		;字符初始颜色
    mov ax,cs
	mov es,ax		; ES = 0
	mov ds,ax		; DS = CS
	mov es,ax		; ES = CS
	mov	ax,0B800h	; 文本窗口显存起始地址
	mov	gs,ax		; GS = B800h
    mov byte[char],'A'
loop1:
	dec word[count]		    ;递减计数变量
	jnz loop1				;count大于0时一直循环，以实现延迟显示
	mov word[count],delay	;count为0时重新赋delay给count
	dec word[dcount]		;递减计数变量
    jnz loop1				;dcount控制延迟同上，总延迟为delay*ddelay
	mov word[count],delay
	mov word[dcount],ddelay

    mov al,1
    cmp al,byte[rdul]
	jz  DnRt			;rdul等于1时跳转至DnRt
    mov al,2
    cmp al,byte[rdul]	;rdul等于2时跳转至UpRt
	jz  UpRt
    mov al,3
    cmp al,byte[rdul]	;rdul等于3时跳转至UpLt
	jz  UpLt
    mov al,4
    cmp al,byte[rdul]	;rdul等于4时跳转至DnLt
	jz  DnLt
    jmp $				;不满足上述情况则退出程序
	
;向右下移动
DnRt:			
	inc word[x]
	inc word[y]			;x和y坐标都递增
	mov bx,word[x]
	mov ax,24
	sub ax,bx
    jz  dr2ur			;x等于24时出界，改为向右上
	mov bx,word[y]
	mov ax,80
	sub ax,bx
    jz  dr2dl			;y等于80时出界，改为向左下
	jmp show
dr2ur:
    mov word[x],22
    mov byte[rdul],Up_Rt;之后改为向右上运动	
    jmp show
dr2dl:
    mov word[y],78
    mov byte[rdul],Dn_Lt;之后改为向左下运动	
    jmp show
	
;向右上移动
UpRt:
	dec word[x]
	inc word[y]			;x递减，y递增
	mov bx,word[y]
	mov ax,80
	sub ax,bx
    jz  ur2ul			;y等于80时出界，改为向左上
	mov bx,word[x]
	mov ax,12
	sub ax,bx			
    jz  ur2dr			;x等于12时出界，改为向右下
	jmp show
ur2ul:
    mov word[y],78
    mov byte[rdul],Up_Lt;之后改为向左上运动	
    jmp show
ur2dr:
	mov bx,word[y]
	mov ax,79
	sub ax,bx
	jz home				;退出程序
    mov word[x],14
    mov byte[rdul],Dn_Rt;之后改为向右下运动	
    jmp show
	
;向左上移动
UpLt:
	dec word[x]	
	dec word[y]			;x和y坐标都递减
	mov bx,word[x]
	mov ax,12
	sub ax,bx
    jz  ul2dl			;x等于12时出界，改为向左下
	mov bx,word[y]
	mov ax,40
	sub ax,bx
    jz  ul2ur			;y等于40时出界，改为向右上
	jmp show
ul2dl:
    mov word[x],14
    mov byte[rdul],Dn_Lt;之后改为向左下运动	
    jmp show
ul2ur:
    mov word[y],42
    mov byte[rdul],Up_Rt;之后改为向右上运动	
    jmp show
	
;向左下移动
DnLt:
	inc word[x]
	dec word[y]			;x递增，y递减
	mov bx,word[y]
	mov ax,40
	sub ax,bx
    jz  dl2dr			;y等于40时出界，改为向右下
	mov bx,word[x]
	mov ax,24
	sub ax,bx
    jz  dl2ul			;x等于12时出界，改为向左上
	jmp show
dl2dr:
    mov word[y],42
    mov byte[rdul],Dn_Rt;之后改为向右下运动	
    jmp show
dl2ul:
    mov word[x],22
    mov byte[rdul],Up_Lt;之后改为向左上运动	
    jmp show
	
;打印屏幕
show:	
    xor ax,ax			;计算显存地址
    mov ax,word[x]
	mov bx,80
	mul bx
	add ax,word[y]
	mov bx,2
	mul bx
	mov bp,ax
	mov ah,cl
	mov al,byte[char]	;AL = 显示字符值
	mov word[gs:bp],ax  ;显示字符的ASCII码值
	;打印我的学号，颜色和当前字符相同
	mov bp,0F00h
	mov al,'1'
	mov word[gs:bp],ax
	add bp,2
	mov al,'8'
	mov word[gs:bp],ax
	add bp,2
	mov al,'3'
	mov word[gs:bp],ax
	add bp,2
	mov al,'4'
	mov word[gs:bp],ax
	add bp,2
	mov al,'0'
	mov word[gs:bp],ax
	add bp,2
	mov al,'0'
	mov word[gs:bp],ax
	add bp,2
	mov al,'5'
	mov word[gs:bp],ax
	add bp,2
	mov al,'7'
	mov word[gs:bp],ax
	jmp loop1
end:
    jmp $                   ; 停止画框，无限循环 
datadef:	
    count dw delay
    dcount dw ddelay
    rdul db Dn_Rt         ;一开始默认向右下运动
    x    dw 19
    y    dw 40
    char db 'A'