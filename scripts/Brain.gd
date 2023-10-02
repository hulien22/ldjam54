extends Node2D


@export var gridTileScene: PackedScene
@export var wordTileScene: PackedScene
@export var size: Vector2
@export var starting_size: Vector2
@export var starting_offset: Vector2
@export var spread: float = 0
@export var tileScale: float=0.07
#@export var canBuyTiles: bool= false
@export var state_: Global.BrainState = Global.BrainState.VIEW_ONLY;
@export var target_brain_grid_ratio:float = 1.0
# the actual grid and whether or not the grid tiles are available
var grid = []

# the list of word tiles present, can be on or off the grid 
var word_tiles: Array = []

var combat_scene: Combat;
var upgrade_scene: Upgrade;
var update_button_scene: Node2D;

func _ready():
#	print("test")
	for h in size.y:
		var str= ""
		grid.append([])
		for l in size.x:
			var gridTile = gridTileScene.instantiate()
			$GridHolder.add_child(gridTile)
			gridTile.connect("select_tile_click", _on_tile_clicked)
			gridTile.posn = Vector2(l,h)
			gridTile.scale = Vector2(tileScale,tileScale)
			gridTile.position = Vector2(l*gridTile.get_width()+l*spread,h*gridTile.get_height()+h*spread)
			if (h >= starting_offset.y && h < starting_offset.y + starting_size.y && 
				l >= starting_offset.x && l < starting_offset.x + starting_size.x):
				gridTile.unlock();
			else:
				gridTile.lock();
			grid[h].append(gridTile)
#		print(str)
			#var char = word[x][y]
			#var tile = tileScene.instantiate()
			#tile.scale = Vector2(tileScale,tileScale)
			#tile.letter = char
			#tile.position = Vector2(i*tile.get_width()*tileScale+i*spread,0)
			#tiles.append(tile)
			#add_child(tile)
	
	render()

func render_grid():
	# only show grid elements that are bought
	# if we are expanding, then also show ones that are available.
	var is_expanding:bool = (state_ == Global.BrainState.EXPANDING);
	# keep track of active grid boundaries, use this to draw the brain.
	var min_row = size.y;
	var min_col = size.x;
	var max_row = 0;
	var max_col = 0;
	
#	var debug_string = "";
	for row in size.y:
		for col in size.x:
			grid[row][col].visible = false;
			# always show unlocked tiles
			if !grid[row][col].islocked:
				grid[row][col].visible = true;
			elif is_expanding:
				# check if neighbours are visible.
				if (!grid[clamp(row - 1, 0, size.y-1)][col].islocked || 
					!grid[clamp(row + 1, 0, size.y-1)][col].islocked || 
					!grid[row][clamp(col - 1, 0, size.x-1)].islocked || 
					!grid[row][clamp(col + 1, 0, size.x-1)].islocked):
					grid[row][col].visible = true;
			
			# if we made this tile visible, check if we need to update boundaries
			if grid[row][col].visible:
				min_row = min(min_row, row);
				min_col = min(min_col, col);
				max_row = max(max_row, row);
				max_col = max(max_col, col);
#				debug_string += "O ";
#			else:
#				debug_string += "X ";
#		debug_string +="\n";
	
#	print_debug(debug_string);
	# Center the grid such that the center nodes are closest to 0,0
	
	$GridHolder.position.x = -(max_col + min_col) * get_tile_width() / 2.0;
	$GridHolder.position.y = -(max_row + min_row) * get_tile_width() / 2.0;

	# TODO some calculation to resize the brain image to fit the grid
	# Use rect to get brain size approximation, fit the grid inside of that.
	# This value stays the same, even with node resizing.
	var bwidth = $BG/ColorRect.size.x
	var bheight = $BG/ColorRect.size.y
	
	var bonus = 2;
	if (is_expanding):
		bonus = 0;
	var grid_width = (max_col - min_col + bonus) * get_tile_width();
	var grid_height = (max_row - min_row + bonus) * get_tile_width();
	
#	print(grid_width, " ", grid_height, " ", bwidth, " ", bheight);
	# want the ratio of brain:grid to be 1.1:1
	$BG.scale.x = (target_brain_grid_ratio * grid_width) / bwidth;
	$BG.scale.y = (target_brain_grid_ratio * grid_height) / bheight;

func move_grid_word_tiles():
	for word_tile in word_tiles:
#		print(word_tile.word, " ", word_tile.grid_posn);
		if word_tile.on_grid():
			word_tile.global_position.x = $GridHolder.global_position.x + word_tile.grid_posn.x * get_tile_width();
			word_tile.global_position.y = $GridHolder.global_position.y + word_tile.grid_posn.y * get_tile_width();
#			print(word_tile.word, " ", word_tile.global_position);

func render():
	render_grid();
	move_grid_word_tiles();

func get_tile_width() -> float:
	#TODO also need scale in here??
	return grid[0][0].get_width() + spread;


func set_state(s: Global.BrainState):
	cleanup_abandoned_word_tiles()
	state_ = s;
	match s:
		Global.BrainState.ADDING_NEW_WORDS:
			# update all word tiles to be draggable
			for word_tile in word_tiles:
				word_tile.set_state(Global.TileState.DRAGGABLE);
		Global.BrainState.EXPANDING:
			for word_tile in word_tiles:
				word_tile.set_state(Global.TileState.VIEW_ONLY);
		Global.BrainState.COMBAT:
			for word_tile in word_tiles:
				word_tile.set_state(Global.TileState.CLICKABLE);
		Global.BrainState.VIEW_ONLY:
			for word_tile in word_tiles:
				word_tile.set_state(Global.TileState.VIEW_ONLY);
	render()

