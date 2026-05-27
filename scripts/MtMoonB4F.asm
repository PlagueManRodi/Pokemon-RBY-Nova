MtMoonB4F_Script:
	ld hl, wCurrentMapScriptFlags
	bit 6, [hl]
	res 6, [hl]
	call nz, MtMoonB4FCheckBoulderEventScript
	call EnableAutoTextBoxDrawing
	ld hl, MtMoonB4F_ScriptPointers
	ld a, [wMtMoonB4FCurScript]
	jp CallFunctionInTable

MtMoonB4F_ScriptPointers:
	dw MtMoonB4FScript0

MtMoonB4FScript0:
	call MtMoonB4FCheckHole
	jr MtMoonB4FCheckBoulderPosition

MtMoonB4FCheckHole:
	ld hl, MtMoonB4FHoleCoords
	call MtMoonB4FIsPlayerFallingDownHole
	ld a, [wWhichDungeonWarp]
	and a
	ret z
	ld a, MT_MOON_B5F
	ld [wDungeonWarpDestinationMap], a
	ret

MtMoonB4FCheckBoulderPosition:
	ld hl, wFlags_0xcd60
	bit 7, [hl]
	res 7, [hl]
	ret z
	ld hl, MtMoonB4FSwitchAndHoleCoords
	call CheckBoulderCoords
	ret nc
	EventFlagAddress hl, EVENT_MT_MOON_B4F_BOULDER_ON_SWITCH
	ld a, [wCoordIndex]
	cp 6
	jr z, .hole5
	cp 5
	jr z, .hole4
	cp 4
	jr z, .hole3
	cp 3
	jr z, .hole2
	cp 2
	jr z, .hole1
; switch
	CheckEventReuseHL EVENT_MT_MOON_B4F_BOULDER_ON_SWITCH
	SetEventReuseHL EVENT_MT_MOON_B4F_BOULDER_ON_SWITCH
	ret nz
	jr .end
.hole1
	CheckEventAfterBranchReuseHL EVENT_MT_MOON_B4F_BOULDER_DOWN_HOLE_1, EVENT_MT_MOON_B4F_BOULDER_ON_SWITCH
	SetEventReuseHL EVENT_MT_MOON_B4F_BOULDER_DOWN_HOLE_1
	ret nz
	jr .end
.hole2
	CheckEventAfterBranchReuseHL EVENT_MT_MOON_B4F_BOULDER_DOWN_HOLE_2, EVENT_MT_MOON_B4F_BOULDER_ON_SWITCH
	SetEventReuseHL EVENT_MT_MOON_B4F_BOULDER_DOWN_HOLE_2
	ret nz
	jr .end
.hole3
	CheckEventAfterBranchReuseHL EVENT_MT_MOON_B4F_BOULDER_DOWN_HOLE_3, EVENT_MT_MOON_B4F_BOULDER_ON_SWITCH
	SetEventReuseHL EVENT_MT_MOON_B4F_BOULDER_DOWN_HOLE_3
	ret nz
	jr .end
.hole4
	CheckEventAfterBranchReuseHL EVENT_MT_MOON_B4F_BOULDER_DOWN_HOLE_4, EVENT_MT_MOON_B4F_BOULDER_ON_SWITCH
	SetEventReuseHL EVENT_MT_MOON_B4F_BOULDER_DOWN_HOLE_4
	jr z, .threw1stBoulderDownHole4
	CheckEventAfterBranchReuseHL EVENT_MT_MOON_B4F_BOULDER_DOWN_HOLE_6, EVENT_MT_MOON_B4F_BOULDER_DOWN_HOLE_4
	SetEventReuseHL EVENT_MT_MOON_B4F_BOULDER_DOWN_HOLE_6
	ret nz
	jr .end
.hole5
	CheckEventAfterBranchReuseHL EVENT_MT_MOON_B4F_BOULDER_DOWN_HOLE_5, EVENT_MT_MOON_B4F_BOULDER_ON_SWITCH
	SetEventReuseHL EVENT_MT_MOON_B4F_BOULDER_DOWN_HOLE_5
	ret nz
	jr .end
.threw1stBoulderDownHole4
	ld hl, wVermilionBeachFlags
	ldh a, [hSpriteIndex]
	cp 8
	res 1, [hl]
	jr z, .end
	set 1, [hl]
.end
	ld hl, wCurrentMapScriptFlags
	set 6, [hl]
	ret

MtMoonB4FSwitchAndHoleCoords:
	dbmapcoord  7,  5
	; fallthrough
