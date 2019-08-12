; 0000 0000 - 0:
_CallAPISleep EQU 0
ACommand0:
       stdcall [Sleep]
ECommand0:
times (8-ECommand0+ACommand0): nop



; 0000 0001 - 1:
CCommand1 EQU 1
ACommand1:
	db _CallAPISleep
ECommand1:
times (8-ECommand1+ACommand1): nop



; 0000 0010 - 2:
CCommand2 EQU 2
ACommand2:
	db _CallAPISleep
ECommand2:
times (8-ECommand2+ACommand2): nop



; 0000 0011 - 3:
CCommand3 EQU 3
ACommand3:
	popad
ECommand3:
times (8-ECommand3+ACommand3): nop



; 0000 0100 - 4:
CCommand4 EQU 4
ACommand4:
	db _CallAPISleep
ECommand4:
times (8-ECommand4+ACommand4): nop



; 0000 0101 - 5:
CCommand5 EQU 5
ACommand5:
	db _CallAPISleep
ECommand5:
times (8-ECommand5+ACommand5): nop



; 0000 0110 - 6:
CCommand6 EQU 6
ACommand6:
	mov eax, ebx
ECommand6:
times (8-ECommand6+ACommand6): nop



; 0000 0111 - 7:
CCommand7 EQU 7
ACommand7:
	stdcall dword[ebx]
ECommand7:
times (8-ECommand7+ACommand7): nop



; 0000 1000 - 8:
CCommand8 EQU 8
ACommand8:
	db _CallAPISleep
ECommand8:
times (8-ECommand8+ACommand8): nop



; 0000 1001 - 9:
CCommand9 EQU 9
ACommand9:
	nop	; nopREAL
ECommand9:
times (8-ECommand9+ACommand9): nop



; 0000 1010 - 10:
CCommand10 EQU 10
ACommand10:
	mov ebx, edx
ECommand10:
times (8-ECommand10+ACommand10): nop



; 0000 1011 - 11:
CCommand11 EQU 11
ACommand11:
	nop
ECommand11:
times (8-ECommand11+ACommand11): nop



; 0000 1100 - 12:
CCommand12 EQU 12
ACommand12:
	nop
ECommand12:
times (8-ECommand12+ACommand12): nop



; 0000 1101 - 13:
CCommand13 EQU 13
ACommand13:
	nop
ECommand13:
times (8-ECommand13+ACommand13): nop



; 0000 1110 - 14:
CCommand14 EQU 14
ACommand14:
	nop
ECommand14:
times (8-ECommand14+ACommand14): nop



; 0000 1111 - 15:
CCommand15 EQU 15
ACommand15:
	nop
ECommand15:
times (8-ECommand15+ACommand15): nop



; 0001 0000 - 16:
CCommand16 EQU 16
ACommand16:
	db _CallAPISleep
ECommand16:
times (8-ECommand16+ACommand16): nop



; 0001 0001 - 17:
CCommand17 EQU 17
ACommand17:
	popad
ECommand17:
times (8-ECommand17+ACommand17): nop



; 0001 0010 - 18:
CCommand18 EQU 18
ACommand18:
	popad
ECommand18:
times (8-ECommand18+ACommand18): nop



; 0001 0011 - 19:
_popall EQU 19
ACommand19:
	popad
ECommand19:
times (8-ECommand19+ACommand19): nop



; 0001 0100 - 20:
_pushall EQU 20
ACommand20:
	pushad
ECommand20:
times (8-ECommand20+ACommand20): nop



; 0001 0101 - 21:
CCommand21 EQU 21
ACommand21:
	pushad
ECommand21:
times (8-ECommand21+ACommand21): nop



; 0001 0110 - 22:
CCommand22 EQU 22
ACommand22:
	pushad
ECommand22:
times (8-ECommand22+ACommand22): nop



; 0001 0111 - 23:
CCommand23 EQU 23
ACommand23:
	popad
ECommand23:
times (8-ECommand23+ACommand23): nop



; 0001 1000 - 24:
CCommand24 EQU 24
ACommand24:
	nop
ECommand24:
times (8-ECommand24+ACommand24): nop



; 0001 1001 - 25:
CCommand25 EQU 25
ACommand25:
	nop
ECommand25:
times (8-ECommand25+ACommand25): nop



; 0001 1010 - 26:
CCommand26 EQU 26
ACommand26:
	nop
ECommand26:
times (8-ECommand26+ACommand26): nop



; 0001 1011 - 27:
CCommand27 EQU 27
ACommand27:
	stdcall [LoadLibrary]
ECommand27:
times (8-ECommand27+ACommand27): nop



; 0001 1100 - 28:
CCommand28 EQU 28
ACommand28:
	nop
ECommand28:
times (8-ECommand28+ACommand28): nop



; 0001 1101 - 29:
CCommand29 EQU 29
ACommand29:
	mov edx, ebx
ECommand29:
times (8-ECommand29+ACommand29): nop



; 0001 1110 - 30:
CCommand30 EQU 30
ACommand30:
	nop
ECommand30:
times (8-ECommand30+ACommand30): nop



; 0001 1111 - 31:
CCommand31 EQU 31
ACommand31:
	 mov ebp, ebx
ECommand31:
times (8-ECommand31+ACommand31): nop



; 0010 0000 - 32:
CCommand32 EQU 32
ACommand32:
	db _CallAPISleep
ECommand32:
times (8-ECommand32+ACommand32): nop



