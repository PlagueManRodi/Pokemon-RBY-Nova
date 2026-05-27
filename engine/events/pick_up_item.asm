PickUpItem:
	call EnableAutoTextBoxDrawing

	ldh a, [hSpriteIndexOrTextID]
	ld b, a
	ld hl, wMissableObjectList
.missableObjectsListLoop
	ld a, [hli]
	cp $ff
	ret z
	cp b
	jr z, .isMissable
	inc hl
	jr .missableObjectsListLoop

.isMissable
	ld a, [hl]
	ldh [hMissableObjectIndex], a

	ld hl, wMapSpriteExtraData
	ldh a, [hSpriteIndexOrTextID]
	dec a
	add a
	ld d, 0
	ld e, a
	add hl, de
	ld a, [hl]
	ld b, a ; item
	ld c, 1 ; quantity
	call GiveItem
	jr nc, .BagFull
	
	ld a, b
	cp CAPTURE_CHARM
	jr nz, .notCC
	SetEvent EVENT_GOT_CAPTURECHARM
.notCC
	cp TM_TELEPORT
	jr nz, .notTP
	SetEvent EVENT_GOT_TM30
.notTP

	ldh a, [hMissableObjectIndex]
	ld [wMissableObjectIndex], a
;;;;;;;;;; PureRGBnote: CHANGED: in certain maps hidable items use a different set of flags than everywhere else, needed more space for flags.
	CheckEvent EVENT_IN_NEW_MISSABLE_OBJECTS_MAP
	jr nz, .hideNew
	predef HideObject
	jr .cont
.hideNew
	predef HideNewObject
.cont
;;;;;;;;;;
;	predef HideObject
	ld a, 1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, FoundItemText
	jr .print

.BagFull
	ld hl, NoMoreRoomForItemText
.print
	call PrintText
	ret

FoundItemText:
	text_far _FoundItemText
	sound_get_item_1
	text_end

NoMoreRoomForItemText:
	text_far _NoMoreRoomForItemText
	text_end
