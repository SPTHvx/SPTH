InstructionSetSize=37 ; It is 32, but 32=2^N, thus very bad for LCG
		      ; 37 is the next bigger prime, thus=good ;)
AminoAcidList FIX @nopREAL,@nopsA,@nopsB,@nopsD,@nopdA,@nopdB,@nopdD,@save,@addsaved,@saveWrtOff,@saveJmpOff,@writeByte,@writeDWord,@getDO,@getdata,@getEIP,@push,@pop,@pushall,@popall,@add0001,@sub0001,@shl,@shr,@xor,@and,@mul,@div,@JnzUp,@JnzDown,@call,@CallAPILoadLibrary

_START EQU StartCodon
_STOP EQU StopCodon

MAX_NUMBER = 999'999'999'999'999'999



macro displayDecNum num* ; useful for debugging
{
    dN1=  num MOD 10
    dN2= ((num-dN1)/10) MOD 10
    dN3= ((num-dN1-dN2)/100) MOD 10
    dN4= ((num-dN1-dN2-dN3)/1'000) MOD 10
    dN5= ((num-dN1-dN2-dN3-dN4)/10'000) MOD 10
    dN6= ((num-dN1-dN2-dN3-dN4-dN5)/100'000) MOD 10
    dN7= ((num-dN1-dN2-dN3-dN4-dN5-dN6)/1'000'000) MOD 10
    dN8= ((num-dN1-dN2-dN3-dN4-dN5-dN6-dN7)/10'000'000) MOD 10
    dN9= ((num-dN1-dN2-dN3-dN4-dN5-dN6-dN7-dN8)/100'000'000) MOD 10
    dN10=((num-dN1-dN2-dN3-dN4-dN5-dN6-dN7-dN8-dN9)/1'000'000'000) MOD 10
    dN11=((num-dN1-dN2-dN3-dN4-dN5-dN6-dN7-dN8-dN9-dN10)/10'000'000'000) MOD 10
    dN12=((num-dN1-dN2-dN3-dN4-dN5-dN6-dN7-dN8-dN9-dN10-dN11)/100'000'000'000) MOD 10
    dN13=((num-dN1-dN2-dN3-dN4-dN5-dN6-dN7-dN8-dN9-dN10-dN11-dN12)/1'000'000'000'000) MOD 10
    dN14=((num-dN1-dN2-dN3-dN4-dN5-dN6-dN7-dN8-dN9-dN10-dN11-dN12-dN13)/10'000'000'000'000) MOD 10
    dN15=((num-dN1-dN2-dN3-dN4-dN5-dN6-dN7-dN8-dN9-dN10-dN11-dN12-dN13-dN14)/100'000'000'000'000) MOD 10
    dN16=((num-dN1-dN2-dN3-dN4-dN5-dN6-dN7-dN8-dN9-dN10-dN11-dN12-dN13-dN14-dN15)/1'000'000'000'000'000) MOD 10
    dN17=((num-dN1-dN2-dN3-dN4-dN5-dN6-dN7-dN8-dN9-dN10-dN11-dN12-dN13-dN14-dN15-dN16)/10'000'000'000'000'000) MOD 10
    dN18=((num-dN1-dN2-dN3-dN4-dN5-dN6-dN7-dN8-dN9-dN10-dN11-dN12-dN13-dN14-dN15-dN16-dN17)/100'000'000'000'000'000) MOD 10
    display dN18+'0',dN17+'0',dN16+'0',dN15+'0',dN14+'0',dN13+'0',dN12+'0',dN11+'0',dN10+'0',dN9+'0',dN8+'0',dN7+'0',dN6+'0',dN5+'0',dN4+'0',dN3+'0',dN2+'0',dN1+'0',13,10
}

macro displayList list*
{
    display '0: '
    displayDecNum list#0
    display '1: '
    displayDecNum list#1
    display '2: '
    displayDecNum list#2
    display '3: '
    displayDecNum list#3
    display '4: '
    displayDecNum list#4
    display '5: '
    displayDecNum list#5
    display '6: '
    displayDecNum list#6
    display '7: '
    displayDecNum list#7
    display '8: '
    displayDecNum list#8
    display '9: '
    displayDecNum list#9

}


macro appendToList list*, codon*
{
    if list#0<(MAX_NUMBER/1'000)
	list#0=(list#0*1'000)+codon
    else if list#1<(MAX_NUMBER/1'000)
	list#1=(list#1*1'000)+codon
    else if list#2<(MAX_NUMBER/1'000)
	list#2=(list#2*1'000)+codon
    else if list#3<(MAX_NUMBER/1'000)
	list#3=(list#3*1'000)+codon
    else if list#4<(MAX_NUMBER/1'000)
	list#4=(list#4*1'000)+codon
    else if list#5<(MAX_NUMBER/1'000)
	list#5=(list#5*1'000)+codon
    else if list#6<(MAX_NUMBER/1'000)
	list#6=(list#6*1'000)+codon
    else if list#7<(MAX_NUMBER/1'000)
	list#7=(list#7*1'000)+codon
    else if list#8<(MAX_NUMBER/1'000)
	list#8=(list#8*1'000)+codon
    else if list#9<(MAX_NUMBER/1'000)
	list#9=(list#9*1'000)+codon
    else
	display "Too much codons added",13,10," for one amino acid"
	err
	; 10*6+1=61 codons map to one amino acid...
    end if
}


getListSizeRV = 0
macro getListSize list*
{
    multiplicator=0
    number=list#0
    if list#9>0
	multiplicator=9
	number=list#9
    else if list#8>0
	multiplicator=8
	number=list#8
    else if list#7>0
	multiplicator=7
	number=list#7
    else if list#6>0
	multiplicator=6
	number=list#6
    else if list#5>0
	multiplicator=5
	number=list#5
    else if list#4>0
	multiplicator=4
	number=list#4
    else if list#3>0
	multiplicator=3
	number=list#3
    else if list#2>0
	multiplicator=2
	number=list#2
    else if list#1>0
	multiplicator=1
	number=list#1
    end if

    addend = 0
    while number>0
	addend=addend+1
	number=number/1000
    end while

    getListSizeRV=(multiplicator*6+addend)
}


getItemRV=0
IsJnzDown=0
macro getItem list*, index*
{
; gives elements in a special order: starting from list#0[5]...list#0[0] -> list#1[5]...list#2[0]
; could be changed, but no need for that as it will be only called by getRandomItem.

    getListSize list

    number=0
    if index<getListSizeRV
	if (index/(9*6))>0
	    number=list#9
	else if (index/(8*6))>0
	    number=list#8
	else if (index/(7*6))>0
	    number=list#7
	else if (index/(6*6))>0
	    number=list#6
	else if (index/(5*6))>0
	    number=list#5
	else if (index/(4*6))>0
	    number=list#4
	else if (index/(3*6))>0
	    number=list#3
	else if (index/(2*6))>0
	    number=list#2
	else if (index/(1*6))>0
	    number=list#1
	else
	    number=list#0
	end if

	newindex=index MOD 6

	while newindex>0
	    number=number/1000
	    newindex=newindex-1
	end while

	getItemRV=number MOD 1000

    else
	display 'Tried to access an element',13,10,'that doesnt exist'
	err
    end if

    list#42=list#42+1
}


macro getRandomItem list*
{
    getListSize list
    GetNewRandomNumber
    RndElement = (RndNum SHR 16) MOD getListSizeRV

    getItem list, RndElement

    db getItemRV

;    displayDecNum getItemRV

}


macro CreateEmptyList list*
{
    list#0 = 0
    list#1 = 0
    list#2 = 0
    list#3 = 0
    list#4 = 0
    list#5 = 0
    list#6 = 0
    list#7 = 0
    list#8 = 0
    list#9 = 0

    list#42 = 0     ; How often a codon called an amino acid

    list#666 = 0    ; How much different codons map one amino acid
}

macro CalculateListSizeOfAminoAcids [AminoAcid]
{
    getListSize AminoAcid#.list
    AminoAcid#.list666=getListSizeRV
    display `AminoAcid,': '
    displayDecNum AminoAcid#.list666
}


macro displayAminoAcidDistribution [AminoAcid]
{
    display `AminoAcid,': '
    displayDecNum AminoAcid#.list42
}


;macro CreateAnIntron
;{
;    GetNewRandomNumber
;    if ((RndNum SHR 16) MOD IntronInsertThreshold)=0

;        WhichIntron=((RndNum SHR 16) MOD 3)
;        if WhichIntron=0
;            db StopCodon
;        end if

;        GetNewRandomNumber

;        while ((RndNum SHR 16) MOD 37)<>0
;            GetNewRandomNumber
;            RRR=((RndNum SHR 16) MOD 255)
;            if WhichIntron=0
;                db (RRR XOR 0x67)
;            else
;                db (RRR OR 0x91)
;            end if
;        end while

;        if WhichIntron=0
;            db StartCodon
;        end if
;    end if
;}


macro CreatePaddedInstruction instr*, op1, op2
{
    virtual at 0
	if op2 eq
	    if op1 eq
		instr
	    else
		instr op1
	    end if
	else
	    instr op1,op2
	end if
	InstrSize = $
    end virtual

    GetNewRandomNumber
    NOPsBefore=(RndNum MOD (8-InstrSize+1))


    times NOPsBefore: nop

    if op2 eq
	if op1 eq
	    instr
	else
	    instr op1
	end if
    else
	instr op1,op2
    end if

    times (8-InstrSize-NOPsBefore): nop
}


; @command.list ... list that contains all codons that point to the amino acid
; @command ... macro that returns the amino acid and creates the @command.list
; _command ... how one actually calls the command (will return a random codon from @command)

CreateEmptyList @nopREAL.list
macro @nopREAL codon*
{
    CreatePaddedInstruction nop
    appendToList @nopREAL.list, codon
}
macro _nopREAL { getRandomItem @nopREAL.list }

; - - -


CreateEmptyList  @nopsA.list
macro @nopsA codon*
{
    CreatePaddedInstruction mov, ebx, eax
    appendToList @nopsA.list, codon
}
macro _nopsA { getRandomItem @nopsA.list }

; - - -

CreateEmptyList @nopsB.list
macro @nopsB codon*
{
    CreatePaddedInstruction mov, ebx, ebp
    appendToList @nopsB.list, codon
}
macro _nopsB { getRandomItem @nopsB.list }

; - - -

CreateEmptyList @nopsD.list
macro @nopsD codon*
{
    CreatePaddedInstruction mov, ebx, edx
    appendToList @nopsD.list, codon
}
macro _nopsD { getRandomItem @nopsD.list }

; - - -

CreateEmptyList @nopdA.list
macro @nopdA codon*
{
    CreatePaddedInstruction mov, eax, ebx
    appendToList @nopdA.list, codon
}
macro _nopdA { getRandomItem @nopdA.list }

; - - -

CreateEmptyList @nopdB.list
macro @nopdB codon*
{
    CreatePaddedInstruction mov, ebp, ebx
    appendToList @nopdB.list, codon
}
macro _nopdB { getRandomItem @nopdB.list }

; - - -

CreateEmptyList @nopdD.list
macro @nopdD codon*
{
    CreatePaddedInstruction mov, edx, ebx
    appendToList @nopdD.list, codon
}
macro _nopdD { getRandomItem @nopdD.list }

; - - -

CreateEmptyList @saveWrtOff.list
macro @saveWrtOff codon*
{
    CreatePaddedInstruction mov, edi, ebx
    appendToList @saveWrtOff.list, codon
}
macro _saveWrtOff { getRandomItem @saveWrtOff.list }

; - - -

CreateEmptyList @saveJmpOff.list
macro @saveJmpOff codon*
{
    CreatePaddedInstruction mov, esi, ebx
    appendToList @saveJmpOff.list, codon
}
macro _saveJmpOff { getRandomItem @saveJmpOff.list }

; - - -

CreateEmptyList @writeByte.list
macro @writeByte codon*
{
    CreatePaddedInstruction mov, byte[edi], bl
    appendToList @writeByte.list, codon
}
macro _writeByte { getRandomItem @writeByte.list }

; - - -

CreateEmptyList @writeDWord.list
macro @writeDWord codon*
{
    CreatePaddedInstruction mov, dword[edi], ebx
    appendToList @writeDWord.list, codon
}
macro _writeDWord { getRandomItem @writeDWord.list }

; - - -

CreateEmptyList @save.list
macro @save codon*
{
    CreatePaddedInstruction mov, ecx, ebx
    appendToList @save.list, codon
}
macro _save { getRandomItem @save.list }

; - - -

CreateEmptyList @addsaved.list
macro @addsaved codon*
{
    CreatePaddedInstruction add, ebx, ecx
    appendToList @addsaved.list, codon
}
macro _addsaved { getRandomItem @addsaved.list }

; - - -

CreateEmptyList @getDO.list
macro @getDO codon*
{
    CreatePaddedInstruction mov, ebx, DataOffset
    appendToList @getDO.list, codon
}
macro _getDO { getRandomItem @getDO.list }

; - - -

CreateEmptyList @getdata.list
macro @getdata codon*
{
    CreatePaddedInstruction mov, ebx, dword[ebx]
    appendToList @getdata.list, codon
}
macro _getdata { getRandomItem @getdata.list }

; - - -

CreateEmptyList @getEIP.list
macro @getEIP codon*
{
    InstrSize=6
    db 0xE8,0x00,0x00,0x00,0x00,0x5B
    times (8-InstrSize): nop	      ; padding
    appendToList @getEIP.list, codon
}
macro _getEIP { getRandomItem @getEIP.list }

; - - -

CreateEmptyList @push.list
macro @push codon*
{
    CreatePaddedInstruction push, ebx
    appendToList @push.list, codon
}
macro _push { getRandomItem @push.list }

; - - -

CreateEmptyList @pop.list
macro @pop codon*
{
    CreatePaddedInstruction pop, ebx
    appendToList @pop.list, codon
}
macro _pop { getRandomItem @pop.list }

; - - -

CreateEmptyList @pushall.list
macro @pushall codon*
{
    CreatePaddedInstruction pushad
    appendToList @pushall.list, codon
}
macro _pushall { getRandomItem @pushall.list }

; - - -

CreateEmptyList @popall.list
macro @popall codon*
{
    CreatePaddedInstruction popad
    appendToList @popall.list, codon
}
macro _popall { getRandomItem @popall.list }

; - - -


CreateEmptyList @mul.list
macro @mul codon*
{
    CreatePaddedInstruction mul, ebx
    appendToList @mul.list, codon
}
macro _mul {getRandomItem @mul.list}

; - - -

CreateEmptyList @div.list
macro @div codon*
{
    CreatePaddedInstruction div, ebx
    appendToList @div.list, codon
}
macro _div { getRandomItem @div.list }

; - - -

CreateEmptyList @shl.list
macro @shl codon*
{
    CreatePaddedInstruction shl, ebx, cl
    appendToList @shl.list, codon
}
macro _shl { getRandomItem @shl.list }

; - - -

CreateEmptyList @shr.list
macro @shr codon*
{
    CreatePaddedInstruction shr, ebx, cl
    appendToList @shr.list, codon
}
macro _shr { getRandomItem @shr.list }

; - - -

CreateEmptyList @and.list
macro @and codon*
{
    CreatePaddedInstruction and, ebx, ecx
    appendToList @and.list, codon
}
macro _and { getRandomItem @and.list }

; - - -

CreateEmptyList @xor.list
macro @xor codon*
{
    CreatePaddedInstruction xor, ebx, ecx
    appendToList @xor.list, codon
}
macro _xor { getRandomItem @xor.list }

; - - -

CreateEmptyList @add0001.list
macro @add0001 codon*
{
    CreatePaddedInstruction add, ebx, 0x0001
    appendToList @add0001.list, codon
}
macro _add0001 { getRandomItem @add0001.list }


; - - -

CreateEmptyList @sub0001.list
macro @sub0001 codon*
{
    CreatePaddedInstruction sub, ebx, 1
    appendToList @sub0001.list, codon
}
macro _sub0001 { getRandomItem @sub0001.list }

; - - -

CreateEmptyList @JnzUp.list
macro @JnzUp codon*
{
    InstrSize = 4
    db 0x74,0x02,0xFF,0xE6
    times (8-InstrSize): nop

    appendToList @JnzUp.list, codon
}
macro _JnzUp { getRandomItem @JnzUp.list }

; - - -

CreateEmptyList @JnzDown.list
macro @JnzDown codon*
{
    local StartCommand, EndCommand
    InstrSize=2
    db 0x75, 0x26
    times (8-InstrSize): nop

    appendToList @JnzDown.list, codon
}
macro _JnzDown { getRandomItem @JnzDown.list }

; - - -

CreateEmptyList @call.list
macro @call codon*
{
    CreatePaddedInstruction stdcall, ebx
    appendToList @call.list, codon
}
macro _call { getRandomItem @call.list }

; - - -

CreateEmptyList @CallAPILoadLibrary.list
macro @CallAPILoadLibrary codon*
{
    CreatePaddedInstruction stdcall, [LoadLibrary]
    appendToList @CallAPILoadLibrary.list, codon
}
macro _CallAPILoadLibrary { getRandomItem @CallAPILoadLibrary.list }

; - - -

CreateEmptyList @CallAPIMessageBox.list
macro @CallAPIMessageBox codon*
{
    CreatePaddedInstruction stdcall, [MessageBox]
    appendToList @CallAPIMessageBox.list, codon
}
macro _CallAPIMessageBox { getRandomItem @CallAPIMessageBox.list }

; - - -

CreateEmptyList @CallAPIExitProcess.list
macro @CallAPIExitProcess codon*
{
    CreatePaddedInstruction stdcall, [ExitProcess]
    appendToList @CallAPIExitProcess.list, codon
}

macro _CallAPIExitProcess { getRandomItem @CallAPIExitProcess.list }

; - - -

CreateEmptyList @int3.list
macro @int3 codon*
{
    ;CreatePaddedInstruction int3
    int 3
    times 6: nop
    appendToList @int3.list, codon
}
macro _int3 { getRandomItem @int3.list }

; - - -


macro CountListEntries [AminoAcid]
{
    display `AminoAcid,': '
    getListSize AminoAcid#.list
    displayDecNum getListSizeRV
}


macro CheckIfAllAminoAcidsAreCreated [AminoAcid]
{
    getListSize AminoAcid#.list
    if getListSizeRV=0
	display "At least one Amino Acid",13,10,"has no codon for mapping.",13,10,"Try to compile again!"
	err
    end if
}



macro CreateRandomAlphabet
{
    repeat 256
	cc = % - 1				     ; Starts at 1, but should start at 0
	if (cc AND 0x91)=0x91
	    @nopREAL cc   ; Splicing
	    display '@nopREAL: '
	    displayDecNum cc
	else if cc=StartCodon
	    CreatePaddedInstruction xchg, ebx, ebx   ; some No-Operation, such that its different to nopREAL and will not be target of polymorphism
	    display 'StartCodon: '
	    displayDecNum cc
	else if cc=StopCodon
	    CreatePaddedInstruction xchg, ecx, ecx   ; some No-Operation, such that its different to nopREAL and will not be target of polymorphism
	    display 'StopCodon: '
	    displayDecNum cc
	else
	    GetNewRandomNumber
	    RR = (RndNum MOD (InstructionSetSize*2)) ; (InstructionSetSize*2) because the LCG doesnt create perfect random numbers
						     ; It does not create 2^n as often as primes or (2^n +/- 1), so by taking two numbers,
						     ; a 2^n will be paired with (2^n +/- 1), thus the probability that a amino acid will
						     ; not be taken at all decreases alot. (=rare err-message at CheckIfAllAminoAcidsAreCreated)
	    if RR<2
		@nopREAL cc
		display '@nopREAL: '
		displayDecNum cc
	    else if RR<4
		@nopsA cc
		display '@nopsA: '
		displayDecNum cc
	    else if RR<6
		@nopsB cc
		display '@nopsB: '
		displayDecNum cc
	    else if RR<8
		@nopsD cc
		display '@nopsD: '
		displayDecNum cc
	    else if RR<10
		@nopdA cc
		display '@nopdA: '
		displayDecNum cc
	    else if RR<12
		@nopdB cc
		display '@nopdB: '
		displayDecNum cc
	    else if RR<14
		@nopdD cc
		display '@nopdD: '
		displayDecNum cc
	    else if RR<16
		@saveWrtOff cc
		display '@saveWrtOff: '
		displayDecNum cc
	    else if RR<18
		@saveJmpOff cc
		display '@saveJmpOff: '
		displayDecNum cc
	    else if RR<20
		@writeByte cc
		display '@writeByte: '
		displayDecNum cc
	    else if RR<22
		@writeDWord cc
		display '@writeDWord: '
		displayDecNum cc
	    else if RR<24
		@save cc
		display '@save: '
		displayDecNum cc
	    else if RR<26
		@addsaved cc
		display '@addsaved: '
		displayDecNum cc
	    else if RR<28
		@getDO cc
		display '@getDO: '
		displayDecNum cc
	    else if RR<30
		@getdata cc
		display '@getdata: '
		displayDecNum cc
	    else if RR<32
		@getEIP cc
		display '@getEIP: '
		displayDecNum cc
	    else if RR<34
		@push cc
		display '@push: '
		displayDecNum cc
	    else if RR<36
		@pop cc
		display '@pop: '
		displayDecNum cc
	    else if RR<38
		@pushall cc
		display '@pushall: '
		displayDecNum cc
	    else if RR<40
		@popall cc
		display '@popall: '
		displayDecNum cc
	    else if RR<42
		@mul cc
		display '@mul: '
		displayDecNum cc
	    else if RR<44
		@div cc
		display '@div: '
		displayDecNum cc
	    else if RR<46
		@shl cc
		display '@shl: '
		displayDecNum cc
	    else if RR<48
		@shr cc
		display '@shr: '
		displayDecNum cc
	    else if RR<50
		@and cc
		display '@and: '
		displayDecNum cc
	    else if RR<52
		@xor cc
		display '@xor: '
		displayDecNum cc
	    else if RR<54
		@add0001 cc
		display '@add0001: '
		displayDecNum cc
	    else if RR<56
		@sub0001 cc
		display '@sub0001: '
		displayDecNum cc
	    else if RR<58
		@JnzUp cc
		display '@JnzUp: '
		displayDecNum cc
	    else if RR<60
		@JnzDown cc
		display '@JnzDown: '
		displayDecNum cc
	    else if RR<62
		@call cc
		display '@call: '
		displayDecNum cc
	    else if RR<64
		@CallAPILoadLibrary cc
		display '@CallAPILoadLibrary: '
		displayDecNum cc
	    else
		@int3 cc
		display '@shl: '
		displayDecNum cc
	    end if
	end if
    end repeat
    display 13,10,'---',13,10
    CountListEntries AminoAcidList
    CheckIfAllAminoAcidsAreCreated AminoAcidList
}





macro CreateBalancedAlphabet
{
	     @nopdD 0

	     @nopdD 1

	     @nopdD 2

	     @nopdD 3

	     @addsaved 4

	     @and 5

	     @addsaved 6

	     @and 7

	     @popall 8

	     @pushall 9

	     @getdata 10

	     @pushall 11

	     @call 12

	     @add0001 13

	     @getdata 14

	     @nopdA 15

	     @push 16

	     @writeDWord 17

	     @push 18

	     @writeDWord 19

	     @push 20

	     @and 21

	     @push 22

	     @and 23

	     @getdata 24

	     @add0001 25

	     @getdata 26

	     @sub0001 27

	     @getdata 28

	     @add0001 29

	     @getdata 30

	     @and 31

	     @mul 32

	     @nopdD 33

	     @mul 34

	     @nopdD 35

	     @addsaved 36

	     @getEIP 37

	     @addsaved 38

	     @getEIP 39

	     @pop 40

	     @nopsA 41

	     @pop 42

	     @nopsA 43

	     @pop 44

	     @add0001 45

	     @JnzUp 46

	     @nopdA 47

	     @push 48

	     @writeDWord 49

	     @push 50

	     @writeDWord 51

	     @push 52

	     @saveJmpOff 53

	     @push 54

	     @saveJmpOff 55

	     @pop 56

	     @add0001 57

	     @pop 58

	     @sub0001 59

	     @pop 60

	     @add0001 61

	     @pop 62

	     @nopdA 63

	     @popall 64

	     @writeDWord 65

	     @CallAPILoadLibrary 66

	     @writeDWord 67

	     @popall 68

	     @and 69

	     @addsaved 70

	     @and 71

	     @popall 72

	     @pushall 73

	     @getdata 74

	     @pushall 75

	     @popall 76

	     @add0001 77

	     @getdata 78

	     @nopdA 79

	     @popall 80

	     @writeDWord 81

	     @push 82

	     @writeDWord 83

	     @popall 84

	     @and 85

	     @save 86

	     @and 87

	     @popall 88

	     @add0001 89

	     @getdata 90

	     @sub0001 91

	     @popall 92

	     @add0001 93

	     @getdata 94

	     @and 95

	     @saveWrtOff 96

	     @writeDWord 97

	     @saveWrtOff 98

	     @writeDWord 99

	     @saveWrtOff 100

	     @getEIP 101

	     @saveWrtOff 102

	     @nopdA 103

	     @saveWrtOff 104

	     @nopsA 105

	     @saveWrtOff 106

	     @nopsA 107

	     @saveWrtOff 108

	     @add0001 109

	     @saveWrtOff 110

	     @nopdA 111

	     @saveWrtOff 112

	     @writeDWord 113

	     @push 114

	     @writeDWord 115

	     @saveWrtOff 116

	     @saveJmpOff 117

	     @writeByte 118

	     @nopdA 119

	     @saveWrtOff 120

	     @add0001 121

	     @JnzDown 122

	     @sub0001 123

	     @saveWrtOff 124

	     @add0001 125

	     @writeByte 126

	     @nopdA 127

	     @getDO 128

	     @getDO 129

	     @getDO 130

	     @getDO 131

	     @addsaved 132

	     @shl 133

	     @addsaved 134

	     @shl 135

	     @shr 136

	     @nopREAL 137

	     @nopsB 138

	     @nopsA 139

	     @shr 140

	     @add0001 141

	     @nopdB 142

	     @nopdB 143

	     ; 144 = 0x90 = real NOP! :)
	     @nopREAL 144

	     ; SPLICING! must be NOP!!!
	     @nopREAL 145

	     @nopsB 146

	     ; SPLICING! must be NOP!!!
	     @nopREAL 147

	     @save 148

	     ; SPLICING! must be NOP!!!
	     @nopREAL 149

	     @save 150

	     ; SPLICING! must be NOP!!!
	     @nopREAL 151


_START EQU 152
ACommand152:
		     ; THIS IS THE START CODON!!!
		     ; THE bit-sequence is different to other no-operations,
		     ; such that it wont be targeted from the poly-engine
		 xchg ebx, ebx
ECommand152:
times (8-ECommand152+ACommand152): nop


	     ; SPLICING! must be NOP!!!
	     @nopREAL 153

	     @nopsB 154

	     ; SPLICING! must be NOP!!!
	     @nopREAL 155

	     @save 156

	     ; SPLICING! must be NOP!!!
	     @nopREAL 157

	     @save 158

	     ; SPLICING! must be NOP!!!
	     @nopREAL 159

	     @getDO 160

	     @getDO 161

	     @getDO 162

	     @getDO 163

	     @shl 164

	     @shl 165

	     @shl 166

	     @shl 167

	     @xor 168

	     @nopREAL 169

	     @nopsD 170

	     @nopsA 171

	     @shl 172

	     @add0001 173

	     @nopsD 174

	     @nopdB 175


_STOP EQU 176
ACommand176:
		     ; THIS IS THE STOP CODON!!!
		     ; THE bit-sequence is different to other no-operations,
		     ; such that it wont be targeted from the poly-engine
		 xchg ecx, ecx
ECommand176:
times (8-ECommand176+ACommand176): nop


	     ; SPLICING! must be NOP!!!
	     @nopREAL 177

	     @div 178

	     ; SPLICING! must be NOP!!!
	     @nopREAL 179

	     @save 180

	     ; SPLICING! must be NOP!!!
	     @nopREAL 181

	     @save 182

	     ; SPLICING! must be NOP!!!
	     @nopREAL 183

	     @xor 184

	     ; SPLICING! must be NOP!!!
	     @nopREAL 185

	     @nopsD 186

	     ; SPLICING! must be NOP!!!
	     @nopREAL 187

	     @save 188

	     ; SPLICING! must be NOP!!!
	     @nopREAL 189

	     @save 190

	     ; SPLICING! must be NOP!!!
	     @nopREAL 191

	     @getDO 192

	     @add0001 193

	     @getDO 194

	     @getDO 195

	     @addsaved 196

	     @shl 197

	     @addsaved 198

	     @shl 199

	     @shr 200

	     @nopREAL 201

	     @nopsB 202

	     @nopsA 203

	     @addsaved 204

	     @add0001 205

	     @nopdB 206

	     @nopdB 207

	     @sub0001 208

	     ; SPLICING! must be NOP!!!
	     @nopREAL 209

	     @nopsB 210

	     ; SPLICING! must be NOP!!!
	     @nopREAL 211

	     @save 212

	     ; SPLICING! must be NOP!!!
	     @nopREAL 213

	     @save 214

	     ; SPLICING! must be NOP!!!
	     @nopREAL 215

	     @sub0001 216

	     ; SPLICING! must be NOP!!!
	     @nopREAL 217

	     @nopsB 218

	     ; SPLICING! must be NOP!!!
	     @nopREAL 219

	     @save 220

	     ; SPLICING! must be NOP!!!
	     @nopREAL 221

	     @save 222

	     ; SPLICING! must be NOP!!!
	     @nopREAL 223

	     @getDO 224

	     @getDO 225

	     @getDO 226

	     @getDO 227

	     @shl 228

	     @shl 229

	     @shl 230

	     @shl 231

	     @xor 232

	     @nopREAL 233

	     @nopsD 234

	     @nopsA 235

	     @shl 236

	     @add0001 237

	     @nopsD 238

	     @nopdB 239

	     @xor 240

	     ; SPLICING! must be NOP!!!
	     @nopREAL 241

	     @div 242

	     ; SPLICING! must be NOP!!!
	     @nopREAL 243

	     @save 244

	     ; SPLICING! must be NOP!!!
	     @nopREAL 245

	     @save 246

	     ; SPLICING! must be NOP!!!
	     @nopREAL 247

	     @xor 248

	     ; SPLICING! must be NOP!!!
	     @nopREAL 249

	     @nopsD 250

	     ; SPLICING! must be NOP!!!
	     @nopREAL 251

	     @save 252

	     ; SPLICING! must be NOP!!!
	     @nopREAL 253

	     @save 254

	     ; SPLICING! must be NOP!!!
	     @nopREAL 255



;1380: Energy!: 1055.83


}


macro CreateAlphabet
{
    CreateBalancedAlphabet
;    CreateRandomAlphabet
}