_LABEL_NOTES_START:
	db	"---"
	db	227,"-",233
	db	227,232,233
	db	228,"-",233
	db	228,232,233
	db	229,"-",233
	db	230,"-",233
	db	230,232,233
	db	231,"-",233
	db	231,232,233
	db	225,"-",233
	db	225,232,233
	db	226,"-",233

	db	227,"-",234
	db	227,232,234
	db	228,"-",234
	db	228,232,234
	db	229,"-",234
	db	230,"-",234
	db	230,232,234
	db	231,"-",234
	db	231,232,234
	db	225,"-",234
	db	225,232,234
	db	226,"-",234
	db	227,"-",235
	db	227,232,235
	db	228,"-",235
	db	228,232,235
	db	229,"-",235
	db	230,"-",235
	db	230,232,235
	db	231,"-",235
	db	231,232,235
	db	225,"-",235
	db	225,232,235
	db	226,"-",235
	db	227,"-",236
	db	227,232,236
	db	228,"-",236
	db	228,232,236
	db	229,"-",236
	db	230,"-",236
	db	230,232,236
	db	231,"-",236
	db	231,232,236
	db	225,"-",236
	db	225,232,236
	db	226,"-",236
	db	227,"-",237
	db	227,232,237
	db	228,"-",237
	db	228,232,237
	db	229,"-",237
	db	230,"-",237
	db	230,232,237
	db	231,"-",237
	db	231,232,237
	db	225,"-",237
	db	225,232,237
	db	226,"-",237
	db	227,"-",238
	db	227,232,238
	db	228,"-",238
	db	228,232,238
	db	229,"-",238
	db	230,"-",238
	db	230,232,238
	db	231,"-",238
	db	231,232,238
	db	225,"-",238
	db	225,232,238
	db	226,"-",238
	db	227,"-",239
	db	227,232,239
	db	228,"-",239
	db	228,232,239
	db	229,"-",239
	db	230,"-",239
	db	230,232,239
	db	231,"-",239
	db	231,232,239
	db	225,"-",239
	db	225,232,239
	db	226,"-",239
	db	227,"-",240
	db	227,232,240
	db	228,"-",240
	db	228,232,240
	db	229,"-",240
	db	230,"-",240
	db	230,232,240
	db	231,"-",240
	db	231,232,240
	db	225,"-",240
	db	225,232,240
	db	226,"-",240
	db	"-",224,"-"
	db	"-",$fb,"-"
	db	" ",$1f,"0"
_LABEL_NOTES_END:

_KEY_NOTE_TABLE_START:
	db	  2+26,  97+1,    12+2,  3+12+1,   255+0,  6+12+1,  8+12+1, 10+12+1	; 0-7
	db	   255,    26,     255,  8+24+1,   255+0,  5+24+1,  7+24+1,  3+12+1	; 8-15
	db   	   255,   255,    1+12,  2+12+1,  4+12+1,   255+0,      97,     7+1 	; 16-23
	db	     5,     4,  4+12+1,      99,     6+1,     8+1,  0+24+1,    10+1	; 24-31
	db	     0,  2+12,    11+1,     9+1,  2+24+1,  4+24+1,  0+12+1,  5+12+1	; 32-39
	db	     2,  8+12, 11+12+1,     5+1,  2+12+1,     2+1,  9+12+1,     0+1	; 40-47
