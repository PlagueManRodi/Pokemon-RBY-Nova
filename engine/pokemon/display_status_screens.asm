DisplayStatusScreens:
	ld a, [wMonDataLocation]
	cp 3
	jp nc, .default
	ld a, [wWhichMon]
	ld [wTempWhichMonStorage], a
.showStatusScreen
	predef StatusScreen
	ld b, 0
	jr .checkInput
.showStatusScreenDV
	predef StatusScreen
	ld b, 1
	jr .checkInput
.showStatusScreenSTXP
	predef StatusScreen
	ld b, 2
	jr .checkInput
.showStatusScreen2
	predef StatusScreen2
	ld b, 3
.checkInput
	bit BIT_B_BUTTON, d
	jp nz, .pressedB
	bit BIT_D_UP, d
	jr nz, .pressedUp
	bit BIT_D_DOWN, d
	jr nz, .pressedDown
	bit BIT_D_RIGHT, d
	jr nz, .pressedRight
	; pressedLeft
	ld a, b
	cp 0
	jp z, .waitForNewInput
	cp 1
	jr nz, .checkNext
	ld hl, wNewFlags
	set 3, [hl]
	;
	ld a, e
	ldh [hTileAnimations], a
	;
	jr .showStatusScreen
.checkNext
	cp 2
	jr nz, .onStatusScreen2
.switchToDVScreen
	ld hl, wNewFlags
	set 4, [hl]
	set 3, [hl]
	;
	ld a, e
	ldh [hTileAnimations], a
	;
	jr .showStatusScreenDV ; dv
.onStatusScreen2
	CheckEvent EVENT_PLAYING_WITHOUT_STAT_EXP
	jr nz, .switchToDVScreen
	ld hl, wNewFlags
	set 5, [hl]
	set 3, [hl]
	;
	ld a, e
	ldh [hTileAnimations], a
	;
	jr .showStatusScreenSTXP ; stxp
.pressedRight
	ld a, b
	cp 3
	jr z, .waitForNewInput
	cp 2
	jr nz, .notStatusScreenSTXP
	; status screen STXP
.switchToStatusScreen2
	;
	ld a, e
	ldh [hTileAnimations], a
	;
	jr .showStatusScreen2
.notStatusScreenSTXP
	cp 1
	jr nz, .notStatusScreenDV
	CheckEvent EVENT_PLAYING_WITHOUT_STAT_EXP
	jr nz, .switchToStatusScreen2
	ld hl, wNewFlags
	set 5, [hl]
	set 3, [hl]
	;
	ld a, e
	ldh [hTileAnimations], a
	;
	jr .showStatusScreenSTXP ; stxp
.notStatusScreenDV
	ld hl, wNewFlags
	set 4, [hl]
	set 3, [hl]
	;
	ld a, e
	ldh [hTileAnimations], a
	;
	jp .showStatusScreenDV ; dv
.pressedUp
	ld a, [wWhichMon]
	cp 0
	jr z, .waitForNewInput
	dec a
	ld [wWhichMon], a
	;
	ld a, e
	ldh [hTileAnimations], a
	;
	jp .showStatusScreen
.pressedDown
	ld a, [wMonDataLocation]
	cp PLAYER_PARTY_DATA
	jr z, .party
	cp ENEMY_PARTY_DATA
	jr z, .enemy
	; BOX_DATA
	ld a, [wBoxCount]
	jr .gotA
.enemy
	ld a, [wEnemyPartyCount]
	jr .gotA
.party
	ld a, [wPartyCount]
.gotA
	ld c, a
	ld a, [wWhichMon]
	inc a
	cp c
	jr nc, .waitForNewInput
	ld [wWhichMon], a
	;
	ld a, e
	ldh [hTileAnimations], a
	;
	jp .showStatusScreen
.waitForNewInput
	push de
	push bc
	call Joypad
	pop bc
	pop de
	ldh a, [hJoyPressed]
	ld d, a
	and B_BUTTON | D_UP | D_DOWN | D_RIGHT | D_LEFT
	jr z, .waitForNewInput
	jp DisplayStatusScreens.checkInput
.default
	predef StatusScreen
	ld a, e
	ldh [hTileAnimations], a
	predef StatusScreen2
