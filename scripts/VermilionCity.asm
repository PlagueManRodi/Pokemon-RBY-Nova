VermilionCity_Script:
	call EnableAutoTextBoxDrawing
	ld hl, wCurrentMapScriptFlags
	bit 6, [hl]
	res 6, [hl]
	push hl
	call nz, .initCityScript
	pop hl
	bit 5, [hl]
	res 5, [hl]
	call nz, .setFirstLockTrashCanIndex
	ld hl, VermilionCity_ScriptPointers
	ld a, [wVermilionCityCurScript]
	jp CallFunctionInTable

.setFirstLockTrashCanIndex
	call Random
	ldh a, [hRandomSub]
	and $e
	ld [wFirstLockTrashCanIndex], a
; hide Vermilion Beach entrance
IF DEF(_DEBUG)
	ret
ENDC
	CheckEvent EVENT_BECAME_CHAMPION
	ret nz
	ld a, 25
	ld [wNewTileBlockID], a
	lb bc, 2, 0
	predef ReplaceTileBlock
	lb bc, 3, 0
	predef ReplaceTileBlock
	ld a, 21
	ld [wNewTileBlockID], a
	lb bc, 4, 0
	predef_jump ReplaceTileBlock

.initCityScript
	callfar ResetVermilionBeachEvents
	callfar RemoveVermilionBeachItems
	CheckEventHL EVENT_SS_ANNE_LEFT
	ret z
	CheckEventReuseHL EVENT_WALKED_PAST_GUARD_AFTER_SS_ANNE_LEFT
	SetEventReuseHL EVENT_WALKED_PAST_GUARD_AFTER_SS_ANNE_LEFT
	ret nz
	ld a, $2
	ld [wVermilionCityCurScript], a
	ret

VermilionCity_ScriptPointers:
	dw VermilionCityScript0
	dw VermilionCityScript1
	dw VermilionCityScript2
	dw VermilionCityScript3
	dw VermilionCityScript4

VermilionCityScript0:
	call VermilionCityGymDoorScript
	ld a, [wSpritePlayerStateData1FacingDirection]
	and a ; cp SPRITE_FACING_DOWN
	ret nz
	ld hl, SSAnneTicketCheckCoords
	call ArePlayerCoordsInArray
	ret nc
	xor a
	ldh [hJoyHeld], a
	ld [wcf0d], a
	CheckEvent EVENT_GOT_GOLD_TICKET
	jr nz, .inPostGame
	ld a, $3
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
	CheckEvent EVENT_SS_ANNE_LEFT
	jr nz, .shipHasDeparted
	ld b, S_S_TICKET
	predef GetQuantityOfItemInBag
	ld a, b
	and a
	ret nz
.shipHasDeparted
	ld a, D_UP
	ld [wSimulatedJoypadStatesEnd], a
	ld a, $1
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
	ld a, $1
	ld [wVermilionCityCurScript], a
	ret
.inPostGame
	ld a, $f
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
	ld b, GOLD_TICKET
	predef GetQuantityOfItemInBag
	ld a, b
	and a
	ret nz
	jr .shipHasDeparted

VermilionCityGymDoorScript:
	CheckEvent EVENT_SS_ANNE_LEFT
	jr z, .gym_closed
	ret
.gym_closed
	ld a, [wYCoord]
	cp 20
	ret nz
	ld a, [wXCoord]
	cp 12
	ret nz
	ld a, $e
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
	xor a
	ldh [hJoyHeld], a
	call StartSimulatingJoypadStates
	ld a, $1
	ld [wSimulatedJoypadStatesIndex], a
	ld a, D_DOWN
	ld [wSimulatedJoypadStatesEnd], a
	xor a
	ld [wSpritePlayerStateData1FacingDirection], a
	ld [wJoyIgnore], a
	ret
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	call Delay3
	ld a, 0
	ld [wVermilionCityCurScript], a
	ret

SSAnneTicketCheckCoords:
	dbmapcoord 18, 30
	db -1 ; end

VermilionCityScript4:
	ld hl, SSAnneTicketCheckCoords
	call ArePlayerCoordsInArray
	ret c
	ld a, $0
	ld [wVermilionCityCurScript], a
	ret

VermilionCityScript2:
	ld a, $ff
	ld [wJoyIgnore], a
	ld a, D_UP
	ld [wSimulatedJoypadStatesEnd], a
	ld [wSimulatedJoypadStatesEnd + 1], a
	ld a, 2
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
	ld a, $3
	ld [wVermilionCityCurScript], a
	ret

VermilionCityScript3:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	xor a
	ld [wJoyIgnore], a
	ldh [hJoyHeld], a
	ld a, $0
	ld [wVermilionCityCurScript], a
	ret

VermilionCityScript1:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	ld c, 10
	call DelayFrames
	ld a, $0
	ld [wVermilionCityCurScript], a
	ret

VermilionCity_TextPointers:
	dw VermilionCityText1
	dw VermilionCityText2
	dw VermilionCityText3
	dw VermilionCityText4
	dw VermilionCityText5
	dw VermilionCityText6
	dw VermilionCityText7
	dw VermilionCityText8
	dw MartSignText
	dw PokeCenterSignText
	dw VermilionCityText11
	dw VermilionCityText12
	dw VermilionCityText13
	dw VermilionCityText15
	dw VermilionCityText16

