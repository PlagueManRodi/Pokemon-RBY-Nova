OptionalFeatures:
	ld hl, OptionalFeaturesIntroText
	call PrintText
;	ld hl, LevelCapsExpQuestionText
;	call PrintText
;	call YesNoChoice ; Yes/No Prompt
;	ld a, [wCurrentMenuItem]
;	and a
;	jp z, .noLevelCapExplanation
	;NO
;	ld hl, LevelCapsExpText
;	call PrintText
;.noLevelCapExplanation
	call FadeOutAndIn
	ld hl, LevelCapsText
	call PrintText
	call PlaceRecommendedTextString
	call YesNoChoice ; Yes/No Prompt
	call ClearRecommendedTextString
	ld a, [wCurrentMenuItem]
	and a
	jp nz, .noLevelCaps
	;YES
	SetEvent EVENT_PLAYING_WITH_LEVEL_CAPS
	ld a, 10
	ld [wLevelCap], a
.noLevelCaps
;	ld hl, StatExpExpQuestionText
;	call PrintText
;	call YesNoChoice ; Yes/No Prompt
;	ld a, [wCurrentMenuItem]
;	and a
;	jp z, .noStatExpExplanation
	;NO
;	ld hl, StatExpExpText
;	call PrintText
;.noStatExpExplanation
	call FadeOutAndIn
	ld hl, StatExpText
	call PrintText
	hlcoord 2, 10
	call PlaceSpecialRecommendedTextString
	call YesNoChoice ; Yes/No Prompt
	hlcoord 2, 10
	call PlaceSpecialRecommendedTextString
	ld a, [wCurrentMenuItem]
	and a
	jp z, .statExpOn
	;NO
	SetEvent EVENT_PLAYING_WITHOUT_STAT_EXP
.statExpOn
;	ld hl, ConvItemsExpQuestionText
;	call PrintText
;	call YesNoChoice ; Yes/No Prompt
;	ld a, [wCurrentMenuItem]
;	and a
;	jp z, .noConvItemsExplanation
	;NO
;	ld hl, ConvItemsExpText
;	call PrintText
;.noConvItemsExplanation
	call FadeOutAndIn
	ld hl, ConvItemsText
	call PrintText
	call PlaceRecommendedTextString
	call YesNoChoice ; Yes/No Prompt
	call ClearRecommendedTextString
	ld a, [wCurrentMenuItem]
	and a
	jp nz, .noConvItems
	;YES
	SetEvent EVENT_RECEIVED_CONV_ITEMS
	ld hl, wNumBoxItems
	ld a, RECOVERY_KIT
	ld [wcf91], a
	ld a, 1
	ld [wItemQuantity], a
	call AddItemToInventory  ; give one recovery kit
	ld a, REPEL_KIT
	ld [wcf91], a
	ld a, 1
	ld [wItemQuantity], a
	call AddItemToInventory  ; give one repel kit
	ld a, TRAINING_KIT
	ld [wcf91], a
	ld a, 1
	ld [wItemQuantity], a
	call AddItemToInventory  ; give one training kit
.noConvItems
	call FadeOutAndIn
	ld hl, PartyCapsText
	call PrintText
	call PlaceRecommendedTextString
	call YesNoChoice ; Yes/No Prompt
	call ClearRecommendedTextString
	ld a, [wCurrentMenuItem]
	and a
	jp nz, .partyCapsOff
	;YES
	SetEvent EVENT_PLAYING_WITH_PARTY_CAPS
.partyCapsOff
	ld hl, EnjoyGameText
	call PrintText
	call GBFadeOutToWhite
	call ClearScreen
	ld c, 4
	call DelayFrames
	ret
	
OptionalFeaturesIntroText:
	text_far _OptionalFeaturesIntroText
	text_end
;LevelCapsExpQuestionText:
;	text_far _LevelCapsExpQuestionText
;	text_end
;LevelCapsExpText:
;	text_far _LevelCapsExpText
;	text_end
LevelCapsText:
	text_far _LevelCapsText
	text_end
;StatExpExpQuestionText:
;	text_far _StatExpExpQuestionText
;	text_end
;StatExpExpText:
;	text_far _StatExpExpText
;	text_end
StatExpText:
	text_far _StatExpText
	text_end
;ConvItemsExpQuestionText:
;	text_far _ConvItemsExpQuestionText
;	text_end
;ConvItemsExpText:
;	text_far _ConvItemsExpText
;	text_end
ConvItemsText:
	text_far _ConvItemsText
	text_end
PartyCapsText:
	text_far _PartyCapsText
	text_end
EnjoyGameText:
	text_far _EnjoyGameText
	text_end
RecommendedText:
	db "RECOMMENDED▶@"
EmptyString:
	db "            @"
FadeOutAndIn:
	call GBFadeOutToWhite
	call ClearScreen
	call Delay3
	jp GBFadeInFromWhite
PlaceRecommendedTextString:
	hlcoord 2, 8
	; fallthrough
PlaceSpecialRecommendedTextString:
	ld de, RecommendedText
	jp PlaceString
ClearRecommendedTextString:
	hlcoord 2, 8
	; fallthrough
ClearSpecialRecommendedTextString:
	ld de, EmptyString
	jp PlaceString

CheckPartyCaps::
	CheckEvent EVENT_PLAYING_WITH_PARTY_CAPS
	scf
	jr z, .ret
	ld a, [wPartyCount]
	dec a
	cp d
.ret
	ld a, d
	ld d, 0
	ret c
	ld hl, PartyCap3ExceedText
	cp 3
	jr z, .printText
	ld hl, PartyCap4ExceedText
	cp 4
	jr z, .printText
	ld hl, PartyCap5ExceedText
.printText
	call PrintText
	ld d, 1
	ret
	
PartyCap3ExceedText:
	text_far _PartyCap3ExceedText
	text_end

PartyCap4ExceedText:
	text_far _PartyCap4ExceedText
	text_end

PartyCap5ExceedText:
	text_far _PartyCap5ExceedText
	text_end
