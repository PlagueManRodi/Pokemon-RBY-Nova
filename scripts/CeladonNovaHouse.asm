CeladonNovaHouse_Script:
	call EnableAutoTextBoxDrawing
	ld a, [wNovaHouseCurScript]
	ld hl, NovaHouse_ScriptPointers
	jp CallFunctionInTable

NovaHouse_ScriptPointers:
	dw NovaHouseScript0
	dw NovaHouseScript1
	
NovaHouseScript0:
	ret

NovaHouseScript1:
	ld a, [wIsInBattle]
	cp $ff
	jr z, NovaHouseDontEndBattle
	SetEvent EVENT_BEAT_RICH_GUY
	ld a, 5
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
	ld a, 0
	ld [wNovaHouseCurScript], a
	ret

NovaHouseDontEndBattle:
	xor a
	ld [wNovaHouseCurScript], a
	ld [wJoyIgnore], a
	ret

CeladonNovaHouse_TextPointers:
	dw MrHyperText
	dw StatExpLadyText
	dw ConvItemsWomanText
	dw NewSaleWomanText
	dw RichGuyText
	dw PokeShuffleWomanText
	dw KantoStrongestManText

MrHyperText:
	text_asm
	call SaveScreenTilesToBuffer2 ; It really doesn't need to be done this early, it just helps.
	ld hl, MrHyperSpeech
	call PrintText
	call YesNoChoice ; Yes/No Prompt
	ld a, [wCurrentMenuItem]
	and a
	jp nz, .refused
	; Proceed from here if Yes is stated. 
	; Here, the party menu pops up and the player picks a Pokemon to juice.
	xor a
	ld [wUpdateSpritesEnabled], a
	ld [wPartyMenuTypeOrMessageID], a
	ld [wMenuItemToSwap], a
	call DisplayPartyMenu
	push af
	call GBPalWhiteOutWithDelay3
	call RestoreScreenTilesAndReloadTilePatterns
	call LoadGBPal
	pop af
	ld a, $1
	jr c, .refused
	ld hl, MrHyperDone1
	call PrintText
	; DV increasing process.
	; Thanks to Vimescarrot for giving me pointers on this!
	ld a, [wWhichPokemon] ; Find the Pokemon's position in party.
	ld hl, wPartyMon1DVs ; Load DVs into hl
	ld bc, wPartyMon2 - wPartyMon1 ; This gets to the right slot for DVs
	call AddNTimes ; Gets us there
	ld a, %11111111 ; Load FF, perfect 15s
	ld [hli], a ; Load 1111 1111 to Attack + Defence
	ld [hl], a ; Now load 1111 1111 to Speed + Special
	; Stat Exp. Maxing
	ld a, [wWhichPokemon] ; Find the Pokemon's position in party.
	ld hl, wPartyMon1HPExp ; Load Stat Exp. into hl
	ld bc, wPartyMon2 - wPartyMon1 ; This gets to the right slot for Stat Exp.
	call AddNTimes ; Gets us there
	ld a, %11111111 ; Load FF, perfect 15s
	ld [hli], a ; Load 1111 1111 to HP1
	ld [hli], a ; Load 1111 1111 to HP2
	ld [hli], a ; Load 1111 1111 to ATK1
	ld [hli], a ; Load 1111 1111 to ATK2
	ld [hli], a ; Load 1111 1111 to DEF1
	ld [hli], a ; Load 1111 1111 to DEF2
	ld [hli], a ; Load 1111 1111 to SPE1
	ld [hli], a ; Load 1111 1111 to SPE2
	ld [hli], a ; Load 1111 1111 to SPC1
	ld [hl], a ; load 1111 1111 to SPC2
	; Recalc the stats
	call StatRecalculation
	predef HealParty
	ld a, SFX_LEVEL_UP
	call PlaySound
	ld hl, MrHyperDone2
	call PrintText
	jr .done
.refused
	ld hl, MrHyperNo
	call PrintText
	jr .done
.done
	jp TextScriptEnd
	
StatExpLadyText:
	text_asm
	ld hl, StatExpLadyIntroduction
	call PrintText
	call YesNoChoice ; Yes/No Prompt
	ld a, [wCurrentMenuItem]
	and a
	ld hl, StatExpLadyRefused
	jr nz, .refused3
	;YES
	ld hl, StatExpLadySpeech
	call PrintText
	call YesNoChoice ; Yes/No Prompt
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .refused2
	;YES
	ResetEvent EVENT_PLAYING_WITHOUT_STAT_EXP
	jr .recalcPartyStats