; 0010 0001 - 33:
CCommand33 EQU 33
ACommand33:
	push ebx
ECommand33:
times (8-ECommand33+ACommand33): nop



; 0010 0010 - 34:
CCommand34 EQU 34
ACommand34:
	db _CallAPISleep
ECommand34:
times (8-ECommand34+ACommand34): nop



; 0010 0011 - 35:
CCommand35 EQU 35
ACommand35:
	stdcall dword[ebx]
ECommand35:
times (8-ECommand35+ACommand35): nop



; 0010 0100 - 36:
CCommand36 EQU 36
ACommand36:
	db _CallAPISleep
ECommand36:
times (8-ECommand36+ACommand36): nop



; 0010 0101 - 37:
CCommand37 EQU 37
ACommand37:
	stdcall dword[ebx]
ECommand37:
times (8-ECommand37+ACommand37): nop



; 0010 0110 - 38:
CCommand38 EQU 38
ACommand38:
	stdcall dword[ebx]
ECommand38:
times (8-ECommand38+ACommand38): nop



; 0010 0111 - 39:
_call EQU 39
ACommand39:
	stdcall dword[ebx]
ECommand39:
times (8-ECommand39+ACommand39): nop



; 0010 1000 - 40:
CCommand40 EQU 40
ACommand40:
	nop
ECommand40:
times (8-ECommand40+ACommand40): nop



; 0010 1001 - 41:
CCommand41 EQU 41
ACommand41:
	nop
ECommand41:
times (8-ECommand41+ACommand41): nop



; 0010 1010 - 42:
CCommand42 EQU 42
ACommand42:
	stdcall [LoadLibrary]
ECommand42:
times (8-ECommand42+ACommand42): nop



; 0010 1011 - 43:
CCommand43 EQU 43
ACommand43:
	stdcall [LoadLibrary]
ECommand43:
times (8-ECommand43+ACommand43): nop



; 0010 1100 - 44:
CCommand44 EQU 44
ACommand44:
	mov edi, ebx
ECommand44:
times (8-ECommand44+ACommand44): nop



; 0010 1101 - 45:
CCommand45 EQU 45
ACommand45:
	mov edx, ebx
ECommand45:
times (8-ECommand45+ACommand45): nop



; 0010 1110 - 46:
CCommand46 EQU 46
ACommand46:
	mov ebx, dword[ebx]
ECommand46:
times (8-ECommand46+ACommand46): nop



; 0010 1111 - 47:
CCommand47 EQU 47
ACommand47:
	mov ebp, ebx
ECommand47:
times (8-ECommand47+ACommand47): nop



; 0011 0000 - 48:
CCommand48 EQU 48
ACommand48:
	nop
ECommand48:
times (8-ECommand48+ACommand48): nop



; 0011 0001 - 49:
CCommand49 EQU 49
ACommand49:
	nop
ECommand49:
times (8-ECommand49+ACommand49): nop



; 0011 0010 - 50:
CCommand50 EQU 50
ACommand50:
	nop
ECommand50:
times (8-ECommand50+ACommand50): nop



; 0011 0011 - 51:
CCommand51 EQU 51
ACommand51:
	nop
ECommand51:
times (8-ECommand51+ACommand51): nop



; 0011 0100 - 52:
CCommand52 EQU 52
ACommand52:
	pushad
ECommand52:
times (8-ECommand52+ACommand52): nop



; 0011 0101 - 53:
CCommand53 EQU 53
ACommand53:
	pushad
ECommand53:
times (8-ECommand53+ACommand53): nop



; 0011 0110 - 54:
CCommand54 EQU 54
ACommand54:
	pushad
ECommand54:
times (8-ECommand54+ACommand54): nop



; 0011 0111 - 55:
CCommand55 EQU 55
ACommand55:
	mov byte[edi], bl
ECommand55:
times (8-ECommand55+ACommand55): nop



; 0011 1000 - 56:
CCommand56 EQU 56
ACommand56:
	nop
ECommand56:
times (8-ECommand56+ACommand56): nop



; 0011 1001 - 57:
CCommand57 EQU 57
ACommand57:
	stdcall [LoadLibrary]
ECommand57:
times (8-ECommand57+ACommand57): nop



; 0011 1010 - 58:
CCommand58 EQU 58
ACommand58:
	stdcall [LoadLibrary]
ECommand58:
times (8-ECommand58+ACommand58): nop



; 0011 1011 - 59:
_CallAPILoadLibrary EQU 59
ACommand59:
	stdcall [LoadLibrary]
ECommand59:
times (8-ECommand59+ACommand59): nop



; 0011 1100 - 60:
CCommand60 EQU 60
ACommand60:
	mov edx, ebx
ECommand60:
times (8-ECommand60+ACommand60): nop



; 0011 1101 - 61:
_nopdD EQU 61
ACommand61:
	mov edx, ebx
ECommand61:
times (8-ECommand61+ACommand61): nop



; 0011 1110 - 62:
CCommand62 EQU 62
ACommand62:
	mov ebp, ebx
ECommand62:
times (8-ECommand62+ACommand62): nop



; 0011 1111 - 63:
_nopdB EQU 63
ACommand63:
	mov ebp, ebx
ECommand63:
times (8-ECommand63+ACommand63): nop



; 0100 0000 - 64:
CCommand64 EQU 64
ACommand64:
	db _CallAPISleep
ECommand64:
times (8-ECommand64+ACommand64): nop



