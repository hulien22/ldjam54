extends Node2D


@export var gridTileScene: PackedScene
@export var size: Vector2
@export var spread: float = 0
@export var tileScale: float=0.1
signal move_player_click(posn: Vector2)
var grid = []

func _ready():
	#move_player_click.connect("move_player_click", _on_tile_clicked)
	print("test")
	for h in size.y:
		var str= ""
		grid[h]=[]
		for l in size.x:
			var gridTile = gridTileScene.instantiate()
			add_child(gridTile)
			gridTile.posn = Vector2(h,l)
			gridTile.scale = Vector2(tileScale,tileScale)
			gridTile.position = Vector2(h*gridTile.get_height()*tileScale+h*spread,
											l*gridTile.get_width()*tileScale+l*spread)
			grid[h][l]=gridTile
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
	
func _on_tile_clicked(posn: Vector2):
	pass
	
