ChampionsRoom_Script:
	call EnableAutoTextBoxDrawing
	ld hl, ChampionsRoom_ScriptPointers
	ld a, [wChampionsRoomCurScript]
	jp CallFunctionInTable

ResetGaryScript:
	xor a
	ld [wJoyIgnore], a
	ld [wChampionsRoomCurScript], a
	ret

ChampionsRoom_ScriptPointers:
	dw GaryScript0
	dw GaryScript1
	dw GaryScript2
	dw GaryScript3
	dw GaryScript4
	dw GaryScript5
	dw GaryScript6
	dw GaryScript7
	dw GaryScript8
	dw GaryScript9
	dw GaryScript10
	dw GaryScript11
	dw MoveToCorrectSpot
	dw SetCorrectFacing

GaryScript0:
	ld hl, wVermilionBeachFlags
	lb bc, FLAG_TEST, 2
	predef FlagActionPredef
	ld a, c
	and a
	ret nz
	ld hl, CoordsData_CoordsChampionsRoom
	call ArePlayerCoordsInArray
	jr nc, .checkForOtherExit
	ld a, $6
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
	xor a
	ldh [hJoyHeld], a
	call StartSimulatingJoypadStates
	ld a, $1
	ld [wSimulatedJoypadStatesIndex], a
	ld a, D_UP
	ld [wSimulatedJoypadStatesEnd], a
	xor a
	ld [wSpritePlayerStateData1FacingDirection], a
	ld [wJoyIgnore], a
	ld a, $b
	ld [wChampionsRoomCurScript], a
	ret
.checkForOtherExit
	CheckEvent EVENT_BEAT_CHAMPION_RIVAL
	ret nz
	ld a, [wYCoord]
	cp 1
	ret nz
	ld a, 7
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
	xor a
	ldh [hJoyHeld], a
	call StartSimulatingJoypadStates
	ld a, D_DOWN
	ld [wSimulatedJoypadStatesEnd], a
	ld a, $1
	ld [wSimulatedJoypadStatesIndex], a
	xor a
	ld [wSpritePlayerStateData1FacingDirection], a
	ld [wJoyIgnore], a
	ld a, $b
	ld [wChampionsRoomCurScript], a
	ret

CoordsData_CoordsChampionsRoom:
	dbmapcoord 3, 6
	dbmapcoord 4, 6
	db -1 ; end

GaryScript1:
	ld a, $ff
	ld [wJoyIgnore], a
	ld hl, wSimulatedJoypadStatesEnd
	ld de, GaryEntrance_RLEMovement
	call DecodeRLEList
	dec a
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
	ld a, $b
	ld [wChampionsRoomCurScript], a
	ret

GaryEntrance_RLEMovement:
	db D_UP, 1
	db D_RIGHT, 1
	db D_UP, 1
	db -1 ; end

GaryScript2:
	xor a
	ld [wJoyIgnore], a
	ld hl, wOptions
	res 7, [hl]  ; Turn on battle animations to make the battle feel more epic.
;	ld a, 1
;	ldh [hSpriteIndexOrTextID], a
;	call DisplayTextID
	call Delay3
	ld hl, wd72d
	set 6, [hl]
	set 7, [hl]
	ld hl, GaryDefeatedText
	ld de, GaryVictoryText
	call SaveEndBattleTextPointers
	predef HealParty
	ld a, OPP_RIVAL3
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

	xor a
	ldh [hJoyHeld], a
	ld a, $3
	ld [wChampionsRoomCurScript], a
	ret

GaryScript3:
	ld a, [wIsInBattle]
	cp $ff
	jp z, ResetGaryScript
	call UpdateSprites
	SetEvent EVENT_BEAT_CHAMPION_RIVAL
	ld a, $f0
	ld [wJoyIgnore], a
	ld a, $1
	ldh [hSpriteIndexOrTextID], a
	call GaryScript_760c8
	ld a, $1
	ldh [hSpriteIndex], a
	call SetSpriteMovementBytesToFF
	ld a, $4
	ld [wChampionsRoomCurScript], a
	ret

GaryScript4:
	farcall Music_Cities1AlternateTempo
	ld a, $2
	ldh [hSpriteIndexOrTextID], a
	call GaryScript_760c8
	ld a, $2
	ldh [hSpriteIndex], a
	call SetSpriteMovementBytesToFF
	ld de, OakEntranceAfterVictoryMovement
	ld a, $2
	ldh [hSpriteIndex], a
	call MoveSprite
	ld a, HS_CHAMPIONS_ROOM_OAK
	ld [wMissableObjectIndex], a
	predef ShowObject
	ld a, $5
	ld [wChampionsRoomCurScript], a
	ret

OakEntranceAfterVictoryMovement:
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db -1 ; end

GaryScript5:
	ld a, [wd730]
	bit 0, a
	ret nz
	ld a, PLAYER_DIR_LEFT
	ld [wPlayerMovingDirection], a
	ld a, $1
	ldh [hSpriteIndex], a
	ld a, SPRITE_FACING_LEFT
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld a, $2
	ldh [hSpriteIndex], a
	xor a ; SPRITE_FACING_DOWN
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld a, $3
	ldh [hSpriteIndexOrTextID], a
	call GaryScript_760c8
	ld a, $6
	ld [wChampionsRoomCurScript], a
	ret

