extends Node2D


@export var gridTileScene: PackedScene
@export var size: Vector2
@export var spread: float = 0
@export var tileScale: float=0.1
@export var canBuyTiles: bool= false
var grid = []

func _ready():
	
	print("test")
	for h in size.y:
		var str= ""
		grid.append([])
		for l in size.x:
			var gridTile = gridTileScene.instantiate()
			add_child(gridTile)
			gridTile.connect("select_tile_click", _on_tile_clicked)
			gridTile.posn = Vector2(l,h)
			gridTile.scale = Vector2(tileScale,tileScale)
			gridTile.position = Vector2(l*gridTile.get_width()+l*spread,h*gridTile.get_height()+h*spread)
			grid[h].append(gridTile)
		print(str)
			#var char = word[x][y]
			#var tile = tileScene.instantiate()
			#tile.scale = Vector2(tileScale,tileScale)
			#tile.letter = char
			#tile.position = Vector2(i*tile.get_width()*tileScale+i*spread,0)
			#tiles.append(tile)
			#add_child(tile)
			
func _process(delta):
	var cursorPos = get_global_mouse_position()
	mouse_to_grid(cursorPos)
	
	
func mouse_to_grid(pos):
	pass
	
func _on_tile_clicked(gridPosn:Vector2):
	print(gridPosn)
	if canBuyTiles:
		var clickedTile = grid[gridPosn.y][gridPosn.x]
		if clickedTile.isLocked():
			clickedTile.unlock()
		else:
			clickedTile.lock()
	
