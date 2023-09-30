extends Node2D

@export var map_scene: PackedScene
@export var combat_scene: PackedScene
@export var boss_scene: PackedScene
@export var library_scene: PackedScene
@export var oracle_scene: PackedScene
@export var upgrade_scene: PackedScene
@export var forge_scene: PackedScene

var map
var current_node

func _ready():
	map = map_scene.instantiate()
	map.connect("moved_to_location", _on_moved_to_location)

func _on_button_pressed():
	remove_child(current_node)
	add_child(map)

func _on_moved_to_location(location: Location):
	var node
	match location.location_type:
		Location.LOCATION.COMBAT:
			node = combat_scene.instantiate()
		Location.LOCATION.BOSS:
			node = boss_scene.instantiate()
		Location.LOCATION.LIBRARY:
			node = library_scene.instantiate()
		Location.LOCATION.ORACLE:
			node = oracle_scene.instantiate()
		Location.LOCATION.UPGRADE:
			node = upgrade_scene.instantiate()
		Location.LOCATION.FORGE:
			node = forge_scene.instantiate()
	add_child(node)
	current_node = node
	remove_child(map)
