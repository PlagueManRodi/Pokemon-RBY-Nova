PokemonTower6F_Script:
	call EnableAutoTextBoxDrawing
	ld hl, PokemonTower6TrainerHeaders
	ld de, PokemonTower6F_ScriptPointers
	ld a, [wPokemonTower6FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wPokemonTower6FCurScript], a
	ret

PokemonTower6F_ScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle

PokemonTower6F_TextPointers:
	dw PokemonTower6Text1
	dw PokemonTower6Text2
	dw PokemonTower6Text3
	dw PickUpItemText
	dw PickUpItemText

PokemonTower6TrainerHeaders:
	def_trainers
PokemonTower6TrainerHeader0:
	trainer EVENT_BEAT_POKEMONTOWER_6_TRAINER_0, 3, PokemonTower6BattleText1, PokemonTower6EndBattleText1, PokemonTower6AfterBattleText1
PokemonTower6TrainerHeader1:
	trainer EVENT_BEAT_POKEMONTOWER_6_TRAINER_1, 3, PokemonTower6BattleText2, PokemonTower6EndBattleText2, PokemonTower6AfterBattleText2
PokemonTower6TrainerHeader2:
	trainer EVENT_BEAT_POKEMONTOWER_6_TRAINER_2, 2, PokemonTower6BattleText3, PokemonTower6EndBattleText3, PokemonTower6AfterBattleText3
	db -1 ; end

PokemonTower6Text1:
	text_asm
	ld hl, PokemonTower6TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

PokemonTower6Text2:
	text_asm
	ld hl, PokemonTower6TrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

PokemonTower6Text3:
	text_asm
	ld hl, PokemonTower6TrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

PokemonTower6BattleText1:
	text_far _PokemonTower6BattleText1
	text_end

PokemonTower6EndBattleText1:
	text_far _PokemonTower6EndBattleText1
	text_end

PokemonTower6AfterBattleText1:
	text_far _PokemonTower6AfterBattleText1
	text_end

PokemonTower6BattleText2:
	text_far _PokemonTower6BattleText2
	text_end

PokemonTower6EndBattleText2:
	text_far _PokemonTower6EndBattleText2
	text_end

PokemonTower6AfterBattleText2:
	text_far _PokemonTower6AfterBattleText2
	text_end

PokemonTower6BattleText3:
	text_far _PokemonTower6BattleText3
	text_end

PokemonTower6EndBattleText3:
	text_far _PokemonTower6EndBattleText3
	text_end

PokemonTower6AfterBattleText3:
	text_far _PokemonTower6AfterBattleText3
	text_end
