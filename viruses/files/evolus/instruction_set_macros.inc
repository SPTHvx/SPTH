macro addnumber BigNum*
{
;    CreateAnIntron
    AlreadyStarted=0
    if BigNum<25
	repeat BigNum
	    _add0001
	end repeat
    else
	_pushall
	_push  ; BC1 to stack
	_save
;        CreateAnIntron
	_xor   ; BC1=0
	_add0001
	_save
	_sub0001 ; BC1=0, BC2=1
;        CreateAnIntron
	irp num, 0x8000'0000,0x4000'0000,0x2000'0000,0x1000'0000,0x800'0000,0x400'0000,0x200'0000,0x100'0000,0x80'0000,0x40'0000,0x20'0000,0x10'0000,0x8'0000,0x4'0000,0x2'0000,0x1'0000,0x8000,0x4000,0x2000,0x1000,0x800,0x400,0x200,0x100,0x80,0x40,0x20,0x10,0x8,0x4,0x2,0x1
	\{
	    if AlreadyStarted=1
		_shl
	    end if
	    if (BigNum AND num)>0
		_add0001
		AlreadyStarted=1
	    end if
	\} ; BC1=BigNum
;        CreateAnIntron
	_save		; BC2=BigNum
	_pop		; restore BC1
	_addsaved	; BC1=BC1+BigNum
	_nopdC		; Save in RegC
	_popall 	; Restore all registers
	_nopsC		; BC1=BC1+BigNum
;        CreateAnIntron
	_pushall	; Restore ZF
	_save
	_and
	_popall
    end if
;    CreateAnIntron

}


macro GetAddress address
{
    _getDO
;    CreateAnIntron
    addnumber (address-DataOffset)
}



macro CallAPI APIName
{
;    CreateAnIntron
    _getDO
    addnumber (APIName-DataOffset)
    _getdata
    _call
;    CreateAnIntron
}



macro CalcNewRandNumberAndSaveIt
{
	GetAddress RandomNumber
;        CreateAnIntron
	_saveWrtOff
	_getdata
	_nopdA			 ; eax=[RandomNumber]

	_zer0 0
	addnumber 1103515245
;        CreateAnIntron
	_mul			 ; eax*=1103515245 % 2^32

	_zer0 0
	addnumber 12345
	_save
;        CreateAnIntron
	_nopsA
	_addsaved		 ; eax+=12345 % 2^32

	_writeDWord		 ; mov [RandomNumber], ebx
}


macro _nopdC
{
	_pushall		; save all registers
	_push			; save BC1
;        CreateAnIntron
	_getDO			; For code-optimization, RegC is at DataOffset+0x0. But could be anywhere as _add0001 exists.
;        CreateAnIntron
	_saveWrtOff		; BA1=RegC
	_pop
	_writeDWord		; mov dword[RegC], BC1
	_popall 		; restore all registers
}


macro _nopsC
{
	_getDO			; For code-optimization, RegC is at DataOffset+0x0. But could be anywhere as _add0001 exists.
	_getdata
;        CreateAnIntron
	display '.'
}


macro _zer0 SaveBC2*
{
; Simulate _zer0 instruction.
; The argument tells wheter BC2 should be restored or not.

    if SaveBC2<>0
	_pushall
;        CreateAnIntron
    end if

;        CreateAnIntron
	_save		; BC2=BC1
	_xor		; BC1=BC1 XOR BC2 = 0


    if SaveBC2<>0
	_nopdC
	_popall
	_nopsC
    end if
}


macro _subsaved SaveBC2*
{
; Simulate _subsaved instruction.
; The argument tells wheter BC2 should be restored or not.

    if SaveBC2<>0
	_pushall
;        CreateAnIntron
    end if

;         CreateAnIntron
	_push		; save BC1
	_zer0 1 	; BC1=0
	_sub0001	; BC1=0xFFFF'FFFF
;        CreateAnIntron
	_xor		; BC1=0xFFFF'FFFF XOR BC2
	_add0001	; BC1=-BC2
	_save		; BC2=-BC2
	_pop		; restore BC1
	_addsaved	; BC1=BC1+(-BC2)
;        CreateAnIntron

    if SaveBC2<>0
	_nopdC
	_popall
	_nopsC
;        CreateAnIntron
	_pushall	; Restore ZF
	_save
	_and
	_popall
    end if

}