; 0100 0001 - 65:
CCommand65 EQU 65
ACommand65:
	nop
ECommand65:
times (8-ECommand65+ACommand65): nop



; 0100 0010 - 66:
CCommand66 EQU 66
ACommand66:
	nop
ECommand66:
times (8-ECommand66+ACommand66): nop



; 0100 0011 - 67:
CCommand67 EQU 67
ACommand67:
	nop
ECommand67:
times (8-ECommand67+ACommand67): nop



; 0100 0100 - 68:
CCommand68 EQU 68
ACommand68:
	nop
ECommand68:
times (8-ECommand68+ACommand68): nop



; 0100 0101 - 69:
CCommand69 EQU 69
ACommand69:
	mov ebx, ebp
ECommand69:
times (8-ECommand69+ACommand69): nop



; 0100 0110 - 70:
_nopdA EQU 70
ACommand70:
	mov eax, ebx
ECommand70:
times (8-ECommand70+ACommand70): nop



; 0100 0111 - 71:
CCommand71 EQU 71
ACommand71:
	mov eax, ebx
ECommand71:
times (8-ECommand71+ACommand71): nop



; 0100 1000 - 72:
CCommand72 EQU 72
ACommand72:
	nop
ECommand72:
times (8-ECommand72+ACommand72): nop



; 0100 1001 - 73:
_nopREAL EQU 73
ACommand73:
	nop  ; nopREAL
ECommand73:
times (8-ECommand73+ACommand73): nop



; 0100 1010 - 74:
_nopsD EQU 74
ACommand74:
	mov ebx, edx
ECommand74:
times (8-ECommand74+ACommand74): nop



; 0100 1011 - 75:
CCommand75 EQU 75
ACommand75:
	mov ebx, edx
ECommand75:
times (8-ECommand75+ACommand75): nop



; 0100 1100 - 76:
_nopsB EQU 76
ACommand76:
	mov ebx, ebp
ECommand76:
times (8-ECommand76+ACommand76): nop



; 0100 1101 - 77:
CCommand77 EQU 77
ACommand77:
	mov ebx, ebp
ECommand77:
times (8-ECommand77+ACommand77): nop



; 0100 1110 - 78:
CCommand78 EQU 78
ACommand78:
	mov ebx, eax
ECommand78:
times (8-ECommand78+ACommand78): nop



; 0100 1111 - 79:
_nopsA EQU 79
ACommand79:
	mov ebx, eax
ECommand79:
times (8-ECommand79+ACommand79): nop



; 0101 0000 - 80:
CCommand80 EQU 80
ACommand80:
	nop
ECommand80:
times (8-ECommand80+ACommand80): nop



; 0101 0001 - 81:
CCommand81 EQU 81
ACommand81:
	jz over5
	jmp esi
	over5:
ECommand81:
times (8-ECommand81+ACommand81): nop



; 0101 0010 - 82:
CCommand82 EQU 82
ACommand82:
	pop ebx
ECommand82:
times (8-ECommand82+ACommand82): nop



; 0101 0011 - 83:
CCommand83 EQU 83
ACommand83:
	pop ebx
ECommand83:
times (8-ECommand83+ACommand83): nop



; 0101 0100 - 84:
CCommand84 EQU 84
ACommand84:
	pop ebx
ECommand84:
times (8-ECommand84+ACommand84): nop



; 0101 0101 - 85:
CCommand85 EQU 85
ACommand85:
	pop ebx
ECommand85:
times (8-ECommand85+ACommand85): nop



; 0101 0110 - 86:
CCommand86 EQU 86
ACommand86:
	mov eax, ebx
ECommand86:
times (8-ECommand86+ACommand86): nop



; 0101 0111 - 87:
CCommand87 EQU 87
ACommand87:
	mov byte[edi], bl
ECommand87:
times (8-ECommand87+ACommand87): nop



; 0101 1000 - 88:
CCommand88 EQU 88
ACommand88:
	mov ebx, 0x0
ECommand88:
times (8-ECommand88+ACommand88): nop



; 0101 1001 - 89:
CCommand89 EQU 89
ACommand89:
	nop   ; nopREAL
ECommand89:
times (8-ECommand89+ACommand89): nop



; 0101 1010 - 90:
CCommand90 EQU 90
ACommand90:
	xor ebx, ecx
ECommand90:
times (8-ECommand90+ACommand90): nop



; 0101 1011 - 91:
CCommand91 EQU 91
ACommand91:
	nop    ; nopREAL
ECommand91:
times (8-ECommand91+ACommand91): nop



; 0101 1100 - 92:
_pop EQU 92
ACommand92:
	pop ebx
ECommand92:
times (8-ECommand92+ACommand92): nop



; 0101 1101 - 93:
CCommand93 EQU 93
ACommand93:
	pop ebx
ECommand93:
times (8-ECommand93+ACommand93): nop



; 0101 1110 - 94:
CCommand94 EQU 94
ACommand94:
	pop ebx
ECommand94:
times (8-ECommand94+ACommand94): nop



; 0101 1111 - 95:
CCommand95 EQU 95
ACommand95:
	sub ebx, 0x0001
ECommand95:
times (8-ECommand95+ACommand95): nop



; 0110 0000 - 96:
CCommand96 EQU 96
ACommand96:
	nop
ECommand96:
times (8-ECommand96+ACommand96): nop



; 0110 0001 - 97:
_push EQU 97
ACommand97:
	 push ebx
