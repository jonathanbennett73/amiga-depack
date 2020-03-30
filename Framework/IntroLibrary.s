*****************************************************************************

; Name			: IntroLibrary.s
; Coded by		: Antiriad (Jonathan Bennett <jon@autoitscript.com>)
; Description		: Shared useful functions that can be turned on from IntroConfig.i.
; Date last edited	: 04/02/2020
				
*****************************************************************************

	INCLUDE "IntroConfig.i"
	INCLUDE "IntroLibrary.i"

*****************************************************************************

	SECTION	IntroFramework_PublicCode,CODE	;Code section in Public memory

*****************************************************************************
*****************************************************************************


*****************************************************************************
* Arj m7 depacker. 
* arjbeta a -m7 -jm __temp__archive__.arj in.bin
* arj2raw __temp__archive__.arj in.bin out.am7
* IN:		a0, packed data
*		a1, destination
* OUT:		a1, ptr to end of packed data
* TRASHED:	d0-d1/a0-a1
*****************************************************************************
	
	IFD	LIB_ENABLE_ARJM7
	xdef	LIB_ArjM7_Depack
LIB_ArjM7_Depack:
	;routine wants src=a1,dest=a0
	exg	a0,a1		

	;a2, buffer (11312 bytes / LIB_ARJM7_BUFFER_SIZE)
	lea	LIB_Depack_Buffer,a2

	INCLUDE "Depack/ArjM7_Depack_ross.asm"
	ENDC


*****************************************************************************
* PackFire depacker (large model). 
* packfire -l in.bin out.pkf
* IN:		a0, packed data
*		a1, destination
* OUT:		
* TRASHED:	d0-d1/a0-a1
*****************************************************************************
	
	IFD	LIB_ENABLE_PACKFIRE_LARGE
	xdef	LIB_PackFire_Large_Depack
LIB_PackFire_Large_Depack:
	movem.l	d2-d7/a2-a6,-(sp)
	;a2, buffer (15980 bytes / LIB_PACKFIRE_BUFFER_SIZE)
	lea	LIB_Depack_Buffer,a2
	bsr.s	packfire_large_depack
	movem.l	(sp)+,d2-d7/a2-a6
	rts

	INCLUDE "Depack/PackFire_Depack_Large.asm"
	ENDC


*****************************************************************************
* LZ4 depacker. 
* Use lz4.exe -9 --no-frame-crc in.bin out.lz4
* IN:		a0, packed data
*		a1, destination
*		d0.l, size of packed data in bytes
* OUT:		
* TRASHED:	d0-d1/a0-a1
*****************************************************************************
	
	IFD	LIB_ENABLE_LZ4
	xdef	LIB_LZ4_Depack
LIB_LZ4_Depack:
	movem.l	d2-d7/a2-a6,-(sp)
	bsr.s	lz4_frame_depack
	movem.l	(sp)+,d2-d7/a2-a6
	rts

	INCLUDE "Depack/LZ4_Depack_Frame.asm"
	ENDC


*****************************************************************************
* Cranker depacker. 
* Use cranker -cd -f in.bin -o out.cra
*
* In-place decrunching: Align the crunched data to the end of the
*	destination area PLUS overhead.
*
* IN:		a0, packed data
*		a1, destination
* OUT:		
* TRASHED:	d0-d1/a0-a1
*****************************************************************************
	
	IFD	LIB_ENABLE_CRANKER
	xdef	LIB_Cranker_Depack
LIB_Cranker_Depack:
	;Note that the cruncher produces a 4 byte header, $b0 followed by the
	;24bit length of the decrunched data. Strip off or skip these first
	;four bytes from the crunched data when passing them to this routine.
	addq.l	#4,a0	

	INCLUDE "Depack/Cranker_Depack.asm"
	ENDC


*****************************************************************************
* Doynamite68k depacker. 
* Use doynamite68k_lz.exe -o output.doy intput.bin
* IN:		a0, packed data (must be even aligned)
*		a1, destination
* OUT:		
* TRASHED:	d0-d1/a0-a1
*****************************************************************************
	
	IFD	LIB_ENABLE_DOYNAMITE68K
	xdef	LIB_Doynamite68k_Depack