MtMoonB4FHoleCoords:
	dbmapcoord  1,  1
	dbmapcoord 13,  1
	dbmapcoord 12,  6
	dbmapcoord  4, 10
	dbmapcoord  4, 13
	db -1 ; end
	
MtMoonB4FIsPlayerFallingDownHole:
	xor a
	ld [wWhichDungeonWarp], a
	ld a, [wd72d]
	bit 4, a
	ret nz
	call ArePlayerCoordsInArray
	ret nc
	ld a, [wCoordIndex]
	ld [wWhichDungeonWarp], a
	ld hl, wd72d
	set 4, [hl]
	ld hl, wd732
	set 4, [hl]
	ret

MtMoonB4FCheckBoulderEventScript:
	CheckEvent EVENT_MT_MOON_B4F_BOULDER_ON_SWITCH
	jr z, .checkHoles
	ld a, 4
	lb bc, 1, 3
	ld [wNewTileBlockID], a
	predef ReplaceTileBlock
	ld a, HS_MT_MOON_B4F_BOULDER_7
	ld [wMissableObjectIndex], a
	predef HideNewObject
	ld a, HS_MT_MOON_B4F_BOULDER_10
	ld [wMissableObjectIndex], a
	predef ShowNewObject
.checkHoles
	CheckEvent EVENT_MT_MOON_B4F_BOULDER_DOWN_HOLE_1
	jr z, .next
	ld a, HS_MT_MOON_B4F_BOULDER_1
	ld [wMissableObjectIndex], a
	predef HideNewObject
	ld a, HS_MT_MOON_B5F_BOULDER_1
	ld [wMissableObjectIndex], a
	predef ShowNewObject
.next
	CheckEvent EVENT_MT_MOON_B4F_BOULDER_DOWN_HOLE_2
	jr z, .next2
	ld a, HS_MT_MOON_B4F_BOULDER_3
	ld [wMissableObjectIndex], a
	predef HideNewObject
	ld a, HS_MT_MOON_B5F_BOULDER_2
	ld [wMissableObjectIndex], a
	predef ShowNewObject
.next2
	CheckEvent EVENT_MT_MOON_B4F_BOULDER_DOWN_HOLE_3
	jr z, .next3
	ld a, HS_MT_MOON_B4F_BOULDER_6
	ld [wMissableObjectIndex], a
	predef HideNewObject
	ld a, HS_MT_MOON_B5F_BOULDER_3
	ld [wMissableObjectIndex], a
	predef ShowNewObject
.next3
	CheckEvent EVENT_MT_MOON_B4F_BOULDER_DOWN_HOLE_4
	jr z, .next4
	ld hl, wVermilionBeachFlags
	bit 1, [hl]
	ld a, HS_MT_MOON_B4F_BOULDER_8
	jr z, .skip
	ld a, HS_MT_MOON_B4F_BOULDER_9
.skip
	ld [wMissableObjectIndex], a
	predef HideNewObject
	ld a, HS_MT_MOON_B5F_BOULDER_4
	ld [wMissableObjectIndex], a
	predef ShowNewObject
.next4
	CheckEvent EVENT_MT_MOON_B4F_BOULDER_DOWN_HOLE_5
	jr z, .next5
	ld a, HS_MT_MOON_B4F_BOULDER_8
	ld [wMissableObjectIndex], a
	predef HideNewObject
	ld a, HS_MT_MOON_B5F_BOULDER_7
	ld [wMissableObjectIndex], a
	predef ShowNewObject
.next5
	CheckEvent EVENT_MT_MOON_B4F_BOULDER_DOWN_HOLE_6
	ret z
	ld hl, wVermilionBeachFlags
	bit 1, [hl]
	ld a, HS_MT_MOON_B4F_BOULDER_9
	jr z, .skip2
	ld a, HS_MT_MOON_B4F_BOULDER_8
.skip2
	ld [wMissableObjectIndex], a
	predef HideNewObject
	ld a, HS_MT_MOON_B5F_BOULDER_5
	ld [wMissableObjectIndex], a
	predef_jump ShowNewObject

MtMoonB4F_TextPointers:
	dw BoulderText
	dw BoulderText
	dw BoulderText
	dw BoulderText
	dw BoulderText
	dw BoulderText
	dw BoulderText
	dw BoulderText
	dw BoulderText
	dw MtMoonB4FBoulderOnSwitchText
	dw PickUpItemText
	dw PickUpItemText
	dw PickUpItemText
	
MtMoonB4FBoulderOnSwitchText:
	text_far _BoulderOnSwitchText
	text_end
