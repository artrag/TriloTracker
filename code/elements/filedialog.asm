;===========================================================
; --- draw_filedialog
; Display the sequence area.  Without actual values 
; 
;===========================================================
draw_filedialog:

	;filemessage/input
	ld	hl,(80*2)+0
	ld	de,(58*256) + 2
	call	draw_box	
	ld	hl,0x0002
	ld	de,0x3903
	call	draw_colorbox	
	
	;directory
	ld	hl,(80*4)+0
	ld	de,(58*256) + 1
	call	draw_box	
	ld	hl,0x0004
	ld	de,0x3901
	call	draw_colorbox		
	
	
	;rightside bar
	ld	hl,0x3902
	ld	de,0x1718
	call	draw_colorbox	
	 
	;new song area 
	ld	hl,(80*2)+57
	ld	de,(23*256) + 2
	call	draw_box	
	ld	hl,0x3a03
	ld	de,0x1501
	call	erase_colorbox	
	ld	hl,(80*3)+0x3b
	ld	de,_LABEL_DISKNEW
	call	draw_label	 
	 
	 
	;song area
	ld	hl,(80*4)+57
	ld	de,(23*256) + 5
	call	draw_box	
	ld	hl,0x3a05
	ld	de,0x1504
	call	erase_colorbox	
	ld	hl,(80*5)+0x3b
	ld	de,_LABEL_DISKSONG
	call	draw_label
	inc	de
	ld	hl,(80*6)+0x3b
	call	draw_label
	inc	de	
	ld	hl,(80*7)+0x3b
	call	draw_label
	inc	de	
	ld	hl,(80*8)+0x3b
	call	draw_label	
	
	
	;wkit area
	ld	hl,(80*9)+57
	ld	de,(23*256) + 5
	call	draw_box	
	ld	hl,0x3a0a
	ld	de,0x1504
	call	erase_colorbox		
	ld	hl,(80*10)+0x3b	
	ld	de,_LABEL_DISKIMP
	call	draw_label
	inc	de
	ld	hl,(80*11)+0x3b
	call	draw_label
	inc	de	
	ld	hl,(80*12)+0x3b
	call	draw_label
	inc	de	
	ld	hl,(80*13)+0x3b
	call	draw_label	
	
	
	;drive name
	ld	hl,(80*14)+57
	ld	de,(23*256) + 2
	call	draw_box	
	ld	hl,0x3a0f
	ld	de,0x1501
	call	erase_colorbox	
	ld	hl,(80*15)+0x3b	
	ld	de,_LABEL_DISKDRIVE
	call	draw_label
	
	
	;Exit to DOS
	ld	hl,(80*23)+57
	ld	de,(23*256) + 2
	call	draw_box	
	ld	hl,0x3a18
	ld	de,0x1501
	call	erase_colorbox	
	ld	hl,(80*24)+0x3b	
	ld	de,_LABEL_EXIT
	call	draw_label
	ret

_LABEL_DISKNEW:
	db	"New Song",0	
_LABEL_DISKSONG:
	db	"Load Song",0
	db	"Save Song",0
	db	"Load Backup",0
	db	"Delete Song",0
_LABEL_DISKIMP:
	db	"Import FastTracker2",0
	db	"Import MB1.4",0
	db	"---",0
	db	"---",0		

_LABEL_DISKDRIVE:
	db	"Drive:  :",0	
_LABEL_EXIT:
	db	"Exit to DOS",0	
	
;===========================================================
; --- update_filename
; Display the current filename.   
; 
;===========================================================
update_filename:
	ld	de,_FILENAMEMES
	ld	hl,(80*3)+2
	ld	b,45
	call	draw_label_fast

	ret



