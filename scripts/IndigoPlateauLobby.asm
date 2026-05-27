IndigoPlateauLobby_Script:
	call Serial_TryEstablishingExternallyClockedConnection
	call EnableAutoTextBoxDrawing
	ld hl, IndigoPlateauLobby_ScriptPointers
	ld a, [wIndigoPlateauLobbyCurScript]
	jp CallFunctionInTable
	
IndigoPlateauLobby_ScriptPointers:
	dw IndigoPlateauLobbyScript0
	dw IndigoPlateauLobbyScript1
	
IndigoPlateauLobbyScript0:
	call CheckIfProLeagueAvailable
	ld hl, wCurrentMapScriptFlags
	bit 6, [hl]
	res 6, [hl]
	ret z
	ResetEvent EVENT_VICTORY_ROAD_1_BOULDER_ON_SWITCH
	ld a, HS_AGATHA
	ld [wMissableObjectIndex], a
	predef ShowNewObject
	ld a, HS_KAREN
	ld [wMissableObjectIndex], a
	predef HideNewObject
	ld a, HS_CHAMPIONS_ROOM_BLUE
	ld [wMissableObjectIndex], a
	predef ShowObject
	ld hl, wBeatLorelei
	bit 1, [hl]
	res 1, [hl]
	ret z
	; Elite 4 events
	ResetEventRange INDIGO_PLATEAU_EVENTS_START, EVENT_BEAT_CHAMPION_RIVAL
	ret

CheckIfProLeagueAvailable:
	ld a, [wYCoord]
	cp 1
	ret nz
	ld a, [wXCoord]
	cp 8
	ret nz
	ld a, [wProBadgeFlags]
	cp -1
	ret nz
	ld a, 8
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
	xor a
    ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, wVermilionBeachFlags
	ld a, [wCurrentMenuItem]
	ld b, a
	ld c, 2
	push bc
	predef FlagActionPredef
	ld a, 9
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
	xor a
    ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ldh [hJoyHeld], a
	call StartSimulatingJoypadStates
	ld a, $1
	ld [wSimulatedJoypadStatesIndex], a
	pop bc
	ld a, [wCurrentMenuItem]
	and a
	ld a, D_DOWN
	jr nz, .choseNo
	ld a, b
	and a
	jr z, .skip
	ld a, HS_AGATHA
	ld [wMissableObjectIndex], a
	predef HideNewObject
	ld a, HS_KAREN
	ld [wMissableObjectIndex], a
	predef ShowNewObject
	ld a, HS_CHAMPIONS_ROOM_BLUE
	ld [wMissableObjectIndex], a
	predef HideObject
.skip
	ld a, D_UP
.choseNo
	ld [wSimulatedJoypadStatesEnd], a
	xor a
	ld [wSpritePlayerStateData1FacingDirection], a
	ld [wJoyIgnore], a
	ld a, 1
	ld [wIndigoPlateauLobbyCurScript], a
	ret
	
IndigoPlateauLobbyScript1:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	call Delay3
	ld a, 0
	ld [wIndigoPlateauLobbyCurScript], a
	ret

IndigoPlateauLobby_TextPointers:
	dw IndigoHealNurseText
	dw IndigoPlateauLobbyText2
	dw IndigoPlateauLobbyText3
	dw IndigoCashierText
	dw IndigoTradeNurseText
	dw MoveDeleterText1
	dw MoveRelearnerText1
	dw ProLeagueText1
	dw ProLeagueText2

IndigoHealNurseText:
	script_pokecenter_nurse

IndigoPlateauLobbyText2:
	text_far _IndigoPlateauLobbyText2
	text_end

IndigoPlateauLobbyText3:
	text_far _IndigoPlateauLobbyText3
	text_end

IndigoCashierText:
	script_mart ULTRA_BALL, GREAT_BALL, FULL_RESTORE, MAX_POTION, FULL_HEAL, REVIVE, MAX_REPEL

IndigoTradeNurseText:
	script_cable_club_receptionist

ProLeagueText1:
	text_asm
	call DisableWaitingAfterTextDisplay
	ld hl, ProLeagueText1a
	call PrintText
	call SaveScreenTilesToBuffer1
	hlcoord 11, 7
	lb bc, 8, 12
	ld a, NORMAL_PRO_MENU
	ld [wTwoOptionMenuID], a
	ld a, TWO_OPTION_MENU
	ld [wTextBoxID], a
	call DisplayTextBoxID
	call LoadScreenTilesFromBuffer1
	jp TextScriptEnd
	
ProLeagueText2:
	text_asm
	call DisableWaitingAfterTextDisplay
	ld hl, ProLeagueText2a
	call PrintText
	call YesNoChoice
	jp TextScriptEnd

ProLeagueText1a:
	text_far _ProLeagueText1
	text_end

ProLeagueText2a:
	text_far _ProLeagueText2
	text_end
