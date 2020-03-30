
*****************************************************************************

; Name			: main.s
; Coded by		: Antiriad (Jonathan Bennett <jon@autoitscript.com)
; Description		: Entry point
				
*****************************************************************************

	INCLUDE "IntroConfig.i"
	INCLUDE "Framework/IntroLibrary.i"

; Additional external symbols 
	xref	LIB_NRV2S_Depack
	xref	LIB_NRV2R_Depack
	xref	LIB_LZ4_Depack
	xref	LIB_RNC_Depack
	xref	LIB_ArjM7_Depack
	xref	LIB_PackFire_Large_Depack
	xref	LIB_Cranker_Depack
	xref	LIB_Doynamite68k_Depack
	xref	LIB_Shrinkler_Depack

*****************************************************************************

	SECTION	Main_PublicCode,CODE	;Code section in Public memory

*****************************************************************************

Main:
	; TODO:
	; Timings and output of time. 
	lea	Input,a0
	lea	Output,a1
	jsr	LIB_NRV2S_Depack

	; Keep cli happy
	moveq	#0,d0
	rts

*****************************************************************************

	EVEN
Input:	INCBIN "AssetsConverted\test.bin.nrv2s"

	EVEN
Output:	ds.b	200*1024		;200KB buffer
