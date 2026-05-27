HallOfFame_Script:
	call EnableAutoTextBoxDrawing
	ld hl, HallOfFame_ScriptPointers
	ld a, [wHallOfFameCurScript]
	jp CallFunctionInTable

HallofFameRoomScript_5a4aa:
	xor a
	ld [wJoyIgnore], a
	ld [wHallOfFameCurScript], a
	ret

HallOfFame_ScriptPointers:
	dw HallofFameRoomScript0
	dw HallofFameRoomScript1
	dw HallofFameRoomScript2
	dw HallofFameRoomScript3
	dw HallofFameRoomScript4
	dw HallofFameRoomScript5

HallofFameRoomScript3:
	ld a, [wIsInBattle]
	cp $ff
	jp z, HallofFameRoomScript_5a4aa
	call UpdateSprites
	farcall Music_Cities1AlternateTempo
	SetEvent EVENT_BEAT_CHAMPION_OAK
	SetEvent EVENT_BECAME_CHAMPION
	
	;; NEW LEVEL CAP
	CheckEvent EVENT_PLAYING_WITH_LEVEL_CAPS
	jr z, .notPlayingWithLevelCaps
	ld hl, wLevelCap
	ld a, 0
	cp [hl]
	jr z, .notPlayingWithLevelCaps
	ld a, 100
	cp [hl]
	jr c, .notPlayingWithLevelCaps
	ld [wLevelCap], a
.notPlayingWithLevelCaps
	ResetEvent EVENT_PLAYING_WITH_LEVEL_CAPS
	;;
	
	ld a, $ff
	ld [wJoyIgnore], a
	ld a, $1
	ldh [hSpriteIndexOrTextID], a
	ld a, $f0
	ld [wJoyIgnore], a
	call DisplayTextID
	ld a, $ff
	ld [wJoyIgnore], a
	ld a, HS_CERULEAN_CAVE_GUY
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_ARTICUNO
	ld [wMissableObjectIndex], a
	predef ShowObject
	ld a, HS_ZAPDOS
	ld [wMissableObjectIndex], a
	predef ShowObject
	ld a, HS_MOLTRES
	ld [wMissableObjectIndex], a
	predef ShowObject
	ld a, HS_MEWTWO
	ld [wMissableObjectIndex], a
	predef ShowObject
	ResetEvent EVENT_BEAT_ARTICUNO
	ResetEvent EVENT_BEAT_ZAPDOS
	ResetEvent EVENT_BEAT_MOLTRES
	ResetEvent EVENT_BEAT_MEWTWO
	ld a, HS_VERMILION_HARBOR_MEW_GIFT
	ld [wMissableObjectIndex], a
	predef ShowObject
	CheckEvent EVENT_BEAT_COOLTRAINER_SUPERBOSS
	jr nz, .alreadyDefeatedCool
	ld a, HS_ROCK_TUNNEL_B1F_COOLTRAINER
	ld [wMissableObjectIndex], a
	predef ShowObject
.alreadyDefeatedCool
	CheckEvent EVENT_BEAT_BUGCATCHER_SUPERBOSS
	jr nz, .alreadyDefeatedBug
	ld a, HS_VIRIDIAN_FOREST_BUGCATCHER
	ld [wMissableObjectIndex], a
	predef ShowObject
.alreadyDefeatedBug
	ld a, HS_SANDYSHOCK
	ld [wMissableObjectIndex], a
	predef ShowObject
	ld a, HS_VERMILION_BEACH_SANDYSHOCK_GIFT
	ld [wMissableObjectIndex], a
	predef HideObject
	ResetEvent EVENT_BEAT_SANDYSHOCK
	callfar ResetVermilionBeachEvents
	ld a, HS_SCREAMTAIL
	ld [wMissableObjectIndex], a
	predef ShowNewObject
	ld a, HS_MT_MOON_B5F_SCREAMTAIL_GIFT
	ld [wMissableObjectIndex], a
	predef HideNewObject
	ResetEvent EVENT_BEAT_SCREAMTAIL
	callfar ResetMtMoonLowerFloorsEvents	
	ld a, HS_VIRIDIAN_GYM_GIOVANNI
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_VIRIDIAN_GYM_RIVAL
	ld [wMissableObjectIndex], a
	predef ShowObject
	predef HealParty
	ld a, $2
	ld [wHallOfFameCurScript], a
	ret

HallofFameRoomScript2:
	call Delay3
	ld a, [wLetterPrintingDelayFlags]
	push af
	xor a
	ld [wJoyIgnore], a
	predef HallOfFamePC
	pop af
	ld [wLetterPrintingDelayFlags], a
	ld hl, wFlags_D733
	res 1, [hl]
	inc hl
	set 0, [hl]
	xor a
	ld hl, wLoreleisRoomCurScript
	ld [hli], a ; wLoreleisRoomCurScript
	ld [hli], a ; wBrunosRoomCurScript
	ld [hl], a ; wAgathasRoomCurScript
	ld [wLancesRoomCurScript], a
	ld [wHallOfFameCurScript], a
	; Elite 4 events
	ResetEventRange INDIGO_PLATEAU_EVENTS_START, INDIGO_PLATEAU_EVENTS_END, 1
	xor a
	ld [wHallOfFameCurScript], a
	ld a, PALLET_TOWN
	ld [wLastBlackoutMap], a
	farcall SaveSAVtoSRAM
	ld b, 5
.delayLoop
	ld c, 600 / 5
	call DelayFrames
	dec b
	jr nz, .delayLoop
	call WaitForTextScrollButtonPress
	jp Init

