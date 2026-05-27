PlayBattleMusic::
	xor a
	ld [wAudioFadeOutControl], a
	ld [wLowHealthAlarm], a
	dec a ; SFX_STOP_ALL_MUSIC
	ld [wNewSoundID], a
	call PlaySound
	call DelayFrame
	ld a, [wGymLeaderNo]
	and a
	jr z, .notGymLeaderBattle
.gymLeaderBattle
	ld a, MUSIC_GYM_LEADER_BATTLE
	jr .playSong
.notGymLeaderBattle
	ld a, [wCurOpponent]
	cp OPP_ID_OFFSET
	jr c, .wildBattle
	ld hl, GymLeaderMusicList
	ld de, 1
	call IsInArray
	jr c, .gymLeaderBattle
	ld a, [wCurOpponent]
	cp OPP_PROF_OAK
	jr z, .finalBattle
	cp OPP_RIVAL3
	jr nz, .next
	ld a, [wTrainerNo]
	cp 4
	jr z, .gymLeaderBattle
	jr .finalBattle
.next
	cp OPP_GIOVANNI
	jr nz, .next2
	ld a, [wTrainerNo]
	cp 4
	jr z, .gymLeaderBattle
	jr .normalTrainerBattle
.next2
	cp OPP_AGATHA
	jr nz, .normalTrainerBattle
	ld a, [wTrainerNo]
	cp 2
	jr z, .finalBattle
	; fallthrough
.normalTrainerBattle
	ld a, MUSIC_TRAINER_BATTLE
	jr .playSong
.finalBattle
	ld a, MUSIC_FINAL_BATTLE
	jr .playSong
.wildBattle
	ld a, MUSIC_WILD_BATTLE
.playSong
	ld c, BANK(Music_GymLeaderBattle)
	jp PlayMusic

GymLeaderMusicList:
	db OPP_BROCK
	db OPP_MISTY
	db OPP_LT_SURGE
	db OPP_ERIKA
	db OPP_KOGA
	db OPP_SABRINA
	db OPP_BLAINE
	db OPP_LANCE
	db $FF ; end
