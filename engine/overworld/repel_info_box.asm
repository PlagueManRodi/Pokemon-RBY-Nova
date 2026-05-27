PrintRepelInfo::
	hlcoord 0, 0
	ld b, 3
	ld c, 7
	call TextBoxBorder
	ld a, [wRepelTotalSteps]
	and a
	jr nz, .notOFF
	hlcoord 1, 3
	ld de, OFFText
	call PlaceString
	jr .printRepelText
.notOFF
	cp -1
	jr nz, .notON
	hlcoord 1, 3
	ld de, ONText
	call PlaceString	
	jr .printRepelText
.notON
	hlcoord 1, 3
	ld de, wRepelRemainingSteps
	lb bc, $C1, 3
	call PrintNumber
	hlcoord 4, 3
	ld de, NewSlashText
	call PlaceString
	hlcoord 5, 3
	ld de, wRepelTotalSteps
	lb bc, $C1, 3
	call PrintNumber
.printRepelText
	hlcoord 1, 1
	ld de, RepelText
	jp PlaceString

NewSlashText:
	db "/@"

RepelText:
	db "REPEL@"
	
ONText:
	db " ON@"
	
OFFText:
	db " OFF@"
