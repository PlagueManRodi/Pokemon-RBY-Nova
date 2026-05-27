MtMoonB5F_Script:
	ld hl, wCurrentMapScriptFlags
	bit 6, [hl]
	res 6, [hl]
	call nz, MtMoonB5FCheckBoulderEventScript
	call EnableAutoTextBoxDrawing
	ld hl, MtMoonB5F_ScriptPointers
	ld a, [wMtMoonB5FCurScript]
	jp CallFunctionInTable
	
MtMoonB5F_ScriptPointers:
	dw MtMoonB5FScript0
	dw MtMoonB5FScript1

MtMoonB5FScript0:
	ld hl, wFlags_0xcd60
	bit 7, [hl]
	res 7, [hl]
	ret z
	ld hl, MtMoonB5FSwitchCoords
	call CheckBoulderCoords
	ret nc
	EventFlagAddress hl, EVENT_MT_MOON_B5F_BOULDER_ON_SWITCH_1
	ld a, [wCoordIndex]
	cp 4
	jr z, .fourthSwitch
	cp 3
	jr z, .thirdSwitch
	cp 2
	jr z, .secondSwitch
; first switch
	CheckEventReuseHL EVENT_MT_MOON_B5F_BOULDER_ON_SWITCH_1
	SetEventReuseHL EVENT_MT_MOON_B5F_BOULDER_ON_SWITCH_1
	ret nz
	jr .end
.secondSwitch
	CheckEventAfterBranchReuseHL EVENT_MT_MOON_B5F_BOULDER_ON_SWITCH_2, EVENT_MT_MOON_B5F_BOULDER_ON_SWITCH_1
	SetEventReuseHL EVENT_MT_MOON_B5F_BOULDER_ON_SWITCH_2
	ret nz
	jr .end
.thirdSwitch
	CheckEventAfterBranchReuseHL EVENT_MT_MOON_B5F_BOULDER_ON_SWITCH_3, EVENT_MT_MOON_B5F_BOULDER_ON_SWITCH_1
	SetEventReuseHL EVENT_MT_MOON_B5F_BOULDER_ON_SWITCH_3
	ret nz
	jr .end
.fourthSwitch
	CheckEventAfterBranchReuseHL EVENT_MT_MOON_B5F_BOULDER_ON_SWITCH_4, EVENT_MT_MOON_B5F_BOULDER_ON_SWITCH_1
	SetEventReuseHL EVENT_MT_MOON_B5F_BOULDER_ON_SWITCH_4
	ret nz
.end
	ld hl, wCurrentMapScriptFlags
	set 6, [hl]
	ret

MtMoonB5FSwitchCoords:
	dbmapcoord  5, 15
	dbmapcoord  7, 12
	dbmapcoord 13, 10
	dbmapcoord 15,  1
	db -1 ; end

MtMoonB5FCheckBoulderEventScript:
;	xor a
;	ldh [hSpriteIndex],a
	CheckEvent EVENT_MT_MOON_B5F_BOULDER_ON_SWITCH_1
	jr z, .next
	lb bc, 5, 5
	call ReplaceMtMoonB5FBlock
.next
	CheckEvent EVENT_MT_MOON_B5F_BOULDER_ON_SWITCH_2
	jr z, .next2
	lb bc, 4, 5
	call ReplaceMtMoonB5FBlock
.next2
	CheckEvent EVENT_MT_MOON_B5F_BOULDER_ON_SWITCH_3
	jr z, .next3
	lb bc, 3, 4
	call ReplaceMtMoonB5FBlock
.next3
	CheckEvent EVENT_MT_MOON_B5F_BOULDER_ON_SWITCH_4
	jr z, .next4
	lb bc, 2, 4	
	call ReplaceMtMoonB5FBlock
.next4
	jr MtMoonB5FHideAndShowBoulderObjects
	
ReplaceMtMoonB5FBlock:
	ld a, 1
	ld [wNewTileBlockID], a
	predef_jump ReplaceTileBlock
	