ECommand97:
times (8-ECommand97+ACommand97): nop



; 0110 0010 - 98:
CCommand98 EQU 98
ACommand98:
	push ebx
ECommand98:
times (8-ECommand98+ACommand98): nop



; 0110 0011 - 99:
CCommand99 EQU 99
ACommand99:
	push ebx
ECommand99:
times (8-ECommand99+ACommand99): nop



; 0110 0100 - 100:
CCommand100 EQU 100
ACommand100:
	call gEIP6
	gEIP6:
	pop ebx
ECommand100:
times (8-ECommand100+ACommand100): nop



; 0110 0101 - 101:
CCommand101 EQU 101
ACommand101:
	push ebx
ECommand101:
times (8-ECommand101+ACommand101): nop



; 0110 0110 - 102:
CCommand102 EQU 102
ACommand102:
	call gEIP7
	gEIP7:
	pop ebx
ECommand102:
times (8-ECommand102+ACommand102): nop



; 0110 0111 - 103:
CCommand103 EQU 103
ACommand103:
	mov ebx, dword[ebx]
ECommand103:
times (8-ECommand103+ACommand103): nop



; 0110 1000 - 104:
_writeDWord EQU 104
ACommand104:
	mov dword[edi], ebx
ECommand104:
times (8-ECommand104+ACommand104): nop



; 0110 1001 - 105:
CCommand105 EQU 105
ACommand105:
	push ebx
ECommand105:
times (8-ECommand105+ACommand105): nop



; 0110 1010 - 106:
CCommand106 EQU 106
ACommand106:
	mov dword[edi], ebx
ECommand106:
times (8-ECommand106+ACommand106): nop



; 0110 1011 - 107:
CCommand107 EQU 107
ACommand107:
	mov ebx, dword[ebx]
ECommand107:
times (8-ECommand107+ACommand107): nop



; 0110 1100 - 108:
_saveWrtOff EQU 108
ACommand108:
	mov edi, ebx
ECommand108:
times (8-ECommand108+ACommand108): nop



; 0110 1101 - 109:
CCommand109 EQU 109
ACommand109:
	mov edi, ebx
ECommand109:
times (8-ECommand109+ACommand109): nop



; 0110 1110 - 110:
CCommand110 EQU 110
ACommand110:
	mov edi, ebx
ECommand110:
times (8-ECommand110+ACommand110): nop



; 0110 1111 - 111:
_getdata EQU 111
ACommand111:
	 mov ebx, dword[ebx]
ECommand111:
times (8-ECommand111+ACommand111): nop



; 0111 0000 - 112:
CCommand112 EQU 112
ACommand112:
	mov ebx, 0x0
ECommand112:
times (8-ECommand112+ACommand112): nop



; 0111 0001 - 113:
CCommand113 EQU 113
ACommand113:
	push ebx
ECommand113:
times (8-ECommand113+ACommand113): nop



; 0111 0010 - 114:
CCommand114 EQU 114
ACommand114:
	nop
ECommand114:
times (8-ECommand114+ACommand114): nop



; 0111 0011 - 115:
_MsgC  EQU 115
ACommand115:
	stdcall[MessageBox]
ECommand115:
times (8-ECommand115+ACommand115): nop



; 0111 0100 - 116:
CCommand116 EQU 116
ACommand116:
	db 0x74, 0x20
ECommand116:
times (8-ECommand116+ACommand116): nop



; 0111 0101 - 117:
CCommand117 EQU 117
ACommand117:
	db 0x74, 0x20
ECommand117:
times (8-ECommand117+ACommand117): nop



; 0111 0110 - 118:
CCommand118 EQU 118
ACommand118:
	mov byte[edi], bl
ECommand118:
times (8-ECommand118+ACommand118): nop



; 0111 0111 - 119:
_writeByte EQU 119
ACommand119:
	mov byte[edi], bl
ECommand119:
times (8-ECommand119+ACommand119): nop



; 0111 1000 - 120:
_zer0 EQU 120
ACommand120:
	mov ebx, 0x0
ECommand120:
times (8-ECommand120+ACommand120): nop



; 0111 1001 - 121:
CCommand121 EQU 121
ACommand121:
	mov ebx, 0x0
ECommand121:
times (8-ECommand121+ACommand121): nop



; 0111 1010 - 122:
CCommand122 EQU 122
ACommand122:
	mov ebx, 0x0
ECommand122:
times (8-ECommand122+ACommand122): nop



; 0111 1011 - 123:
CCommand123 EQU 123
ACommand123:
	add ebx, 0x0040
ECommand123:
times (8-ECommand123+ACommand123): nop



; 0111 1100 - 124:
CCommand124 EQU 124
ACommand124:
	mov ebx, 0x0
ECommand124:
times (8-ECommand124+ACommand124): nop



; 0111 1101 - 125:
CCommand125 EQU 125
ACommand125:
	add ebx, 0x0010
ECommand125:
times (8-ECommand125+ACommand125): nop



; 0111 1110 - 126:
CCommand126 EQU 126
ACommand126:
	add ebx, 0x0004
ECommand126:
times (8-ECommand126+ACommand126): nop



; 0111 1111 - 127:
_sub0001 EQU 127
ACommand127:
	sub ebx, 0x0001
ECommand127:
times (8-ECommand127+ACommand127): nop



; 1000 0000 - 128:
CCommand128 EQU 128
ACommand128:
	db _CallAPISleep
ECommand128:
times (8-ECommand128+ACommand128): nop



