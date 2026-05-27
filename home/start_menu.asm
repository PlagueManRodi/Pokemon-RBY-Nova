DisplaySelectMenu::						;;
	SetEvent EVENT_ON_SELECT_MENU		;;
	jr DisplayStartMenu.skipResetEvent	;;
DisplayStartMenu::
	ResetEvent EVENT_ON_SELECT_MENU		;;
.skipResetEvent							;;
	ld a, BANK(StartMenu_Pokedex)
	ldh [hLoadedROMBank], a
	ld [MBC1RomBank], a
	ld a, [wWalkBikeSurfState] ; walking/biking/surfing
	ld [wWalkBikeSurfStateCopy], a
	ld a, SFX_START_MENU
	call PlaySound

RedisplayStartMenu::
	farcall DrawStartMenu
	;
	CheckEvent EVENT_ON_SELECT_MENU
	jr z, .SZSteps
	farcall PrintRepelInfo
	jr .skipSZSteps
.SZSteps
	;
	farcall PrintSafariZoneSteps ; print Safari Zone info, if in Safari Zone
.skipSZSteps ;;
	call UpdateSprites
.loop
	call HandleMenuInput
	ld b, a
.checkIfUpPressed
	bit BIT_D_UP, a
	jr z, .checkIfDownPressed
	ld a, [wCurrentMenuItem] ; menu selection
	and a
	jr nz, .loop
	ld a, [wLastMenuItem]
	and a
	jr nz, .loop
; if the player pressed tried to go past the top item, wrap around to the bottom
	CheckEvent EVENT_ON_SELECT_MENU
	jp z, .onStartMenu
	farcall SelectMenuItemNumCheck
	ld a, d
	dec a
	jr .wrapMenuItemId
.onStartMenu
	CheckEvent EVENT_GOT_POKEDEX
	ld a, 7 ; edited; there are 8 menu items with the pokedex + portablePC, so the max index is 7
	jr nz, .wrapMenuItemId
	ld a, 5 ; there are only 6 menu items without the pokedex + portablePC
.wrapMenuItemId
	ld [wCurrentMenuItem], a
	call EraseMenuCursor
	jr .loop
.checkIfDownPressed
	bit BIT_D_DOWN, a
	jr z, .buttonPressed
; if the player pressed tried to go past the bottom item, wrap around to the top
	CheckEvent EVENT_ON_SELECT_MENU
	jp z, .onStartMenu2
	farcall SelectMenuItemNumCheck
	ld c, d
	jr .checkIfPastBottom
.onStartMenu2
	CheckEvent EVENT_GOT_POKEDEX
	ld c, 8 ; edited, there are 8 menu items with the pokedex + portablePC
	jr nz, .checkIfPastBottom
	ld c, 6 ; edited, there are only 6 menu items without the pokedex + portablePC
.checkIfPastBottom
	ld a, [wCurrentMenuItem]
	cp c
	jr nz, .loop
; the player went past the bottom, so wrap to the top
	xor a
	ld [wCurrentMenuItem], a
	call EraseMenuCursor
	jr .loop
.buttonPressed ; A, B, or Start button pressed
	call PlaceUnfilledArrowMenuCursor
	CheckEvent EVENT_ON_SELECT_MENU
	ld a, [wCurrentMenuItem]
	jr z, .notSelect
	ld [wSelectSavedMenuItem], a
	jr .alreadySaved
.notSelect
	ld [wBattleAndStartSavedMenuItem], a ; save current menu selection
.alreadySaved
	ld a, b
	and B_BUTTON | START | SELECT ; was the Start button or B button pressed?
	jp nz, CloseStartMenu
	call SaveScreenTilesToBuffer2 ; copy background from wTileMap to wTileMapBackup2
	CheckEvent EVENT_ON_SELECT_MENU
	jp nz, DisplaySelectMenuItem
	CheckEvent EVENT_GOT_POKEDEX
	ld a, [wCurrentMenuItem]
	jr nz, .displayMenuItem
	inc a ; adjust position to account for missing pokedex menu item
.displayMenuItem
	cp 0
	jp z, StartMenu_Pokedex
	cp 1
	jp z, StartMenu_Pokemon
	cp 2
	jp z, StartMenu_Item
	CheckEvent EVENT_GOT_POKEDEX
	ld a, [wCurrentMenuItem]
	jr nz, .displayMenuItem2
	inc a ; adjust position to account for missing portable pc menu item
	inc a
.displayMenuItem2
	cp 3
	jp z, StartMenu_PortablePC ; new
	cp 4
	jp z, StartMenu_TrainerInfo
	cp 5
	jp z, StartMenu_SaveReset
	cp 6 ; new
	jp z, StartMenu_Option

; EXIT falls through to here
CloseStartMenu::
	ResetEvent EVENT_ON_SELECT_MENU
	call Joypad
	ldh a, [hJoyPressed]
	bit BIT_A_BUTTON, a
	jr nz, CloseStartMenu
	call LoadTextBoxTilePatterns
	jp CloseTextDisplay	

DisplaySelectMenuItem::
	ld b, 0
	ld c, 5
	lb de, 5, 5
	lb hl, 5, 5
	CheckEvent EVENT_GOT_HM01
	jr z, .noCut
	ld c, b
	inc b
.noCut
	CheckEvent EVENT_GOT_HM02
	jr z, .noFly
	ld d, b
	inc b
.noFly
	CheckEvent EVENT_GOT_HM03
	jr z, .noSurf
	ld e, b
	inc b
.noSurf
	CheckEvent EVENT_GOT_HM04
	jr z, .noStrength
	ld h, b
	inc b
.noStrength
	CheckEvent EVENT_GOT_HM05
	jr z, .noFlash
	ld l, b
	inc b
.noFlash
	ld a, [wCurrentMenuItem]
;	cp 5
;	jr nc, CloseStartMenu
	cp c
	jr z, ChosenCut
	cp d
	jr z, ChosenFly
	cp e
	jr z, ChosenSurf
	cp h
	jr z, ChosenStrength
	cp l
	jr z, ChosenFlash
	cp b
	jp z, StartMenu_Item
	jr CloseStartMenu

ChosenCut::
	call SaveScreenTilesToBuffer1
	ld a, 0
	jp UseHMMove
	
ChosenFly::
	call SaveScreenTilesToBuffer1
	ld a, 2
	jp UseHMMove
	
ChosenSurf::
	call SaveScreenTilesToBuffer1
	ld a, 4
	jp UseHMMove
	
ChosenStrength::
	call SaveScreenTilesToBuffer1
	ld a, 6
	jp UseHMMove

ChosenFlash::
	call SaveScreenTilesToBuffer1
	ld a, 8
	jp UseHMMove	