;===========================================================
; --- update_filedialog
; Display the sequence area.  Without actual values 
; 
;===========================================================
update_filedialog:
	;--- the current drive
	ld	hl,(80*4)+0
	ld	de,(58*256) + 1
	call	draw_box	
	
	ld	de,disk_workdir
	ld	hl,(80*15)+0x3b+7
	ld	b,1
	call	draw_label_fast

	;--- the current directory
	ld	de,buffer		; buffer has drive+path+wildcard
	ld	hl,(80*4)+2
	call	draw_label	

	;--- Show current menu selection
	ld	a,(menu_selection)
	cp	1
	jr.	c,_ufd_showselection
	inc	a
	cp	6
	jr.	c,_ufd_showselection
	inc	a
	cp	11
	jr.	c,_ufd_showselection
	inc	a
	cp	13
	jr.	c,_ufd_showselection
	add	8
	
_ufd_showselection:
	add	3
	ld	l,a
	ld	h,59
	ld	de,0x1301
	call	draw_colorbox


	call	update_filedialog_files


update_filedialog_END:
	ret
	

;===========================================================
; --- update_filedialog_fileselection
; Display the file select cusor
; 
;===========================================================
update_filedailog_fileselection:
	; draw the file selector
	
	;--- Check if we have found anything
	ld	a,(disk_entries)
	and	a
	ret	z
	
	ld	a,(file_selection)
	ld	c,a
	
	and	0x03
	jr.	z,0f

	ld	b,a
	
99:	add	13
	djnz	99b
	
0:	
	ld	h,a
	ld	a,c
	and	0xfc
	rrca
	rrca

	add	6
	ld	l,a	

	ld	de,0x0e01	
	call	draw_colorbox		

	ret
	
;===========================================================
; --- update_filedialog_files
; Display the files found.
; 
;===========================================================
update_filedialog_files:
	;--- show the found files.
	
	ld	hl,(80*6)+0
	ld	de,buffer+192
	
	ld	a,(disk_entries)
	and	a
	jr.	z,_fd_noentries
	
	ld	c,a
	xor	a
	ld	b,a
	push	bc	
1:		

	push	de
	push	hl
	
	ld	b,14
	call	draw_label_fast
	
	pop	hl
	pop	de
	pop	bc
	
	inc	b
	ld	a,b
	cp	c
	jr.	z,_fd_noentries
	
	push	bc
	and	3
	jr.	nz,3f
	ld	bc,38	
	jr.	4f
3:
	ld	bc,14
4:
	add	hl,bc
	
	ld	a,14
	add	a,e
	ld	e,a
	jr.	nc,0f
	inc	d
0:	
	jr.	1b	

	
_fd_noentries:	
	; erase the files area
	ld	hl,0x0005
	ld	de,0x3915
	call	erase_colorbox		
	
	ret

	
;===========================================================
; --- init_filedialog
; Starts the file dialog  Without actual values 
; 
;===========================================================	
init_filedialog:

	ld	a,(editmode)
	cp	5
	ret	z

	call	save_cursor

	; erase workingdir display.
	xor	a
	ld	(buffer),a	

	; --- Init values
	ld	a,5
	ld	(editmode),a
	ld	a,0
	ld	(editsubmode),a	
	ld	(file_selection),a
	ld	(disk_entries),a	
	inc	a
	ld	(menu_selection),a
	
	
	call 	reset_cursor_filedialog
	call	clear_screen
	call	draw_filedialog
	
	; fill buffer with information
	ld	de,_TMU_WILDCARD
	call	set_wildcard
	
;	ld	de,_FILMES_retrieve
;	call	message_filedialog
;	call	get_dir
	ld	de,_FILMES_none
	call	message_filedialog	
	
	; show this information	
	call	update_filedialog

	ret
	
	
;===========================================================
; --- processkey_filedialog
; input handling
; 
;===========================================================
processkey_filedialog:

	ld	a,(editsubmode)
	;-- special check for filename
	cp	255
	jr.	z,processkey_filedialog_filename
	
	and	a
	jr.	z,processkey_filedialog_menu		;--- Menu select
	;dec	a
	jr.	processkey_filedialog_selectfile	;--- File select
	
	ret

_FILENAMEMES:	db "Please enter the filename: "
_FILENAME:	db	"filename          "
_FILEX	equ	29
;===========================================================
; --- processkey_filedialog_filename
; input filename handling
; 
;===========================================================
processkey_filedialog_filename:

	ld	a,(editsubmode)
	cp	255
	jr.	z,_pff_no_init
	
	;--- erase the filename
	ld	hl,_FILENAME
	ld	b,8
	ld	a," "
