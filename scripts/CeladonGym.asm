CeladonGym_Script:
	ld hl, wCurrentMapScriptFlags
	bit 6, [hl]
	res 6, [hl]
	call nz, .LoadNames
	call EnableAutoTextBoxDrawing
	ld hl, CeladonGymTrainerHeaders
	ld de, CeladonGym_ScriptPointers
	ld a, [wCeladonGymCurScript]
	call ExecuteCurMapScriptInTable
	ld [wCeladonGymCurScript], a
	ret

.LoadNames:
	ld hl, .CityName
	ld de, .LeaderName
	jp LoadGymLeaderAndCityName

.CityName:
	db "CELADON CITY@"

.LeaderName:
	db "ERIKA@"

CeladonGymResetScripts:
	xor a
	ld [wJoyIgnore], a
	ld [wCeladonGymCurScript], a
	ld [wCurMapScript], a
	ret

CeladonGym_ScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle
	dw CeladonGymErikaPostBattle

CeladonGymErikaPostBattle:
	ld a, [wIsInBattle]
	cp $ff
	jp z, CeladonGymResetScripts
	ld a, $f0
	ld [wJoyIgnore], a
	;
	CheckEvent EVENT_BECAME_CHAMPION
	jr z, CeladonGymReceiveTM21	
	ld a, 12
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
	ld hl, wProBadgeFlags
	lb bc, FLAG_TEST, 3
	predef FlagActionPredef
	ld a, c
	and a
	jp nz, CeladonGymResetScripts
	lb bc, FLAG_SET, 3
	predef FlagActionPredef
	ld a, 13
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
	ld hl, wProBadgeFlags
	ld a, -1
	cp [hl]
	jp nz, CeladonGymResetScripts
	ld a, 14
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
	jp CeladonGymResetScripts
	;
CeladonGymReceiveTM21:
	ld a, $9
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
	SetEvent EVENT_BEAT_ERIKA
	lb bc, TM_MEGA_DRAIN, 1
	call GiveItem
	jr nc, .BagFull
	ld a, $a
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
	SetEvent EVENT_GOT_TM21
	jr .gymVictory
.BagFull
	ld a, $b
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
.gymVictory
	ld hl, wObtainedBadges
	set BIT_RAINBOWBADGE, [hl]
	ld hl, wBeatGymFlags
	set BIT_RAINBOWBADGE, [hl]
	
	;; NEW LEVEL CAP
	CheckEvent EVENT_PLAYING_WITH_LEVEL_CAPS
	jr z, .notPlayingWithLevelCaps
	ld hl, wLevelCap
	ld a, 0
	cp [hl]
	jr z, .notPlayingWithLevelCaps
	ld a, 38
	cp [hl]
	jr c, .notPlayingWithLevelCaps
	ld [wLevelCap], a
.notPlayingWithLevelCaps
	;;

	; deactivate gym trainers
	SetEventRange EVENT_BEAT_CELADON_GYM_TRAINER_0, EVENT_BEAT_CELADON_GYM_TRAINER_6

	jp CeladonGymResetScripts

CeladonGym_TextPointers:
	dw ErikaText
	dw CeladonGymTrainerText1
	dw CeladonGymTrainerText2
	dw CeladonGymTrainerText3
	dw CeladonGymTrainerText4
	dw CeladonGymTrainerText5
	dw CeladonGymTrainerText6
	dw CeladonGymTrainerText7
	dw ErikaRainbowBadgeInfoText
	dw ReceivedTM21Text
	dw TM21NoRoomText
	dw CeladonGymRematchPostBattleText ; NEW
	dw ReceivedProRainbowBadgeText ; NEW
	dw ProLeagueAvailableText ; NEW

CeladonGymTrainerHeaders:
	def_trainers 2
CeladonGymTrainerHeader0:
	trainer EVENT_BEAT_CELADON_GYM_TRAINER_0, 2, CeladonGymBattleText2, CeladonGymEndBattleText2, CeladonGymAfterBattleText2
