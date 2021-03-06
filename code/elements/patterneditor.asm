;===========================================================
; --- draw_patterneditor
;
; Display the pattern editor.  Without actual values 
; 
;===========================================================
draw_patterneditor:
	ld	a,255
	ld	(song_order_update),a
	call	clear_screen
	call	draw_orderbox
	call	draw_songbox
	call	draw_patternbox
	call	draw_instrumentbox


;	ld	hl,SCC_slot
;	ld	de,(0)+44
;	call	draw_decimal

	; patterneditor

	ld	hl,0x0009
	ld	de,0x5001	
	call	draw_colorbox	
	ld	hl,0x000a
	ld	de,0x0210	
	call	draw_colorbox	
	ld	hl,0x4e0a
	ld	de,0x0210	
	call	draw_colorbox	
	ld	hl,0x001a
	ld	de,0x5001	
	call	draw_colorbox	
	
	

	ret

;===========================================================
; --- update_patternbox
;
; Display the pattern area values.
; 
;===========================================================
update_patterneditor:
	call	update_patternbox
	;call	update_editbox
	call	update_trackbox
	call	update_songbox
	call	update_instrumentbox
	call	update_orderbox


	ret
	

	
restore_patterneditor:
	ld	a,(editmode)
	cp	0
	ret	z


	ld	a,0
	ld	(editmode),a	
		
	call	restore_cursor
	
	call	draw_patterneditor
	call	update_patterneditor
	
	ret
	
	
;===========================================================
; --- update_patternbox
;
; Display the pattern area values.
; 
;===========================================================	
init_patterneditor:

	ld	a,(editmode)
	cp	0
	ret	z

	; --- File selectio pointer to the first entry			
	xor	a
	ld	(menu_selection),a
	; --- init mode
	ld	a,0
	ld	(editmode),a
	ld	a,0
	ld	(editsubmode),a	

	call	reset_cursor_trackbox


	; --- show the screen

	call	draw_patterneditor
	call	update_patterneditor
	ld	a,255
	ld	(song_order_update),a
	call	build_order_list
	call	update_orderbox

	
	ret

;===========================================================
; --- update_patterneditor
; Display the pattern track area.  Without actual values 
; 
;===========================================================	
processkey_patterneditor:

	;--- general keys for patterneditor
	ld	a,(key)
	and	a
	jr.	z,97f
	dec	a		;--- F1 = Playback
	jr.	nz,0f
		call	start_playback
		jr.	processkey_patterneditor_END
0:	dec	a		;--- F2 = Instrument editor
	jr.	nz,0f
IFDEF TTFM
		ld	a,7
		call	swap_loadelementblock
ENDIF
		jr.	init_psgsampleeditor
		;jr.	processkey_patterneditor_END

IFDEF TTSCC		
0:	;--- F3
	dec	a
	
ELSE
0:	;--- F3 Drum macro editor
	dec	a
	jr.	nz,0f
		ld	a,8
		call	swap_loadelementblock
		jr.	init_drumeditor

ENDIF

0:	;--- F4
	dec	a
	jr.	nz,0f
		ld	a,4
		call	swap_loadblock
		jr.	init_trackmanager

0:	;--- F5
	dec	a
	jr.	nz,0f
		ld	a,(skey)
		cp	1	
		jr.	z,44f	;init_configeditor	
	
		ld    a,6
		call    swap_loadelementblock
    
		jr.    init_filedialog
		;jr.    processkey_patterneditor_END    

44:
		ld	a,3
		call	swap_loadblock		
		jr.	init_configeditor
		
		
			
0:	;--- CTRL
	ld	a,(fkey)
	cp	6
	jr.	nz,97f
	
	ld	a,(key)
	cp	'1'+128
	jr.	nz,0f
	ld	a,(MainMixer)
	xor	32
_mix:	ld	(MainMixer),a
	jr.	draw_pattern_header
0:
	cp	'2'+128
	jr.	nz,0f
	ld	a,(MainMixer)
	xor	64
	jr.	_mix
0:
	cp	"3"+128
	jr.	nz,0f
	ld	a,(MainMixer)
	xor	128
	jr.	_mix
0:
	cp	"4"+128
	jr.	nz,0f
	ld	a,(MainMixer)
	xor	1
	jr.	_mix
0:
	cp	"5"+128
	jr.	nz,0f
	ld	a,(MainMixer)
	xor	2
	jr.	_mix
0:
	cp	"6"+128
	jr.	nz,0f
	ld	a,(MainMixer)
	xor	4
	jr.	_mix
