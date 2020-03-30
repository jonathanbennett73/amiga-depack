	IFND _INTROCONFIG_I
_INTROCONFIG_I SET 1

*****************************************************************************

; Name			: IntroConfig.i
; Coded by		: Antiriad (Jonathan Bennett <jon@autoitscript.com)
; Description		: Global config like music type.
				
*****************************************************************************

;Compression libraries
;Compression (best to worst): PKF,SHR,AM7,NRV2S,DOY,CRA,LZ4
;Speed (quickest to slowest): LZ4,CRA,DOY,NRV2S,AM7,SHR,PKF
;Notes: nrv/cra/shr can do in-place with offset.

;Packers available, lz4 is reference for speed/size comparison
;LZ4		(1x speed, 100% size)
;Cranker	(1.3x, 93%)
;Doynamite68k	(1.8x, 88%)
;nrv2s		(2.0x, 85%)
;Arj m7		(3.4x, 79%)
;Shrinkler	(23x, 71%)
;PackFire	(46x, 70%)
;
;All basic routines take parameters:
;a0, source/packed data
;a1, destination
;Assume all routines trash d0-d1/a0-a1.
;Check headers in IntroLibrary.s for anything else.

LIB_ENABLE_LZ4			= 1	;(LZ4) LZ4 
LIB_ENABLE_CRANKER		= 1	;(CRA) LZO depacking
LIB_ENABLE_DOYNAMITE68K		= 1	;(DOY) Doynamite68k
LIB_ENABLE_NRV2S		= 1	;(NRV) Ross's nrv2s
LIB_ENABLE_NRV2R		= 1	;(NRV) Ross's nrv2r (in place no offset)
;LIB_ENABLE_ARJM7		= 1	;(AM7) Arj m7
LIB_ENABLE_PACKFIRE_LARGE	= 1	;(PKF) Packfire LZMA depacking
LIB_ENABLE_SHRINKLER		= 1	;(SHR) Shrinkler LZMA

;Note can only have one RNC compression enabled due to variable clashes. 
LIB_ENABLE_RNC_1		= 1	;(RNC) RNC Method 1
;LIB_ENABLE_RNC_1C		= 1	;(RNC) RNC Method 1 Compact
;LIB_ENABLE_RNC_2		= 1	;(RNC) RNC Method 2
;LIB_ENABLE_RNC_2C		= 1	;(RNC) RNC Method 2 Compact

*****************************************************************************

	ENDC