88:
	ld	(hl),a
	inc	hl
	djnz	88b

	;-- Display the current file extension.
	ld	de,disk_wildcard+1
	ld	b,4
88:
	ld	a,(de)
	inc	de
	ld	(hl),a
	inc	hl
	djnz	88b	

	;--- set the cursor and editsubtype
	ld	a,255
	ld	(editsubmode),a
	ld	a,_FILEX
	ld	(cursor_x),a
	ld	a,3
	ld	(cursor_y),a
	ld	a,1
	ld	(cursor_type),a
	;--- make a box to enter the filename
	ld	hl,0x1D03
	ld	de,0x0801
	call	erase_colorbox	
	
	
	
_pff_no_init:

	ld	a,(key)
	;--- Check if edit is ended.
	cp	_ESC
	jr.	nz,99f
88:		ld	a,2	; save menu
		ld	(editsubmode),a
		call	reset_cursor_filedialog
		ld	de,_FILMES_select_save
		call	message_filedialog
		;--- Erase the filename input box
	;	ld	hl,0x1D03
	;	ld	de,0x0801
	;	call	draw_colorbox
		jr.	processkey_filedialog_filename_END
99:
	ld	hl,_FILENAME


	;--- Check if edit is submitted
	cp	_ENTER
	jr.	nz,99f
	
		ld	hl,_FILENAME
		ld	a,(cursor_x)
		sub	_FILEX+1
		add	a,l
		ld	l,a
		jr.	nc,44f
		inc	h
44:
		inc	hl
		;now add the extension
		ld	de,disk_wildcard+1
		ld	b,4
77:
		ld	a,(de)
		inc	de
		ld	(hl),a
		inc	hl
		djnz	77b	


	;	inc	hl
		ld	(hl),0
		ld	hl,_FILENAME
		
		;--- we reuse this file input routine for all file types.
		;    se we need to check the extention before saveing.
		call	check_extension
		
		and	a
0:		jr.	nz,0f
		call	create_tmufile
;		ld	a,(current_song)
		call	set_songpage
		jr.	restore_filedialog
0:		dec	a
		jr.	nz,0f
		call	create_infile
;		ld	a,(current_song)
		call	set_songpage
		jr.	restore_insfiledialog
			
0:		dec	a
		jr.	nz,0f
		call	create_insfile
;		ld	a,(current_song)
		call	set_songpage
		jr.	restore_insfiledialog	
0:		dec	a
		jr.	nz,0f
		call	create_mafile
;		ld	a,(current_song)
		call	set_songpage
		jr.	restore_insfiledialog	
0:		dec	a
		jr.	nz,0f
		call	create_masfile
;		ld	a,(current_song)
		call	set_songpage
		jr.	restore_insfiledialog	
0:		dec	a
		jr.	nz,0f
		call	create_wafile
;		ld	a,(current_song)
		call	set_songpage
		jr.	restore_insfiledialog	
0:		dec	a
		jr.	nz,0f
		call	create_wasfile
;		ld	a,(current_song)
		call	set_songpage
		jr.	restore_insfiledialog	
	
		; if all fails.	
;		ld	a,(current_song)
		call	set_songpage

		jr.	restore_filedialog
	
99:
	;--- Backspace
	cp	_BACKSPACE
	jr.	nz,99f


		; get location in RAM
;		ld	b,a
		ld	a,(cursor_x)
		sub	_FILEX+1
		add	a,l
		ld	l,a
		jr.	nc,88f
		inc	h
88:
		; move cursor (if possible)
		ld	a,(cursor_x)
		cp	_FILEX+1
		jr.	c,77f		
		dec	a
		ld	(cursor_x),a
77:		
		ld	(hl),32
		call	update_filename
		jr.	processkey_filedialog_filename_END

