VermilionBeach_Script:
	call EnableAutoTextBoxDrawing
	ld hl, VermilionBeachTrainerHeaders
	ld de, VermilionBeach_ScriptPointers
	ld a, [wVermilionBeachCurScript]
	call ExecuteCurMapScriptInTable
	ld [wVermilionBeachCurScript], a
	call VermilionBeachItemCheck
	ret

VermilionBeach_ScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle
	dw VermilionBeachScript4
	dw VermilionBeachScript5

VermilionBeachScript4:
	ld a, [wIsInBattle]
	cp $ff
	jr z, VermilionBeachBattleLost
	SetEvent EVENT_BEAT_SANDYSHOCK
	ld hl, wVermilionBeachFlags
	res 0, [hl]
	call GBFadeOutToBlack
	ld a, HS_SANDYSHOCK
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_VERMILION_BEACH_SANDYSHOCK_GIFT
	ld [wMissableObjectIndex], a
	predef ShowObject
	call GBFadeInFromBlack
	xor a
	ld [wVermilionBeachCurScript], a
	ld [wCurMapScript], a
	ret
	
VermilionBeachBattleLost:
	xor a
	ld [wVermilionBeachCurScript], a
	ld [wCurMapScript], a
	ld [wJoyIgnore], a
	ret

RemoveVermilionBeachItems::
	CheckEvent EVENT_BEAT_SANDYSHOCK
	ret nz
	ld hl, wVermilionBeachFlags
	bit 0, [hl]
	ret z
	res 0, [hl]
	ld a, HYPER_POTION
	ldh [hItemToRemoveID], a
	farcall RemoveItemByID
	ld a, ELIXER
	ldh [hItemToRemoveID], a
	farcall RemoveItemByID
	ld a, MAX_REVIVE
	ldh [hItemToRemoveID], a
	farcall RemoveItemByID
	ld a, FULL_RESTORE
	ldh [hItemToRemoveID], a
	farcall RemoveItemByID
	ld a, MAX_POTION
	ldh [hItemToRemoveID], a
	farcall RemoveItemByID
	ld a, SODA_POP
	ldh [hItemToRemoveID], a
	farcall RemoveItemByID
	ld a, FULL_HEAL
	ldh [hItemToRemoveID], a
	farcall RemoveItemByID
	ld a, REVIVE
	ldh [hItemToRemoveID], a
	farjp RemoveItemByID
	
ResetVermilionBeachEvents::
	CheckEvent EVENT_BEAT_SANDYSHOCK
	ret nz
;	ld hl, wVermilionBeachFlags
;	bit 0, [hl]
;	ret z
	ResetEventRange EVENT_BEAT_VERMILION_BEACH_TRAINER_0, EVENT_BEAT_VERMILION_BEACH_TRAINER_8
	ld a, HS_VERMILION_BEACH_ITEM_1
	ld [wMissableObjectIndex], a
	predef ShowObject
	ld a, HS_VERMILION_BEACH_ITEM_2
	ld [wMissableObjectIndex], a
	predef ShowObject
	ld a, HS_VERMILION_BEACH_ITEM_3
	ld [wMissableObjectIndex], a
	predef ShowObject
	ld a, HS_VERMILION_BEACH_ITEM_4
	ld [wMissableObjectIndex], a
	predef ShowObject
	ld hl, wObtainedHiddenItemsFlags+7
	ld a, [hl]
	ld b, a
	ld a, $3F
	and b
	ld [hli], a
	ld a, [hl]
	ld b, a
	ld a, $FC
	and b
	ld [hl], a
	ret

VermilionBeachItemCheck:
IF DEF(_DEBUG)
	call DebugPressedOrHeldB
	ret nz
ENDC
	CheckEvent EVENT_BEAT_SANDYSHOCK
	ret nz
	ld a, [wYCoord]
	cp 24
	ret nz
	ld a, [wXCoord]
	cp 46
	ret nz
	ld hl, wVermilionBeachFlags
	bit 0, [hl]
	ret nz
	set 0, [hl]
	ld a, [wNumBagItems]
	and a
	ret z
	res 0, [hl]
	call GBFadeOutToWhite
	call Delay3
	call GBFadeInFromWhite
	ld a, 16
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
	xor a
	ldh [hJoyHeld], a
	call StartSimulatingJoypadStates
	ld a, 1
	ld [wSimulatedJoypadStatesIndex], a
	ld a, D_RIGHT
	ld [wSimulatedJoypadStatesEnd], a
	xor a
	ld [wSpritePlayerStateData1FacingDirection], a
	ld [wJoyIgnore], a
	ld a, 4
	ld [wVermilionBeachCurScript], a
	ld [wCurMapScript], a
	ret

