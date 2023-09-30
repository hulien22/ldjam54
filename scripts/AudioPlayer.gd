extends AudioStreamPlayer

@export var combat_music: AudioStream
@export var boss_music: AudioStream

func _ready():
	stream = boss_music
	play()
