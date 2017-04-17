;Fan Speed Sensing and Control
.model tiny
.486
.data

;8255 data
	creg	equ	06h

.code
.startup

;Programming 8255
init8255_:
	mov al, 83h
	out creg, al

kr_10:
	mov al, 00h
	out 04h, al
kr_11:
	in	al, 04h
	and al, 0f0h
	cmp al, 0e0h
	jnz kr_11
	call delay_20ms
	
	mov al, 00h
;Programming 8254s
init8254_1:
	

.exit
end