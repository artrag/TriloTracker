;================================
; The new replayer.
;
; Persistent RAM unswappable
;
;================================
_SP_Storage	dw	0	; to store the SP

replay_key				db 0			; key to test for stopping sound
replay_line				db 0			; local playing line to sync visual playback
replay_speed 			db 2			; speed to replay (get from song)
replay_speed_subtimer 		db 0			; counter for finer speed
replay_speed_timer 		db 0 			; counter for speed
replay_mode 			db 0			; Replayer status
; mode 0  = no sound output
; mode 1  = replay song 
; mode 2  = instrument key jazz
; mode 4  = pattern keyjazz
; mode 5  = replay song step based  


replay_patpointer 		dw 0			; pointer to the data
replay_patpage 			db 0 			; the current page
replay_previous_note		db 0			; previousnote played
replay_mainvol			db 0			; the volume correction.

;replay_vib_table			dw 0			; pointer to the vibrato table
replay_Tonetable			dw TRACK_ToneTable

replay_morph_active		db 0			; flag to indicate morphing is active
replay_morph_type			db 0			; 0 = from start from currenr waveform. 1= continue from waveform in SCC Register
replay_morph_timer		db 0			; step timer between morphs
replay_morph_speed		db 0 
replay_morph_counter		db 0			; counter till end morph
replay_morph_buffer		ds 64,0		; interleaved buffer with morphed waveform and morph delta values
replay_morph_waveform		db 0 			; waveform we are morphin to.
replay_arp_speed			db 0			; counter for arp speed

;replay_sample_num			db 0 			; Current sample deeing played 
;replay_sample_active		db 0			; 0 = inactive, 1 update, -1 init
;replay_sample_waveoffset	db 0			; Offset for the waveform beeing used.
;replay_sample_period		dw 0			; Pointer to the period data
;replay_sample_data		dw 0			; Pointer to the waveform data

TRACK_Instrument		equ 0	
TRACK_Waveform		equ 1

TRACK_Command		equ 2
TRACK_MacroPointer	equ 3	
TRACK_Note			equ 5	
TRACK_Volume		equ 6	
TRACK_Flags			equ 7	
_TRG_NOT:		equ	0		; 0 = note trigger
_ACT_NOT:		equ	1		; 1 = note active
	; 2 = morph active		;-< for SCC when 1 then waveform is followin morph buffer
_TRG_CMD:		equ	3	; 3 = command trigger
_ACT_MOR:		equ 	4		; 4 = Morph follow active
	; 5 = instrument trigger
_TRG_WAV:		equ	6		; 6 = waveform trigger
_PSG_SCC:		equ   7		; 7 = PSG/SCC
TRACK_MacroStep		equ 8			; reset after note set
TRACK_ToneAdd		equ 9			; reset after note set
TRACK_VolumeAdd		equ 11		; reset after note set
TRACK_Noise			equ 12		; reset after note set

TRACK_cmd_ToneSlideAdd	equ 13		; reset after note set
;TRACK_cmd_VolumeSlideAdd	equ 15		; reset after note set
TRACK_cmd_NoteAdd		equ 15		; reset after note set
TRACK_cmd_ToneAdd		equ 16		; reset after note set
TRACK_cmd_VolumeAdd	equ 18		; reset after note set
TRACK_cmd_0			equ 19
TRACK_cmd_1			equ 20
TRACK_cmd_2			equ 21
TRACK_cmd_3			equ 22
TRACK_cmd_4_depth		equ 23
TRACK_cmd_4_step		equ 25
;TRACK_cmd_6			equ 26
TRACK_cmd_detune		equ 26

TRACK_cmd_9			equ 28
TRACK_cmd_A			equ 29		
TRACK_cmd_B			equ 30		
TRACK_cmd_E			equ 31
;TRACK_cmd_F		equ 31
TRACK_Timer			equ 32		; used for timing by all cmd's
TRACK_Step			equ 33		; only for VIBRATO???

TRACK_REC_SIZE		equ 34

TRACK_Chan1			ds	TRACK_REC_SIZE
TRACK_Chan2			ds	TRACK_REC_SIZE
TRACK_Chan3			ds	TRACK_REC_SIZE
TRACK_Chan4			ds	TRACK_REC_SIZE
TRACK_Chan5			ds	TRACK_REC_SIZE
TRACK_Chan6			ds	TRACK_REC_SIZE
TRACK_Chan7			ds	TRACK_REC_SIZE
TRACK_Chan8			ds	TRACK_REC_SIZE


