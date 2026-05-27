_SelectMenuItemNumCheck:	
	ld d, 2
	CheckEvent EVENT_GOT_HM01
	jr z, .noCut
	inc d
.noCut
	CheckEvent EVENT_GOT_HM02
	jr z, .noFly
	inc d
.noFly
	CheckEvent EVENT_GOT_HM03
	jr z, .noSurf
	inc d
.noSurf
	CheckEvent EVENT_GOT_HM04
	jr z, .noStrength
	inc d
.noStrength
	CheckEvent EVENT_GOT_HM05
	jr z, .noFlash
	inc d
.noFlash
	ret
