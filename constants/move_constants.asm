; move ids
; indexes for:
; - Moves (see data/moves/moves.asm)
; - MoveNames (see data/moves/names.asm)
; - AttackAnimationPointers (see data/moves/animations.asm)
; - MoveSoundTable (see data/moves/sfx.asm)
	const_def
	const NO_MOVE      ; 00
	const POUND        ; 01
	const KARATE_CHOP  ; 02
	const DOUBLESLAP   ; 03
	const COMET_PUNCH  ; 04
	const MEGA_PUNCH   ; 05
	const PAY_DAY      ; 06
	const FIRE_PUNCH   ; 07
	const ICE_PUNCH    ; 08
	const THUNDERPUNCH ; 09
	const SCRATCH      ; 0a
	const VICEGRIP     ; 0b
	const GUILLOTINE   ; 0c
	const RAZOR_WIND   ; 0d
	const SWORDS_DANCE ; 0e
	const CUT          ; 0f
	const GUST         ; 10
	const WING_ATTACK  ; 11
	const WHIRLWIND    ; 12
	const FLY          ; 13
	const BIND         ; 14
	const SLAM         ; 15
	const VINE_WHIP    ; 16
	const STOMP        ; 17
	const DOUBLE_KICK  ; 18
	const MEGA_KICK    ; 19
	const JUMP_KICK    ; 1a
	const ROLLING_KICK ; 1b
	const SAND_ATTACK  ; 1c
	const HEADBUTT     ; 1d
	const HORN_ATTACK  ; 1e
	const FURY_ATTACK  ; 1f
	const HORN_DRILL   ; 20
	const TACKLE       ; 21
	const BODY_SLAM    ; 22
	const WRAP         ; 23
	const TAKE_DOWN    ; 24
	const THRASH       ; 25
	const DOUBLE_EDGE  ; 26
	const TAIL_WHIP    ; 27
	const POISON_STING ; 28
	const TWINEEDLE    ; 29
	const PIN_MISSILE  ; 2a
	const LEER         ; 2b
	const BITE         ; 2c
	const GROWL        ; 2d
	const ROAR         ; 2e
	const SING         ; 2f
	const SUPERSONIC   ; 30
	const SONICBOOM    ; 31
	const DISABLE      ; 32
	const ACID         ; 33
	const EMBER        ; 34
	const FLAMETHROWER ; 35
	const MIST         ; 36
	const WATER_GUN    ; 37
	const HYDRO_PUMP   ; 38
	const SURF         ; 39
	const ICE_BEAM     ; 3a
	const BLIZZARD     ; 3b
	const PSYBEAM      ; 3c
	const BUBBLEBEAM   ; 3d
	const AURORA_BEAM  ; 3e
	const HYPER_BEAM   ; 3f
	const PECK         ; 40
	const DRILL_PECK   ; 41
	const SUBMISSION   ; 42
	const LOW_KICK     ; 43
	const COUNTER      ; 44
	const SEISMIC_TOSS ; 45
	const STRENGTH     ; 46
	const ABSORB       ; 47
	const MEGA_DRAIN   ; 48
	const LEECH_SEED   ; 49
	const GROWTH       ; 4a
	const RAZOR_LEAF   ; 4b
	const SOLARBEAM    ; 4c
	const POISONPOWDER ; 4d
	const STUN_SPORE   ; 4e
	const SLEEP_POWDER ; 4f
	const PETAL_DANCE  ; 50
	const STRING_SHOT  ; 51
	const DRAGON_RAGE  ; 52
	const FIRE_SPIN    ; 53
	const THUNDERSHOCK ; 54
	const THUNDERBOLT  ; 55
	const THUNDER_WAVE ; 56
	const THUNDER      ; 57
	const ROCK_THROW   ; 58
	const EARTHQUAKE   ; 59
	const FISSURE      ; 5a
	const DIG          ; 5b
	const TOXIC        ; 5c
	const CONFUSION    ; 5d
	const PSYCHIC_M    ; 5e
	const HYPNOSIS     ; 5f
	const MEDITATE     ; 60
	const AGILITY      ; 61
	const QUICK_ATTACK ; 62
	const RAGE         ; 63
	const TELEPORT     ; 64
	const NIGHT_SHADE  ; 65
	const MIMIC        ; 66
	const SCREECH      ; 67
	const DOUBLE_TEAM  ; 68
	const RECOVER      ; 69
	const HARDEN       ; 6a
	const MINIMIZE     ; 6b
	const SMOKESCREEN  ; 6c
	const CONFUSE_RAY  ; 6d
	const WITHDRAW     ; 6e
	const DEFENSE_CURL ; 6f
	const BARRIER      ; 70
	const LIGHT_SCREEN ; 71
	const HAZE         ; 72
	const REFLECT      ; 73
	const FOCUS_ENERGY ; 74
	const BIDE         ; 75
	const METRONOME    ; 76
	const MIRROR_MOVE  ; 77
	const SELFDESTRUCT ; 78
	const EGG_BOMB     ; 79
	const LICK         ; 7a
	const SMOG         ; 7b
	const SLUDGE       ; 7c
	const BONE_CLUB    ; 7d
	const FIRE_BLAST   ; 7e
	const WATERFALL    ; 7f
	const CLAMP        ; 80
	const SWIFT        ; 81
	const SKULL_BASH   ; 82
	const SPIKE_CANNON ; 83
	const CONSTRICT    ; 84
	const AMNESIA      ; 85
	const KINESIS      ; 86
	const SOFTBOILED   ; 87
	const HI_JUMP_KICK ; 88
	const GLARE        ; 89
	const DREAM_EATER  ; 8a
	const POISON_GAS   ; 8b
	const BARRAGE      ; 8c
	const LEECH_LIFE   ; 8d
	const LOVELY_KISS  ; 8e
	const SKY_ATTACK   ; 8f
	const TRANSFORM    ; 90
	const BUBBLE       ; 91
	const DIZZY_PUNCH  ; 92
	const SPORE        ; 93
	const FLASH        ; 94
	const PSYWAVE      ; 95
	const SPLASH       ; 96
	const ACID_ARMOR   ; 97
	const CRABHAMMER   ; 98
	const EXPLOSION    ; 99
	const FURY_SWIPES  ; 9a
	const BONEMERANG   ; 9b
	const REST         ; 9c
	const ROCK_SLIDE   ; 9d
	const HYPER_FANG   ; 9e
	const SHARPEN      ; 9f
	const CONVERSION   ; a0
	const TRI_ATTACK   ; a1
	const SUPER_FANG   ; a2
	const SLASH        ; a3
	const SUBSTITUTE   ; a4
