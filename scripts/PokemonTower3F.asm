PokemonTower3F_Script:
	call EnableAutoTextBoxDrawing
	ld hl, PokemonTower3TrainerHeaders
	ld de, PokemonTower3F_ScriptPointers
	ld a, [wPokemonTower3FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wPokemonTower3FCurScript], a
	ret

PokemonTower6Script_60b02:
	xor a
	ld [wJoyIgnore], a
	ld [wPokemonTower3FCurScript], a
	ld [wCurMapScript], a
	ret

PokemonTower3F_ScriptPointers:
	dw PokemonTower3Script0
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle
	dw PokemonTower3Script3
	dw PokemonTower3Script4

PokemonTower3Script0:
	CheckEvent EVENT_BEAT_GHOST_MAROWAK
	jp nz, CheckFightingMapTrainers
	ld hl, CoordsData_60b45
	call ArePlayerCoordsInArray
	jp nc, CheckFightingMapTrainers
	xor a
	ldh [hJoyHeld], a
	ld a, $5
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
	ld a, RESTLESS_SOUL
	ld [wCurOpponent], a
	ld a, 38
	ld [wCurEnemyLVL], a
	ld a, $4
	ld [wPokemonTower3FCurScript], a
	ld [wCurMapScript], a
	ret

CoordsData_60b45:
	dbmapcoord 18,  8
	dbmapcoord 17,  9
	dbmapcoord 18, 10
	db -1 ; end

PokemonTower3Script4:
	ld a, [wIsInBattle]
	cp $ff
	jp z, PokemonTower6Script_60b02
	ld a, $ff
	ld [wJoyIgnore], a
	ld a, [wd72d]
	bit 6, a
	ret nz
	call UpdateSprites
	ld a, $f0
	ld [wJoyIgnore], a
	ld a, [wBattleResult]
	and a
	jr nz, .asm_60b82
	SetEvent EVENT_BEAT_GHOST_MAROWAK
	ld a, $6
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
	xor a
	ld [wJoyIgnore], a
	ld a, $0
	ld [wPokemonTower3FCurScript], a
	ld [wCurMapScript], a
	ret
.asm_60b82
	ld a, $1
	ld [wSimulatedJoypadStatesIndex], a
	ld a, D_LEFT
	ld [wSimulatedJoypadStatesEnd], a
	xor a
	ld [wSpritePlayerStateData2MovementByte1], a
	ld [wOverrideSimulatedJoypadStatesMask], a
	ld hl, wd730
	set 7, [hl]
	ld a, $3
	ld [wPokemonTower3FCurScript], a
	ld [wCurMapScript], a
	ret

PokemonTower3Script3:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	call Delay3
	xor a
	ld [wPokemonTower3FCurScript], a
	ld [wCurMapScript], a
	ret

PokemonTower3F_TextPointers:
	dw PokemonTower3Text1
	dw PokemonTower3Text2
	dw PokemonTower3Text3
	dw PickUpItemText
	dw PokemonTower3Text5
	dw PokemonTower3Text6

PokemonTower3TrainerHeaders:
	def_trainers
PokemonTower3TrainerHeader0:
	trainer EVENT_BEAT_POKEMONTOWER_3_TRAINER_0, 2, PokemonTower3BattleText1, PokemonTower3EndBattleText1, PokemonTower3AfterBattleText1
PokemonTower3TrainerHeader1:
	trainer EVENT_BEAT_POKEMONTOWER_3_TRAINER_1, 3, PokemonTower3BattleText2, PokemonTower3EndBattleText2, PokemonTower3AfterBattleText2
PokemonTower3TrainerHeader2:
	trainer EVENT_BEAT_POKEMONTOWER_3_TRAINER_2, 2, PokemonTower3BattleText3, PokemonTower3EndBattleText3, PokemonTower3AfterBattleText3
	db -1 ; end

PokemonTower3Text1:
	text_asm
	ld hl, PokemonTower3TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

PokemonTower3Text2:
	text_asm
	ld hl, PokemonTower3TrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

PokemonTower3Text3:
	text_asm
	ld hl, PokemonTower3TrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

PokemonTower3BattleText1:
	text_far _PokemonTower3BattleText1
	text_end

PokemonTower3EndBattleText1:
	text_far _PokemonTower3EndBattleText1
	text_end

PokemonTower3AfterBattleText1:
	text_far _PokemonTower3AfterBattleText1
	text_end

PokemonTower3BattleText2:
	text_far _PokemonTower3BattleText2
	text_end

PokemonTower3EndBattleText2:
	text_far _PokemonTower3EndBattleText2
	text_end

PokemonTower3AfterBattleText2:
	text_far _PokemonTower3AfterBattleText2
	text_end

PokemonTower3BattleText3:
	text_far _PokemonTower3BattleText3
	text_end

PokemonTower3EndBattleText3:
	text_far _PokemonTower3EndBattleText3
	text_end

PokemonTower3AfterBattleText3:
	text_far _PokemonTower3AfterBattleText3
	text_end

PokemonTower3Text6:
	text_asm
	ld hl, PokemonTower2Text_60c1f
	call PrintText
	ld a, RESTLESS_SOUL
	call PlayCry
	call WaitForSoundToFinish
	ld c, 30
	call DelayFrames
	ld hl, PokemonTower2Text_60c24
	call PrintText
	jp TextScriptEnd

PokemonTower2Text_60c1f:
	text_far _PokemonTower2Text_60c1f
	text_end

PokemonTower2Text_60c24:
	text_far _PokemonTower2Text_60c24
	text_end

PokemonTower3Text5:
	text_far _PokemonTower6Text6
	text_end