; 1000 0001 - 129:
CCommand129 EQU 129
ACommand129:
	nop
ECommand129:
times (8-ECommand129+ACommand129): nop



; 1000 0010 - 130:
CCommand130 EQU 130
ACommand130:
	mov ebx, DataOffset
ECommand130:
times (8-ECommand130+ACommand130): nop



; 1000 0011 - 131:
CCommand131 EQU 131
ACommand131:
	nop
ECommand131:
times (8-ECommand131+ACommand131): nop



; 1000 0100 - 132:
CCommand132 EQU 132
ACommand132:
	mul ebx
ECommand132:
times (8-ECommand132+ACommand132): nop



; 1000 0101 - 133:
CCommand133 EQU 133
ACommand133:
	nop
ECommand133:
times (8-ECommand133+ACommand133): nop



; 1000 0110 - 134:
_mul EQU 134
ACommand134:
	mul ebx
ECommand134:
times (8-ECommand134+ACommand134): nop



; 1000 0111 - 135:
CCommand135 EQU 135
ACommand135:
	div ebx
ECommand135:
times (8-ECommand135+ACommand135): nop



; 1000 1000 - 136:
CCommand136 EQU 136
ACommand136:
	nop
ECommand136:
times (8-ECommand136+ACommand136): nop



; 1000 1001 - 137:
CCommand137 EQU 137
ACommand137:
	nop
ECommand137:
times (8-ECommand137+ACommand137): nop



; 1000 1010 - 138:
CCommand138 EQU 138
ACommand138:
	mov ecx, ebx
ECommand138:
times (8-ECommand138+ACommand138): nop



; 1000 1011 - 139:
CCommand139 EQU 139
ACommand139:
	mov esi, ebx
ECommand139:
times (8-ECommand139+ACommand139): nop



; 1000 1100 - 140:
CCommand140 EQU 140
ACommand140:
	mov ecx, ebx
ECommand140:
times (8-ECommand140+ACommand140): nop



; 1000 1101 - 141:
CCommand141 EQU 141
ACommand141:
	mov ecx, ebx
ECommand141:
times (8-ECommand141+ACommand141): nop



; 1000 1110 - 142:
_save EQU 142
ACommand142:
	mov ecx, ebx
ECommand142:
times (8-ECommand142+ACommand142): nop



; 1000 1111 - 143:
CCommand143 EQU 143
ACommand143:
	mov ecx, ebx
ECommand143:
times (8-ECommand143+ACommand143): nop



; 1001 0000 - 144:
_subsaved EQU 144
ACommand144:
	sub ebx, ecx
ECommand144:
times (8-ECommand144+ACommand144): nop



; 1001 0001 - 145:
CCommand145 EQU 145
ACommand145:
	nop
ECommand145:
times (8-ECommand145+ACommand145): nop



; 1001 0010 - 146:
_addsaved EQU 146
ACommand146:
	add ebx, ecx
ECommand146:
times (8-ECommand146+ACommand146): nop



; 1001 0011 - 147:
CCommand147 EQU 147
ACommand147:
	add ebx, ecx
ECommand147:
times (8-ECommand147+ACommand147): nop



; 1001 0100 - 148:
CCommand148 EQU 148
ACommand148:
	sub ebx, ecx
ECommand148:
times (8-ECommand148+ACommand148): nop



; 1001 0101 - 149:
CCommand149 EQU 149
ACommand149:
	div ebx
ECommand149:
times (8-ECommand149+ACommand149): nop



; 1001 0110 - 150:
CCommand150 EQU 150
ACommand150:
	div ebx
ECommand150:
times (8-ECommand150+ACommand150): nop



; 1001 0111 - 151:
_div EQU 151
ACommand151:
	div ebx
ECommand151:
times (8-ECommand151+ACommand151): nop



; 1001 1000 - 152:
CCommand152 EQU 152
ACommand152:
	nop
ECommand152:
times (8-ECommand152+ACommand152): nop



; 1001 1001 - 153:
CCommand153 EQU 153
ACommand153:
	nop
ECommand153:
times (8-ECommand153+ACommand153): nop



; 1001 1010 - 154:
CCommand154 EQU 154
ACommand154:
	xor ebx, ecx
ECommand154:
times (8-ECommand154+ACommand154): nop



; 1001 1011 - 155:
CCommand155 EQU 155
ACommand155:
	add ebx, 0x1000
ECommand155:
times (8-ECommand155+ACommand155): nop



; 1001 1100 - 156:
CCommand156 EQU 156
ACommand156:
	shr ebx, cl
ECommand156:
times (8-ECommand156+ACommand156): nop



; 1001 1101 - 157:
CCommand157 EQU 157
ACommand157:
	mov ecx, ebx
ECommand157:
times (8-ECommand157+ACommand157): nop



; 1001 1110 - 158:
CCommand158 EQU 158
ACommand158:
	mov ecx, ebx
ECommand158:
times (8-ECommand158+ACommand158): nop



; 1001 1111 - 159:
CCommand159 EQU 159
ACommand159:
	add ebx, 0x1000
ECommand159:
times (8-ECommand159+ACommand159): nop



; 1010 0000 - 160:
CCommand160 EQU 160
ACommand160:
	nop
ECommand160:
times (8-ECommand160+ACommand160): nop



; 1010 0001 - 161:
CCommand161 EQU 161
ACommand161:
	nop
ECommand161:
times (8-ECommand161+ACommand161): nop