;	db	255	; 0x21  !
;	db	255 	; 0x22	" 	  
;	db	1+3+12+12	; 0x23	# 	  
;	db	255	; 0x24  $
;	db	1+6+12+12	; 0x25	% 	  
;	db	1+10+12+12; 0x26	& 	  
;	db	255  	; 0x27		  
;	db	1+1+12+24	; 0x28  (
;	db	1+3+12+24	; 0x29	) 	   
;	db	255    	; 0x2a  * 
;	db	1+6+12+24	; 0x2b	+  	  
;	db	1+0+12	; 0x2c	,	C+1
;	db	255	; 0xde  -
;	db	1+2+12	; 0x2e	.	D+1
;	db	1+4+12	; 0x2f	/	E+1
;	db	1+3+12+12	; 0x30	0	D#
;	db	255	; 0x31  1
;	db	1+1+12	; 0x32	2	C#
;	db	1+3+12	; 0x33	3	D#
;	db	255	; 0x34  4
;	db	1+6+12	; 0x35	5	F#
;	db	1+8+12	; 0x36	6	G#
;	db	1+10+12	; 0x37	7	A#
;	db	255	; 0x38  8
;	db	1+1+12+12	; 0x39	9	C#
;	db	1+3+12+12	; 0x3a  :
;	db	1+3+12	; 0x3b	; 	D#
;	db	1+0+12+12	; 0x3c  <
;	db	1+6+12+12	; 0x3d	=	F#
;	db	1+2+12+12	; 0x3e  >
;	db	1+4+12+12	; 0x3f  ?
;	db	1+1+12+12	; 0x40  @
;	db	1+96	; 0x41	A	-R-
;	db	1+7+12	; 0x42	B	G
;	db	1+4+12	; 0x43	C	E
;	db	1+3+12	; 0x44	D	D#
;	db	1+4+12+12	; 0x45	E	E
;	db	255	; 0x46 -------------------
;	db	1+6+12	; 0x47	G	F#
;	db	1+8+12	; 0x48	H	G#
;	db	1+0+12+24	; 0x49	I	C
;	db	1+10+12	; 0x4A	J	A#
;	db	0;97	; 0x4b	K	---
;	db	1+1+12+12	; 0x4C	L	C#
;	db	1+11+12	; 0x4D	M	B
;	db	1+9+12	; 0x4E	N	A
;	db	1+2+12+24	; 0x4F	O	D
;	db	1+4+12+24	; 0x50	P	E
;	db	1+0+12+12	; 0x51	Q	C
;	db	1+5+12+12	; 0x52	R	F
;	db	1+1+12	; 0x53	S	C#
;	db	1+7+12+12	; 0x54	T	G
;	db	1+11+24	; 0x55	U	B
;	db	1+5+12	; 0x56	V	F
;	db	1+2+12+12	; 0x57	W	D
;	db	1+2+12	; 0x58	X	D
;	db	1+9+12+12	; 0x59	Y	A
;	db	1+0+12	; 0x5A	Z	C
;	db	1+5+12+12	; 0x5b	[	F
;	db	255	; 0x5c -------------------
;	db	1+7+12+12	; 0x5d	]	G
;	db	1+8+12+12	; 0x5e  ^
;	db	255	; 0x5f  _
;	db	255	; 0x60  `
;	db	1+96	; 0x61	A	-R-
;	db	1+7	; 0x62	B	G
;	db	1+4	; 0x63	C	E
;	db	1+3	; 0x64	D	D#
;	db	1+4+12	; 0x65	E	E
;	db	255	; 0x66 -------------------
;	db	1+6	; 0x67	G	F#
;	db	1+8	; 0x68	H	G#
;	db	1+0+12+12	; 0x69	I	C
;	db	1+10	; 0x6A	J	A#
;	db	0;97	; 0x6b	K	---
;	db	1+1+12	; 0x6C	L	C#
;	db	1+11	; 0x6D	M	B
;	db	1+9	; 0x6E	N	A
;	db	1+2+12+12	; 0x6F	O	D
;	db	1+4+12+12	; 0x70	P	E
;	db	1+0+12	; 0x71	Q	C
;	db	1+5+12	; 0x72	R	F
;	db	1+1	; 0x73	S	C#
;	db	1+7+12	; 0x74	T	G
;	db	1+11+12	; 0x75	U	B
;	db	1+5	; 0x76	V	F
;	db	1+2+12	; 0x77	W	D
;	db	1+2	; 0x78	X	D
;	db	1+9+12	; 0x79	Y	A
;	db	1+0	; 0x7A	Z	C
;	db	1+5+12+24	; 0x7b  {
;	db	255	; 0x7c  |
;	db	1+7+12+24	; 0x7d  }
;	db	255	; 0x7e  ~	
;	db	0	; 0x7f	DEL	---
_KEY_NOTE_TABLE_END: