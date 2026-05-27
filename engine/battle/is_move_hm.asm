; sets carry if move is an HM, clears carry if move is not an HM
; Input: a = move ID
IsMoveHM::
	ld a, d
	ld hl, HMMoves
	ld de, 1
	call IsInArray
	push af
	pop de
	ret
	
HMMoves::
INCLUDE "data/moves/hm_moves.asm"
