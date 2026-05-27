ViridianForestNorthGate_Script:
	call EnableAutoTextBoxDrawing
	ld hl, wCurrentMapScriptFlags
	bit 5, [hl]
	res 5, [hl]
	call nz, RandomizeMushroomsN
	ret

RandomizeMushroomsN:
	call Random
	ld b, a
	ld a, [wObtainedBadges]
	bit BIT_RAINBOWBADGE, a
	jr z, .worseChanceN
	bit BIT_EARTHBADGE, a
	ld a, b
	jr z, .normalChanceN
	call Random
	and b
	jr .normalChanceN
.worseChanceN
	call Random
	or b
.normalChanceN
	ld [wObtainedHiddenItemsFlags], a
	ret

ViridianForestNorthGate_TextPointers:
	dw ViridianForestExitText1
	dw ViridianForestExitText2

ViridianForestExitText1:
	text_far _ViridianForestExitText1
	text_end

ViridianForestExitText2:
	text_far _ViridianForestExitText2
	text_end
