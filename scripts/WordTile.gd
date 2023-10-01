extends Node2D

@export var word: String
@export var spread: float = 0
@export var tileScale: float=0.1
@export var tileScene: PackedScene

var tiles= []
var isSelected = false
var wasRightClicked = false
func _ready():
	
	for i in len(word):
		var char = word[i]
		var tile = tileScene.instantiate()
		tile.scale = Vector2(tileScale,tileScale)
		tile.letter = char
		tile.connect("select_drag",set_selected)
		tile.position = Vector2(i*tile.get_width()*tileScale+i*spread,0)
		tiles.append(tile)
		add_child(tile)
	

func set_selected(isSel):
	isSelected = isSel
	print("is selected",isSelected)
func _process(delta):
	if isSelected:
		global_position = lerp(global_position,get_global_mouse_position(),25*delta)
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
			wasRightClicked= true
		else:
			if wasRightClicked:
				#rotate
				rotation_degrees += 90
			wasRightClicked=false
