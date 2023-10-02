extends Node2D

@export var menu_scene: PackedScene

func _on_pressed():
	get_tree().change_scene_to_packed(menu_scene)
