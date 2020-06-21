org 1000h

_start:
	int	22h	
	mov	ah, 1
	int 	21h
	mov	ah, 2
	int	21h
	mov	ah, 3
	mov	bx, 1
	int	21h
	mov	ax, 0B800h
	mov	gs, ax
	mov	bh, 0Fh
	mov	[gs:((80*21)*2)], bx
	int	20h