99:
	;--- All other (normal) keys
	cp	"!"
	jr.	z,_foundvalidchar
	cp	"#"
	jr.	c,processkey_filedialog_filename_END
	cp	"'"+1
	jr.	c,_foundvalidchar
	cp	"-"
	jr.	z,_foundvalidchar
	cp	"0"
	jr.	c,processkey_filedialog_filename_END
	cp	":"
	jr.	c,_foundvalidchar	
	cp	"?"
	jr.	c,processkey_filedialog_filename_END
	cp	"Z"+1
	jr.	c,_foundvalidchar
	cp	"^"
	jr.	c,processkey_filedialog_filename_END
	cp	"~"+1
	jr.	nc,processkey_filedialog_filename_END

_foundvalidchar:
	;--- Make capitals
	cp	"a"
	jr.	c,77f
	cp	"z"+1
	jr.	nc,77f
	sub	32
77:
	
	ld	b,a
	ld	a,(cursor_x)
	sub	_FILEX
	add	a,l
	ld	l,a
	jr.	nc,88f
	inc	h
88:
		ld	a,(cursor_x)
		cp	_FILEX+8
		jr.	nc,22f
		call	flush_cursor
		inc	a
		ld	(cursor_x),a
99:	ld	(hl),b
22:	call	update_filename
	jr.	processkey_filedialog_filename_END

0:			
processkey_filedialog_filename_END:
	ret







;===========================================================
; --- processkey_filedialog_menu
;
; 
;===========================================================
processkey_filedialog_menu:
	ld	a,(key)
	
	; - ESCAPE
	cp	_ESC
	jr.	nz,0f
	; escape 
		call	restore_patterneditor
		jr.	processkey_filedialog_fileselect_END
0:
	; - UP
	cp	_KEY_UP
	jr.	nz,0f
	;up
		ld	a,(menu_selection)
		and	a
		jr.	z,processkey_filedialog_menu_END	; no update
		dec	a
		ld	(menu_selection),a
		;--- erase the menu selection	
777:		call	reset_cursor_filedialog
		ld	hl,0x3a03
		ld	de,0x1501
		call	erase_colorbox
		ld	hl,0x3a05
		ld	de,0x1504
		call	erase_colorbox	
		ld	hl,0x3a0a
		ld	de,0x1504
		call	erase_colorbox			
		ld	hl,0x3a0f
		ld	de,0x1501
		call	erase_colorbox	
		ld	hl,0x3a18
		ld	de,0x1501
		call	erase_colorbox				
		jr.	_pfd_m_END	
0:
	; - down
	cp	_KEY_DOWN
	jr.	nz,0f
	;down
		ld	a,(menu_selection)
		cp	10
		jr.	nc,processkey_filedialog_menu_END	; no update
		inc	a
		ld	(menu_selection),a
		jr.	777b
0:
	; - right
	cp	_KEY_RIGHT
	jr.	nz,0f	
	;--- check if we are at drive select
;	ld	a,(menu_selection)
;	cp	8
;	jr.	nz,processkey_filedialog_menu_END
	;--- get next drive
	ld	a,(disk_drives)		; contains the available drives.
	ld	b,a
	ld	d,1
	
	ld	a,(disk_workdir)		; the drive name is in the buffer
	sub	65
	ld	c,a
	jr.	_fd_drive_change

0:
	; - left
	cp	_KEY_LEFT
	jr.	nz,0f	
	;--- check if we are at drive select
;	ld	a,(menu_selection)
;	cp	8
;	jr.	nz,processkey_filedialog_menu_END
	;--- get next drive
	ld	a,(disk_drives)		; contains the available drives.
	ld	b,a
	ld	d,-1
	
	ld	a,(disk_workdir)		; the drive name is in the buffer
	sub	65
	ld	c,a
	
_fd_drive_change:	
	;-- translate current drive to bit mask
	and	a
	jr.	z,_fd_drive_loop
_fd_drive_l:
	rrc	b
	dec	a
	jr.	nz,_fd_drive_l

	;-- apply mask and shift till next drive.
	
