TradeMons:
; entries correspond to TRADE_FOR_* constants
	table_width 3 + NAME_LENGTH, TradeMons
	; give mon, get mon, dialog id, nickname
	; The two instances of TRADE_DIALOGSET_EVOLUTION are a leftover
	; from the Japanese Blue trades, which used species that evolve.
	; Japanese Red and Green used TRADE_DIALOGSET_CASUAL, and had
	; the same species as English Red and Blue.
	db MEOWTH,     RATTATA,   TRADE_DIALOGSET_CASUAL, "SPLINTER@@@" ; Route 11
	db MR_MIME,    KADABRA,   TRADE_DIALOGSET_CASUAL, "SPOONMAN@@@" ; Route 2
	db BUTTERFREE, BEEDRILL,  TRADE_DIALOGSET_HAPPY,  "CHIKUCHIKU@" ; unused
	db GYARADOS,   STEELIX,   TRADE_DIALOGSET_CASUAL, "SOLIDSNAKE@" ; Cinnabar Island
	db PIDGEOTTO,  SPEAROW,   TRADE_DIALOGSET_HAPPY,  "BIRDIE@@@@@" ; Vermilion City
	db DITTO,      HAUNTER,   TRADE_DIALOGSET_CASUAL, "PHANTOM@@@@" ; Route 18
	db PARAS,      MAGNEMITE, TRADE_DIALOGSET_CASUAL, "GILBERT@@@@" ; Cerulean City
	db KANGASKHAN, TAUROS,    TRADE_DIALOGSET_CASUAL, "THE BULL@@@" ; Cinnabar Island
	db DEWGONG,    LAPRAS,    TRADE_DIALOGSET_HAPPY,  "SURFBOARD@@" ; Cinnabar Island
	db NIDORINA,   NIDORINO,  TRADE_DIALOGSET_HAPPY,  "OLLIE@@@@@@" ; Route 5
	assert_table_length NUM_NPC_TRADES
