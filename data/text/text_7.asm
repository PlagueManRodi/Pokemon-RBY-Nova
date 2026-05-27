_ItemUseText001::
	text "<PLAYER> used@"
	text_end

_ItemUseText002::
	text_ram wStringBuffer
	text "!"
	done

_GotOnBicycleText1::
	text "<PLAYER> got on the@"
	text_end

_GotOnBicycleText2::
	text_ram wStringBuffer
	text "!"
	prompt

_GotOffBicycleText1::
	text "<PLAYER> got off@"
	text_end

_GotOffBicycleText2::
	text "the @"
	text_ram wStringBuffer
	text "."
	prompt

_PokedexOrAttackdex:: ; new, testing
	text "What DEX category"
	line "to visualize?"
	done

_ThrewAwayItemText::
	text "Threw away"
	line "@"
	text_ram wcd6d
	text "."
	prompt

_IsItOKToTossItemText::
	text "Is it OK to toss"
	line "@"
	text_ram wStringBuffer
	text "?"
	prompt

_TooImportantToTossText::
	text "That's too impor-"
	line "tant to toss!"
	prompt

_AlreadyKnowsText::
	text_ram wcd6d
	text " knows"
	line "@"
	text_ram wStringBuffer
	text "!"
	prompt

_ConnectCableText::
	text "Okay, connect the"
	line "cable like so!"
	prompt

_TradedForText::
	text "<PLAYER> traded"
	line "@"
	text_ram wInGameTradeGiveMonName
	text " for"
	cont "@"
	text_ram wInGameTradeReceiveMonName
	text "!@"
	text_end

_WannaTrade1Text::
	text "I'm looking for"
	line "@"
	text_ram wInGameTradeGiveMonName
	text "! Wanna"

	para "trade one for"
	line "@"
	text_ram wInGameTradeReceiveMonName
	text "? "
	done

_NoTrade1Text::
	text "Awww!"
	line "Oh well..."
	done

_WrongMon1Text::
	text "What? That's not"
	line "@"
	text_ram wInGameTradeGiveMonName
	text "!"

	para "If you get one,"
	line "come back here!"
	done

_Thanks1Text::
	text "Hey thanks!"
	done

_AfterTrade1Text::
	text "Isn't my old"
	line "@"
	text_ram wInGameTradeReceiveMonName
	text " great?"
	done

_WannaTrade2Text::
	text "Hello there! Do"
	line "you want to trade"

	para "your @"
	text_ram wInGameTradeGiveMonName
	text_start
	line "for @"
	text_ram wInGameTradeReceiveMonName
	text "?"
	done

_NoTrade2Text::
	text "Well, if you"
	line "don't want to..."
	done

_WrongMon2Text::
	text "Hmmm? This isn't"
	line "@"
	text_ram wInGameTradeGiveMonName
	text "."

	para "Think of me when"
	line "you get one."
	done

_Thanks2Text::
	text "Thanks!"
	done

_AfterTrade2Text::
	text "Hello there! Your"
	line "old @"
	text_ram wInGameTradeGiveMonName
	text " is"
	cont "magnificent!"
	done

_WannaTrade3Text::
	text "Hi! Do you have"
	line "@"
	text_ram wInGameTradeGiveMonName
	text "?"

	para "Want to trade it"
	line "for @"
	text_ram wInGameTradeReceiveMonName
	text "?"
	done

_NoTrade3Text::
	text "That's too bad."
	done

_WrongMon3Text::
	text "...This is no"
	line "@"
	text_ram wInGameTradeGiveMonName
	text "."

	para "If you get one,"
	line "trade it with me!"
	done

_Thanks3Text::
	text "Thanks pal!"
	done

_AfterTrade3Text::
	text "How is my old"
	line "@"
	text_ram wInGameTradeReceiveMonName
	text "?"

	para "My @"
	text_ram wInGameTradeGiveMonName
	text " is"
	line "doing great!"
	done

_NothingToCutText::
	text "There isn't"
	line "anything to CUT!"
	prompt

_UsedCutText::
	text_ram wcd6d
	text " hacked"
	line "away with CUT!"
	prompt