_fd_drive_loop:
	ld	a,d
	cp	-1
	jr.	nz,_fd_drive_fw

	;--- backward
	rlc	b
	dec	c
	jr.	_fd_drive_check

_fd_drive_fw:
	;--- forward
	inc	c
	rrc	b	

_fd_drive_check:
	ld	a,c
	and	$07
	ld	c,a

	bit	0,b
	jr.	z,_fd_drive_loop

	xor	a
	ld	(window_shown),a
	;--- set the new drive
	ld	a,c
	call 	select_drive
	
	ld	a,(window_shown)
	and	a
	jp	nz,restore_filedialog
	
	;--- no erorr was shown.
	ld	de,_FILMES_none
	call	message_filedialog
	call	reset_cursor_filedialog
	jr.	_pfd_m_END


	
0:
	; --- ENTER
	cp	_KEY_ENTER
	jr.	z,99f
	cp	_SPACE	
	jr.	nz,processkey_filedialog_menu_END
99:	
	;-- reset selection cursor position.
	xor	a
	ld	(file_selection),a
	;--- Selection is made
	ld	a,(menu_selection)
	and	a
	jr.	z,0f
	dec	a
	jr.	z,1f
	dec	a
	jr.	z,2f
	dec	a
	jr.	z,3f
	dec	a
	jr.	z,4f
	dec	a
	jr.	z,5f		; import XM
	dec	a
	jr.	z,6f		; import mb1.4
	dec	a
	dec	a
	dec	a
	dec	a
	jp	z,8f		; exit to dos
	ret	

0:	;--- 0 = new song
;	ld	a,(current_song)
	call	new_song
	ld	a,5			; trick mode as it is set to 0 by new_song
	ld	(editmode),a
	call	restore_patterneditor
	jr.	reset_cursor_trackbox
	
1:	;--- 1 = load file
	ld	a,1
	ld	(editsubmode),a	
	call	reset_cursor_filedialog
	
	;	; fill buffer with information
	ld	de,_TMU_WILDCARD
	call	set_wildcard
	ld	de,_FILMES_retrieve
	call	message_filedialog
	xor	a
	ld	(window_shown),a
	call	get_dir
	ld	a,(window_shown)
	and	a
		call	nz,restore_filedialog
	ld	de,_FILMES_select_open
	call	message_filedialog
	
	call	update_filedialog	
	jr.	update_filedailog_fileselection

2:	;--- 2 = save file
	ld	a,2
	ld	(editsubmode),a
	call	reset_cursor_filedialog
	
	; fill buffer with information
	ld	de,_TMU_WILDCARD
	call	set_wildcard
	ld	de,_FILMES_retrieve
	call	message_filedialog
	xor	a
	ld	(window_shown),a
	dec	a
	ld	(suppress_filenotfound),a
	call	get_dir
	xor	a
	ld	(suppress_filenotfound),a
	ld	a,(window_shown)
;	and	a
;		call	nz,restore_filedialog
	ld	de,_FILMES_select_save
	call	message_filedialog
	
	call	update_filedialog	
	jr.	update_filedailog_fileselection
		
3:	;--- 3 = load backup	
	ld	a,1
	ld	(editsubmode),a	
	call	reset_cursor_filedialog
	
	;	; fill buffer with information
	ld	de,_TM_WILDCARD
	call	set_wildcard
	ld	de,_FILMES_retrieve
	call	message_filedialog
	xor	a
	ld	(window_shown),a
	call	get_dir
	ld	a,(window_shown)
	and	a
		call	nz,restore_filedialog
	ld	de,_FILMES_select_open
	call	message_filedialog
	
	call	update_filedialog	
	jr.	update_filedailog_fileselection

4:	;--- 4 = delete file
	ld	a,3
	ld	(editsubmode),a	
	call	reset_cursor_filedialog
	
	;	; fill buffer with information
	ld	de,_DEL_WILDCARD
	call	set_wildcard
	ld	de,_FILMES_retrieve
	call	message_filedialog
	xor	a
	ld	(window_shown),a
	call	get_dir
	ld	a,(window_shown)
	and	a
		call	nz,restore_filedialog
	ld	de,_FILMES_select_delete
	call	message_filedialog
	
	call	update_filedialog	
	jr.	update_filedailog_fileselection
	