func set_combat_node(scene: Combat):
	combat_scene = scene;
	
func set_upgrade_node(scene: Upgrade):
	upgrade_scene = scene;

func set_update_button_scene(scene: Node2D):
	update_button_scene = scene;

func _on_tile_clicked(gridPosn:Vector2):
#	print(gridPosn)
	if state_ == Global.BrainState.EXPANDING:
		var clickedTile = grid[gridPosn.y][gridPosn.x]
		if clickedTile.isLocked():
			clickedTile.unlock()
			upgrade_scene.on_upgrade();
			render()
	else:
		push_warning("got tile clicked signal while in unexpected state: ", state_);

func spawn_new_word(word: String, global_posn: Vector2, st:Global.TileState = Global.TileState.DRAGGABLE):
#	assert(state_ == Global.BrainState.ADDING_NEW_WORDS);
	var word_tile = wordTileScene.instantiate();
	word_tile.word = word;
	word_tile.connect("was_dropped", _handle_dropped_word_tile);
	word_tile.connect("was_clicked", _handle_clicked_word_tile);
	word_tile.connect("was_picked_up", _handle_picked_up_word_tile);
	word_tile.global_position = global_posn;
	word_tile.tileScale = tileScale
	word_tile.spread = spread;
	word_tiles.append(word_tile);
	word_tile.set_state(st);
	$WordsHolder.add_child(word_tile);


func check_for_valid_placement(word_tile:WordTile) -> Array:
	var has_a_grid_spot: bool = false;
	var has_a_non_grid_spot: bool = false;
	# Get grid position
	var grid_posn = (word_tile.global_position + Vector2(get_tile_width() / 2, get_tile_width() / 2) - $GridHolder.global_position) / get_tile_width();
	grid_posn.x = int(grid_posn.x);
	grid_posn.y = int(grid_posn.y);
	
	# analyze all the grid spots we intersect with, even the ones outside the grid.
	var dir:Vector2;
	if (word_tile.direction == WordTile.Direction.RIGHT):
		dir = Vector2(1, 0);
	else:
		dir = Vector2(0,1);
	
	for i in word_tile.word.length():
		var p = grid_posn + i * dir;
		if (p.x >= 0 && p.x < size.x && p.y >= 0 && p.y < size.y):
			# an actual grid element
			if (grid[p.y][p.x].isLocked()):
				has_a_non_grid_spot = true;
			elif (does_other_word_tile_collide(word_tile, p)):
				# We have a collision with another word in the grid, this is always invalid!
				return [true, true];
			else:
				has_a_grid_spot = true;
		else:
			# invalid spot
			has_a_non_grid_spot = true;
		
		#shortcircuit early
		if has_a_grid_spot && has_a_non_grid_spot:
			return [true, true];
	
	# made it to the end with only valid or invalid tiles, therefore this is a valid spot.
	return [has_a_grid_spot, has_a_non_grid_spot];

func does_other_word_tile_collide(word_tile: WordTile, grid_posn: Vector2) -> bool:
	for w in word_tiles:
		if w.on_grid() && w != word_tile:
			# check if we collide with this word
			if (w.direction == WordTile.Direction.RIGHT && grid_posn.y == w.grid_posn.y && grid_posn.x >= w.grid_posn.x && grid_posn.x < w.grid_posn.x + w.word.length()):
				return true;
			elif (w.direction == WordTile.Direction.DOWN && grid_posn.x == w.grid_posn.x && grid_posn.y >= w.grid_posn.y && grid_posn.y < w.grid_posn.y + w.word.length()):
				return true
	return false


func _handle_clicked_word_tile(word_tile: WordTile, selected:bool):
#	print("CLICKED ", word_tile.word, " ", word_tile);
	combat_scene.add_word_tile(word_tile, selected);
	

func _handle_dropped_word_tile(word_tile: WordTile):
#	print("DROPPED ", word_tile.word, " ", word_tile);
	var res:Array = check_for_valid_placement(word_tile);
	
#	print(res);
	if (res[0] && res[1]):
		# invalid spot to be dropped, return word tile back to previous location
		word_tile.return_to_prev_loc();
	elif (res[0]):
		# valid spot on the grid!
		var grid_posn = (word_tile.global_position + Vector2(get_tile_width() / 2, get_tile_width() / 2) - $GridHolder.global_position) / get_tile_width();
		grid_posn.x = int(grid_posn.x);
		grid_posn.y = int(grid_posn.y);
		word_tile.grid_posn = grid_posn;
		render();
	else:
		word_tile.grid_posn = WordTile.NOT_ON_GRID;
	
	send_button_update_to_scene()

func send_button_update_to_scene():
	if update_button_scene != null:
		var count = 0;
		for w in word_tiles:
			if w.on_grid():
				count += 1;
		update_button_scene.update_button(count);

func _handle_picked_up_word_tile(word_tile: WordTile):
	word_tile.move_to_front()

func cleanup_abandoned_word_tiles():
	#loop backwards to deal with deletion issues
	for i in range(word_tiles.size() - 1, -1, -1):
		if (!word_tiles[i].on_grid()):
#			print_debug("Deleting word tile ", word_tiles[i].word);
			word_tiles[i].queue_free();
			word_tiles.remove_at(i);