GaryScript6:
	ld a, $2
	ldh [hSpriteIndex], a
	ld a, SPRITE_FACING_RIGHT
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld a, $4
	ldh [hSpriteIndexOrTextID], a
	call GaryScript_760c8
	ld a, $7
	ld [wChampionsRoomCurScript], a
	ret

GaryScript7:
	ld a, $2
	ldh [hSpriteIndex], a
	xor a ; SPRITE_FACING_DOWN
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld a, $5
	ldh [hSpriteIndexOrTextID], a
	call GaryScript_760c8
	ld de, OakExitGaryRoomMovement
	ld a, $2
	ldh [hSpriteIndex], a
	call MoveSprite
	ld a, $8
	ld [wChampionsRoomCurScript], a
	ret

OakExitGaryRoomMovement:
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db -1 ; end

GaryScript8:
	ld a, [wd730]
	bit 0, a
	ret nz
	ld a, HS_CHAMPIONS_ROOM_OAK
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, $9
	ld [wChampionsRoomCurScript], a
	ret

GaryScript9:
	ld a, $ff
	ld [wJoyIgnore], a
;	ld hl, wSimulatedJoypadStatesEnd
;	ld de, WalkToHallOfFame_RLEMovment
;	call DecodeRLEList
;	dec a
;	ld [wSimulatedJoypadStatesIndex], a
;	call StartSimulatingJoypadStates
	ld a, $a
	ld [wChampionsRoomCurScript], a
	ret

WalkToHallOfFame_RLEMovment:
	db D_UP, 2
	db D_LEFT, 1
	db -1 ; end

GaryScript10:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	xor a
	ld [wJoyIgnore], a
	ld a, $0
	ld [wChampionsRoomCurScript], a
	ret

GaryScript11:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	call Delay3
	ld a, $0
	ld [wChampionsRoomCurScript], a
	ld [wCurMapScript], a
	ret

GaryScript_760c8:
	ld a, $f0
	ld [wJoyIgnore], a
	call DisplayTextID
	ld a, $ff
	ld [wJoyIgnore], a
	ret

MoveToCorrectSpot:
	ld a, 2
	ld [wChampionsRoomCurScript], a
	ld [wCurMapScript], a
	ld a, [wYCoord]
	cp 3
	ret z
	ld a, 13
	ld [wChampionsRoomCurScript], a
	ld [wCurMapScript], a
	ld hl, wSimulatedJoypadStatesEnd
	ld a, [wXCoord]
	cp 3
	ld de, LeftSide_RLEMovment
	jr z, .next
	ld de, RightSide_RLEMovment	
.next
	call DecodeRLEList
	dec a
	ld [wSimulatedJoypadStatesIndex], a
	jp StartSimulatingJoypadStates
	
SetCorrectFacing:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	call Delay3
	ld a, 1 ; RIVAL
	ldh [hSpriteIndex], a
	xor a ; SPRITE_FACING_DOWN
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld a, PLAYER_DIR_UP
	ld [wPlayerMovingDirection], a
	ld a, 2
	ld [wChampionsRoomCurScript], a
	ld [wCurMapScript], a
	ret

RightSide_RLEMovment:
	db D_LEFT, 1
	db D_DOWN, 1
	db -1 ; end

LeftSide_RLEMovment:
	db D_RIGHT, 1
	db D_DOWN, 1
	db -1 ; end

ChampionsRoom_TextPointers:
	dw GaryText1
	dw GaryText2
	dw GaryText3
	dw GaryText4
	dw GaryText5
	dw GaryText6
	dw GaryText7

GaryText1:
	text_asm
	CheckEvent EVENT_BEAT_CHAMPION_RIVAL
	jr z, .preBattle
	ld hl, GaryText_76103
	call PrintText
	jp TextScriptEnd
.preBattle
	ld hl, GaryChampionIntroText
	call PrintText
	ld a, 12
	ld [wChampionsRoomCurScript], a
	ld [wCurMapScript], a
	jp TextScriptEnd

GaryChampionIntroText:
	text_far _GaryChampionIntroText
	text_end

GaryDefeatedText:
	text_far _GaryDefeatedText
	text_end

GaryVictoryText:
	text_far _GaryVictoryText
	text_end

GaryText_76103:
	text_far _GaryText_76103
	text_end

GaryText2:
	text_far _GaryText2
	text_end

GaryText3:
	text_asm
	ld a, [wPlayerStarter]
	ld [wd11e], a
	call GetMonName
	ld hl, GaryText_76120
	call PrintText
	jp TextScriptEnd

GaryText_76120:
	text_far _GaryText_76120
	text_end

GaryText4:
	text_far _GaryText_76125
	text_end

GaryText5:
	text_far _GaryText_7612a
	text_end

GaryText6:
	text_asm
	CheckEvent EVENT_BEAT_CHAMPION_RIVAL
	ld hl, GaryText7
	jr z, .printText
	ld hl, GaryText6a
.printText
	call PrintText
	jp TextScriptEnd

GaryText6a:
	text_far _GaryText6
	text_end

GaryText7:
	text_far _GaryText7
	text_end