0:
	cp	"7"+128
	jr.	nz,0f
	ld	a,(MainMixer)
	xor	8
	jr.	_mix
0:
	cp	"8"+128
	jr.	nz,0f
	ld	a,(MainMixer)
	xor	16
	jr.	_mix
0:	
	
;	;--- CTRL + S sampleeditor
;	cp	's'
;	jr.	z,0f
;	cp	'S'
;	jr.	nz,1f	
;0:	call	init_psgsampleeditor
;	jr.	processkey_patterneditor_END
1:
	;--- CTRL + N - Song Name
	cp	_CTRL_N
	jr.	nz,1f
		ld	a,(editsubmode)
		and	a
		jr.	nz,99f
		call	save_cursor
99:		ld	a,1
		ld	(editsubmode),a
		call	reset_cursor_songbox
		jr.	processkey_patterneditor_END
1:
	;--- CTRL + B - Song By
	cp	_CTRL_B
	jr.	nz,1f
		ld	a,(editsubmode)
		and	a
		jr.	nz,99f
		call	save_cursor
99:		ld	a,2
		ld	(editsubmode),a
		call	reset_cursor_songbox
		jr.	processkey_patterneditor_END
1:
	;--- CTRL + P - Pattern number
	cp	_CTRL_P
	jr.	nz,1f
		ld	a,(editsubmode)
		and	a
		jr.	nz,99f
		call	save_cursor
99:		ld	a,3
		ld	(editsubmode),a
		call	reset_cursor_patternbox
		jr.	processkey_patterneditor_END
1:
	;--- CTRL + L - Pattern Length
	cp	_CTRL_L
	jr.	nz,1f
		ld	a,(editsubmode)
		and	a
		jr.	nz,99f
		call	save_cursor
99:		ld	a,4
		ld	(editsubmode),a
		call	reset_cursor_patternbox
		jr.	processkey_patterneditor_END
1:
	;--- CTRL + S - Song speed
	cp	_CTRL_S
	jr.	nz,1f
		ld	a,(editsubmode)
		and	a
		jr.	nz,99f
		call	save_cursor
99:		ld	a,5
		ld	(editsubmode),a
		call	reset_cursor_patternbox
		jr.	processkey_patterneditor_END
1:
	;--- CTRL + O - Octave
	cp	_CTRL_O
	jr.	nz,1f
		ld	a,(editsubmode)
		and	a
		jr.	nz,99f
		call	save_cursor
99:		ld	a,6
		ld	(editsubmode),a
		call	reset_cursor_patternbox
		jr.	processkey_patterneditor_END
1:
	;--- CTRL + D - Pattern order list
	cp	_CTRL_D
	jr.	nz,1f
_ppp_orderlist:
		ld	a,(editsubmode)
		and	a
		jr.	nz,99f
		call	save_cursor
99:		ld	a,7
		ld	(editsubmode),a
		call	reset_cursor_orderbox
		jr.	processkey_patterneditor_END
1:
	;--- CTRL + R - Restart/loop
		cp	_CTRL_R
	jr.	nz,1f
		ld	a,(editsubmode)
		and	a
		jr.	nz,99f
		call	save_cursor
99:		ld	a,8
		ld	(editsubmode),a
		call	reset_cursor_patternbox
		jr.	processkey_patterneditor_END
1:
	;--- CTRL + A - Add (rows after input to cursor)
	cp	_CTRL_A
	jr.	nz,1f
		ld	a,(editsubmode)
		and	a
		jr.	nz,99f
		call	save_cursor
99:		ld	a,9
		ld	(editsubmode),a
		call	reset_cursor_patternbox
		jr.	processkey_patterneditor_END
1:
	;--- CTRL + T - Step edit
	cp	_CTRL_T
	jr.	nz,1f
		ld	a,(editsubmode)
		and	a
		jr.	nz,99f
		call	save_cursor
99:		ld	a,10
		ld	(editsubmode),a
		call	reset_cursor_patternbox
		jr.	processkey_patterneditor_END
1:
	;--- CTRL + I - Instruments
	cp	_CTRL_I
	jr.	nz,1f
_ppp_instruments:	
		ld	a,(editsubmode)
		and	a
		jr.	nz,99f
		call	save_cursor
99:		ld	a,11
		ld	(editsubmode),a
		call	reset_cursor_instrumentbox
		jr.	processkey_patterneditor_END
1:
	;--- CTRL + M - Volume balance mixer
	cp	_CTRL_M
	jr.	nz,1f
		ld	a,(editsubmode)
		and	a
		jr.	nz,99f
		call	save_cursor
