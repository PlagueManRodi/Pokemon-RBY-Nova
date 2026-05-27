; Compare strings, c bytes in length, at de and hl.
; Often used to compare big endian numbers in battle calculations.
StringCmp::
	ld a, [de]
	cp [hl]
	ret nz
	inc de
	inc hl
	dec c
	jr nz, StringCmp
	ret

; sets carry flag if DE is greater than HL. Sets zero flag if they're equal.
CompareDEHL::
    ld a, h
    sub d
    ret nz ; if carry, DE is greater, if no carry, HL is greater
; 2nd byte comparison
    ld a, l
    sub e
    ret ; if carry, DE is greater, if no carry, HL is greater, if z, they're equal
