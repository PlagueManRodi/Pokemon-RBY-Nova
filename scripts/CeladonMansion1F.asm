CeladonMansion1F_Script:
	jp EnableAutoTextBoxDrawing

CeladonMansion1F_TextPointers:
	dw CeladonMansion1Text1
	dw CeladonMansion1Text2
	dw CeladonMansion1Text3
	dw CeladonMansion1Text4
	dw CeladonMansion1Text5

CeladonMansion1_PlayCryScript:
	call PlayCry
	jp TextScriptEnd

CeladonMansion1Text1:
	text_far _CeladonMansion1Text1
	text_asm
	ld a, MEOWTH
	jp CeladonMansion1_PlayCryScript

CeladonMansion1Text2:
	text_asm
	CheckEvent EVENT_GOT_TEA
	jr nz, .got_item
	ld hl, CeladonMansion1Text2bis
	call PrintText
	lb bc, TEA, 1
	call GiveItem
	jr nc, .bag_full
	SetEvent EVENT_GOT_TEA
	ld hl, CeladonMansion1Text2bis2
	call PrintText
	ld hl, CeladonMansion1Text2bis3
	call PrintText
	jp TextScriptEnd
.bag_full
	ld hl, CeladonMansion1Text2bis4
	call PrintText
	jp TextScriptEnd
.got_item
	ld hl, CeladonMansion1Text2bis5
	call PrintText
	jp TextScriptEnd

CeladonMansion1Text3:
	text_far _CeladonMansion1Text3
	text_asm
	ld a, CLEFAIRY
	jp CeladonMansion1_PlayCryScript

CeladonMansion1Text4:
	text_far _CeladonMansion1Text4
	text_asm
	ld a, NIDORAN_F
	jp CeladonMansion1_PlayCryScript

CeladonMansion1Text5:
	text_far _CeladonMansion1Text5
	text_end

CeladonMansion1Text2bis:
	text_far _CeladonMansion1Text2bis
	text_end

CeladonMansion1Text2bis2:
	text_far _CeladonMansion1Text2bis2
	sound_get_item_1
	text_end

CeladonMansion1Text2bis3:
	text_far _CeladonMansion1Text2bis3
	text_end

CeladonMansion1Text2bis4:
	text_far _CeladonMansion1Text2bis4
	text_end

CeladonMansion1Text2bis5:
	text_far _CeladonMansion1Text2bis5
	text_end