IF DEF(_MODERN)
	const MEGAHORN     ; a5
	const POLLEN_PUFF  ; a6
	const X_SCISSOR    ; a7
	const SIGNAL_BEAM  ; a8
	const CRUNCH       ; a9
	const DARK_PULSE   ; aa
	const FEINT_ATTACK ; ab
	const OUTRAGE      ; ac
	const DRAGONHAMMER ; ad
	const DRAGON_PULSE ; ae
	const DRAGONBREATH ; af
	const TWISTER      ; b0
	const DUAL_CHOP    ; b1
	const DISCHARGE    ; b2
	const THUNDER_FANG ; b3
	const SPARK        ; b4
	const MOONLIGHT    ; b5
	const MOONBLAST    ; b6
	const DAZZLE_GLEAM ; b7
	const DISARM_VOICE ; b8
	const FAIRY_WIND   ; b9
	const METEORASSAIL ; ba
	const FOCUS_BLAST  ; bb
	const DRAIN_PUNCH  ; bc
	const LOW_SWEEP    ; bd
	const STORM_THROW  ; be
	const VACUUM_WAVE  ; bf
	const FIRE_FANG    ; c0
	const FLAME_WHEEL  ; c1
	const ROOST        ; c2
	const BRAVE_BIRD   ; c3
	const HURRICANE    ; c4
	const AIR_SLASH    ; c5
	const AERIAL_ACE   ; c6
	const SHADOW_BONE  ; c7
	const SHADOW_BALL  ; c8
	const SHADOW_PUNCH ; c9
	const SHADOW_SNEAK ; ca
	const SYNTHESIS    ; cb
	const GRASSWHISTLE ; cc
	const POWER_WHIP   ; cd
	const GIGA_DRAIN   ; ce
	const SCORCH_SANDS ; cf
	const MUD_SHOT     ; d0
	const SHEER_COLD   ; d1
	const ICICLE_CRASH ; d2
	const ICE_FANG     ; d3
	const ICY_WIND     ; d4
	const SLACK_OFF    ; d5
	const MORNING_SUN  ; d6
	const ROCK_CLIMB   ; d7
	const GUNK_SHOT    ; d8
	const SLUDGE_BOMB  ; d9
	const ROCK_POLISH  ; da
	const ROCK_WRECKER ; db
	const ROCK_TOMB    ; dc
	const IRON_DEFENSE ; dd
	const IRON_TAIL    ; de
	const IRON_HEAD    ; df
	const FLASH_CANNON ; e0
	const METAL_CLAW   ; e1
	const WATER_PULSE  ; e2
	const AQUA_JET     ; e3
	const STONE_EDGE   ; e4
	const LEAF_BLADE   ; e5
	const NIGHT_SLASH  ; e6
	const CROSS_CHOP   ; e7
	const ROCK_SMASH   ; e8
	const POISON_TAIL  ; e9
	const REFLECT_TYPE ; ea
	const POWER_GEM    ; eb
