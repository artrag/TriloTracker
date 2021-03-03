
;===========================================================
; --- draw_samplebox
; Display the sample area.  Without actual values 
; 
;===========================================================
draw_samplebox:
	; box around number, length, restart etc
	ld	hl,(80*6)+8
	ld	de,(49*256) + 3
	call	draw_box
	
	; box around macro lines
	ld	hl,(80*9)+0
	ld	de,(48*256) + 17
	call	draw_box	


	ld	hl,(80*6)+1+8
	ld	de,_LABEL_SAPMPLEBOX
	call	draw_label
	
	ld	hl,(80*7)+2+8
	ld	de,_LABEL_SAPMPLETEXT
	call	draw_label
	ld	hl,(80*8)+2+8
;	ld	de,_LABEL_SAMPLE_NR
	call	draw_label


	ld	hl,(80*9)+1
	ld	de,_LABEL_SAPMPLEMACRO
	call	draw_label


;	ld	hl,(80*9)+1+28+4
;	ld	de,_LABEL_SAMPPLEFORM
;	call	draw_label


	ld	hl,0x0806
	ld	de,0x3103	
	call	draw_colorbox	
	;ld	hl,0x0a08
	;ld	de,0x0501	
	;call	erase_colorbox	
	ld	hl,0x0f08
	ld	de,0x0401	
	call	erase_colorbox		
;	ld	hl,0x1408
;	ld	de,0x0801	
;	call	erase_colorbox
;	ld	hl,0x1908
;	ld	de,0x0401	
;	call	erase_colorbox

	ld	hl,0x1e08
	ld	de,0x1001	
	call	erase_colorbox
	ld	hl,0x2f08
	ld	de,0x0401	
	call	erase_colorbox
;	ld	hl,0x3408
;	ld	de,0x0401	
;	call	erase_colorbox

	; under the info top area
	ld	hl,0x0009
	ld	de,0x5012	
	call	draw_colorbox

      ;-- loop column
	ld	hl,0x060a
	ld	de,0x0110	
	call	erase_colorbox	

	; macro data
	ld	hl,0x090a
	ld	de,0x2610	
	call	erase_colorbox	
		
	ret
	
_LABEL_SAPMPLEBOX:
	db	"Sample edit:",0
_LABEL_SAPMPLEMACRO:
	db	"Sample:",$81,"Base",$81,"Start",$81,"End",$81,$81,$81,"Loop",$81,$81,"Description",0

_LABEL_SAPMPLETEXT:
	db	"Sam:                Description:     Oct:",0
_LABEL_SAMPLE_NR:	
	db	_ARROWLEFT,"0x",_ARROWRIGHT,0
_LABEL_SAMPLE_OCT:
	db	_ARROWLEFT,"xx",_ARROWRIGHT,0


_sample_SAMPLESTRING:
	db	"   _____|---   .|--- . .|--- . ."
_udm_pntpos:	dw	0
;===========================================================
; --- update_samplebox
; Display the values
; 
;===========================================================
update_samplebox:
	;--- Sample info
	ld	de,_LABEL_SAMPLE_NR+2
	ld	a,(sample_current)
	call	draw_hex
	ld	de,_LABEL_SAMPLE_OCT+1
	ld	a,(song_octave)
	call	draw_decimal

	; draw nr 
	ld	de,_LABEL_SAMPLE_NR
	ld	hl,(80*8)+8+2
	ld	b,4
	call	draw_label_fast

	;--- draw sample name
	ld	de,sample_names
	ld	a,(sample_current)
[3]	add	a			; times 8
	add	a,e
	ld 	e,a
	jp	nc,99f
	inc	d
99:
	ld	hl,(80*8)+1+8+21	
	ld	b,8
	call	draw_label_fast

	;draw description + octave
	ld	hl,(80*8)+1+8+38
	ld	de,_LABEL_SAMPLE_OCT
	ld	b,4
	call	draw_label_fast


	ret

;===========================================================
; --- process_key_samplebox
;
; Process the input for the sample macro. 
; 
; 
;===========================================================
process_key_samplebox:
	
	ld	a,(key)
	and	a
	ret	z



process_key_samplebox_END:
	ret


_COLTAB_SAMPLE:
	db	0,1	; 0 = basesample
	db	1,1	; 1 = snare
	db	2,1	; 2 = tomtom
	db	3,1	; 3 = cymbal
	db	4,2	; 4 = highhat
	; bd registers
	db	5,1	; 5 = note/deviation
	db	6,1	; 6 = note/deviationhigh
	db	7,4	; 7 = note/deviationlow
	db	9,2	; 9 = volume low
	; hh/sn registers
	db	5,1	; 5 = note/deviation
	db	6,1	; 6 = note/deviationhigh
	db	7,2	; 7 = note/deviationlow
	db	8,2	; 8 = volume high
	db	9,2	; 9 = volume low
	; tom/cy registers
	db	5,1	; 5 = note/deviation
	db	6,1	; 6 = note/deviationhigh
	db	7,2	; 7 = note/deviationlow
	db	8,2	; 8 = volume high
	db	9,255	; 9 = volume low	
	
	


;===========================================================
; --- process_key_macrobox_octave
;
;  
;===========================================================
process_key_samplebox_octave:
	ld	a,(song_octave)
	ld	c,a
	ld	a,(key)

	;--- Check if edit is ended.
	cp	_ENTER
	jr.	z,44f
	cp	_ESC
	jr.	nz,0f
44:		call	restore_cursor
		;call	reset_cursor_trackbox
		jr.	process_key_samplebox_octave_END
0:		
	;--- Key_up - Pattern down	
	cp	_KEY_DOWN
	jr.	z,44f
	cp	_KEY_LEFT
	jr.	nz,0f
44:		dec	c
		ld	a,c
		jr.	z,process_key_samplebox_octave_END
88:		ld	(song_octave),a
		call	update_samplebox
		jr.	process_key_samplebox_octave_END	
0:
	;--- Key_down - Pattern up	
	cp	_KEY_UP
	jr.	z,44f
	cp	_KEY_RIGHT
	jr.	nz,0f
44:		ld	a,c
		cp	7
		jr.	nc,process_key_samplebox_octave_END
		inc	a
		jr.	88b	
0:
	;---- number key
	cp	"1"
	jr.	c,0f
	cp	"8"
	jr.	nc,0f

		sub	48
		ld	(song_octave),a
		call	restore_cursor
		call	update_samplebox
		jr.	process_key_samplebox_octave_END
0:	
process_key_samplebox_octave_END:
	ret



;===========================================================
; --- reset_cursor_macrobox
;
; Reset the cursor to the top left of the pattern.
; To be used when switching patterns, after loadinging and etc
;===========================================================
reset_cursor_samplebox:

	ret