.refused2
	SetEvent EVENT_PLAYING_WITHOUT_STAT_EXP
.recalcPartyStats
	ld b, 0
.partyMonLoop
	ld a, [wPartyCount]
	cp b
	jr z, .allMonDone
	ld a, b
	ld [wWhichPokemon], a
	push bc
	call StatRecalculation
	pop bc
	inc b
	jr .partyMonLoop
.allMonDone
	predef HealParty
	ld a, SFX_LEVEL_UP
	call PlaySound
	ld hl, StatExpLadyDone
.refused3
	call PrintText
	jp TextScriptEnd

StatRecalculation:
	ld a, 0
	ld [wMonDataLocation], a
	call LoadMonData
	ld a, [wWhichPokemon]
	ld hl, wPartyMons
	ld bc, wPartyMon2 - wPartyMon1
	call AddNTimes
	push hl
	ld bc, wPartyMon1Level - wPartyMon1
	add hl, bc ; hl now points to level
	ld a, [hl] ; a = level
	ld [wCurEnemyLVL], a ; store level
	pop hl
	ld bc, wPartyMon1Stats - wPartyMon1
	add hl, bc
	ld d, h
	ld e, l ; de now points to stats
	ld bc, (wPartyMon1Exp + 2) - wPartyMon1Stats
	add hl, bc ; hl now points to LSB of experience
	ld b, 1
	call CalcStats ; recalculate stats
	ret
	
ConvItemsWomanText:
	text_asm
	ld hl, ConvItemsWomanAlreadyGot
	CheckEvent EVENT_RECEIVED_CONV_ITEMS
	jr nz, .endOfConvWoman
	ld hl, ConvItemsWomanPrompt
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	ld hl, ConvItemsWomanTooBad
	jr nz, .endOfConvWoman
	;YES
	lb bc, RECOVERY_KIT, 1
	call GiveItem
	ld hl, ConvItemsWomanNotEnoughSpace
	jr nc, .endOfConvWoman
	lb bc, REPEL_KIT, 1
	call GiveItem
	jr nc, .bag_full_1
	lb bc, TRAINING_KIT, 1
	call GiveItem
	jr nc, .bag_full_2
	SetEvent EVENT_RECEIVED_CONV_ITEMS
	ld hl, ReceivedConvItems
	call PrintText
	CheckEvent EVENT_GOT_TM41
	jr nz, .skipHeal
	ld hl, ReceivedHEALText2
	call PrintText
.skipHeal
	ld hl, ReceivedWARDText
	call PrintText
	ld hl, ReceivedTRAINText
	jr .endOfConvWoman
.bag_full_2
	ld a, REPEL_KIT
	ldh [hItemToRemoveID], a
	farcall RemoveItemByID
.bag_full_1
	ld a, RECOVERY_KIT
	ldh [hItemToRemoveID], a
	farcall RemoveItemByID
	ld hl, ConvItemsWomanNotEnoughSpace
.endOfConvWoman
	call PrintText
	jp TextScriptEnd	

NewSaleWomanText:
	text_far _NewSaleWomanText
	text_end

NovaHouseTrainerHeaders:
	def_trainers 2
RichGuyTrainerHeader:
	trainer EVENT_BEAT_RICH_GUY, 0, RichGuyBeforeBattleText, RichGuyEndBattleText, RichGuyAfterBattleText
	db -1 ; end

RichGuyText:
	text_asm
	CheckEvent EVENT_BEAT_RICH_GUY
	jr nz, RichGuyAfterBattleText
	ld hl, RichGuyIntroText
	call PrintText
	call YesNoChoice ; Yes/No Prompt
	ld a, [wCurrentMenuItem]
	and a
	jp nz, .noBattle
	ld hl, RichGuyTrainerHeader
	call TalkToTrainer
	ld a, 1
	ld [wNovaHouseCurScript], a
	jr .trainerDone
.noBattle
	ld hl, RichGuyNextTimeText
	call PrintText
.trainerDone
	jp TextScriptEnd

RichGuyIntroText:
	text_far _RichGuyIntroText
	text_end
	
RichGuyNextTimeText:
	text_far _RichGuyNextTimeText
	text_end

RichGuyBeforeBattleText:
	text_far _RichGuyBeforeBattleText
	text_end

