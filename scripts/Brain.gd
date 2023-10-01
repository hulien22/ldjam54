extends Node2D


@export var gridTileScene: PackedScene
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
var wordtiles: Array = []


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
	render_grid()

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
	var grid_width = (max_col - min_col) * (grid[0][0].get_width() + spread);
	var grid_height = (max_row - min_row) * (grid[0][0].get_width() + spread);
	
	$GridHolder.position.x = -(max_col + min_col) * (grid[0][0].get_width() + spread) / 2.0;
	$GridHolder.position.y = -(max_row + min_row) * (grid[0][0].get_width() + spread) / 2.0;

	# TODO some calculation to resize the brain image to fit the grid
	# Use rect to get brain size approximation, fit the grid inside of that.
	# This value stays the same, even with node resizing.
	var bwidth = $BG/ColorRect.size.x
	var bheight = $BG/ColorRect.size.y
	
	print(grid_width, " ", grid_height, " ", bwidth, " ", bheight);
	# want the ratio of brain:grid to be 1.1:1
	$BG.scale.x = (target_brain_grid_ratio * grid_width) / bwidth;
	$BG.scale.y = (target_brain_grid_ratio * grid_height) / bheight;
	
	
	

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


func _process(delta):
	var cursorPos = get_global_mouse_position()
	mouse_to_grid(cursorPos)
	
	
func mouse_to_grid(pos):
	pass
	
func _on_tile_clicked(gridPosn:Vector2):
	assert(state_ == Global.BrainState.EXPANDING);
	print(gridPosn)
	if canBuyTiles:
		var clickedTile = grid[gridPosn.y][gridPosn.x]
		if clickedTile.isLocked():
			clickedTile.unlock()
			render_grid()
#		else:
#			clickedTile.lock()
	
