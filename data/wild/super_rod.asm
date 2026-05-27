; super rod encounters
SuperRodData:
	; map, fishing group
	dbw PALLET_TOWN,         .Group1
	dbw VIRIDIAN_CITY,       .Group1
	dbw CERULEAN_CITY,       .Group7
	dbw VERMILION_CITY,      .Group4
	dbw CELADON_CITY,        .Group4
	dbw FUCHSIA_CITY,        .Group2
	dbw CINNABAR_ISLAND,     .Group8
	dbw ROUTE_4,             .Group7
	dbw ROUTE_6,             .Group4
	dbw ROUTE_10,            .Group3
	dbw ROUTE_11,            .Group4
	dbw ROUTE_12,            .Group2
	dbw ROUTE_13,            .Group2
	dbw ROUTE_17,            .Group2
	dbw ROUTE_18,            .Group2
	dbw ROUTE_19,            .Group5
	dbw ROUTE_20,            .Group8
	dbw ROUTE_21,            .Group8
	dbw ROUTE_22,            .Group2
	dbw ROUTE_23,            .Group2
	dbw ROUTE_24,            .Group3
	dbw ROUTE_25,            .Group3
	dbw CERULEAN_GYM,        .Group3
	dbw VERMILION_DOCK,      .Group4
	dbw SEAFOAM_ISLANDS_B3F, .Group9
	dbw SEAFOAM_ISLANDS_B4F, .Group9
	dbw SAFARI_ZONE_EAST,    .Group6
	dbw SAFARI_ZONE_NORTH,   .Group6
	dbw SAFARI_ZONE_WEST,    .Group6
	dbw SAFARI_ZONE_CENTER,  .Group6
	dbw CERULEAN_CAVE_2F,    .Group10
	dbw CERULEAN_CAVE_B1F,   .Group10
	dbw CERULEAN_CAVE_1F,    .Group10
	db -1 ; end

; fishing groups
; number of monsters, followed by level/monster pairs

.Group1:
	db 4
	db 35, GYARADOS
	db 35, SEAKING
	db 35, SEADRA
	db 35, STARYU

.Group2:
	db 4
	db 35, GYARADOS
	db 35, SEAKING
	db 35, SEADRA
	db 35, KINGLER

.Group3:
	db 4
	db 35, GYARADOS
	db 35, SEAKING
	db 35, SEADRA
	db 35, GOLDUCK

.Group4:
	db 4
	db 35, GYARADOS
	db 35, SEAKING
	db 35, SEADRA
	db 35, POLIWHIRL

.Group5:
	db 4
	db 35, GYARADOS
	db 35, SEAKING
	db 35, SEADRA
	db 35, TENTACRUEL

.Group6:
	db 4
	db 35, KINGLER
	db 35, GOLDUCK
	db 35, POLIWHIRL
	db 35, STARYU

.Group7:
	db 4
	db 43, GYARADOS
	db 43, SEAKING
	db 43, SEADRA
	db 43, GOLDUCK

.Group8:
	db 4
	db 43, GYARADOS
	db 43, SEAKING
	db 43, SEADRA
	db 43, TENTACRUEL

.Group9:
	db 4
	db 43, DEWGONG
	db 43, SHELLDER
	db 43, SEADRA
	db 43, STARYU

.Group10:
	db 4
	db 60, OMANYTE
	db 60, KABUTO
	db 60, STARMIE
	db 60, CLOYSTER