VermilionCityText1:
	text_far _VermilionCityText1
	text_end

VermilionCityText2:
	text_asm
	CheckEvent EVENT_SS_ANNE_LEFT
	jr nz, .shipHasDeparted
	ld hl, VermilionCityTextDidYouSee
	call PrintText
	jr .end
.shipHasDeparted
	ld hl, VermilionCityTextSSAnneDeparted
	call PrintText
.end
	jp TextScriptEnd

VermilionCityTextDidYouSee:
	text_far _VermilionCityTextDidYouSee
	text_end

VermilionCityTextSSAnneDeparted:
	text_far _VermilionCityTextSSAnneDeparted
	text_end

VermilionCityText3:
	text_asm
	CheckEvent EVENT_GOT_GOLD_TICKET
	jr nz, .shipIsBack
	CheckEvent EVENT_SS_ANNE_LEFT
	jr nz, .shipHasDeparted
	ld a, [wSpritePlayerStateData1FacingDirection]
	cp SPRITE_FACING_RIGHT
	jr z, .greetPlayer
	ld hl, .inFrontOfOrBehindGuardCoords
	call ArePlayerCoordsInArray
	jr nc, .greetPlayerAndCheckTicket
.greetPlayer
	ld hl, SSAnneWelcomeText4
	call PrintText
	jr .end
.greetPlayerAndCheckTicket
	ld hl, SSAnneWelcomeText9
	call PrintText
	ld b, S_S_TICKET
	predef GetQuantityOfItemInBag
	ld a, b
	and a
	jr nz, .playerHasTicket
	ld hl, SSAnneNoTicketText
	call PrintText
	jr .end
.playerHasTicket
	ld hl, SSAnneFlashedTicketText
	call PrintText
	ld a, $4
	ld [wVermilionCityCurScript], a
	jr .end
.shipHasDeparted
	ld hl, SSAnneNotHereText
	call PrintText
	jr .end
.shipIsBack
	ld hl, SSAnneShipBackText
	call PrintText
.end
	jp TextScriptEnd

.inFrontOfOrBehindGuardCoords
	dbmapcoord 19, 29 ; in front of guard
	dbmapcoord 19, 31 ; behind guard
	db -1 ; end

SSAnneWelcomeText4:
	text_far _SSAnneWelcomeText4
	text_end

SSAnneWelcomeText9:
	text_far _SSAnneWelcomeText9
	text_end

SSAnneFlashedTicketText:
	text_far _SSAnneFlashedTicketText
	text_end

SSAnneNoTicketText:
	text_far _SSAnneNoTicketText
	text_end

SSAnneNotHereText:
	text_far _SSAnneNotHereText
	text_end

VermilionCityText4:
	text_far _VermilionCityText4
	text_end

VermilionCityText5:
	text_far _VermilionCityText5
	text_asm
	ld a, MACHOP
	call PlayCry
	call WaitForSoundToFinish
	ld hl, VermilionCityText14
	ret

VermilionCityText14:
	text_far _VermilionCityText14
	text_end

VermilionCityText6:
	text_far _VermilionCityText6
	text_end

VermilionCityText7:
	text_far _VermilionCityText7
	text_end

VermilionCityText8:
	text_far _VermilionCityText8
	text_end

VermilionCityText11:
	text_far _VermilionCityText11
	text_end

VermilionCityText12:
	text_far _VermilionCityText12
	text_end

VermilionCityText13:
	text_far _VermilionCityText13
	text_end

VermilionCityText15:
	text_far _VermilionCityText15
	text_end

VermilionCityText16:
	text_asm
	ld a, [wSpritePlayerStateData1FacingDirection]
	cp SPRITE_FACING_RIGHT
	jr z, .greetPlayer2
	ld hl, .inFrontOfOrBehindGuardCoords2
	call ArePlayerCoordsInArray
	jr nc, .greetPlayerAndCheckTicket2
.greetPlayer2
	ld hl, SSAnneWelcomeText42
	call PrintText
	jr .end2
.greetPlayerAndCheckTicket2
	ld hl, SSAnneWelcomeText92
	call PrintText
	ld b, GOLD_TICKET
	predef GetQuantityOfItemInBag
	ld a, b
	and a
	jr nz, .playerHasTicket2
	ld hl, SSAnneNoTicketText2
	call PrintText
	jr .end2
.playerHasTicket2
	ld hl, SSAnneFlashedTicketText2
	call PrintText
	ld a, $4
	ld [wVermilionCityCurScript], a
	jr .end2
.end2
	jp TextScriptEnd

.inFrontOfOrBehindGuardCoords2
	dbmapcoord 19, 29 ; in front of guard
	dbmapcoord 19, 31 ; behind guard
	db -1 ; end

SSAnneWelcomeText42:
	text_far _SSAnneWelcomeText42
	text_end

SSAnneWelcomeText92:
	text_far _SSAnneWelcomeText92
	text_end

SSAnneFlashedTicketText2:
	text_far _SSAnneFlashedTicketText2
	text_end

SSAnneNoTicketText2:
	text_far _SSAnneNoTicketText2
	text_end

SSAnneShipBackText:
	text_far _SSAnneShipBackText
	text_end