CeladonGymTrainerHeader1:
	trainer EVENT_BEAT_CELADON_GYM_TRAINER_1, 2, CeladonGymBattleText3, CeladonGymEndBattleText3, CeladonGymAfterBattleText3
CeladonGymTrainerHeader2:
	trainer EVENT_BEAT_CELADON_GYM_TRAINER_2, 4, CeladonGymBattleText4, CeladonGymEndBattleText4, CeladonGymAfterBattleText4
CeladonGymTrainerHeader3:
	trainer EVENT_BEAT_CELADON_GYM_TRAINER_3, 4, CeladonGymBattleText5, CeladonGymEndBattleText5, CeladonGymAfterBattleText5
CeladonGymTrainerHeader4:
	trainer EVENT_BEAT_CELADON_GYM_TRAINER_4, 2, CeladonGymBattleText6, CeladonGymEndBattleText6, CeladonGymAfterBattleText6
CeladonGymTrainerHeader5:
	trainer EVENT_BEAT_CELADON_GYM_TRAINER_5, 2, CeladonGymBattleText7, CeladonGymEndBattleText7, CeladonGymAfterBattleText7
CeladonGymTrainerHeader6:
	trainer EVENT_BEAT_CELADON_GYM_TRAINER_6, 3, CeladonGymBattleText8, CeladonGymEndBattleText8, CeladonGymAfterBattleText8
	db -1 ; end

ErikaText:
	text_asm
	CheckEvent EVENT_BEAT_ERIKA
	jr z, .beforeBeat
	CheckEventReuseA EVENT_GOT_TM21
	jr nz, .afterBeat
	call z, CeladonGymReceiveTM21
	call DisableWaitingAfterTextDisplay
	jp .done
.afterBeat
	;
	CheckEvent EVENT_BECAME_CHAMPION
	jr nz, .ErikaRematch
	;
	ld hl, ErikaPostBattleAdviceText
	call PrintText
	jp .done
.beforeBeat
	ld d, 4
	callfar CheckPartyCaps
	ld a, d
	and a
	jr nz, .done
	predef HealParty
	ld hl, ErikaPreBattleText
	call PrintText
	ld hl, wd72d
	set 6, [hl]
	set 7, [hl]
	ld hl, ReceivedRainbowBadgeText
	ld de, ReceivedRainbowBadgeText
	call SaveEndBattleTextPointers
	ldh a, [hSpriteIndex]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters
	ld a, $4
	ld [wGymLeaderNo], a
	;
	jr .endBattle
.ErikaRematch
	predef HealParty
	ld hl, ErikaPreBattleRematchText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .refused
	ld hl, ErikaPreBattleRematchAcceptedText
	call PrintText
	call Delay3
	ld hl, wd72d
	set 6, [hl]
	set 7, [hl]
	ld hl, CeladonGymRematchDefeatedText
	ld de, CeladonGymRematchDefeatedText
	call SaveEndBattleTextPointers
	ld a, OPP_ERIKA
	ld [wCurOpponent], a
	ld a, 2
	ld [wTrainerNo], a
	jr .endBattle
.refused
	ld hl, ErikaPreBattleRematchRefusedText
	call PrintText
	jr .done
.endBattle
	;
	ld a, $3
	ld [wCeladonGymCurScript], a
	ld [wCurMapScript], a
.done
	jp TextScriptEnd

ErikaPreBattleText:
	text_far _ErikaPreBattleText
	text_end

ReceivedRainbowBadgeText:
	text_far _ReceivedRainbowBadgeText
	sound_get_item_1
	text_promptbutton
	text_end

ErikaPostBattleAdviceText:
	text_far _ErikaPostBattleAdviceText
	text_end

ErikaRainbowBadgeInfoText:
	text_far _ErikaRainbowBadgeInfoText
	text_end

