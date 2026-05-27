MtMoonB3F_Script:
	ld hl, wCurrentMapScriptFlags
	bit 6, [hl]
	res 6, [hl]
	call nz, MtMoonB3FHideAndShowBoulderObjects
	call EnableAutoTextBoxDrawing
	ld hl, MtMoonB3F_ScriptPointers
	ld a, [wMtMoonB3FCurScript]
	jp CallFunctionInTable

MtMoonB3F_ScriptPointers:
	dw MtMoonB3FScript0

MtMoonB3FScript0:
	call MtMoonB3FCheckHole
	jr MtMoonB3FCheckBoulderPosition
	
MtMoonB3FCheckHole:
	ld hl, MtMoonB3FHoleCoords
	call MtMoonB3FIsPlayerFallingDownHole
	ld a, [wWhichDungeonWarp]
	and a
	ret z
	ld a, MT_MOON_B4F
	ld [wDungeonWarpDestinationMap], a
	ret

MtMoonB3FCheckBoulderPosition:
	ld hl, wFlags_0xcd60
	bit 7, [hl]
	res 7, [hl]
	ret z
	ld hl, MtMoonB3FHoleCoords
	call CheckBoulderCoords
	ret nc
	EventFlagAddress hl, EVENT_MT_MOON_B3F_BOULDER_DOWN_HOLE_1
	ld a, [wCoordIndex]
	cp 7 
	jr z, .hole7
	cp 6
	jr z, .hole6
	cp 5
	jr z, .hole5
	cp 4
	jr z, .hole4
	cp 3
	jr z, .hole3
	cp 2
	jr z, .hole2
; hole 1
	CheckEventReuseHL EVENT_MT_MOON_B3F_BOULDER_DOWN_HOLE_1
	SetEventReuseHL EVENT_MT_MOON_B3F_BOULDER_DOWN_HOLE_1
	ret nz
	jr .end
.hole2
	CheckEventAfterBranchReuseHL EVENT_MT_MOON_B3F_BOULDER_DOWN_HOLE_2, EVENT_MT_MOON_B3F_BOULDER_DOWN_HOLE_1
	SetEventReuseHL EVENT_MT_MOON_B3F_BOULDER_DOWN_HOLE_2
	ret nz
	jr .end
.hole3
	CheckEventAfterBranchReuseHL EVENT_MT_MOON_B3F_BOULDER_DOWN_HOLE_3, EVENT_MT_MOON_B3F_BOULDER_DOWN_HOLE_1
	SetEventReuseHL EVENT_MT_MOON_B3F_BOULDER_DOWN_HOLE_3
	ret nz
	jr .end
.hole4
	CheckEventAfterBranchReuseHL EVENT_MT_MOON_B3F_BOULDER_DOWN_HOLE_4, EVENT_MT_MOON_B3F_BOULDER_DOWN_HOLE_1
	SetEventReuseHL EVENT_MT_MOON_B3F_BOULDER_DOWN_HOLE_4
	ret nz
	jr .end
.hole5
	CheckEventAfterBranchReuseHL EVENT_MT_MOON_B3F_BOULDER_DOWN_HOLE_5, EVENT_MT_MOON_B3F_BOULDER_DOWN_HOLE_1
	SetEventReuseHL EVENT_MT_MOON_B3F_BOULDER_DOWN_HOLE_5
	ret nz
	jr .end
.hole6
	CheckEventAfterBranchReuseHL EVENT_MT_MOON_B3F_BOULDER_DOWN_HOLE_6, EVENT_MT_MOON_B3F_BOULDER_DOWN_HOLE_1
	SetEventReuseHL EVENT_MT_MOON_B3F_BOULDER_DOWN_HOLE_6
	ret nz
	jr .end
.hole7
	CheckEventAfterBranchReuseHL EVENT_MT_MOON_B3F_BOULDER_DOWN_HOLE_7, EVENT_MT_MOON_B3F_BOULDER_DOWN_HOLE_1
	SetEventReuseHL EVENT_MT_MOON_B3F_BOULDER_DOWN_HOLE_7
	ret nz
.end
	ld hl, wCurrentMapScriptFlags
	set 6, [hl]
	ret

MtMoonB3FHoleCoords:
	dbmapcoord  2,  2
	dbmapcoord  5,  4
	dbmapcoord  9,  1
	dbmapcoord  9,  3
	dbmapcoord 12,  4
	dbmapcoord  3,  7	
	dbmapcoord  6, 10	
	db -1 ; end
	
MtMoonB3FIsPlayerFallingDownHole:
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

MtMoonB3FHideAndShowBoulderObjects:
	CheckEvent EVENT_MT_MOON_B3F_BOULDER_DOWN_HOLE_1
	jr z, .next
	ld a, HS_MT_MOON_B3F_BOULDER_1
	ld [wMissableObjectIndex], a
	predef HideNewObject
	ld a, HS_MT_MOON_B4F_BOULDER_1
	ld [wMissableObjectIndex], a
	predef ShowNewObject
.next
	CheckEvent EVENT_MT_MOON_B3F_BOULDER_DOWN_HOLE_2
	jr z, .next2
	ld a, HS_MT_MOON_B3F_BOULDER_1
	ld [wMissableObjectIndex], a
	predef HideNewObject
	ld a, HS_MT_MOON_B4F_BOULDER_2
	ld [wMissableObjectIndex], a
	predef ShowNewObject
.next2
	CheckEvent EVENT_MT_MOON_B3F_BOULDER_DOWN_HOLE_3
	jr z, .next3
	ld a, HS_MT_MOON_B3F_BOULDER_3
	ld [wMissableObjectIndex], a
	predef HideNewObject
	ld a, HS_MT_MOON_B4F_BOULDER_4
	ld [wMissableObjectIndex], a
	predef ShowNewObject
.next3
	CheckEvent EVENT_MT_MOON_B3F_BOULDER_DOWN_HOLE_4
	jr z, .next4	
	ld a, HS_MT_MOON_B3F_BOULDER_4
	ld [wMissableObjectIndex], a
	predef HideNewObject
	ld a, HS_MT_MOON_B4F_BOULDER_5
	ld [wMissableObjectIndex], a
	predef ShowNewObject
.next4
	CheckEvent EVENT_MT_MOON_B3F_BOULDER_DOWN_HOLE_5
	jr z, .next5
	ld a, HS_MT_MOON_B3F_BOULDER_2
	ld [wMissableObjectIndex], a
	predef HideNewObject
	ld a, HS_MT_MOON_B4F_BOULDER_6
	ld [wMissableObjectIndex], a
	predef ShowNewObject
.next5
	CheckEvent EVENT_MT_MOON_B3F_BOULDER_DOWN_HOLE_6
	jr z, .next6	
	ld a, HS_MT_MOON_B3F_BOULDER_5
	ld [wMissableObjectIndex], a
	predef HideNewObject
	ld a, HS_MT_MOON_B4F_BOULDER_7
	ld [wMissableObjectIndex], a
	predef ShowNewObject
.next6
	CheckEvent EVENT_MT_MOON_B3F_BOULDER_DOWN_HOLE_7
	ret z
	ld a, HS_MT_MOON_B3F_BOULDER_6
	ld [wMissableObjectIndex], a
	predef HideNewObject
	ld a, HS_MT_MOON_B4F_BOULDER_9
	ld [wMissableObjectIndex], a
	predef_jump ShowNewObject

MtMoonB3F_TextPointers:
	dw BoulderText
	dw BoulderText
	dw BoulderText
	dw BoulderText
	dw BoulderText
	dw BoulderText
	dw PickUpItemText
	dw PickUpItemText
	dw PickUpItemText
