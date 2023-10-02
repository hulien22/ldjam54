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
	$UI/MapBtn/Button.pressed.connect(self.show_map_preview);
	$UI/BrainBtn/Button.pressed.connect(self.show_brain_preview);
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
			node.num_upgrades_available = 3;
			node.connect("start_upgrade_phase", _start_upgrade_phase);
			node.connect("end_upgrade_phase", _end_upgrade_phase);
			$Brain.set_upgrade_node(node); 
			show_brain(false);
		Location.LOCATION.FORGE:
			node = forge_scene.instantiate()
			node.connect("start_forge_phase", _start_forge_phase);
			node.connect("end_forge_phase", _end_forge_phase);
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
	if show:
		$UI/BrainBtn/Button.disabled = true;
		$UI/BrainBtn.modulate = Color.DIM_GRAY;
	else:
		$UI/BrainBtn/Button.disabled = false;
		$UI/BrainBtn.modulate = Color.WHITE;

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

func _start_upgrade_phase(global_posn:Vector2):
	# set the brain to the correct phase
	$Brain.set_state(Global.BrainState.EXPANDING);
	# move the brain to correct position
	move_brain(global_posn);
	show_brain(true);

func _end_upgrade_phase():
	# stop allowing expansion
	$Brain.set_state(Global.BrainState.ADDING_NEW_WORDS);
#	$Brain.set_state(Global.BrainState.VIEW_ONLY);

func _start_forge_phase():
#	# set the brain to the correct phase
#	$Brain.set_state(Global.BrainState.ADDING_NEW_WORDS);
#	# move the brain to correct position
#	move_brain(global_posn); 
#
#	#spawn a bunch of words
#	var n = randi_range(5,10);
#	for i in n:
#		$Brain.spawn_new_word(Global.get_word(), Vector2(200,40 * i - 300));
#	show_brain(true);
	pass

func _end_forge_phase(global_posn:Vector2, w: String):
	move_brain(global_posn);
	$Brain.set_state(Global.BrainState.ADDING_NEW_WORDS);
	$Brain.spawn_new_word(w, Vector2(200,40));
	show_brain(true);

func show_map_preview():
	pass

func show_brain_preview():
	pass
