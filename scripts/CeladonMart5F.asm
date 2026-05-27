CeladonMart5F_Script:
	CheckEvent EVENT_BECAME_CHAMPION
	jr nz, .afterBeat
	ld hl, CeladonMart5F_TextPointers
	jr .done
.afterBeat
	ld hl, CeladonMart5F_TextPointers2
.done
	ld a, l
	ld [wMapTextPtr], a
	ld a, h
	ld [wMapTextPtr+1], a
	jp EnableAutoTextBoxDrawing

CeladonMart5F_TextPointers:
	dw CeladonMart5Text1
	dw CeladonMart5Text2
	dw CeladonMart5Clerk1Text
	dw CeladonMart5Clerk2Text
	dw CeladonMart5Text5

CeladonMart5F_TextPointers2:
	dw CeladonMart5Text1
	dw CeladonMart5Text2
	dw CeladonMart5Clerk1Text
	dw CeladonMart5Clerk2Text2
	dw CeladonMart5Text5

CeladonMart5Text1:
	text_far _CeladonMart5Text1
	text_end

CeladonMart5Text2:
	text_far _CeladonMart5Text2
	text_end

CeladonMart5Text5:
	text_far _CeladonMart5Text5
	text_end

CeladonMart5Clerk1Text:
	script_mart X_ACCURACY, GUARD_SPEC, DIRE_HIT, X_ATTACK, X_DEFEND, X_SPEED, X_SPECIAL

CeladonMart5Clerk2Text:
	script_mart HP_UP, PROTEIN, IRON, CARBOS, CALCIUM

CeladonMart5Clerk2Text2:
	script_mart HP_UP, PROTEIN, IRON, CARBOS, CALCIUM, PP_UP
