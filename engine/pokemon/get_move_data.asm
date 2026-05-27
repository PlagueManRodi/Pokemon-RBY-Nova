GetMoveData:
	ld a, d
	dec a
	ld hl, Moves
	ld bc, MOVE_LENGTH
	call AddNTimes
	ld de, wEnemyMoveNum
	call CopyData
	ld de, wEnemyMoveNum
	callfar AcidTypeMoveCheck
	ret