99:		ld	a,12
		ld	(editsubmode),a
		call	reset_cursor_songbox
		jr.	processkey_patterneditor_END
1:
	; CTRL-HOME
	;--- Check here the skey's
	ld	a,(skey)
	cp	2		;HOME
	jr.	nz,0f

	;-- restore the cursor from the stack if editsubmode>0
	ld	a,(editsubmode)
	and	a
	jr.	z,99f
	call	restore_cursor
99:
	
	; To start of pattern
	xor	a
	ld	(song_order_pos),a
	ld	hl,song_order
	ld	a,(hl)
	ld	(song_pattern),a	
	jr.	_pkp_home_cont

0:	

	
	;--- Check here the other combinations	
97:	; when no CTRL was pressed

	;--- Check here the skey's
	ld	a,(skey)
	cp	2		;HOME
	jr.	nz,0f

	;-- restore the cursor from the stack if editsubmode>0
	ld	a,(editsubmode)
	and	a
	jr.	z,99f
	call	restore_cursor
99:
_pkp_home_cont:
	; To start of pattern
	; save current column values
	ld	bc,(cursor_input)	; get input AND column
	ld	a,(cursor_x)
	ld	d,a
	ld	a,(cursor_type)
	ld	e,a	 

	push	de
	push	bc

	call	flush_cursor
	call	reset_cursor_trackbox
	
	;-- restore column values
	pop	bc
	pop	de
	ld	(cursor_input),bc
	ld	a,d
	ld	(cursor_x),a
	ld	a,e
	ld	(cursor_type),a
	
	call	reset_selection		
	call	build_order_list
	call	update_patterneditor
	jr.	processkey_patterneditor_END

0:		

	;--- End the CTRL and skey checks
	ld	a,(key)
	;--- '`' - Pattern order list
	cp	0x60	;"`"
	jr.	nz,1f
	ld	a,(editmode)
	cp	7
	ld	a,(key)
	jr.	nz,_ppp_orderlist
	
	;--- Instrument select
;1:	cp	_KEY_TAB
;	jr.	nz,1f
;	ld	a,(editmode)
;	cp	11
;	ld	a,(key)
;	jr.	nz,_ppp_instruments

1:
	cp	_SPACE
	jr.	nz,1f
	;--- only if we are editing
	ld	a,(editsubmode)
	and	a
	jr.	nz,1f
	ld	a,(keyjazz)
	xor 	1
	ld	(keyjazz),a
	jr.	set_textcolor		
1:


	;--- dispatch to editmode handler
	ld	a,(editsubmode)
	and	a	
	jr.	nz,0f
	;--- Track edit mode
		jr.	process_key_trackbox	
0:	dec	a
	jr.	nz,0f
	;--- Song name
		call	process_key_songbox
		jr.	processkey_patterneditor_END	
0:	dec	a
	jr.	nz,0f
	;--- Song by
		call	process_key_songbox
		jr.	processkey_patterneditor_END		
0:
	dec	a
	jr.	nz,0f
	;--- Pattern number
		call	process_key_patternbox_pattern
		jr.	processkey_patterneditor_END		
0:
	dec	a
	jr.	nz,0f
	;--- Pattern length
		call	process_key_patternbox_length
		jr.	processkey_patterneditor_END		
0:
	dec	a
	jr.	nz,0f
	;--- Pattern speed
		call	process_key_patternbox_speed
		jr.	processkey_patterneditor_END		
0:
	dec	a
	jr.	nz,0f
	;--- Pattern octave
		call	process_key_patternbox_octave
		jr.	processkey_patterneditor_END		
0:
	dec	a
	jr.	nz,0f
	;--- Pattern order list
		call	process_key_orderbox
		jr.	processkey_patterneditor_END		
0:
	dec	a
	jr.	nz,0f
;	;--- Restart (order loop) 
		call	process_key_patternbox_restart
		jr.	processkey_patterneditor_END		
0:
	dec	a
	jr.	nz,0f
	;--- Add edit 
		call	process_key_patternbox_add
		jr.	processkey_patterneditor_END		
0:
	dec	a
	jr.	nz,0f
	;--- Pattern step
		call	process_key_patternbox_step
		jr.	processkey_patterneditor_END		
0:
	dec	a
	jr.	nz,0f
	;--- Instruments
		call	process_key_instrumentbox
		jr.	processkey_patterneditor_END		
0:
	dec	a
	jr.	nz,0f
	;--- Volume balance
		call	process_key_songbox_volume
		jr.	processkey_patterneditor_END		
0:


	
processkey_patterneditor_END:
	ret	


	