HallofFameRoomScript0:
;	ld a, $ff
;	ld [wJoyIgnore], a
;	ld hl, wSimulatedJoypadStatesEnd
;	ld de, RLEMovement5a528
;	call DecodeRLEList
;	dec a
;	ld [wSimulatedJoypadStatesIndex], a
;	call StartSimulatingJoypadStates
;	ld a, $1
;	ld [wHallOfFameCurScript], a
	ret

RLEMovement5a528:
	db D_UP, 5
	db -1 ; end

HallofFameRoomScript1:
	predef HealParty
	ld hl, wOptions
	res 7, [hl]  ; Turn on battle animations to make the battle feel more epic.
	ld hl, wVermilionBeachFlags
	lb bc, FLAG_TEST, 2
	predef FlagActionPredef
	ld a, c
	and a
	jr z, .notRematch
	ld hl, wd72d
	set 6, [hl]
	set 7, [hl]
	ld hl, OakRematchEndBattleText
	ld de, OakRematchEndBattleText
	call SaveEndBattleTextPointers
	ld a, OPP_PROF_OAK
	ld [wCurOpponent], a
	ld a, 4
	ld [wTrainerNo], a
	jr .done
;	ld a, $1
;	ldh [hSpriteIndexOrTextID], a
;	call DisplayTextID
;	call Delay3
.notRematch
	ld hl, wd72d
	set 6, [hl]
	set 7, [hl]
	ld hl, OakDefeatedText
	ld de, OakVictoryText
	call SaveEndBattleTextPointers
	ld a, OPP_PROF_OAK
	ld [wCurOpponent], a

	; select which team to use during the encounter
	ld a, [wRivalStarter]
	cp STARTER2
	jr nz, .NotStarter2
	ld a, $1
	jr .saveTrainerId
.NotStarter2
	cp STARTER3
	jr nz, .NotStarter3
	ld a, $2
	jr .saveTrainerId
.NotStarter3
	ld a, $3
.saveTrainerId
	ld [wTrainerNo], a
.done
	xor a
	ldh [hJoyHeld], a
	ld a, $3
	ld [wHallOfFameCurScript], a
	ret	

HallofFameRoomScript4:
	ld a, 1
	ld [wHallOfFameCurScript], a
	ld [wCurMapScript], a
	ld a, [wXCoord]
	cp 4
	jp z, HallofFameRoomScript1
	ld a, 5
	ld [wHallOfFameCurScript], a
	ld [wCurMapScript], a
	ld hl, wSimulatedJoypadStatesEnd
	ld a, [wXCoord]
	cp 5
	ld de, LeftSide2_RLEMovment
	jr z, .next
	ld de, RightSide2_RLEMovment	
.next
	call DecodeRLEList
	dec a
	ld [wSimulatedJoypadStatesIndex], a
	jp StartSimulatingJoypadStates
	
RightSide2_RLEMovment:
	db D_UP, 1
	db D_LEFT, 2
	db D_DOWN, 1
	db -1 ; end

LeftSide2_RLEMovment:
	db D_UP, 1
	db D_LEFT, 1
	db -1 ; end

HallofFameRoomScript5:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	ld a, PLAYER_DIR_RIGHT
	ld [wPlayerMovingDirection], a
	ld a, $1
	ldh [hSpriteIndex], a
	call SetSpriteMovementBytesToFF
	ld a, SPRITE_FACING_LEFT
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	call Delay3
	xor a
	ld [wJoyIgnore], a
	inc a ; PLAYER_DIR_RIGHT
	ld [wPlayerMovingDirection], a
	ld a, 1
	ld [wHallOfFameCurScript], a
	ld [wCurMapScript], a
	ret

HallOfFame_TextPointers:
	dw HallofFameRoomText1

HallofFameRoomText1:
	text_asm
	ld hl, wVermilionBeachFlags
	lb bc, FLAG_TEST, 2
	predef FlagActionPredef
	ld a, c
	and a
	jr nz, .OakRematch
	CheckEvent EVENT_BEAT_CHAMPION_OAK
	ld hl, OakChampionIntroTextPart1
	jr z, .printText
	ld hl, OakPostBattleText
	call PrintText
	jp TextScriptEnd
.printText
	call PrintText
	ld c, BANK(Music_IndigoPlateau)
	ld a, MUSIC_INDIGO_PLATEAU
	call PlayMusic
	ld hl, OakChampionIntroTextPart2
	call PrintText
	ld a, $4
	ld [wHallOfFameCurScript], a
	jp TextScriptEnd
.OakRematch
	CheckEvent EVENT_BEAT_CHAMPION_OAK
	jr z, .beforeRematch
	ld hl, OakRematchAfterBattleText
	call PrintText
	jp TextScriptEnd
.beforeRematch
	ld hl, OakRematchBeforeBattleText
	call PrintText
	ld a, $4
	ld [wHallOfFameCurScript], a
	jp TextScriptEnd
	
OakChampionIntroTextPart1:
	text_far _OakChampionIntroTextPart1
	text_end

OakChampionIntroTextPart2:
	text_far _OakChampionIntroTextPart2
	text_end

OakDefeatedText:
	text_far _OakDefeatedText
	text_end

OakVictoryText:
	text_far _OakVictoryText
	text_end

OakPostBattleText:
	text_far _OakPostBattleText
	text_end

OakRematchBeforeBattleText:
	text_far _OakRematchBeforeBattleText
	text_end

OakRematchEndBattleText:
	text_far _OakRematchEndBattleText
	text_end

OakRematchAfterBattleText:
	text_far _OakRematchAfterBattleText
	text_end