5:	;--- 5 = import xm
	ld	a,4
	ld	(editsubmode),a	
	call	reset_cursor_filedialog
	
	ld	a,2
	call	swap_loadblock
	
	
	;	; fill buffer with information
	ld	de,_XM_WILDCARD
	call	set_wildcard
	ld	de,_FILMES_retrieve
	call	message_filedialog
	xor	a
	ld	(window_shown),a
	call	get_dir
	ld	a,(window_shown)
	and	a
		call	nz,restore_filedialog
	ld	de,_FILMES_select_open
	call	message_filedialog
	
	call	update_filedialog	
	jr.	update_filedailog_fileselection	

6:	;--- 6 = import mbm
	ld	a,5
	ld	(editsubmode),a
	call	reset_cursor_filedialog
	
	ld	a,1
	call	swap_loadblock
	;--- fill buffer with files
	ld	de,_MBM_WILDCARD
	call	set_wildcard
	ld	de,_FILMES_retrieve
	call	message_filedialog
	xor	a
	ld	(window_shown),a
	call	get_dir
	ld	a,(window_shown)
	and	a
		call	nz,restore_filedialog
	ld	de,_FILMES_select_open
	call	message_filedialog
	
	call	update_filedialog	
	jr.	update_filedailog_fileselection

	; return to dos
8:	
	call	reset_hook
	ld	a,(prim_slot)
	ld	h,$80
	call	enaslt
	ld	a,(org_page)
	call	PUT_P2
	
	

	;iniplt
	ld	iy,(EXPTBL-1)       ;BIOS slot in iyh
     	ld	ix,$0141             ;address of BIOS routine
	call	CALSLT 

	; set scr 0 
	ld	iy,(EXPTBL-1)       ;BIOS slot in iyh
      ld	ix,$006c             ;address of BIOS routine
	ld	a,0
      call	CALSLT              ;interslot call	

	; txt mode (to previous)
	ld	iy,(EXPTBL-1)       ;BIOS slot in iyh
      ld	ix,$0078             ;address of BIOS routine
      call	CALSLT              ;interslot call	

	;kill buffer
	ld	iy,(EXPTBL-1)       ;BIOS slot in iyh
      ld	ix,$0156             ;address of BIOS routine
      call	CALSLT              ;interslot call
	
	;--- return to DOS
	jp	0
	
	

	; restore the VDP
	
CALSLT:      EQU    #001C
EXPTBL:      EQU    #FCC1
	;ret



0:
_pfd_m_END:
	jr.	update_filedialog
	
processkey_filedialog_menu_END:
	ret

;===========================================================
; --- processkey_filedialog_selectfile
;
; 
;===========================================================
processkey_filedialog_selectfile:
	ld	a,(key)
	
	; - ESCAPE
	cp	_ESC
	jr.	nz,0f
	; escape 
_restore_after_error:
		xor	a
		ld	(editsubmode),a
		ld	(disk_entries),a
		call	_fd_noentries
		call	reset_cursor_filedialog
		ld	de,_FILMES_none
		call	message_filedialog
		jr.	update_filedialog
0:	
	
	; - Left
	cp	_KEY_LEFT
	jr.	nz,0f
	; left key
	ld	a,(file_selection)
	and	a
	ret	z	; no update
	dec	a
	ld	(file_selection),a
	jr.	_pfd_sf_END
0:
	; - Right
	cp	_KEY_RIGHT
	jr.	nz,0f
	; left right
	ld	a,(disk_entries)
	dec	a
	ld	b,a
	ld	a,(file_selection)
	cp	b
	ret	nc	; no update
	inc	a
	ld	(file_selection),a
	jr.	_pfd_sf_END	
0:
	; - UP
	cp	_KEY_UP
	jr.	nz,0f
	;up
		ld	a,(file_selection)
		cp	4
		jr.	c,processkey_filedialog_fileselect_END	; no update
		sub	4
		ld	(file_selection),a
		jr.	_pfd_sf_END	