VermilionBeachScript5:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	call Delay3
	ld a, 0
	ld [wVermilionBeachCurScript], a
	ld [wCurMapScript], a
	ret

VermilionBeach_TextPointers:
	dw VermilionBeachText1
	dw VermilionBeachText2
	dw VermilionBeachText3
	dw VermilionBeachText4
	dw VermilionBeachText5
	dw VermilionBeachText6
	dw VermilionBeachText7
	dw VermilionBeachText8
	dw VermilionBeachText9
	dw SandyshockText
	dw PickUpItemText
	dw PickUpItemText
	dw PickUpItemText
	dw PickUpItemText
	dw VermilionBeachText15
	dw VermilionBeachText16
	
VermilionBeachTrainerHeaders:
	def_trainers
VermilionBeachTrainerHeader0:
	trainer EVENT_BEAT_VERMILION_BEACH_TRAINER_0, 1, VermilionBeachBattleText1, VermilionBeachEndBattleText1, VermilionBeachAfterBattleText1
VermilionBeachTrainerHeader1:
	trainer EVENT_BEAT_VERMILION_BEACH_TRAINER_1, 1, VermilionBeachBattleText2, VermilionBeachEndBattleText2, VermilionBeachAfterBattleText2
VermilionBeachTrainerHeader2:
	trainer EVENT_BEAT_VERMILION_BEACH_TRAINER_2, 1, VermilionBeachBattleText3, VermilionBeachEndBattleText3, VermilionBeachAfterBattleText3
VermilionBeachTrainerHeader3:
	trainer EVENT_BEAT_VERMILION_BEACH_TRAINER_3, 5, VermilionBeachBattleText4, VermilionBeachEndBattleText4, VermilionBeachAfterBattleText4
VermilionBeachTrainerHeader4:
	trainer EVENT_BEAT_VERMILION_BEACH_TRAINER_4, 2, VermilionBeachBattleText5, VermilionBeachEndBattleText5, VermilionBeachAfterBattleText5
VermilionBeachTrainerHeader5:
	trainer EVENT_BEAT_VERMILION_BEACH_TRAINER_5, 5, VermilionBeachBattleText6, VermilionBeachEndBattleText6, VermilionBeachAfterBattleText6
VermilionBeachTrainerHeader6:
	trainer EVENT_BEAT_VERMILION_BEACH_TRAINER_6, 1, VermilionBeachBattleText7, VermilionBeachEndBattleText7, VermilionBeachAfterBattleText7
VermilionBeachTrainerHeader7:
	trainer EVENT_BEAT_VERMILION_BEACH_TRAINER_7, 1, VermilionBeachBattleText8, VermilionBeachEndBattleText8, VermilionBeachAfterBattleText8
VermilionBeachTrainerHeader8:
	trainer EVENT_BEAT_VERMILION_BEACH_TRAINER_8, 3, VermilionBeachBattleText9, VermilionBeachEndBattleText9, VermilionBeachAfterBattleText9
SandyshockTrainerHeader:
	trainer EVENT_BEAT_SANDYSHOCK, 0, SandyshockBattleText, SandyshockBattleText, SandyshockBattleText
	db -1 ; end

VermilionBeachText1:
	text_asm
	ld hl, VermilionBeachTrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd
	
VermilionBeachText2:
	text_asm
	ld hl, VermilionBeachTrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd
	
VermilionBeachText3:
	text_asm
	ld hl, VermilionBeachTrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd
	
VermilionBeachText4:
	text_asm
	ld hl, VermilionBeachTrainerHeader3
	call TalkToTrainer
	jp TextScriptEnd
	
VermilionBeachText5:
	text_asm
	ld hl, VermilionBeachTrainerHeader4
	call TalkToTrainer
	jp TextScriptEnd
	
VermilionBeachText6:
	text_asm
	ld hl, VermilionBeachTrainerHeader5
	call TalkToTrainer
	jp TextScriptEnd
	