.pressedB
	ld a, e
	ldh [hTileAnimations], a
	ld a, [wTempWhichMonStorage]
	ld [wWhichMon], a
	call LoadMonData
	ld hl, wd72c
	res 1, [hl]
	ld a, $77
	ldh [rNR50], a
	call GBPalWhiteOut
	jp ClearScreen
	ret

PrintStatDVSting:
	ld hl, wNewFlags
	bit 4, [hl]
	ld de, DVText
	jr nz, .notStat
	bit 5, [hl]
	ld de, SXPText
	jr nz, .notStat
	ld de, StatText
.notStat
	hlcoord 10, 17
	jp PlaceString

DVText:
	db "<D><V>@"

StatText:
	db "<ST2><AT>@"
	
SXPText:
	db "<S><XP>@"

DrawHPDV:
	ld hl, wNewFlags
	bit 5, [hl]
	jr nz, DrawHPSTXP
	bit 4, [hl]
	ret z
	hlcoord 9, 4
	ld de, ClearHPString
	call PlaceString
	hlcoord 9, 4
	ld de, HPDVText
	call PlaceString
	hlcoord 16, 4
	ld de, wDVBuffer
	ld b, 0
	ld a, [wLoadedMonDVs]
	bit 4, a
	jr z, .skip1
	set 3, b
.skip1
	bit 0, a
	jr z, .skip2
	set 2, b
.skip2
	ld a, [wLoadedMonDVs+1]
	bit 4, a
	jr z, .skip3
	set 1, b
.skip3
	bit 0, a
	jr z, .skip4
	set 0, b
.skip4
	ld a, b
	ld [de], a
	lb bc, 1, 3
	jp PrintNumber

ClearHPString:
	db "          @"

HPDVText:
	db "  DV@"

DrawHPSTXP:
	hlcoord 9, 4
	ld de, ClearHPString
	call PlaceString
	hlcoord 9, 4
	ld de, HPSXPText
	call PlaceString
	hlcoord 14, 4
	ld de, wLoadedMonHPExp
	lb bc, 2, 5
	jp PrintNumber

HPSXPText:
	db "  XP@"

_PrintSTXPBox:
	hlcoord 0, 8
	ld b, 8
	ld c, 8
	call TextBoxBorder ; Draws the box
	hlcoord 1, 9 ; Start printing stats from here
	ld bc, $17 ; Number offset
	push bc
	push hl
	ld de, StatSTXPText
	call PlaceString
	pop hl
	pop bc
	add hl, bc
	ld de, wLoadedMonAttackExp
	lb bc, 2, 5
	call PrintStat2
	ld de, wLoadedMonDefenseExp
	call PrintStat2
	ld de, wLoadedMonSpeedExp
	call PrintStat2
	ld de, wLoadedMonSpecialExp
	call PrintNumber
	ret
	
_PrintDVBox:
	hlcoord 0, 8
	ld b, 8
	ld c, 8
	call TextBoxBorder ; Draws the box
	hlcoord 1, 9 ; Start printing stats from here
	ld bc, $19 ; Number offset
	push bc
	push hl
	ld de, DVsText
	call PlaceString
	pop hl
	pop bc
	add hl, bc
	ld a, [wLoadedMonDVs]
	and $F0
	swap a
	ld de, wDVBuffer
	ld [de], a
	lb bc, 1, 3
	call PrintStat2
	ld de, wDVBuffer
	ld a, [wLoadedMonDVs]
	and $0F
	ld [de], a
	call PrintStat2
	ld de, wDVBuffer
	ld a, [wLoadedMonDVs+1]
	and $F0
	swap a
	ld [de], a
	call PrintStat2
	ld de, wDVBuffer
	ld a, [wLoadedMonDVs+1]
	and $0F
	ld [de], a
	call PrintNumber
	ret

PrintStat2:
	push hl
	call PrintNumber
	pop hl
	ld de, SCREEN_WIDTH * 2
	add hl, de
	ret

StatSTXPText:
	db   "ATK.XP"
	next "DEF.XP"
	next "SPE.XP"
	next "SPCL.XP@"

DVsText:
	db   "ATK.DV"
	next "DEF.DV"
	next "SPE.DV"
	next "SPCL.DV@"
