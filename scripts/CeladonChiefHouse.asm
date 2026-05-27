CeladonChiefHouse_Script:
	call EnableAutoTextBoxDrawing
	ld a, [wChiefHouseCurScript]
	ld hl, ChiefHouse_ScriptPointers
	jp CallFunctionInTable

ChiefHouse_ScriptPointers:
	dw ChiefHouseScript0
	dw ChiefHouseScript1
	
ChiefHouseScript0:
	ret

ChiefHouseScript1:
	call EndTrainerBattle
	ld a, [wIsInBattle]
	cp $ff
	jr z, ChiefHouseDontEndBattle
	SetEvent EVENT_BEAT_CHIEF
	ld a, 1
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
	CheckEvent EVENT_BEAT_GIOVANNI_SUPERBOSS
	jr nz, .dontTriggerGio
	CheckEvent EVENT_BEAT_MEWTWO_1ST_TIME
	jr z, .dontTriggerGio
	ld a, HS_POKEMON_MANSION_GIOVANNI
	ld [wMissableObjectIndex], a
	predef ShowObject
.dontTriggerGio
	xor a
	ld [wChiefHouseCurScript], a
	ret

ChiefHouseDontEndBattle:
	xor a
	ld [wChiefHouseCurScript], a
	ld [wJoyIgnore], a
	ret

CeladonChiefHouse_TextPointers:
	dw CeladonHouseText1
	dw CeladonHouseText2
	dw CeladonHouseText3

CeladonHouseText1:
	text_asm
	CheckEvent EVENT_BEAT_CHIEF
	jr nz, .alreadyDefeated
	CheckEvent EVENT_BECAME_CHAMPION
	jr nz, CeladonHouseText4
.alreadyDefeated
	ld hl, CeladonHouseText1a
	call PrintText
	jp TextScriptEnd
	
CeladonHouseText1a:
	text_far _CeladonHouseText1
	text_end

CeladonHouseText2:
	text_far _CeladonHouseText2
	text_end

CeladonHouseText3:
	text_far _CeladonHouseText3
	text_end

ChiefHouseTrainerHeaders:
	def_trainers 3
ChiefTrainerHeader:
	trainer EVENT_BEAT_CHIEF, 0, ChiefBattleText, ChiefEndBattleText, ChiefBattleText
	db -1 ; end

CeladonHouseText4:
	ld hl, ChiefTrainerHeader
	call TalkToTrainer
	ld a, 1
	ld [wChiefHouseCurScript], a
	jp TextScriptEnd

ChiefBattleText:
	text_far _ChiefBattleText
	text_end

ChiefEndBattleText:
	text_far _ChiefEndBattleText
	text_end