VermilionBeachText7:
	text_asm
	ld hl, VermilionBeachTrainerHeader6
	call TalkToTrainer
	jp TextScriptEnd
	
VermilionBeachText8:
	text_asm
	ld hl, VermilionBeachTrainerHeader7
	call TalkToTrainer
	jp TextScriptEnd
	
VermilionBeachText9:
	text_asm
	ld hl, VermilionBeachTrainerHeader8
	call TalkToTrainer
	jp TextScriptEnd

SandyshockText:
	text_asm
	ld hl, SandyshockTrainerHeader
	call TalkToTrainer
	ld a, 3
	ld [wCurMapScript], a
	ld [wVermilionBeachCurScript], a
	jp TextScriptEnd

VermilionBeachText15:
	text_asm
	lb bc, SANDYSHOCK, 100
	call GivePokemon
	jr nc, .party_full
	ld a, HS_VERMILION_BEACH_SANDYSHOCK_GIFT
	ld [wMissableObjectIndex], a
	predef HideObject
.party_full
	jp TextScriptEnd
	
VermilionBeachText16:
	text_asm
	ld hl, VermilionBeachMagneticFieldText
	call PrintText
	jp TextScriptEnd
	
VermilionBeachMagneticFieldText:
	text_far _VermilionBeachMagneticFieldText
	text_end

VermilionBeachBattleText1:
	text_far _VermilionBeachBattleText1
	text_end

VermilionBeachEndBattleText1:
	text_far _VermilionBeachEndBattleText1
	text_end

VermilionBeachAfterBattleText1:
	text_far _VermilionBeachAfterBattleText1
	text_end
	
VermilionBeachBattleText2:
	text_far _VermilionBeachBattleText2
	text_end

VermilionBeachEndBattleText2:
	text_far _VermilionBeachEndBattleText2
	text_end

VermilionBeachAfterBattleText2:
	text_far _VermilionBeachAfterBattleText2
	text_end

VermilionBeachBattleText3:
	text_far _VermilionBeachBattleText3
	text_end

VermilionBeachEndBattleText3:
	text_far _VermilionBeachEndBattleText3
	text_end

VermilionBeachAfterBattleText3:
	text_far _VermilionBeachAfterBattleText3
	text_end

VermilionBeachBattleText4:
	text_far _VermilionBeachBattleText4
	text_end

VermilionBeachEndBattleText4:
	text_far _VermilionBeachEndBattleText4
	text_end

VermilionBeachAfterBattleText4:
	text_far _VermilionBeachAfterBattleText4
	text_end

VermilionBeachBattleText5:
	text_far _VermilionBeachBattleText5
	text_end

VermilionBeachEndBattleText5:
	text_far _VermilionBeachEndBattleText5
	text_end

VermilionBeachAfterBattleText5:
	text_far _VermilionBeachAfterBattleText5
	text_end

VermilionBeachBattleText6:
	text_far _VermilionBeachBattleText6
	text_end

VermilionBeachEndBattleText6:
	text_far _VermilionBeachEndBattleText6
	text_end

VermilionBeachAfterBattleText6:
	text_far _VermilionBeachAfterBattleText6
	text_end

VermilionBeachBattleText7:
	text_far _VermilionBeachBattleText7
	text_end

VermilionBeachEndBattleText7:
	text_far _VermilionBeachEndBattleText7
	text_end

VermilionBeachAfterBattleText7:
	text_far _VermilionBeachAfterBattleText7
	text_end

VermilionBeachBattleText8:
	text_far _VermilionBeachBattleText8
	text_end

VermilionBeachEndBattleText8:
	text_far _VermilionBeachEndBattleText8
	text_end

VermilionBeachAfterBattleText8:
	text_far _VermilionBeachAfterBattleText8
	text_end

VermilionBeachBattleText9:
	text_far _VermilionBeachBattleText9
	text_end

VermilionBeachEndBattleText9:
	text_far _VermilionBeachEndBattleText9
	text_end

VermilionBeachAfterBattleText9:
	text_far _VermilionBeachAfterBattleText9
	text_end

SandyshockBattleText:
	text_far _SandyshockBattleText
	text_asm
	ld a, SANDYSHOCK
	call PlayCry
	call WaitForSoundToFinish
	jp TextScriptEnd