MtMoonB5FHideAndShowBoulderObjects:
	CheckEvent EVENT_MT_MOON_B5F_BOULDER_ON_SWITCH_1
	jr z, .next
	ld a, HS_MT_MOON_B5F_BOULDER_7
	ld [wMissableObjectIndex], a
	predef HideNewObject
	ld a, HS_MT_MOON_B5F_BOULDER_8
	ld [wMissableObjectIndex], a
	predef ShowNewObject
.next
	CheckEvent EVENT_MT_MOON_B5F_BOULDER_ON_SWITCH_2
	jr z, .next2
	ld a, HS_MT_MOON_B5F_BOULDER_1
	ld [wMissableObjectIndex], a
	predef HideNewObject
	ld a, HS_MT_MOON_B5F_BOULDER_9
	ld [wMissableObjectIndex], a
	predef ShowNewObject
.next2
	CheckEvent EVENT_MT_MOON_B5F_BOULDER_ON_SWITCH_3
	jr z, .next3
	ld a, HS_MT_MOON_B5F_BOULDER_6
	ld [wMissableObjectIndex], a
	predef HideNewObject
	ld a, HS_MT_MOON_B5F_BOULDER_10
	ld [wMissableObjectIndex], a
	predef ShowNewObject
.next3
	CheckEvent EVENT_MT_MOON_B5F_BOULDER_ON_SWITCH_4
	ret z	
	ld a, HS_MT_MOON_B5F_BOULDER_2
	ld [wMissableObjectIndex], a
	predef HideNewObject
	ld a, HS_MT_MOON_B5F_BOULDER_11
	ld [wMissableObjectIndex], a
	predef_jump ShowNewObject

MtMoonB5FScript1:
	ld a, [wIsInBattle]
	cp $ff
	jr z, MtMoonB5FBattleLost
	SetEvent EVENT_BEAT_SCREAMTAIL
	call GBFadeOutToBlack
	ld a, HS_SCREAMTAIL
	ld [wMissableObjectIndex], a
	predef HideNewObject
	ld a, HS_MT_MOON_B5F_SCREAMTAIL_GIFT
	ld [wMissableObjectIndex], a
	predef ShowNewObject
	call GBFadeInFromBlack
	xor a
	ld [wMtMoonB5FCurScript], a
	ret

MtMoonB5FBattleLost:
	xor a
	ld [wMtMoonB5FCurScript], a
	ld [wJoyIgnore], a
	ret

MtMoonB5F_TextPointers:
	dw BoulderText
	dw BoulderText
	dw BoulderText
	dw BoulderText
	dw BoulderText
	dw BoulderText
	dw BoulderText
	dw MtMoonB5FBoulderOnSwitchText
	dw MtMoonB5FBoulderOnSwitchText
	dw MtMoonB5FBoulderOnSwitchText
	dw MtMoonB5FBoulderOnSwitchText
	dw ScreamtailText
	dw MtMoonB5FText13
	dw PickUpItemText
	dw PickUpItemText

	def_trainers 4
ScreamtailTrainerHeader:
	trainer EVENT_BEAT_SCREAMTAIL, 0, ScreamtailBattleText, ScreamtailBattleText, ScreamtailBattleText
	db -1 ; end

MtMoonB5FBoulderOnSwitchText:
	text_far _BoulderOnSwitchText
	text_end

ScreamtailText:
	text_asm
	ld hl, ScreamtailTrainerHeader
	call TalkToTrainer
	ld a, 1
	ld [wMtMoonB5FCurScript], a
	jp TextScriptEnd

MtMoonB5FText13:
	text_asm
	lb bc, SCREAMTAIL, 100
	call GivePokemon
	jr nc, .party_full
	ld a, HS_MT_MOON_B5F_SCREAMTAIL_GIFT
	ld [wMissableObjectIndex], a
	predef HideNewObject
.party_full
	jp TextScriptEnd

ScreamtailBattleText:
	text_far _ScreamtailBattleText
	text_asm
	ld a, SCREAMTAIL
	call PlayCry
	call WaitForSoundToFinish
	jp TextScriptEnd
