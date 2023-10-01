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
	show_brain(false);
	map = map_scene.instantiate()
	map.connect("moved_to_location", _on_moved_to_location)
	show_first_level()

func show_first_level():
	move_brain(get_viewport_rect().size / 2);
	$Brain.set_state(Global.BrainState.ADDING_NEW_WORDS);
	# game control should probably call these instead
	for i in 15:
		# TODO don't spawn words too long to start with
		# maybe force a certain set of starting words?
		$Brain.spawn_new_word(Global.get_word(), Vector2(200,40 * i - 300));
	show_brain();
	


func _on_button_pressed():
	_end_scene()

func _on_moved_to_location(location: Location):
	var node
	match location.location_type:
		Location.LOCATION.COMBAT:
			node = combat_scene.instantiate()
			node.init(location.debate_topic)
			node.connect("start_combat_phase", _start_combat_phase);
			node.connect("end_combat_phase", _end_combat_phase);
			node.connect("end_scene", _end_scene)
			show_brain(false);
		Location.LOCATION.BOSS:
			node = boss_scene.instantiate()
			show_brain(false);
		Location.LOCATION.LIBRARY:
			node = library_scene.instantiate()
			node.connect("start_library_phase", _start_library_phase);
			node.connect("end_library_phase", _end_library_phase);
			show_brain(false);
		Location.LOCATION.ORACLE:
			node = oracle_scene.instantiate()
			show_brain(false);
		Location.LOCATION.UPGRADE:
			node = upgrade_scene.instantiate()
			show_brain(false);
		Location.LOCATION.FORGE:
			node = forge_scene.instantiate()
			show_brain(false);
	$SceneHolder.add_child(node)
	current_node = node
	$SceneHolder.remove_child(map)

func move_brain(global_posn:Vector2):
	$Brain.global_position = global_posn;

#func scale_brain(s:float):
#	$Brain.scale = s;
func _end_scene():
	if current_node:
		$SceneHolder.remove_child(current_node)
		current_node.queue_free();
	show_brain(false);
	$SceneHolder.add_child(map)
	
func show_brain(show: bool = true):
	$Brain.visible = show;

func _start_combat_phase(global_posn:Vector2):
	# set the brain to the correct phase
	$Brain.set_state(Global.BrainState.COMBAT);
	$Brain.set_combat_node(current_node);
	# move the brain to correct position
	move_brain(global_posn);
	show_brain(true);

func _end_combat_phase():
	# just hide the brain
	show_brain(false);
	# TODO reset the words that were selected? need another phase?

func _start_library_phase(global_posn:Vector2):
	# set the brain to the correct phase
	$Brain.set_state(Global.BrainState.ADDING_NEW_WORDS);
	# move the brain to correct position
	move_brain(global_posn);
	
	#spawn a bunch of words
	var n = randi_range(5,10);
	for i in n:
		$Brain.spawn_new_word(Global.get_word(), Vector2(200,40 * i - 300));
	show_brain(true);

func _end_library_phase():
	# just hide the brain
	show_brain(false);