ReceivedTM21Text:
	text_far _ReceivedTM21Text
	sound_get_item_1
	text_far _TM21ExplanationText
	text_end

TM21NoRoomText:
	text_far _TM21NoRoomText
	text_end

CeladonGymTrainerText1:
	text_asm
	ld hl, CeladonGymTrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

CeladonGymBattleText2:
	text_far _CeladonGymBattleText2
	text_end

CeladonGymEndBattleText2:
	text_far _CeladonGymEndBattleText2
	text_end

CeladonGymAfterBattleText2:
	text_far _CeladonGymAfterBattleText2
	text_end

CeladonGymTrainerText2:
	text_asm
	ld hl, CeladonGymTrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

CeladonGymBattleText3:
	text_far _CeladonGymBattleText3
	text_end

CeladonGymEndBattleText3:
	text_far _CeladonGymEndBattleText3
	text_end

CeladonGymAfterBattleText3:
	text_far _CeladonGymAfterBattleText3
	text_end

CeladonGymTrainerText3:
	text_asm
	ld hl, CeladonGymTrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

CeladonGymBattleText4:
	text_far _CeladonGymBattleText4
	text_end

CeladonGymEndBattleText4:
	text_far _CeladonGymEndBattleText4
	text_end

CeladonGymAfterBattleText4:
	text_far _CeladonGymAfterBattleText4
	text_end

CeladonGymTrainerText4:
	text_asm
	ld hl, CeladonGymTrainerHeader3
	call TalkToTrainer
	jp TextScriptEnd

CeladonGymBattleText5:
	text_far _CeladonGymBattleText5
	text_end

CeladonGymEndBattleText5:
	text_far _CeladonGymEndBattleText5
	text_end

CeladonGymAfterBattleText5:
	text_far _CeladonGymAfterBattleText5
	text_end

CeladonGymTrainerText5:
	text_asm
	ld hl, CeladonGymTrainerHeader4
	call TalkToTrainer
	jp TextScriptEnd

CeladonGymBattleText6:
	text_far _CeladonGymBattleText6
	text_end

CeladonGymEndBattleText6:
	text_far _CeladonGymEndBattleText6
	text_end

CeladonGymAfterBattleText6:
	text_far _CeladonGymAfterBattleText6
	text_end

CeladonGymTrainerText6:
	text_asm
	ld hl, CeladonGymTrainerHeader5
	call TalkToTrainer
	jp TextScriptEnd

CeladonGymBattleText7:
	text_far _CeladonGymBattleText7
	text_end

CeladonGymEndBattleText7:
	text_far _CeladonGymEndBattleText7
	text_end

CeladonGymAfterBattleText7:
	text_far _CeladonGymAfterBattleText7
	text_end

CeladonGymTrainerText7:
	text_asm
	ld hl, CeladonGymTrainerHeader6
	call TalkToTrainer
	jp TextScriptEnd

CeladonGymBattleText8:
	text_far _CeladonGymBattleText8
	text_end

CeladonGymEndBattleText8:
	text_far _CeladonGymEndBattleText8
	text_end

CeladonGymAfterBattleText8:
	text_far _CeladonGymAfterBattleText8
	text_end

;;;

ErikaPreBattleRematchText:
	text_far _CeladonGymRematchPreBattleText
	text_end
	
ErikaPreBattleRematchAcceptedText:
	text_far _CeladonGymRematchAcceptedText
	text_end
	
ErikaPreBattleRematchRefusedText:
	text_far _CeladonGymRematchRefusedText
	text_end

CeladonGymRematchDefeatedText:
	text_far _CeladonGymRematchDefeatedText
	text_end

CeladonGymRematchPostBattleText:
	text_far _CeladonGymRematchPostBattleText
	text_end

ReceivedProRainbowBadgeText:
	text_far _ReceivedProRainbowBadgeText
	sound_get_item_1
	text_end
