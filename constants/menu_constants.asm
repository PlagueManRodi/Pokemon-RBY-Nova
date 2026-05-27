DEF BAG_ITEM_CAPACITY EQU 60
DEF PC_ITEM_CAPACITY  EQU 150

; text box IDs
	const_def 1
	const MESSAGE_BOX                       ; $01
	const_skip                              ; $02
	const MENU_TEMPLATE_03                  ; $03 unused
	const FIELD_MOVE_MON_MENU               ; $04
	const JP_MOCHIMONO_MENU_TEMPLATE        ; $05
	const USE_TOSS_MENU_TEMPLATE            ; $06
	const MENU_TEMPLATE_07                  ; $07 unused
	const JP_SAVE_MESSAGE_MENU_TEMPLATE     ; $08
	const JP_SPEED_OPTIONS_MENU_TEMPLATE    ; $09
	const MENU_POKEMON_ATTACKS_EXIT         ; $0a new, for attackdex
	const BATTLE_MENU_TEMPLATE              ; $0b
	const SWITCH_STATS_CANCEL_MENU_TEMPLATE ; $0c
	const LIST_MENU_BOX                     ; $0d
	const BUY_SELL_QUIT_MENU_TEMPLATE       ; $0e
	const MONEY_BOX_TEMPLATE                ; $0f
	const MENU_TEMPLATE_10                  ; $10 unused
	const MON_SPRITE_POPUP                  ; $11
	const JP_AH_MENU_TEMPLATE               ; $12
	const MONEY_BOX                         ; $13
	const TWO_OPTION_MENU                   ; $14
	const BUY_SELL_QUIT_MENU                ; $15
	const VERSION_BOX                       ; $16
	const START_SORT_TEMPLATE               ; $17
	const TMHM_NAME_TEMPLATE                ; $18
	const_skip                              ; $19
	const JP_POKEDEX_MENU_TEMPLATE          ; $1a
	const SAFARI_BATTLE_MENU_TEMPLATE       ; $1b

; two option menu constants
; TwoOptionMenuStrings indexes (see data/yes_no_menu_strings.asm)
	const_def
	const YES_NO_MENU       ; 0
	const NORTH_WEST_MENU   ; 1
	const SOUTH_EAST_MENU   ; 2
	const WIDE_YES_NO_MENU  ; 3
	const NORTH_EAST_MENU   ; 4
	const TRADE_CANCEL_MENU ; 5
	const HEAL_CANCEL_MENU  ; 6
	const NO_YES_MENU       ; 7
	const NORMAL_PRO_MENU   ; 8 NEW
DEF NUM_TWO_OPTION_MENUS EQU const_value

; menu exit method constants for list menus and the buy/sell/quit menu
DEF CHOSE_MENU_ITEM   EQU 1 ; pressed A
DEF CANCELLED_MENU    EQU 2 ; pressed B

; menu exit method constants for two-option menus
DEF CHOSE_FIRST_ITEM  EQU 1
DEF CHOSE_SECOND_ITEM EQU 2

; move mon constants
	const_def
	const BOX_TO_PARTY     ; 0
	const PARTY_TO_BOX     ; 1
	const DAYCARE_TO_PARTY ; 2
	const PARTY_TO_DAYCARE ; 3

; party menu types
; PartyMenuMessagePointers indexes (see engine/menus/party_menu.asm)
	const_def
	const NORMAL_PARTY_MENU    ; $00
	const USE_ITEM_PARTY_MENU  ; $01
	const BATTLE_PARTY_MENU    ; $02
	const TMHM_PARTY_MENU      ; $03
	const SWAP_MONS_PARTY_MENU ; $04
	const EVO_STONE_PARTY_MENU ; $05
; party menu message IDs
; PartyMenuItemUseMessagePointers indexes (see engine/menus/party_menu.asm)
	const_next $F0
DEF FIRST_PARTY_MENU_TEXT_ID EQU const_value
	const ANTIDOTE_MSG         ; $F0
	const BURN_HEAL_MSG        ; $F1
	const ICE_HEAL_MSG         ; $F2
	const AWAKENING_MSG        ; $F3
	const PARALYZ_HEAL_MSG     ; $F4
	const POTION_MSG           ; $F5
	const FULL_HEAL_MSG        ; $F6
	const REVIVE_MSG           ; $F7
	const RARE_CANDY_MSG       ; $F8

; naming screen types
	const_def
	const NAME_PLAYER_SCREEN ; 0
	const NAME_RIVAL_SCREEN  ; 1
	const NAME_MON_SCREEN    ; 2

; type shuffle constant
	const_def
	const TS_CHARIZARD			; 0
	const TS_BLASTOISE			; 1
	const TS_BUTTERFREE			; 2
	const TS_PIDGEY				; 3
	const TS_PIDGEOTTO			; 4
	const TS_PIDGEOT			; 5
	const TS_SPEAROW			; 6
	const TS_FEAROW				; 7
	const TS_EKANS				; 8		
	const TS_ARBOK				; 9
	const TS_BELLOSSOM			; 10
	const TS_VENONAT			; 11
	const TS_VENOMOTH			; 12
	const TS_PSYDUCK			; 13
	const TS_GOLDUCK			; 14
	const TS_POLITOED			; 15
	const TS_BELLSPROUT			; 16
	const TS_WEEPINBELL			; 17
	const TS_VICTREEBEL			; 18
	const TS_MAGNEMITE			; 19
	const TS_MAGNETON			; 20
	const TS_MAGNEZONE			; 21
	const TS_DODUO				; 22
	const TS_DODRIO				; 23
	const TS_GASTLY				; 24
	const TS_HAUNTER			; 25
	const TS_GENGAR				; 26
	const TS_DROWZEE			; 27
	const TS_HYPNO				; 28
	const TS_GOLDEEN			; 29
	const TS_SEAKING			; 30
	const TS_STARMIE			; 31
	const TS_ELEKID				; 32
	const TS_ELECTABUZZ			; 33
	const TS_ELECTIVIRE			; 34
	const TS_PINSIR				; 35
	const TS_GYARADOS			; 36
	const TS_PORYGON			; 37
	const TS_PORYGON2			; 38
	const TS_PORYGONZ			; 39
	const TS_KABUTO				; 40
	const TS_KABUTOPS			; 41
	const TS_AERODACTYL			; 42
	const TS_DRAGONITE			; 43
	const TS_ACID_TYPE_MOVES	; 44
DEF LAST_ALT_TYPE 	EQU const_value
DEF NUM_ALT_TYPE 	EQU const_value + 1

DEF SPECIAL_ENTRY 		EQU -1
DEF NUM_ALT_TYPE_PAGES	EQU 4