; 1010 0010 - 162:
CCommand162 EQU 162
ACommand162:
      nop
ECommand162:
times (8-ECommand162+ACommand162): nop



; 1010 0011 - 163:
CCommand163 EQU 163
ACommand163:
	nop
ECommand163:
times (8-ECommand163+ACommand163): nop



; 1010 0100 - 164:
CCommand164 EQU 164
ACommand164:
	call gEIP42
	gEIP42:
	pop ebx
ECommand164:
times (8-ECommand164+ACommand164): nop



; 1010 0101 - 165:
CCommand165 EQU 165
ACommand165:
	call gEIP43
	gEIP43:
	pop ebx
ECommand165:
times (8-ECommand165+ACommand165): nop



; 1010 0110 - 166:
CCommand166 EQU 166
ACommand166:
	mul ebx
ECommand166:
times (8-ECommand166+ACommand166): nop



; 1010 0111 - 167:
CCommand167 EQU 167
ACommand167:
	mul ebx
ECommand167:
times (8-ECommand167+ACommand167): nop



; 1010 1000 - 168:
CCommand168 EQU 168
ACommand168:
	mov esi, ebx
ECommand168:
times (8-ECommand168+ACommand168): nop



; 1010 1001 - 169:
CCommand169 EQU 169
ACommand169:
	mov esi, ebx
ECommand169:
times (8-ECommand169+ACommand169): nop



; 1010 1010 - 170:
CCommand170 EQU 170
ACommand170:
	mov esi, ebx
ECommand170:
times (8-ECommand170+ACommand170): nop



; 1010 1011 - 171:
_saveJmpOff EQU 171
ACommand171:
	mov esi, ebx
ECommand171:
times (8-ECommand171+ACommand171): nop



; 1010 1100 - 172:
_shl EQU 172
ACommand172:
	shl ebx, cl
ECommand172:
times (8-ECommand172+ACommand172): nop



; 1010 1101 - 173:
CCommand173 EQU 173
ACommand173:
	shl ebx, cl
ECommand173:
times (8-ECommand173+ACommand173): nop



; 1010 1110 - 174:
CCommand174 EQU 174
ACommand174:
	shl ebx, cl
ECommand174:
times (8-ECommand174+ACommand174): nop



; 1010 1111 - 175:
CCommand175 EQU 175
ACommand175:
	shl ebx, cl
ECommand175:
times (8-ECommand175+ACommand175): nop



; 1011 0000 - 176:
CCommand176 EQU 176
ACommand176:
	nop
ECommand176:
times (8-ECommand176+ACommand176): nop



; 1011 0001 - 177:
CCommand177 EQU 177
ACommand177:
	nop
ECommand177:
times (8-ECommand177+ACommand177): nop



; 1011 0010 - 178:
CCommand178 EQU 178
ACommand178:
	nop
ECommand178:
times (8-ECommand178+ACommand178): nop



; 1011 0011 - 179:
CCommand179 EQU 179
ACommand179:
	nop
ECommand179:
times (8-ECommand179+ACommand179): nop



; 1011 0100 - 180:
CCommand180 EQU 180
ACommand180:
	db 0x74, 0x20
ECommand180:
times (8-ECommand180+ACommand180): nop



; 1011 0101 - 181:
CCommand181 EQU 181
ACommand181:
	db 0x74, 0x20
ECommand181:
times (8-ECommand181+ACommand181): nop



; 1011 0110 - 182:
CCommand182 EQU 182
ACommand182:
	add ebx, 0x0100
ECommand182:
times (8-ECommand182+ACommand182): nop



; 1011 0111 - 183:
CCommand183  EQU 183
ACommand183:
	add ebx, 0x0100
ECommand183:
times (8-ECommand183+ACommand183): nop



; 1011 1000 - 184:
CCommand184 EQU 184
ACommand184:
	shr ebx, cl
ECommand184:
times (8-ECommand184+ACommand184): nop



; 1011 1001 - 185:
CCommand185 EQU 185
ACommand185:
	shr ebx, cl
ECommand185:
times (8-ECommand185+ACommand185): nop



; 1011 1010 - 186:
CCommand186 EQU 186
ACommand186:
	shr ebx, cl
ECommand186:
times (8-ECommand186+ACommand186): nop



; 1011 1011 - 187:
CCommand187 EQU 187
ACommand187:
	shr ebx, cl
ECommand187:
times (8-ECommand187+ACommand187): nop



; 1011 1100 - 188:
_shr EQU 188
ACommand188:
	shr ebx, cl
ECommand188:
times (8-ECommand188+ACommand188): nop



; 1011 1101 - 189:
CCommand189 EQU 189
ACommand189:
	shr ebx, cl
ECommand189:
times (8-ECommand189+ACommand189): nop



; 1011 1110 - 190:
CCommand190 EQU 190
ACommand190:
	shr ebx, cl
ECommand190:
times (8-ECommand190+ACommand190): nop



; 1011 1111 - 191:
_add4000 EQU 191
ACommand191:
	add ebx, 0x4000
ECommand191:
times (8-ECommand191+ACommand191): nop



; 1100 0000 - 192:
CCommand192 EQU 192
ACommand192:
	nop
ECommand192:
times (8-ECommand192+ACommand192): nop



; 1100 0001 - 193:
CCommand193 EQU 193
ACommand193:
	nop
ECommand193:
times (8-ECommand193+ACommand193): nop



