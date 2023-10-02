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
@onready var background_sound = $background
@onready var murmur_sound = $murmur

func _ready():
	stream = serenity
	background_sound.stream = background
	murmur_sound.stream = murmur
	#background_sound.play()
	#murmur_sound.play()
	#play()

func play_pop():
	sound_effects.stream = concrete_pop
	sound_effects.play()

func play_click():
	sound_effects.stream = concrete
	sound_effects.play()

func play_success():
	sound_effects.stream = trumpet_success
	sound_effects.play()
	
func play_fail():
	sound_effects.stream = trumpet_fail
	sound_effects.play()
