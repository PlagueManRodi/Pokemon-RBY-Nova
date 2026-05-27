BillsHousePC:
	call EnableAutoTextBoxDrawing
	ld a, [wSpritePlayerStateData1FacingDirection]
	cp SPRITE_FACING_UP
	ret nz
	CheckEvent EVENT_LEFT_BILLS_HOUSE_AFTER_HELPING
	jr nz, .displayBillsHousePokemonList
	CheckEventReuseA EVENT_USED_CELL_SEPARATOR_ON_BILL
	jr nz, .displayBillsHouseMonitorText
	CheckEventReuseA EVENT_BILL_SAID_USE_CELL_SEPARATOR
	jr nz, .doCellSeparator
.displayBillsHouseMonitorText
	tx_pre_jump BillsHouseMonitorText
.doCellSeparator
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	tx_pre BillsHouseInitiatedText
	ld c, 32
	call DelayFrames
	ld a, SFX_TINK
	call PlaySound
	call WaitForSoundToFinish
	ld c, 80
	call DelayFrames
	ld a, SFX_SHRINK
	call PlaySound
	call WaitForSoundToFinish
	ld c, 48
	call DelayFrames
	ld a, SFX_TINK
	call PlaySound
	call WaitForSoundToFinish
	ld c, 32
	call DelayFrames
	ld a, SFX_GET_ITEM_1
	call PlaySound
	call WaitForSoundToFinish
	call PlayDefaultMusic
	SetEvent EVENT_USED_CELL_SEPARATOR_ON_BILL
	ret
.displayBillsHousePokemonList
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	tx_pre BillsHousePokemonList
	ret

BillsHouseMonitorText::
	text_far _BillsHouseMonitorText
	text_end

BillsHouseInitiatedText::
	text_far _BillsHouseInitiatedText
	text_promptbutton
	text_asm
	ld a, SFX_STOP_ALL_MUSIC
	ld [wNewSoundID], a
	call PlaySound
	ld c, 16
	call DelayFrames
	ld a, SFX_SWITCH
	call PlaySound
	call WaitForSoundToFinish
	ld c, 60
	call DelayFrames
	jp TextScriptEnd

BillsHousePokemonList::
	text_asm
	call SaveScreenTilesToBuffer1
	ld hl, BillsHousePokemonListText1
	call PrintText
	xor a
	ld [wMenuItemOffset], a ; not used
	ld [wCurrentMenuItem], a
	ld [wLastMenuItem], a
	ld a, D_LEFT | D_RIGHT | A_BUTTON | B_BUTTON
	ld [wMenuWatchedKeys], a
	ld a, 4
	ld [wMaxMenuItem], a
	ld a, 2
	ld [wTopMenuItemY], a
	ld a, 1
	ld [wTopMenuItemX], a
.billsPokemonLoop
	ld hl, wd730
	set 6, [hl]
	hlcoord 0, 0
	ld b, 10
	ld c, 18
	call TextBoxBorder
	hlcoord 2, 2
	ld de, BillsMonListTextR
	call PlaceString
	hlcoord 11, 2
	ld de, BillsMonListTextL
	call PlaceString
	ld hl, BillsHousePokemonListText2
	call PrintText
	call SaveScreenTilesToBuffer2
	call HandleMenuInput
	bit BIT_B_BUTTON, a
	jp nz, .cancel
	bit BIT_D_RIGHT, a
	jr z, .didNotPressRight
	; move cursor to right column
	ld a, 4
	ld [wMaxMenuItem], a
	ld a, 2
	ld [wTopMenuItemY], a
	ld a, 10
	ld [wTopMenuItemX], a
	ld a, 5 ; in the the right column, use an offset to prevent overlap
	ld [wMenuItemOffset], a
	jr .billsPokemonLoop
.didNotPressRight
	bit BIT_D_LEFT, a
	jr z, .didNotPressLeftOrRight
	; move cursor to left column
	ld a, 4
	ld [wMaxMenuItem], a
	ld a, 2
	ld [wTopMenuItemY], a
	ld a, 1
	ld [wTopMenuItemX], a
	xor a
	ld [wMenuItemOffset], a
	jr .billsPokemonLoop
.didNotPressLeftOrRight
	ld a, [wCurrentMenuItem]
	ld b, a
	ld a, [wMenuItemOffset]
	add b
	cp 0
	ld b, a
	ld a, EEVEE
	jr z, .displayPokedex
	ld a, b
	cp 1
	ld b, a
	ld a, ESPEON
	jr z, .displayPokedex
	ld a, b
	cp 2
	ld b, a
	ld a, FLAREON
	jr z, .displayPokedex
	ld a, b
	cp 3
	ld b, a
	ld a, GLACEON
	jr z, .displayPokedex
	ld a, b
	cp 4
	ld b, a
	ld a, JOLTEON
	jr z, .displayPokedex
	ld a, b
	cp 5
	ld b, a
	ld a, LEAFEON
	jr z, .displayPokedex
	ld a, b
	cp 6
	ld b, a
	ld a, SYLVEON
	jr z, .displayPokedex
	ld a, b
	cp 7
	ld b, a
	ld a, UMBREON
	jr z, .displayPokedex
	ld a, b
	cp 8
	ld b, a
	ld a, VAPOREON
	jr z, .displayPokedex
	jr .cancel
.displayPokedex
	call DisplayPokedex
	call LoadScreenTilesFromBuffer2
	jp .billsPokemonLoop
.cancel
	ld hl, wd730
	res 6, [hl]
	call LoadScreenTilesFromBuffer2
	jp TextScriptEnd

BillsHousePokemonListText1:
	text_far _BillsHousePokemonListText1
	text_end

BillsMonListTextR:
	db   "EEVEE"
	next "ESPEON"
	next "FLAREON"
	next "GLACEON"
	next "JOLTEON@"
	
BillsMonListTextL:
	db	 "LEAFEON"
	next "SYLVEON"
	next "UMBREON"
	next "VAPOREON"
	next "CANCEL@"

BillsHousePokemonListText2:
	text_far _BillsHousePokemonListText2
	text_end