; 1100 0010 - 194:
_getDO EQU 194
ACommand194:
	mov ebx, DataOffset
ECommand194:
times (8-ECommand194+ACommand194): nop



; 1100 0011 - 195:
CCommand195 EQU 195
ACommand195:
	mov ebx, DataOffset
ECommand195:
times (8-ECommand195+ACommand195): nop



; 1100 0100 - 196:
CCommand196 EQU 196
ACommand196:
	mov ebx, DataOffset
ECommand196:
times (8-ECommand196+ACommand196): nop



; 1100 0101 - 197:
CCommand197 EQU 197
ACommand197:
	mov ebx, DataOffset
ECommand197:
times (8-ECommand197+ACommand197): nop



; 1100 0110 - 198:
CCommand198 EQU 198
ACommand198:
	mov ebx, DataOffset
ECommand198:
times (8-ECommand198+ACommand198): nop



; 1100 0111 - 199:
CCommand199 EQU 199
ACommand199:
	mov ebx, DataOffset
ECommand199:
times (8-ECommand199+ACommand199): nop



; 1100 1000 - 200:
CCommand200 EQU 200
ACommand200:
	mov ebx, DataOffset
ECommand200:
times (8-ECommand200+ACommand200): nop



; 1100 1001 - 201:
CCommand201 EQU 201
ACommand201:
	and ebx, ecx
ECommand201:
times (8-ECommand201+ACommand201): nop



; 1100 1010 - 202:
CCommand202 EQU 202
ACommand202:
	and ebx, ecx
ECommand202:
times (8-ECommand202+ACommand202): nop



; 1100 1011 - 203:
CCommand203 EQU 203
ACommand203:
	and ebx, ecx
ECommand203:
times (8-ECommand203+ACommand203): nop



; 1100 1100 - 204:
CCommand204 EQU 204
ACommand204:
	nop
ECommand204:
times (8-ECommand204+ACommand204): nop



; 1100 1101 - 205:
CCommand205 EQU 205
ACommand205:
	and ebx, ecx
ECommand205:
times (8-ECommand205+ACommand205): nop



; 1100 1110 - 206:
CCommand206 EQU 206
ACommand206:
	and ebx, ecx
ECommand206:
times (8-ECommand206+ACommand206): nop



; 1100 1111 - 207:
_and EQU 207
ACommand207:
	and ebx, ecx
ECommand207:
times (8-ECommand207+ACommand207): nop



; 1101 0000 - 208:
CCommand208 EQU 208
ACommand208:
	mov ebx, DataOffset
ECommand208:
times (8-ECommand208+ACommand208): nop



; 1101 0001 - 209:
CCommand209  EQU 209
ACommand209:
	jz over1
	jmp esi
	over1:
ECommand209:
times (8-ECommand209+ACommand209): nop



; 1101 0010 - 210:
CCommand210 EQU 210
ACommand210:
	jz over2
	jmp esi
	over2:
ECommand210:
times (8-ECommand210+ACommand210): nop



; 1101 0011 - 211:
_JnzUp EQU 211
ACommand211:
	jz over3
	jmp esi
	over3:
ECommand211:
times (8-ECommand211+ACommand211): nop



; 1101 0100 - 212:
CCommand212 EQU 212
ACommand212:
	db 0x74, 0x20
ECommand212:
times (8-ECommand212+ACommand212): nop



; 1101 0101 - 213:
CCommand213 EQU 213
ACommand213:
	db 0x74, 0x20
ECommand213:
times (8-ECommand213+ACommand213): nop



; 1101 0110 - 214:
CCommand214 EQU 214
ACommand214:
	db 0x74, 0x20
ECommand214:
times (8-ECommand214+ACommand214): nop



; 1101 0111 - 215:
CCommand215 EQU 215
ACommand215:
	jz over
	jmp esi
	over:
ECommand215:
times (8-ECommand215+ACommand215): nop



; 1101 1000 - 216:
CCommand216 EQU 216
ACommand216:
	xor ebx, ecx
ECommand216:
times (8-ECommand216+ACommand216): nop



; 1101 1001 - 217:
CCommand217 EQU 217
ACommand217:
	xor ebx, ecx
ECommand217:
times (8-ECommand217+ACommand217): nop



; 1101 1010 - 218:
_xor EQU 218
ACommand218:
	xor ebx, ecx
ECommand218:
times (8-ECommand218+ACommand218): nop



; 1101 1011 - 219:
CCommand219 EQU 219
ACommand219:
	xor ebx, ecx
ECommand219:
times (8-ECommand219+ACommand219): nop



; 1101 1100 - 220:
CCommand220 EQU 220
ACommand220:
	add ebx, 0x1000
ECommand220:
times (8-ECommand220+ACommand220): nop



; 1101 1101 - 221:
CCommand221 EQU 221
ACommand221:
	add ebx, 0x1000
ECommand221:
times (8-ECommand221+ACommand221): nop



; 1101 1110 - 222:
CCommand222 EQU 222
ACommand222:
	add ebx, 0x1000
ECommand222:
times (8-ECommand222+ACommand222): nop



; 1101 1111 - 223:
_add1000 EQU 223
ACommand223:
	add ebx, 0x1000
ECommand223:
times (8-ECommand223+ACommand223): nop



; 1110 0000 - 224:
CCommand224 EQU 224
ACommand224:
	mov ebx, DataOffset
ECommand224:
times (8-ECommand224+ACommand224): nop



