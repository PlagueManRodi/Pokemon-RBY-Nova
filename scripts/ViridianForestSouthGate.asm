ViridianForestSouthGate_Script:
	call EnableAutoTextBoxDrawing
	ld hl, wCurrentMapScriptFlags
	bit 5, [hl]
	res 5, [hl]
	call nz, RandomizeMushroomsS
	ret

RandomizeMushroomsS:
	call Random
	ld b, a
	ld a, [wObtainedBadges]
	bit BIT_RAINBOWBADGE, a
	jr z, .worseChanceS
	bit BIT_EARTHBADGE, a
	ld a, b
	jr z, .normalChanceS
	call Random
	and b
	jr .normalChanceS
.worseChanceS
	call Random
	or b
.normalChanceS
	ld [wObtainedHiddenItemsFlags], a
	ret

ViridianForestSouthGate_TextPointers:
	dw ViridianForestEntranceText1
	dw ViridianForestEntranceText2
	dw ViridianForestEntranceText3

ViridianForestEntranceText1:
	text_far _ViridianForestEntranceText1
	text_end

ViridianForestEntranceText2:
	text_far _ViridianForestEntranceText2
	text_end

ViridianForestEntranceText3:
	text_far _ViridianForestEntranceText3
	text_end