DEF FIRST_ACID_TYPE_MOVE EQU const_value
	const BANE_TOUCH   ; ec
	const ACID_STREAM  ; ed
	const CAUSTIC_BOMB ; ee
DEF LAST_ACID_TYPE_MOVE EQU const_value
ENDC
	const STRUGGLE     ; a5 vanilla / ef modern
DEF NUM_ATTACKS EQU const_value - 1

	; Moves do double duty as animation identifiers. - NEW, now they don't
	; Separate other battle animations
	const_def
	const NO_ANIM
	const SHOWPIC_ANIM
	const STATUS_AFFECTED_ANIM
	const ANIM_A8
	const ENEMY_HUD_SHAKE_ANIM
	const TRADE_BALL_DROP_ANIM
	const TRADE_BALL_SHAKE_ANIM
	const TRADE_BALL_TILT_ANIM
	const TRADE_BALL_POOF_ANIM
	const XSTATITEM_ANIM ; use X Attack/Defense/Speed/Special
	const XSTATITEM_DUPLICATE_ANIM
	const SHRINKING_SQUARE_ANIM
	const ANIM_B1
	const ANIM_B2
	const ANIM_B3
	const ANIM_B4
	const ANIM_B5
	const ANIM_B6
	const ANIM_B7
	const ANIM_B8
	const ANIM_B9
	const BURN_PSN_ANIM ; Plays when a monster is burned or poisoned
	const ANIM_BB
	const SLP_PLAYER_ANIM
	const SLP_ANIM ; sleeping monster
	const CONF_PLAYER_ANIM
	const CONF_ANIM ; confused monster
	const SLIDE_DOWN_ANIM
	const TOSS_ANIM ; toss Poké Ball
	const SHAKE_ANIM ; shaking Poké Ball when catching monster
	const POOF_ANIM ; puff of smoke
	const BLOCKBALL_ANIM ; trainer knocks away Poké Ball
	const GREATTOSS_ANIM ; toss Great Ball
	const ULTRATOSS_ANIM ; toss Ultra Ball or Master Ball
	const SHAKE_SCREEN_ANIM
	const HIDEPIC_ANIM ; monster disappears
	const ROCK_ANIM ; throw rock
	const BAIT_ANIM ; throw bait

DEF NUM_ALTERNATIVE_ANIMS EQU const_value - 1
;DEF NUM_ATTACK_ANIMS EQU const_value - 1
