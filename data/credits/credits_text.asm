CreditsTextPointers:
; entries correspond to CRED_* constants
	table_width 2, CreditsTextPointers
	dw CredVersion
	dw CredTajiri
	dw CredTaOota
	dw CredMorimoto
	dw CredWatanabe
	dw CredMasuda
	dw CredNisino
	dw CredSugimori
	dw CredNishida
	dw CredMiyamoto
	dw CredKawaguchi
	dw CredIshihara
	dw CredYamauchi
	dw CredZinnai
	dw CredHishida
	dw CredSakai
	dw CredYamaguchi
	dw CredYamamoto
	dw CredTaniguchi
	dw CredNonomura
	dw CredFuziwara
	dw CredMatsusima
	dw CredTomisawa
	dw CredKawamoto
	dw CredKakei
	dw CredTsuchiya
	dw CredTaNakamura
	dw CredYuda
	dw CredMon
	dw CredDirector
	dw CredProgrammers
	dw CredCharDesign
	dw CredMusic
	dw CredSoundEffects
	dw CredGameDesign
	dw CredMonsterDesign
	dw CredGameScene
	dw CredParam
	dw CredMap
	dw CredTest
	dw CredSpecial
	dw CredProducers
	dw CredProducer
	dw CredExecutive
	dw CredTamada
	dw CredSaOota
	dw CredYoshikawa
	dw CredToOota
	dw CredUSStaff
	dw CredUSCoord
	dw CredTilden
	dw CredKawakami
	dw CredHiNakamura
	dw CredGiese
	dw CredOsborne
	dw CredTrans
	dw CredOgasawara
	dw CredIwata
	dw CredIzushi
	dw CredHarada
	dw CredMurakawa
	dw CredFukui
	dw CredClub
	dw CredPAAD
	;;
	dw CredNova
	dw CredProgrammer
	dw CredZetaphoenix
	dw CredProgrammingHelp
	dw CredAriahiro
	dw CredBluezangoose
	dw CredDannye
	dw CredDevolov
	dw CredEngezerstorung
	dw CredJojobear
	dw CredLuna
	dw CredMateo
	dw CredMauve
	dw CredMord
	dw CredRMP
	dw CredRangi
	dw CredSTM
	dw CredSuloku
	dw CredVortiene
	dw CredXillicis
	dw CredLeadArt
	dw CredSuunz
	dw CredAdditionalArt
	dw CredAxelcomics
	dw CredDreammaker
	dw CredEssentures
	dw CredNinboy
	dw CredPat
	dw CredRainbowDevs
	dw CredUtytft
	dw CredWittycrow
	dw CredYoellistrator
	dw CredPartyMenuIcons
	dw CredBlueEmerald
	dw CredChamber
	dw CredLake
	dw CredNeslug
	dw CredPikachu25
	dw CredRyta
	dw CredSoloo
	dw CredGSCGraphics
	dw CredGSCGraphicsDesign
	dw CredYoshida
	dw CredOkutani
	dw CredIwashita
	dw CredMonsters1
	dw CredMonsters2
	dw CredMonsters3
	dw CredMonsters4
	dw CredPokeredContributors
	dw CredKanzure
	dw CredIimarckus
	dw CredYenatch
	dw CredManyMore
	dw CredBigYellow
	dw CredLyraWebsite
	dw CredPretDiscord
	dw CredRetroGame1
	dw CredRetroGame2
	dw CredSageDeoxys
	dw CredTesting
	dw CredChris05
	dw CredHyd
	dw CredOblivionWing
	dw CredPatoMareado
	dw CredPk87
	dw CredTheWiseBro
	;;
	assert_table_length NUM_CRED_STRINGS

CredVersion:
IF DEF(_RED)
	db -8, "RED VERSION STAFF@"
ENDC
IF DEF(_BLUE)
	db -8, "BLUE VERSION STAFF@"
ENDC
CredTajiri:
	db -6, "SATOSHI TAJIRI@"
CredTaOota:
	db -6, "TAKENORI OOTA@"
CredMorimoto:
	db -7, "SHIGEKI MORIMOTO@"
CredWatanabe:
	db -7, "TETSUYA WATANABE@"
CredMasuda:
	db -6, "JUNICHI MASUDA@"
CredNisino:
	db -5, "KOHJI NISINO@"