0:
	; - down
	cp	_KEY_DOWN
	jr.	nz,0f
	;down
		ld	a,(disk_entries)
		ld	b,a
		ld	a,(file_selection)
		add	4
		cp	b
		jr.	nc,processkey_filedialog_fileselect_END	; no update
		ld	(file_selection),a
		jr.	_pfd_sf_END	
0:
	;--- Type filename check
	cp	"!"
	jr.	z,_pfs_foundvalidchar
	cp	"#"
	jr.	c,0f
	cp	"'"+1
	jr.	c,_pfs_foundvalidchar
	cp	"-"
	jr.	z,_pfs_foundvalidchar
	cp	"0"
	jr.	c,0f
	cp	":"
	jr.	c,_pfs_foundvalidchar	
	cp	"?"
	jr.	c,0f
	cp	"Z"+1
	jr.	c,_pfs_foundvalidchar
	cp	"^"
	jr.	c,0f
	cp	"~"+1
	jr.	nc,0f

_pfs_foundvalidchar:
	ld	b,a
	ld	a,(editsubmode)
	cp	2
	ld	a,b
	jr.	z,processkey_filedialog_filename	


0:

	;- Enter
	cp	_KEY_ENTER
	jr.	z,99f
	cp	_SPACE
	jr.	nz,processkey_filedialog_fileselect_END
	
99:	ld	hl,buffer+192		; calculate filename pos in the buffer
	ld	a,(file_selection)	; selected file
	and	a
	jr.	z,1f
	ld	b,a
	ld	de,14			; length in buffer of a name
_pfd_eloop:
		add	hl,de		
		djnz	_pfd_eloop
	
1:	ld	a,(hl)			; check first char of filename (type)
	inc	hl
	cp	">"			; it the start contains a "\" then it is a dir	
	jr.	z,_pfd_sf_DIR
	
	;==================================
	;--- Determin the action to execute
	;
	;==================================
	ld	a,(editsubmode)
	dec	a
	jr.	z,_pfd_LOAD
	dec	a
	jr.	z,_pfd_SAVE
	dec	a
	jr.	z,_pfd_DELETE
	dec	a
	jr.	z,_pfd_IMPORTXM
	dec	a
	jr.	z,_pfd_IMPORTMBM
	;--- Add more actions here
	
_pfd_LOAD:	
	xor	a
	ld	(window_shown),a
	;--- LOAD A SONG
	push	hl
;	ld	a,(current_song)
	call 	new_song
	ld	a,5
	ld	(editmode),a
	pop	hl

	ld	de,_FILMES_loading
	call	message_filedialog
	call	open_tmufile		; hl needs to point to the filename 
	
	call	clear_clipboard	
	;--- if loading was succesfull return to pattern editor
	ld	a,(window_shown)
	and	a
	jp	nz,restore_filedialog

	;-- just go to patern editor on success
	call	cursorstack_init
	jr.	init_patterneditor

	;--- SAVE A SONG
_pfd_SAVE:	
	
	ld	de,_FILMES_saving
	call	message_filedialog
	call	save_tmufile		; hl points to filename

;	xor	a
;	ld	(editsubmode),a
;	jr.	_pfd_sf_END
;	ld	a,(current_song)
	call	set_songpage

	jr.	restore_filedialog

_pfd_IMPORTXM:	
	xor	a
	ld	(window_shown),a
	;--- IMPORT XM SONG
	push	hl
;	ld	a,(current_song)
	;-- only erase patterns (save current instruments
	;	as we do not import any form the XM)
	call	clear_patterns
;	call 	new_song
	ld	a,5
	ld	(editmode),a
	pop	hl

	ld	de,_FILMES_loading
	call	message_filedialog
	call	open_xmfile		; hl needs to point to the filename 

;	ld	a,(current_song)
	call	set_songpage	