; 1110 0001 - 225:
CCommand225 EQU 225
ACommand225:
	push ebx
ECommand225:
times (8-ECommand225+ACommand225): nop



; 1110 0010 - 226:
CCommand226 EQU 226
ACommand226:
	mov ebx, DataOffset
ECommand226:
times (8-ECommand226+ACommand226): nop



; 1110 0011 - 227:
CCommand227 EQU 227
ACommand227:
	mov ebx, DataOffset
ECommand227:
times (8-ECommand227+ACommand227): nop



; 1110 0100 - 228:
_getEIP EQU 228
ACommand228:
	call gEIP1
	gEIP1:
	pop ebx
ECommand228:
times (8-ECommand228+ACommand228): nop



; 1110 0101 - 229:
CCommand229 EQU 229
ACommand229:
	call gEIP2
	gEIP2:
	pop ebx
ECommand229:
times (8-ECommand229+ACommand229): nop



; 1110 0110 - 230:
CCommand230 EQU 230
ACommand230:
	call gEIP
	gEIP:
	pop ebx
ECommand230:
times (8-ECommand230+ACommand230): nop



; 1110 0111 - 231:
CCommand231 EQU 231
ACommand231:
	call gEIP22
	gEIP22:
	pop ebx
ECommand231:
times (8-ECommand231+ACommand231): nop



; 1110 1000 - 232:
_JnzDown EQU 232
ACommand232:
	db 0x75, 0x20
ECommand232:
times (8-ECommand232+ACommand232): nop



; 1110 1001 - 233:
CCommand233 EQU 233
ACommand233:
	db 0x75, 0x20
ECommand233:
times (8-ECommand233+ACommand233): nop



; 1110 1010 - 234:
CCommand234 EQU 234
ACommand234:
	db 0x75, 0x20
ECommand234:
times (8-ECommand234+ACommand234): nop



; 1110 1011 - 235:
CCommand235 EQU 235
ACommand235:
	add ebx, 0x0400
ECommand235:
times (8-ECommand235+ACommand235): nop



; 1110 1100 - 236:
CCommand236 EQU 236
ACommand236:
	call gEIP3
	gEIP3:
	pop ebx
ECommand236:
times (8-ECommand236+ACommand236): nop



; 1110 1101 - 237:
CCommand237 EQU 237
ACommand237:
	add ebx, 0x0400
ECommand237:
times (8-ECommand237+ACommand237): nop



; 1110 1110 - 238:
CCommand238 EQU 238
ACommand238:
	nop
ECommand238:
times (8-ECommand238+ACommand238): nop



; 1110 1111 - 239:
_add0400 EQU 239
ACommand239:
	add ebx, 0x0400
ECommand239:
times (8-ECommand239+ACommand239): nop



; 1111 0000 - 240:
CCommand240 EQU 240
ACommand240:
	nop
ECommand240:
times (8-ECommand240+ACommand240): nop



; 1111 0001 - 241:
CCommand241 EQU 241
ACommand241:
	nop
ECommand241:
times (8-ECommand241+ACommand241): nop



; 1111 0010 - 242:
CCommand242 EQU 242
ACommand242:
	nop
ECommand242:
times (8-ECommand242+ACommand242): nop



; 1111 0011 - 243:
CCommand243 EQU 243
ACommand243:
	nop
ECommand243:
times (8-ECommand243+ACommand243): nop



; 1111 0100 - 244:
CCommand244 EQU 244
ACommand244:
	db 0x74, 0x20
ECommand244:
times (8-ECommand244+ACommand244): nop



; 1111 0101 - 245:
_JzDown EQU 245
ACommand245:
	db 0x74, 0x20
ECommand245:
times (8-ECommand245+ACommand245): nop



; 1111 0110 - 246:
CCommand246 EQU 246
ACommand246:
	add ebx, 0x0100
ECommand246:
times (8-ECommand246+ACommand246): nop



; 1111 0111 - 247:
_add0100 EQU 247
ACommand247:
	add ebx, 0x0100
ECommand247:
times (8-ECommand247+ACommand247): nop



; 1111 1000 - 248:
CCommand248 EQU 248
ACommand248:
	mov ebx, 0x0
ECommand248:
times (8-ECommand248+ACommand248): nop



; 1111 1001 - 249:
CCommand249 EQU 249
ACommand249:
	mov ebx, 0x0
ECommand249:
times (8-ECommand249+ACommand249): nop



; 1111 1010 - 250:
CCommand250 EQU 250
ACommand250:
	mov ebx, 0x0
ECommand250:
times (8-ECommand250+ACommand250): nop



; 1111 1011 - 251:
_add0040 EQU 251
ACommand251:
	add ebx, 0x0040
ECommand251:
times (8-ECommand251+ACommand251): nop



; 1111 1100 - 252:
CCommand252 EQU 252
ACommand252:
	add ebx, 0x0010
ECommand252:
times (8-ECommand252+ACommand252): nop



; 1111 1101 - 253:
_add0010 EQU 253
ACommand253:
	add ebx, 0x0010
ECommand253:
times (8-ECommand253+ACommand253): nop



; 1111 1110 - 254:
_add0004 EQU 254
ACommand254:
	add ebx, 0x0004
ECommand254:
times (8-ECommand254+ACommand254): nop



; 1111 1111 - 255:
_add0001 EQU 255
ACommand255:
	add ebx, 0x0001
ECommand255:
times (8-ECommand255+ACommand255): nop