LIB_Doynamite68k_Depack:
	movem.l	d2-d7/a2-a6,-(sp)
	bsr.s	doynax_depack
	movem.l	(sp)+,d2-d7/a2-a6
	rts

	INCLUDE "Depack/doynamite68k_Depack.asm"
	ENDC


*****************************************************************************
* NRV2S depacker.
* IN:		a0, packed data
*		a1, destination
* OUT:		a0, dest start
*		a1, dest end
* TRASHED:	d0-d1/a0-a1
*****************************************************************************
	
	IFD	LIB_ENABLE_NRV2S
	xdef	LIB_NRV2S_Depack
LIB_NRV2S_Depack:
	INCLUDE "Depack/nrv2s_Depack.asm"
	ENDC


*****************************************************************************
* NRV2S depacker (in-place with no offset needed).
* IN:		a0, packed data
* OUT:		a1, dest start
* TRASHED:	d0-d1/a0-a1
*****************************************************************************
	
	IFD	LIB_ENABLE_NRV2R
	xdef	LIB_NRV2R_Depack
LIB_NRV2R_Depack:
	INCLUDE "Depack/nrv2r_Depack.asm"
	ENDC


*****************************************************************************
*
* IN:		a0, packed data
*		a1, destination
* OUT:		
* TRASHED:	d0-d1/a0-a1
*****************************************************************************
	
	IFD	LIB_ENABLE_SHRINKLER
	xdef	LIB_Shrinkler_Depack
LIB_Shrinkler_Depack:
	movem.l	a2-a3,-(sp)		;everything else saved by routine
	sub.l	a2,a2			;no callback
	bsr.s	Shrinkler_Depack
	movem.l	(sp)+,a2-a3
	rts

	INCLUDE "Depack/Shrinkler_Depack.asm"
	ENDC


*****************************************************************************
*
* IN:		a0, packed data
*		a1, destination
* OUT:		d0.l = length of unpacked file in bytes OR error code
*		 0 = not a packed file
*		-1 = packed data CRC error
*		-2 = unpacked data CRC error
* TRASHED:	d0-d1/a0-a1
*****************************************************************************
	
	IFD	LIB_ENABLE_RNC_1
	xdef	LIB_RNC_Depack
LIB_RNC_Depack:
	moveq	#0,d0			;No key
	bsr.s	RNC_Unpack
	rts

	INCLUDE "Depack/RNC_Depack_1.asm"
	ENDC


*****************************************************************************
*
* IN:		a0, packed data
*		a1, destination
* OUT:		
* TRASHED:	d0-d1/a0-a1
*****************************************************************************
	
	IFD	LIB_ENABLE_RNC_1C
	xdef	LIB_RNC_Depack
LIB_RNC_Depack:
	moveq	#0,d0			;No key
	bsr.s	RNC_Unpack
	rts

	INCLUDE "Depack/RNC_Depack_1C.asm"
	ENDC


*****************************************************************************
*
* IN:		a0, packed data
*		a1, destination
* OUT:		d0.l = length of unpacked file in bytes OR error code
*		 0 = not a packed file
*		-1 = packed data CRC error
*		-2 = unpacked data CRC error
* TRASHED:	d0-d1/a0-a1
*****************************************************************************
	
	IFD	LIB_ENABLE_RNC_2
	xdef	LIB_RNC_Depack
LIB_RNC_Depack:
	moveq	#0,d0			;No key
	bsr.s	RNC_Unpack
	rts

	INCLUDE "Depack/RNC_Depack_2.asm"
	ENDC


*****************************************************************************
*****************************************************************************
*****************************************************************************

	SECTION	IntroFramework_PublicBss,BSS	;BSS section in Public memory

*****************************************************************************

; Packfire is largest so if multiple depack routines use this
;LIB_PACKFIRE_BUFFER_SIZE = 15980
;LIB_ARJM7_BUFFER_SIZE = 11312

	IFD	LIB_ENABLE_PACKFIRE_LARGE
LIB_Depack_Buffer:
		ds.b	LIB_PACKFIRE_BUFFER_SIZE
		EVEN
	ELSE
		IFD	LIB_ENABLE_ARJM7
LIB_Depack_Buffer:
			ds.b	LIB_ARJM7_BUFFER_SIZE
			EVEN
		ENDC
	ENDC