;AY_duty1		db	0
;AY_duty2		db	0
;AY_duty3		db	0
;psgmode		db	0
;AY_NoiseOR		db	0
;AY_NoiseAND		db	0


DrumMixer

;--- AY SPECIFIC
AY_registers 
AY_regToneA 	dw	0	; Tone A freq low (8bit)
					; Tone A freq high (4bit)
AY_regToneB 	dw	0	; Tone B freq low
					; Tone B freq high
AY_regToneC 	dw	0	; Tone C freq low
					; Tone C freq high
AY_regNOISE 	db	0	; Noise freq (5bit)
AY_regMIXER 	db	0x38	;x3f	; Mixer control (1 = off, 0 = on)
AY_regVOLA 		db	0	; Chan A volume
AY_regVOLB 		db	0	; Chan B volume
AY_regVOLC  	db	0	; Chan C volume
AY_regEnvL 		db	1	; Volume Env Freq low (8bit)	
AY_regEnvH 		db	0	; Volume Env Freq high (4bit)
AY_regEnvShape 	db	0	; Volume Env Shape (4bit)

;--- SCC SPECIFIC
SCC_registers 
SCC_regToneA 	dw	0	; Tone A freq low (8bit)
					; Tone A freq high (4bit)
SCC_regToneB 	dw	0	; Tone B freq low
					; Tone B freq high
SCC_regToneC 	dw	0	; Tone C freq low
					; Tone C freq high
SCC_regToneD 	dw	0	; Tone D freq low
					; Tone D freq high
SCC_regToneE 	dw	0	; Tone E freq low
					; Tone E freq high
SCC_regVOLA 	db	0	; Chan A volume
SCC_regVOLB 	db	0	; Chan B volume
SCC_regVOLC  	db	0	; Chan C volume
SCC_regVOLD 	db	0	; Chan D volume
SCC_regVOLE  	db	0	; Chan E volume
SCC_regMIXER 	db	0	; x3f	; Mixer control (1 = off, 0 = on)

_WAVESSCC: 			ds	32*MAX_WAVEFORM

_AUDITION_LINE:
		db	0,0,0,0
		db	0,0,0,0
		db	0,0,0,0
		db	0,0,0,0
		db	0,0,0,0
		db	0,0,0,0
		db	0,0,0,0
		db	0,0,0,0
		

psgport:	db	0
;-- SCC registers
oldregs:	ds	32*4+3*5+1,255	; a way to int the SCC
newregs:
_0x9800:	ds	32
_0x9820:	ds	32
_0x9840:	ds	32
_0x9860:	ds	32
_0x9880:	ds	5*2
		ds	5*1
		ds	1

;===========================================================
; ---	replay_play
; Plays the	data according to	the current	replay_mode
; 
;
;===========================================================
replay_play:
	ld	a,(replay_mode)
	and	a
	ret	z	; Replay mode = 0	is silent
	
	dec	a
	jp	z,replay_mode1	; play music normal
	dec	a
	jp	z,replay_mode2	; keyjazz
	dec	a
	jp	z,replay_mode3	; note audition
	dec	a
	jp	z,replay_mode4	; [ENTER] looped play
	dec	a
	jr.	z,replay_mode5	;  Stepped playback
	;--- DEBUG
	XOR	A
	LD	(replay_mode),A
	ret
	
;===========================================================
; ---	replay_init
; Initialize all data for playback
; 
; 
;===========================================================
replay_init:
	; fail save. Check if the replayer is loaded in RAM

	ld	a,(swap_block)
	and	a
	jp	z,replay_init_cont	; loaded; continue to loaded code.
	
	xor	a
	call	swap_loadblock
	
	jp	replay_init_cont
	
	
;===========================================================
; ---	replay_stop
; Silence all channels
; 
; 
;===========================================================
replay_stop:
	xor	a
	ld	(replay_mode),a	
	
	;--- Silence the SCC chip
	ld	(SCC_regMIXER),a

	;--- Silence the AY3 PSG chip
	ld	a,0x3f
	ld	(AY_regMIXER),a



	ret	
	