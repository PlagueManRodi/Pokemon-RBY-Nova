; function that displays the start menu
DrawStartMenu::
	CheckEvent EVENT_ON_SELECT_MENU
	jp nz, SetTextBorderForSelectMenu
	CheckEvent EVENT_GOT_POKEDEX
; menu with pokedex
	hlcoord 10, 0
	lb bc, 16, 8 ; edited for portablePC
	jr nz, .drawTextBoxBorder
; shorter menu if the player doesn't have the pokedex
	hlcoord 10, 0
	ld b, $0c
	ld c, $08
.drawTextBoxBorder
	push bc
	call TextBoxBorder
	pop bc
	ld a, D_DOWN | D_UP | START | SELECT | B_BUTTON | A_BUTTON
	ld [wMenuWatchedKeys], a
	ld a, $02
	ld [wTopMenuItemY], a ; Y position of first menu choice
	ld a, $0b
	ld [wTopMenuItemX], a ; X position of first menu choice
	CheckEvent EVENT_ON_SELECT_MENU
	jr z, .notSelect
	ld a, [wSelectSavedMenuItem] ; remembered menu selection from last time
	jr .alreadyRemembered
.notSelect
	ld a, [wBattleAndStartSavedMenuItem] ; remembered menu selection from last time
.alreadyRemembered
	ld [wCurrentMenuItem], a
	ld [wLastMenuItem], a
	xor a
	ld [wMenuWatchMovingOutOfBounds], a
	ld hl, wd730
	set 6, [hl] ; no pauses between printing each letter
	hlcoord 12, 2
	;
	srl b
	;
	CheckEvent EVENT_ON_SELECT_MENU
	jp nz, PrintSelectMenuText
	;
	CheckEvent EVENT_GOT_POKEDEX
; case for not having pokedex
	ld a, 6
	jr z, .storeMenuItemCount
; case for having pokedex
	ld de, StartMenuPokedexText
	call PrintStartMenuItem
	ld a, 8 ; edited for portablePC
.storeMenuItemCount
	ld [wMaxMenuItem], a ; number of menu items
	ld de, StartMenuPokemonText
	call PrintStartMenuItem
	ld de, StartMenuItemText
	call PrintStartMenuItem
	CheckEvent EVENT_GOT_POKEDEX ; new, for portablePC
	jr z, .dontPrintPortablePC ; new, for portablePC
	ld de, StartMenuPortablePCText ; new, for portablePC
	call PrintStartMenuItem ; new, for portablePC
.dontPrintPortablePC ; new, for portablePC
	ld de, wPlayerName ; player's name
	call PrintStartMenuItem
	ld a, [wd72e]
	bit 6, a ; is the player using the link feature?
; case for not using link feature
	ld de, StartMenuSaveText
	jr z, .printSaveOrResetText
; case for using link feature
	ld de, StartMenuResetText
.printSaveOrResetText
	call PrintStartMenuItem
	ld de, StartMenuOptionText
	call PrintStartMenuItem
	ld de, StartMenuExitText
	call PlaceString
	ld hl, wd730
	res 6, [hl] ; turn pauses between printing letters back on
	ret

StartMenuPokedexText:
	db "POKéDEX@"

StartMenuPokemonText:
	db "POKéMON@"

StartMenuItemText:
	db "ITEM@"

StartMenuPortablePCText: ; new
	db "PORT.PC@"

StartMenuSaveText:
	db "SAVE@"

StartMenuResetText:
	db "RESET@"

StartMenuExitText:
	db "EXIT@"

StartMenuOptionText:
	db "OPTION@"

SelectMenuCutText:
	db "HACK@"

SelectMenuFlyText:
	db "TRAVEL@"
	
SelectMenuSurfText:
	db "SAIL@"
	
SelectMenuStrengthText:
	db "SHOVE@"
	
SelectMenuFlashText:
	db "LIGHT@"
	
SelectMenuOtherText:
	db "OTHER@"

PrintStartMenuItem:
	push hl
	call PlaceString
	pop hl
	ld de, SCREEN_WIDTH * 2
	add hl, de
	ret

SetTextBorderForSelectMenu:
	hlcoord 10, 0
	ld b, 2
	ld c, 8
	CheckEvent EVENT_GOT_HM01
	jr z, .noCut
	inc b
.noCut
	CheckEvent EVENT_GOT_HM02
	jr z, .noFly
	inc b
.noFly
	CheckEvent EVENT_GOT_HM03
	jr z, .noSurf
	inc b
.noSurf
	CheckEvent EVENT_GOT_HM04
	jr z, .noStrength
	inc b
.noStrength
	CheckEvent EVENT_GOT_HM05
	jr z, .noFlash
	inc b
.noFlash
	sla b
	jp DrawStartMenu.drawTextBoxBorder

PrintSelectMenuText:
	ld a, b
	ld [wMaxMenuItem], a ; number of menu items
	CheckEvent EVENT_GOT_HM01
	jr z, .noCut2
	ld de, SelectMenuCutText
	call PrintStartMenuItem
.noCut2
	CheckEvent EVENT_GOT_HM02
	jr z, .noFly2
	ld de, SelectMenuFlyText
	call PrintStartMenuItem
.noFly2
	CheckEvent EVENT_GOT_HM03
	jr z, .noSurf2
	ld de, SelectMenuSurfText
	call PrintStartMenuItem
.noSurf2
	CheckEvent EVENT_GOT_HM04
	jr z, .noStrength2
	ld de, SelectMenuStrengthText
	call PrintStartMenuItem
.noStrength2
	CheckEvent EVENT_GOT_HM05
	jr z, .noFlash2
	ld de, SelectMenuFlashText
	call PrintStartMenuItem
.noFlash2
	ld de, SelectMenuOtherText
	call PrintStartMenuItem
	ld de, StartMenuExitText
	call PlaceString
	ld hl, wd730
	res 6, [hl] ; turn pauses between printing letters back on
	ret

SelectMenuItemNumCheck::
	callfar _SelectMenuItemNumCheck
	ret
