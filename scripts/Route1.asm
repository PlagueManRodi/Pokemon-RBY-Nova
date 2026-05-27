Route1_Script:
	jp EnableAutoTextBoxDrawing

Route1_TextPointers:
	dw PickUpItemText
	dw Route1Text2
	dw Route1Text3
	dw Route1Text4

Route1Text2:
	text_asm
	CheckAndSetEvent EVENT_GOT_POTION_SAMPLE
	jr nz, .got_item
	ld hl, Route1ViridianMartSampleText
	call PrintText
	lb bc, POTION, 1
	call GiveItem
	jr nc, .bag_full
	ld hl, Route1Text_2cae8
	jr .done
.bag_full
	ld hl, Route1Text_2caf3
	jr .done
.got_item
	ld hl, Route1Text_2caee
.done
	call PrintText
	jp TextScriptEnd

Route1ViridianMartSampleText:
	text_far _Route1ViridianMartSampleText
	text_end

Route1Text_2cae8:
	text_far _Route1Text_2cae8
	sound_get_item_1
	text_end

Route1Text_2caee:
	text_far _Route1Text_2caee
	text_end

Route1Text_2caf3:
	text_far _Route1Text_2caf3
	text_end

Route1Text3:
	text_far _Route1Text3
	text_end

Route1Text4:
	text_far _Route1Text4
	text_end
