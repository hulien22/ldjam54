extends Node2D

@export var game_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("brain hover");

func _on_pressed():
	get_tree().change_scene_to_packed(game_scene)