CredSugimori:
	db -5, "KEN SUGIMORI@"
CredNishida:
	db -6, "ATSUKO NISHIDA@"
CredMiyamoto:
	db -7, "SHIGERU MIYAMOTO@"
CredKawaguchi:
	db -8, "TAKASHI KAWAGUCHI@"
CredIshihara:
	db -8, "TSUNEKAZU ISHIHARA@"
CredYamauchi:
	db -7, "HIROSHI YAMAUCHI@"
CredZinnai:
	db -7, "HIROYUKI ZINNAI@"
CredHishida:
	db -7, "TATSUYA HISHIDA@"
CredSakai:
	db -6, "YASUHIRO SAKAI@"
CredYamaguchi:
	db -7, "WATARU YAMAGUCHI@"
CredYamamoto:
	db -8, "KAZUYUKI YAMAMOTO@"
CredTaniguchi:
	db -8, "RYOHSUKE TANIGUCHI@"
CredNonomura:
	db -8, "FUMIHIRO NONOMURA@"
CredFuziwara:
	db -7, "MOTOFUMI FUZIWARA@"
CredMatsusima:
	db -7, "KENJI MATSUSIMA@"
CredTomisawa:
	db -7, "AKIHITO TOMISAWA@"
CredKawamoto:
	db -7, "HIROSHI KAWAMOTO@"
CredKakei:
	db -6, "AKIYOSHI KAKEI@"
CredTsuchiya:
	db -7, "KAZUKI TSUCHIYA@"
CredTaNakamura:
	db -6, "TAKEO NAKAMURA@"
CredYuda:
	db -6, "MASAMITSU YUDA@"
CredMon:
	db -3, "#MON@"
CredDirector:
	db -3, "DIRECTOR@"
CredProgrammers:
	db -5, "PROGRAMMERS@"
CredCharDesign:
	db -7, "CHARACTER DESIGN@"
CredMusic:
	db -2, "MUSIC@"
CredSoundEffects:
	db -6, "SOUND EFFECTS@"
CredGameDesign:
	db -5, "GAME DESIGN@"
CredMonsterDesign:
	db -6, "MONSTER DESIGN@"
CredGameScene:
	db -6, "GAME SCENARIO@"
CredParam:
	db -8, "PARAMETRIC DESIGN@"
CredMap:
	db -4, "MAP DESIGN@"
CredTest:
	db -7, "PRODUCT TESTING@"
CredSpecial:
	db -6, "SPECIAL THANKS@"
CredProducers:
	db -4, "PRODUCERS@"
CredProducer:
	db -4, "PRODUCER@"
CredExecutive:
	db -8, "EXECUTIVE PRODUCER@"
CredTamada:
	db -6, "SOUSUKE TAMADA@"
CredSaOota:
	db -5, "SATOSHI OOTA@"
CredYoshikawa:
	db -6, "RENA YOSHIKAWA@"
CredToOota:
	db -6, "TOMOMICHI OOTA@"
CredUSStaff:
	db -7, "US VERSION STAFF@"
CredUSCoord:
	db -7, "US COORDINATION@"
CredTilden:
	db -5, "GAIL TILDEN@"
CredKawakami:
	db -6, "NAOKO KAWAKAMI@"
CredHiNakamura:
	db -6, "HIRO NAKAMURA@"
CredGiese:
	db -6, "WILLIAM GIESE@"
CredOsborne:
	db -5, "SARA OSBORNE@"
CredTrans:
	db -7, "TEXT TRANSLATION@"
CredOgasawara:
	db -6, "NOB OGASAWARA@"
CredIwata:
	db -5, "SATORU IWATA@"
CredIzushi:
	db -7, "TAKEHIRO IZUSHI@"
CredHarada:
	db -7, "TAKAHIRO HARADA@"
CredMurakawa:
	db -7, "TERUKI MURAKAWA@"
CredFukui:
	db -5, "KOHTA FUKUI@"
CredClub:
	db -9, "NCL SUPER MARIO CLUB@"
CredPAAD:
	db -5, "PAAD TESTING@"
;;
CredNova:
	db -7, "RBY NOVA CREDITS@"
CredProgrammer:
	db -4, "PROGRAMMER@"
CredZetaphoenix:
	db -5, "ZETAPHOENIX@"
