extends Node2D

@export var game_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	AudioPlayer.change_music(false, false)
	$AnimationPlayer.play("brain hover");

func _on_pressed():
	Global.reset_used_prompts()
	get_tree().change_scene_to_packed(game_scene)
