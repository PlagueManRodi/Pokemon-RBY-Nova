HasEnoughCoins::
; Check if the player has at least as many
; coins as the 2-byte BCD value at hCoins.
	ld de, wPlayerCoins
	ld hl, hCoins
	ld c, 2
	call StringCmp
	push af
	pop de
	ret
