;Fan Speed Sensing and Control
.model tiny
.486
.data

;8255 data
	creg	equ	06h
	
;Keyboard data
	table_d	db	06h, 5bh, 4fh, 66h, 6dh, 7dh, 27h, 7fh, 6fh, 37h, 7ch, 39h
	table_k	db	0eeh, 0edh, 0ebh, 0deh, 0ddh, 0dbh, 0beh, 0bdh, 0bbh, 7eh, 7dh, 7bh

.code
.startup

;Programming 8255
init8255_:
	mov al, 83h
	out creg, al
	
;THIS KEYBOARD IS A NORMAL 4X3 KEYBOARD. WE STILL NEED TO CHANGE A LOT OF THINGS ABOUT IT.
kr_0:					;Checking for key release
	mov al, 00h
	out 04h, al
kr_1:
	in	al, 04h
	and al, 0f0h
	cmp al, 0e0h
	jnz kr_1			;Checking for debounce
	call delay_20ms
	
	mov al, 00h
	out 04h, al
kr_2:					;Checking for key press
	in 	al, 04h
	and	al, 0f0h
	cmp al, 0f0h
	jz	kr_2
	call delay_20ms

	mov al, 00h
	out 04h, al
	in 	al, 04h
	and	al, 0f0h
	cmp al, 0f0h
	jz	kr_2
							
	mov al, 0eh			;Checking for key press in column 1
	mov bl, al
	out 04h, al
	in	al, 04h
	and	al, 0f0h
	cmp al, 0f0h
	jnz column_activate_
	
	mov al, 0dh			;Checking for key press in column 2
	mov bl, al
	out 04h, al
	in	al, 04h
	and	al, 0f0h
	cmp	al, 0f0h
	jnz	column_activate_
	
	mov al, 0bh			;Checking for key press in column 3
	mov bl, al
	out 04h, al
	in 	al, 04h
	and al, 0f0h
	cmp al, 0f0h
	jnz cloumn_activate_
	
column_activate_:		;When some column is activated
	or	al, bl
	mov cx, 12			;Because there are 12 keys
	mov di, 00h
	
	compare_:	cmp al, table_k[di]
				jnz final_kb_
				inc di
				loop compare_

final_kb_:
	mov ax, di
;	lea bx, table 		Whatever the fuck this does.
	xlat
	out 00h, al
	jmp kr_0			;Need to add something different here too.
	
;Programming 8254s
init8254_1:
	
;Subroutines ->
;Subroutine for delay of 20ms
delay_20ms	proc near
			mov cx, 20
		x1: nop
			dec cx
			jnz x1
			ret
delay_20ms	endp
.exit
end