CeruleanCaveB1F_Script:
	call EnableAutoTextBoxDrawing
	ld hl, CeruleanCaveB1FTrainerHeaders
	ld de, CeruleanCaveB1F_ScriptPointers
	ld a, [wCeruleanCaveB1FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wCeruleanCaveB1FCurScript], a
	ret

CeruleanCaveB1F_ScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle
	dw CeruleanCaveB1FScript1
	
CeruleanCaveB1FScript1:
	ld a, [wIsInBattle]
	cp $ff
	jr z, CeruleanCaveB1FDontEndBattle
	SetEvent EVENT_BEAT_MEWTWO
	SetEvent EVENT_BEAT_MEWTWO_1ST_TIME
	call GBFadeOutToBlack
	ld a, HS_MEWTWO
	ld [wMissableObjectIndex], a
	predef HideObject
	call GBFadeInFromBlack
	CheckEvent EVENT_BEAT_GIOVANNI_SUPERBOSS
	jr nz, .dontTriggerGio2
	CheckEvent EVENT_BEAT_CHIEF
	jr z, .dontTriggerGio2
	ld a, HS_POKEMON_MANSION_GIOVANNI
	ld [wMissableObjectIndex], a
	predef ShowObject
.dontTriggerGio2
	xor a
	ld [wCeruleanCaveB1FCurScript], a
	ld [wCurMapScript], a
	ret

CeruleanCaveB1FDontEndBattle:
	xor a
	ld [wCeruleanCaveB1FCurScript], a
	ld [wCurMapScript], a
	ld [wJoyIgnore], a
	ret
	
CeruleanCaveB1F_TextPointers:
	dw MewtwoText
	dw PickUpItemText
	dw PickUpItemText

CeruleanCaveB1FTrainerHeaders:
	def_trainers
MewtwoTrainerHeader:
	trainer EVENT_BEAT_MEWTWO, 0, MewtwoBattleText, MewtwoBattleText, MewtwoBattleText
	db -1 ; end

MewtwoText:
	text_asm
	ld hl, MewtwoTrainerHeader
	call TalkToTrainer
	ld a, 3
	ld [wCeruleanCaveB1FCurScript], a
	ld [wCurMapScript], a
	jp TextScriptEnd

MewtwoBattleText:
	text_far _MewtwoBattleText
	text_asm
	ld a, MEWTWO
	call PlayCry
	call WaitForSoundToFinish
	jp TextScriptEnd
