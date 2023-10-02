extends Node2D

@export var map_scene: PackedScene
@export var combat_scene: PackedScene
@export var boss_scene: PackedScene
@export var library_scene: PackedScene
@export var oracle_scene: PackedScene
@export var upgrade_scene: PackedScene
@export var forge_scene: PackedScene
@export var plain_scene: PackedScene
@export var brain_preview_scene: PackedScene
@export var game_over_scene: PackedScene

enum GameSceneState {
	PREVIEW_MAP,
	PREVIEW_BRAIN,
	ON_MAP,
	IN_LEVEL,
};

var scene_state_: GameSceneState = GameSceneState.IN_LEVEL;

var map
var stage
var brain_preview
var current_node
var on_boss
var health:int = 5;

func _ready():
	on_boss = false
	stage = 0
	show_brain(false);
	map = map_scene.instantiate()
	map.stage = 0
	map.connect("moved_to_location", _on_moved_to_location)
	brain_preview = brain_preview_scene.instantiate()
	$UI/MapBtn/Button.pressed.connect(self.show_map_preview);
	$UI/BrainBtn/Button.pressed.connect(self.show_brain_preview);
	update_health(0);
	show_first_level()

#TODO convert to an actual scene
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
			show_brain(false);
			node = combat_scene.instantiate()
			node.init(location.debate_topic, stage)
			node.connect("start_combat_phase", _start_combat_phase);
			node.connect("end_combat_phase", _end_combat_phase);
			node.connect("end_scene", _process_combat_rewards);
		Location.LOCATION.BOSS:
			show_brain(false);
			node = boss_scene.instantiate()
			on_boss = true
		Location.LOCATION.LIBRARY:
			show_brain(false);
			node = library_scene.instantiate()
			node.connect("start_library_phase", _start_library_phase);
			node.connect("end_library_phase", _end_library_phase);
		Location.LOCATION.ORACLE:
			show_brain(false);
			node = oracle_scene.instantiate()
		Location.LOCATION.UPGRADE:
			show_brain(false);
			node = upgrade_scene.instantiate()
			node.num_upgrades_available = 3;
			node.connect("start_upgrade_phase", _start_upgrade_phase);
			node.connect("end_upgrade_phase", _end_upgrade_phase);
			$Brain.set_upgrade_node(node); 
		Location.LOCATION.FORGE:
			show_brain(false);
			node = forge_scene.instantiate()
			node.connect("start_forge_phase", _start_forge_phase);
			node.connect("end_forge_phase", _end_forge_phase);

	switch_to_game_scene_state(GameSceneState.IN_LEVEL);
	$SceneHolder.add_child(node)
	current_node = node
	$SceneHolder.remove_child(map)

func move_brain(global_posn:Vector2):
	$Brain.global_position = global_posn;

#func scale_brain(s:float):
#	$Brain.scale = s;
func _end_scene():
	if current_node != null:
		if on_boss:
			next_stage()
		$SceneHolder.remove_child(current_node)
		current_node.queue_free();
	show_brain(false);
	switch_to_game_scene_state(GameSceneState.ON_MAP);
	$SceneHolder.add_child(map)

func next_stage():
	on_boss = false
	stage += 1
	if map:
		$SceneHolder.remove_child(map)
		map.queue_free()
	map = map_scene.instantiate()
	map.stage = stage
	map.connect("moved_to_location", _on_moved_to_location)
	map.get_node("AnimatedSprite2D").frame = stage
	#$SceneHolder.add_child(map)
	
func show_brain(show: bool = true):
	$Brain.visible = show;
	if show:
		$UI/BrainBtn/Button.disabled = true;
		$UI/BrainBtn.hide();
	else:
		$UI/BrainBtn/Button.disabled = false;
		$UI/BrainBtn.show();

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

func _process_combat_rewards(score: float):
	var node
	# bad copy paste stuff here :/
	if score < 5.0:
		node = library_scene.instantiate();
		node.connect("start_library_phase", _start_library_phase);
		node.connect("end_library_phase", _end_library_phase);
		# change stuff in the node, description, category
	else:
		node = upgrade_scene.instantiate()
		node.num_upgrades_available = 2;
		node.connect("start_upgrade_phase", _start_upgrade_phase);
		node.connect("end_upgrade_phase", _end_upgrade_phase);
		$Brain.set_upgrade_node(node);

	switch_to_game_scene_state(GameSceneState.IN_LEVEL);
	$SceneHolder.remove_child(current_node)
	current_node.queue_free();
	$SceneHolder.add_child(node)
	current_node = node


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


var map_preview_was_brain_visible:bool = false;
func show_map_preview():
	# hide and show brain? need to recall where brain was?
	match scene_state_:
		GameSceneState.IN_LEVEL:
			$SceneHolder.remove_child(current_node);
			$MapPreviewHolder.add_child(map);
			map.set_enabled(false);
			map_preview_was_brain_visible = $Brain.visible;
			$Brain.hide();
			switch_to_game_scene_state(GameSceneState.PREVIEW_MAP);
		GameSceneState.PREVIEW_MAP:
			$MapPreviewHolder.remove_child(map);
			$SceneHolder.add_child(current_node);
			map.set_enabled(true);
			$Brain.visible = map_preview_was_brain_visible;
			$UI/BrainBtn/Button.disabled = map_preview_was_brain_visible;
			$UI/BrainBtn.visible = !map_preview_was_brain_visible;
			switch_to_game_scene_state(GameSceneState.IN_LEVEL);

var brain_preview_previous_state:GameSceneState;
func show_brain_preview():
	match scene_state_:
		GameSceneState.IN_LEVEL, GameSceneState.ON_MAP:
			$BrainPreviewHolder.add_child(brain_preview);
			$Brain.set_state(Global.BrainState.VIEW_ONLY);
			$Brain.global_position = get_viewport_rect().size / 2;
			$Brain.show();
			$UI/MapBtn/Button.disabled = true;
			$UI/MapBtn.hide();
			brain_preview_previous_state = scene_state_;
			scene_state_ = GameSceneState.PREVIEW_BRAIN;
		GameSceneState.PREVIEW_BRAIN:
			$BrainPreviewHolder.remove_child(brain_preview);
			$Brain.hide();
			switch_to_game_scene_state(brain_preview_previous_state);

func switch_to_game_scene_state(s: GameSceneState):
	scene_state_ = s;
	match s:
		GameSceneState.IN_LEVEL:
			$UI/MapBtn/Button.disabled = false;
			$UI/MapBtn.show();
		GameSceneState.ON_MAP:
			$UI/MapBtn/Button.disabled = true;
			$UI/MapBtn.hide();
		GameSceneState.PREVIEW_BRAIN:
			$UI/MapBtn/Button.disabled = true;
			$UI/MapBtn.hide();
		GameSceneState.PREVIEW_MAP:
			$UI/BrainBtn/Button.disabled = true;
			$UI/BrainBtn.hide();

func update_health(add: int):
	health = clamp(health+add, 0, 5);
	#update the health ui
	$UI/Ego/Label.text = str(health);
	if health == 0:
		#GAME OVER
		var node = game_over_scene.instantiate();
		$SceneHolder.remove_child(current_node);
		current_node.queue_free();
		$SceneHolder.remove_child(map);
		$SceneHolder.add_child(node);
		current_node = node;
		$UI/BrainBtn/Button.disabled = false;
		$UI/BrainBtn.show();
		$UI/MapBtn/Button.disabled = false;
		$UI/MapBtn.show();
	
