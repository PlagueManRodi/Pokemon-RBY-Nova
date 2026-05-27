SSAnne1F_Script:
	call EnableAutoTextBoxDrawing
	ret

SSAnne1F_TextPointers:
	dw SSAnne1Text1
	dw SSAnne1Text2
	dw SSAnne1Text3

SSAnne1Text1:
	text_far _SSAnne1Text1
	text_end

SSAnne1Text2:
	text_far _SSAnne1Text2
	text_end
	
SSAnne1Text3:
	text_asm
	ld hl, SSAnnePreHealText
	call PrintText
	predef HealParty
	call GBFadeOutToWhite
	call Delay3
	call GBFadeInFromWhite
	ld hl, SSAnnePostHealText
	call PrintText
	jp TextScriptEnd

SSAnnePreHealText:
	text_far _SSAnnePreHealText
	text_end

SSAnnePostHealText:
	text_far _SSAnnePostHealText
	text_end
