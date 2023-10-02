extends AudioStreamPlayer

@export var combat_music: AudioStream
@export var boss_music: AudioStream
@export var serenity: AudioStream
@export var dulcimer: AudioStream

@export var murmur: AudioStream
@export var background: AudioStream

@export var concrete: AudioStream
@export var concrete_pop: AudioStream
@export var dirt_rock: AudioStream
@export var rock_thing: AudioStream
@export var trumpet_fail: AudioStream
@export var trumpet_success: AudioStream

@onready var sound_effects = $SoundEffects
@onready var trumpet_sound_effects = $TrumpetSoundEffects
@onready var background_sound = $background
@onready var murmur_sound = $murmur

var music_state

func _ready():
	stream = serenity
	background_sound.stream = background
	murmur_sound.stream = murmur
	background_sound.play()
	murmur_sound.play()
	#play()
	music_state = 0

func change_music(combat: bool, boss: bool):
	if (music_state == 1 and !combat and !boss) or (music_state == 2 and combat and !boss) or (music_state == 3 and combat and boss):
		return
	if combat:
		if boss:
			stream = boss_music
			music_state = 3
		else:
			stream = combat_music
			music_state = 2
	else:
		stream = serenity
		music_state = 1
	play()

func play_pop():
	sound_effects.stream = concrete_pop
	sound_effects.play()

func play_click():
	sound_effects.stream = concrete
	sound_effects.play()

func play_success():
	trumpet_sound_effects.stream = trumpet_success
	trumpet_sound_effects.play()
	
func play_fail():
	trumpet_sound_effects.stream = trumpet_fail
	trumpet_sound_effects.play()
