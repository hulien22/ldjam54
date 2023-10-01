extends Node2D


@export var gridTileScene: PackedScene
@export var wordTileScene: PackedScene
@export var size: Vector2
@export var starting_size: Vector2
@export var starting_offset: Vector2
@export var spread: float = 0
@export var tileScale: float=0.07
@export var canBuyTiles: bool= false
@export var state_: Global.BrainState = Global.BrainState.VIEW_ONLY;
@export var target_brain_grid_ratio:float = 1.0
# the actual grid and whether or not the grid tiles are available
var grid = []

# the list of word tiles present, can be on or off the grid 
var word_tiles: Array = []


func _ready():
	print("test")
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
		print(str)
			#var char = word[x][y]
			#var tile = tileScene.instantiate()
			#tile.scale = Vector2(tileScale,tileScale)
			#tile.letter = char
			#tile.position = Vector2(i*tile.get_width()*tileScale+i*spread,0)
			#tiles.append(tile)
			#add_child(tile)
	spawn_new_word("I", Vector2(100,10));
	spawn_new_word("BECAUSE", Vector2(100,20));
	spawn_new_word("LIKE", Vector2(100,30));
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
	
	var debug_string = "";
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
				debug_string += "O ";
			else:
				debug_string += "X ";
		debug_string +="\n";
	
	print_debug(debug_string);
	# Center the grid such that the center nodes are closest to 0,0
	var grid_width = (max_col - min_col) * get_tile_width();
	var grid_height = (max_row - min_row) * get_tile_width();
	
	$GridHolder.position.x = -(max_col + min_col) * get_tile_width() / 2.0;
	$GridHolder.position.y = -(max_row + min_row) * get_tile_width() / 2.0;

	# TODO some calculation to resize the brain image to fit the grid
	# Use rect to get brain size approximation, fit the grid inside of that.
	# This value stays the same, even with node resizing.
	var bwidth = $BG/ColorRect.size.x
	var bheight = $BG/ColorRect.size.y
	
	print(grid_width, " ", grid_height, " ", bwidth, " ", bheight);
	# want the ratio of brain:grid to be 1.1:1
	$BG.scale.x = (target_brain_grid_ratio * grid_width) / bwidth;
	$BG.scale.y = (target_brain_grid_ratio * grid_height) / bheight;

func move_grid_word_tiles():
	for word_tile in word_tiles:
		print(word_tile.word, " ", word_tile.grid_posn);
		if word_tile.on_grid():
			word_tile.global_position.x = $GridHolder.global_position.x + word_tile.grid_posn.x * get_tile_width();
			word_tile.global_position.y = $GridHolder.global_position.y + word_tile.grid_posn.y * get_tile_width();
			print(word_tile.word, " ", word_tile.global_position);

func render():
	render_grid();
	move_grid_word_tiles();

func get_tile_width() -> float:
	#TODO also need scale in here??
	return grid[0][0].get_width() + spread;


func set_state(s: Global.BrainState):
	state_ = s;
	match s:
		Global.BrainState.ADDING_NEW_WORDS:
			# update all words accordingly
			pass
		Global.BrainState.EXPANDING:
			pass
		Global.BrainState.COMBAT:
			pass
		Global.BrainState.VIEW_ONLY:
			pass


#func _process(delta):
#	var cursorPos = get_global_mouse_position()
#	mouse_to_grid(cursorPos)
#
#
#func mouse_to_grid(pos):
#	pass
	
func _on_tile_clicked(gridPosn:Vector2):
	assert(state_ == Global.BrainState.EXPANDING);
	print(gridPosn)
	if canBuyTiles:
		var clickedTile = grid[gridPosn.y][gridPosn.x]
		if clickedTile.isLocked():
			clickedTile.unlock()
			render()
#		else:
#			clickedTile.lock()


func does_tile_have_valid_or_invalid(word_tile:WordTile) -> Array:
	var has_at_least_one_valid_tile: bool = false;
	var has_at_least_one_invalid_tile: bool = false;
	# Get grid position
	var grid_posn = (word_tile.global_position + Vector2(get_tile_width() / 2, get_tile_width() / 2) - $GridHolder.global_position) / get_tile_width();
	grid_posn.x = int(grid_posn.x);
	grid_posn.y = int(grid_posn.y);
	
	# analyze all the grid spots we intersect with, even the ones outside the grid.
	var dir:Vector2;
	if (word_tile.direction == WordTile.Direction.RIGHT):
		dir = Vector2(1, 0)
	else:
		dir = Vector2(0,1)
	
	for i in word_tile.word.length():
		var p = grid_posn + i * dir;
		if (p.x >= 0 && p.x < size.x && p.y >= 0 && p.y < size.y):
			# an actual grid element
			if (grid[p.y][p.x].isLocked()):
				has_at_least_one_invalid_tile = true;
			else:
				# TODO Check for collision with other word tiles here.
				has_at_least_one_valid_tile = true;
		else:
			# invalid spot
			has_at_least_one_invalid_tile = true;
		print(p, " | ",  [has_at_least_one_valid_tile, has_at_least_one_invalid_tile])
		
		#shortcircuit early
		if has_at_least_one_valid_tile && has_at_least_one_invalid_tile:
			return [true, true];
	
	# made it to the end with only valid or invalid tiles, therefore this is a valid spot.
	return [has_at_least_one_valid_tile, has_at_least_one_invalid_tile];

func spawn_new_word(word: String, global_posn: Vector2):
	var word_tile = wordTileScene.instantiate();
	word_tile.word = word;
	word_tile.connect("was_dropped", _handle_dropped_word_tile);
	word_tile.global_position = global_posn;
	word_tile.tileScale = tileScale
	word_tile.spread = spread;
	word_tiles.append(word_tile)
	$WordsHolder.add_child(word_tile);

func _handle_dropped_word_tile(word_tile: WordTile):
	print("DROPPED ", word_tile.word, " ", word_tile);
	var res:Array = does_tile_have_valid_or_invalid(word_tile);
	
	print(res);
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


func cleanup_abandoned_word_tiles():
	pass