RichGuyEndBattleText:
	text_far _RichGuyEndBattleText
	text_end

RichGuyAfterBattleText:
	lb bc, BIG_NUGGET, 1
	call GiveItem
	ld hl, RichGuyBagFullText
	jr nc, .bag_full
	ld hl, RichGuyGiveItemText
.bag_full
	call PrintText
.done
	ResetEvent EVENT_BEAT_RICH_GUY
	jp TextScriptEnd

RichGuyGiveItemText:
	text_far _RichGuyGiveItemText
	sound_get_item_1
	text_end

RichGuyBagFullText:
	text_far _RichGuyBagFullText
	text_end

MrHyperSpeech:
	text_far _MrHyperSpeech
	text_end

MrHyperNo:
	text_far _MrHyperNo
	text_end

MrHyperDone1:
	text_far _MrHyperDone1
	text_end

MrHyperDone2:
	text_far _MrHyperDone2
	text_end

StatExpLadySpeech:
	text_far _StatExpLadySpeech
	text_end

StatExpLadyDone:
	text_far _StatExpLadyDone
	text_end

StatExpLadyIntroduction:
	text_far _StatExpLadyIntroduction
	text_end

StatExpLadyRefused:
	text_far _StatExpLadyRefused
	text_end

ConvItemsWomanAlreadyGot:
	text_far _ConvItemsWomanAlreadyGot
	text_end

ConvItemsWomanPrompt:
	text_far _ConvItemsWomanPrompt
	text_end

ConvItemsWomanTooBad:
	text_far _ConvItemsWomanTooBad
	text_end

ConvItemsWomanNotEnoughSpace:
	text_far _ConvItemsWomanNotEnoughSpace
	text_end

ConvItemsWomanHaveFun:
	text_far _ConvItemsWomanHaveFun
	text_end

ReceivedConvItems:
	text_far _ReceivedRECK
	sound_get_key_item
	text_far _ReceivedREPK
	sound_get_key_item
	text_far _ReceivedTK
	sound_get_key_item
	text_far _ConvItemsWomanHaveFun
	text_end

ReceivedHEALText2:
	text_far _ReceivedHEALText2
	sound_get_key_item
	text_end
	
ReceivedWARDText:
	text_far _ReceivedWARDText
	sound_get_key_item
	text_end

ReceivedTRAINText:
	text_far _ReceivedTRAINText
	sound_get_key_item
	text_end

PokeShuffleWomanText:
	text_asm
	ld hl, PokeShuffleWomanIntroText
	call PrintText
	call YesNoChoice ; Yes/No Prompt
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .no
	call SaveScreenTilesToBuffer2
	call ClearScreen
	call UpdateSprites
	ld a, [wd730] ; wStatusFlags5
	push af
	set 6, a ; BIT_NO_TEXT_DELAY
	ld [wd730], a ; wStatusFlags5
	ld a, [wShownPokeShuffleInfo]
	set 2, a
	ld [wShownPokeShuffleInfo], a
	callfar DisplayTypeShuffleMenu
	ld a, [wShownPokeShuffleInfo]
	res 2, a
	ld [wShownPokeShuffleInfo], a
	pop af
	ld [wd730], a ; wStatusFlags5
	call GBPalWhiteOutWithDelay3
	call LoadScreenTilesFromBuffer2
	call Delay3
	call GBPalNormal
	callfar UpdatePartyTypes
.no
	ld hl, PokeShuffleWomanDoneText
	call PrintText
	jp TextScriptEnd

PokeShuffleWomanIntroText:
	text_far _PokeShuffleWomanIntroText
	text_end

PokeShuffleWomanDoneText:
	text_far _PokeShuffleWomanDoneText
	text_end	

KantoStrongestManText:
	text_asm
	ld hl, KantoStrongestManIntroText
	call PrintText
	call YesNoChoice ; Yes/No Prompt
	ld hl, KantoStrongestManYesText
	ld a, [wCurrentMenuItem]
	and a
	jr z, .done
	ld hl, KantoStrongestManNoText
.done
	call PrintText
	jp TextScriptEnd

KantoStrongestManIntroText:
	text_far _KantoStrongestManIntroText
	text_end

KantoStrongestManYesText:
	text_far _KantoStrongestManYesText
	text_end

KantoStrongestManNoText:
	text_far _KantoStrongestManNoText
	text_end