CredProgrammingHelp:
	db -7, "PROGRAMMING HELP@"
CredAriahiro:
	db -4, "ARIAHIRO64@"
CredBluezangoose:
	db -5, "BLUEZANGOOSE@"
CredDannye:
	db -2, "DANNYE@"
CredDevolov:
	db -3, "DEVOLOV@"
CredEngezerstorung:
	db -6, "ENGEZERSTORUNG@"
CredJojobear:
	db -4, "JOJOBEAR13@"
CredLuna:
	db -7, "JUSTREGULARLUNA@"
CredMateo:
	db -2, "MATEO@"
CredMauve:
	db -2, "MAUVE@"
CredMord:
	db -1, "MORD@"
CredRMP:
	db -8, "RAINBOWMETALPIGEON@"
CredRangi:
	db -3, "RANGI42@"
CredSTM:
	db -6, "SHIRATHEMOGUL@"
CredSuloku:
	db -2, "SULOKU@"
CredVortiene:
	db -3, "VORTIENE@"
CredXillicis:
	db -3, "XILLICIS@"
CredLeadArt:
	db -3, "LEAD ART@"
CredSuunz:
	db -2, "SUUNZ@"
CredAdditionalArt:
	db -6, "ADDITIONAL ART@"
CredAxelcomics:
	db -5, "AXEL-COMICS@"
CredDreammaker:
	db -5, "DREAMMAKER23@"
CredEssentures:
	db -4, "ESSENTURES@"
CredNinboy:
	db -3, "NINBOY01@"
CredPat:
	db -6, "PATATTACKERMAN@"
CredRainbowDevs:
	db -5, "RAINBOWDEVS@"
CredUtytft:
	db -2, "UTYTFT@"
CredWittycrow:
	db -4, "WITTYCROW@"
CredYoellistrator:
	db -6, "YOELLISTRATOR@"
CredPartyMenuIcons:
	db -7, "PARTY MENU ICONS@"
CredBlueEmerald:
	db -5, "BLUE EMERALD@"
CredChamber:
	db -3, "CHAMBER@"
CredLake:
	db -1, "LAKE@"
CredNeslug:
	db -2, "NESLUG@"
CredPikachu25:
	db -4, "PIKACHU25@"
CredRyta:
	db -1, "RYTA@"
CredSoloo:
	db -3, "SOLOO993@"
CredGSCGraphics:
	db -5, "GSC GRAPHICS@"
CredGSCGraphicsDesign:
	db -9, "GSC GRAPHICS DESIGN@"
CredYoshida:
	db -7, "HIRONOBU YOSHIDA@"
CredOkutani:
	db -5, "JUN OKUTANI@"
CredIwashita:
	db -6, "ASUKA IWASHITA@"
CredMonsters1:
	db -9, "ALL MONSTER DESIGNS@"
CredMonsters2:
	db -9, "BELONG TO NINTENDO,@"
CredMonsters3:
	db -9, "GAME FREAK AND THEIR@"
CredMonsters4:
	db -9, "RESPECTIVE CREATORS.@"
CredPokeredContributors:
	db -9, "#RED CONTRIBUTORS@"
CredKanzure:
	db -3, "KANZURE@"
CredIimarckus:
	db -4, "IIMARCKUS@"
CredYenatch:
	db -3, "YENATCH@"
CredManyMore:
	db -6, "AND MANY MORE...@"
CredBigYellow:
	db -4, "BIG YELLOW@"
CredLyraWebsite:
	db -9, "LYRA MADE A WEBSITE@"
CredPretDiscord:
	db -9, "PRET DISCORD SERVER@"
CredRetroGame1:
	db -9, "RETRO GAME MECHANICS@"
CredRetroGame2:
	db -4, "EXPLAINED@"
CredSageDeoxys:
	db -4, "SAGEDEOXYS@"
CredTesting:
	db -3, "TESTING@"
CredChris05:
	db -3, "CHRIS05@"
CredHyd:
	db -1, "HYD@"
CredOblivionWing:
	db -6, "OBLIVION WING@"
CredPatoMareado:
	db -5, "PATOMAREADO@"
CredPk87:
	db -1, "PK87@"
CredTheWiseBro:
	db -7, "THE WISE BROTHA@"
;;