;	call	clear_clipboard	
	;--- go to the start of the song.
	xor	a
	ld	(song_order_pos),a
	call	reset_cursor_trackbox		
	
	;--- if loading was succesfull return to pattern editor
	ld	a,(window_shown)
	and	a
	jp	nz,restore_filedialog

	;-- just go to patern editor on success
	call	cursorstack_init
	jr.	init_patterneditor

	
;	jr.	restore_patterneditor

_pfd_IMPORTMBM:	
	;--- IMPORT MBM SONG
	push	hl
;	ld	a,(current_song)
	;-- only erase patterns (save current instruments
	;	as we do not import any form the XM)
	call	clear_patterns
;	call 	new_song
	ld	a,5
	ld	(editmode),a
	pop	hl

	ld	de,_FILMES_loading
	call	message_filedialog
	call	open_mbmfile		; hl needs to point to the filename 

;	ld	a,(current_song)
	call	set_songpage	
;	call	clear_clipboard	
	
	;--- go to the start of the song.
	xor	a
	ld	(song_order_pos),a
	call	reset_cursor_trackbox	
	
	jr.	restore_patterneditor


	
_pfd_DELETE:
	ld	de,_FILMES_deleting
	call	message_filedialog
	call	delete_tmufile		; hl points to filename
;	ld	a,(current_song)
	call	set_songpage

	jr.	restore_patterneditor


_pfd_sf_DIR:
	call	open_directory
	xor	a
	ld	(file_selection),a
	call	update_filedialog	
	call 	update_filedailog_fileselection

	jr.	_pfd_sf_END


0:
_pfd_sf_END:
	call	_fd_noentries
	call	update_filedailog_fileselection
processkey_filedialog_fileselect_END:
	ret
	
	
	
	
;===========================================================
; --- reset_cursor_filedialog
;
; Reset the cursor 
; 
;===========================================================
reset_cursor_filedialog:
	call	flush_cursor
	
	ld	a,(editsubmode)
	and	a
	jr.	nz,0f	
	;--- Menu slection
		ld	a,2
		ld	(cursor_type),a
		ld	a,76
		ld	(cursor_x),a
		ld	a,(menu_selection)
		cp	1
		jr.	c,99f
		inc	a
		cp	6
		jr.	c,99f
		inc	a
		cp	11
		jr.	c,99f
		inc	a
		cp	13
		jp	c,99f
		add	8
			
99:		add	3
		ld	(cursor_y),a
	ret
	
0:
;	dec	a
;	jr.	nz,0f
	;--- File selection	
		xor	a
		ld	(cursor_type),a
	ret
	
0:	
	

;===========================================================
; --- message_filedialog
;
; shows a message in the filedialog
; 
; DE contains the message start in RAM
;===========================================================
message_filedialog:
	push	hl
	push	bc
	push	af
	
	ld	hl,(80*3)+2
	ld	b,44
	call	draw_label_fast

	pop	af
	pop	bc
	pop	hl

	ret


;--- this restores after error, saving, delete etc.
restore_filedialog:
		call	clear_screen
		xor	a
		ld	(editsubmode),a
		ld	(disk_entries),a
		call	_fd_noentries
		call	reset_cursor_filedialog
		ld	de,_FILMES_none
		call	message_filedialog
		call	draw_filedialog
		jr.	update_filedialog		


suppress_filenotfound:
	db	0			; for suppressing file no found when saving a file and dir is retrieved.


_FILMES_retrieve:	
	db	"Retrieving folders and files...             " 
_FILMES_select_open:	
	db	"Please select a file to open.               "
_FILMES_select_save:
	db	"Please select a file to save or type a name."
_FILMES_select_delete:
	db	"Please select a file to delete."
_FILMES_input_name:
	db	"Save to filename :                          "
_FILMES_loading:
	db	"Opening file. Please wait...                "
_FILMES_saving:
	db	"Saving file. Please wait...                 "	
_FILMES_deleting:
	db	"Deleting file. Please wait...                 "	

_FILMES_importpat:
	db	"Importing pattern xx/yy... please wait.     "
_FILMES_importins:
	db	"Importing instrument xx/yy... please wait.  "
_FILMES_none:
	db	"                                            "	
	
	

	
	