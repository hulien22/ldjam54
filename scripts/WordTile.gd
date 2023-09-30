extends Node2D

@export var word: String
@export var spread: float = 0
@export var tileScale: float=0.1
@export var tileScene: PackedScene

var tiles= []

# Called when the node enters the scene tree for the first time.
func _ready():
	#$word.add_text(word)
	#print($tile.
	#var width = $word.get_content_width()
	#var tile_amount = ceil(word.length()/width)
	
	for i in len(word):
		var char = word[i]
		var tile = tileScene.instantiate()
		tile.scale = Vector2(tileScale,tileScale)
		tile.letter = char
		tile.position = Vector2(i*tile.get_width()*tileScale+i*spread,0)
		tiles.append(tile)
		add_child(tile)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
