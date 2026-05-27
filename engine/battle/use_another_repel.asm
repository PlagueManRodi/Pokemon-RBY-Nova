CheckForMoreRepelInBag:
	ld a, [wRepelTotalSteps]
	ld b, REPEL
	cp 100
	jr z, .found
	ld b, SUPER_REPEL
	cp 200
	jr z, .found
	ld b, MAX_REPEL
	cp 250
	jr nz, .done
.found
	ld a, b
	ld [wd11e], a
	ld [wcf91], a
	call IsItemInBag
	jr z, .done
	ld de, wBagItems+1
	ld a, l
	sub e
	jr nc, .noCarry
	dec h
.noCarry
	ld b, a
	ld a, h
	sub d
	srl a
	rr b
	ld a, b
	ld [wWhichMon], a
	call GetItemName
	call CopyToStringBuffer
	ld a, TEXT_USE_ANOTHER_REPEL
	ldh [hSpriteIndexOrTextID], a
	call EnableAutoTextBoxDrawing
	call DisplayTextID
	ld a, [wActionResultOrTookBattleTurn]
	cp 1
	ret z
.done
	xor a
	ld [wRepelTotalSteps], a
	ret
	