_UsedHackText::
	text "<PLAYER> hacked"
	line "away!"
	prompt

_OptionalFeaturesIntroText::
	text "Welcome!"
	
	para "Thank you for"
	line "playing #MON"
	cont "RBY NOVA."
	
	para "Please read these"
	line "optional features"
	cont "carefully so you"
	cont "get the most out"
	cont "of the game."
	prompt

;_LevelCapsExpQuestionText::
;	text "Do you know what"
;	line "LEVEL CAPs are?"
;	done

;_LevelCapsExpText::
;	text "LEVEL CAPs will"
;	line "prevent you from"
;	cont "out-leveling GYM"
;	cont "LEADERs and other"
;	cont "important fights."
;	prompt

_LevelCapsText::
	text "LEVEL CAPs don't"
	line "let you out-level"
	cont "LEADERs and other"
	cont "boss fights."
	
	para "You'll still reach"
	line "max post credits."
		
	para "Play with LEVEL"
	line "CAPs?"
	done

;_StatExpExpQuestionText::
;	text "Do you know what"
;	line "STAT EXPERIENCE"
;	cont "is?"
;	done

;_StatExpExpText::
;	text "STAT EXPERIENCE"
;	line "is the equivalent"
;	cont "to EVs from later"
;	cont "generations in"
;	cont "this game."
;	prompt

_StatExpText::
	text "STAT EXPERIENCE is"
	line "equivalent to EVs"
	cont "on later GENs."
		
	para "Regardless of your"
	line "choice STAT EXP"
	cont "will be counted"
	cont "and can be added"
	cont "post credits."
	
	para "Play with STAT"
	line "EXPERIENCE?"
	done

;_ConvItemsExpQuestionText::
;	text "Do you know what"
;	line "the CONVINIENCE"
;	cont "ITEMS are?"
;	done

;_ConvItemsExpText::
;	text "These are a set"
;	line "of quality of"
;	cont "life items that"
;	cont "are good for"
;	cont "nuzlockes and"
;	cont "other types of"
;	cont "challenge runs."
	
;	para "These include:"
	
;	para "RECOVERY KIT"
	
;	para "Fully heals the"
;	line "party."
	
;	para "REPEL KIT"
	
;	para "Infinite MAX"
;	line "REPEL."
	
;	para "TRAINING KIT"
	
;	para "Infinite RARE"
;	line "CANDY."
;	prompt

_ConvItemsText::
	text "CONVENIENCE ITEMS"
	line "adds party heal,"
	cont "toggleable REPEL"
	cont "and infinite RARE"
	cont "CANDY items to"
	cont "your PC and"
	cont "SELECT MENU."
	
	para "If not you'll still"
	line "get them post"
	cont "credits."
	
	para "Get CONVENIENCE"
	line "ITEMS?"
	done

_PartyCapsText::
	text "PARTY CAPs don't"
	line "let you fight GYM"
	cont "LEADERs with more"
	cont "#MON in your"
	cont "party than them." 
	
	para "Play with PARTY"
	line "CAPs?"
	done

_EnjoyGameText::
	text "Hope you enjoy"
	line "the game!"
	prompt

_SleepClauseText::
	text "Cannot put foe to"
	line "sleep due to"
	cont "SLEEP CLAUSE!"
	prompt

_FreezeClauseText::
	text "Cannot freeze foe"
	line "due to FREEZE"
	cont "CLAUSE!"
	prompt

_GiveUpText::
	text "Give up?"
	done

_PartyCap3ExceedText::
	text "Come back with"
	line "less #MON. (3)"
	done

_PartyCap4ExceedText::
	text "Come back with"
	line "less #MON. (4)"
	done
	
_PartyCap5ExceedText::
	text "Come back with"
	line "less #MON. (5)"
	done

_CannotUseActionHereText::
	text "You can't perform"
	line "that action here."
	prompt

_BoulderOnSwitchText::
	text "The boulder is on"
	line "a switch!"
	done

_UseAnotherRepelText::
	text "Use another"
	line "@"
	text_ram wcd6d
	text "?"
	done

_ProLeagueAvailableText::
	text "PRO LEAGUE can be"
	line "challenged now!@"
	text_end
