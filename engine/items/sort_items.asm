_SortItems:
	ld hl, SortItemsText ; Display the text to ask to sort
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jp z, .beginSorting ; If yes
	jr .done
.finishedSwapping
	ld a, [hSwapTemp] ; If not 0, then a swap of items did occur
	cp 0
	jr z, .nothingSorted
	ld hl, SortComplete
	jr .printResultText
.nothingSorted
	ld hl, NothingToSort
.printResultText
	call PrintText
.done
	ret
.beginSorting:
	xor a
	ld [hSwapTemp], a ; 1 if something in the bag got sorted
	ld de, 0
	ld hl, ItemSortList
	ld b, [hl] ; This is the first item to check for
	call .ldHLbagorbox ;; changed
	ld c, 0 ; Relative to wBagItems, this is where we'd like to begin swapping
.loopCurrItemInBag
	ld a, [hl] ; Load the value of hl to a (which is an item number) and Increments to the quantity
	cp -1 ; See if the item number is $ff, which is 'cancel'
	jr z, .findNextItem ; If it is cancel, then move onto the next item
	cp b
	jr z, .hasItem ; If it's not b, then go to the next item in the bag
	inc hl ; increments past the quantity to the next item to check
	inc hl
	jr .loopCurrItemInBag
.findNextItem
	ld d, 0
	inc e
	ld hl, ItemSortList
	add hl, de
	ld b, [hl]
	call .ldHLbagorbox ; Resets hl to start at the beginning of the bag ;; changed
	ld a, b
	cp -1 ; Check if we got through all of the items, to the last one
	jr z, .finishedSwapping
	jr .loopCurrItemInBag
.hasItem ; c contains where to swap to relative to the start of wBagItems
		 ; hl contains where the item to swap is absolute.
		 ; b contains the item ID
	push de
	ld d, h
	ld e, l
	call .ldHLbagorbox ;; changed
	ld a, b
	ld b, 0
	add hl, bc ; hl now holds where we'd like to swap to
	ld b, a
	ld a, [de]
	cp [hl]
	jr z, .cont ; If they're the same item
	ld a, 1
	ld [hSwapTemp], a
	ld a, [hl]
	ld [hSwapItemID],a ; [hSwapItemID] = second item ID
	inc hl
	ld a,[hld]
	ld [hSwapItemQuantity],a ; [hSwapItemQuantity] = second item quantity
	ld a,[de]
	ld [hli],a ; put first item ID in second item slot
	inc de
	ld a,[de]
	ld [hl],a ; put first item quantity in second item slot
	ld a,[hSwapItemQuantity]
	ld [de],a ; put second item quantity in first item slot
	dec de
	ld a,[hSwapItemID]
	ld [de],a ; put second item ID in first item slot
.cont
	inc c
	inc c
	ld h, d
	ld l, e
	pop de
	jr .findNextItem
;Allow for sorting both the bag and the item PC box
.ldHLbagorbox
	ld hl, wBagItems
	ld a, [wFlags_0xcd60]
	bit 4, a
	ret z
	ld hl, wBoxItems
	ret

SortItemsText::
	text_far _SortItemsText
	db "@"

SortComplete::
	text_far _SortComplete
	db "@"

NothingToSort::
	text_far _NothingToSort
	db "@"

INCLUDE "data/items/sort_items.asm"
