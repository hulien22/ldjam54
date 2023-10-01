extends Node2D

@export var word: String
@export var spread: float = 0
@export var tileScale: float=0.1
@export var tileScene: PackedScene

var tiles= []
# TODO refactor to a TileState
var isSelected: bool = false
var wasRightClicked: bool = false

var state_:Global.TileState = Global.TileState.DRAGGABLE;

func _ready():
	for i in len(word):
		var char = word[i]
		var tile = tileScene.instantiate()
		tile.scale = Vector2(tileScale,tileScale)
		tile.letter = char
		tile.connect("select_drag", set_selected);
		tile.connect("clicked", was_clicked);
		tile.position = Vector2(i*tile.get_width()*tileScale+i*spread,0)
		tiles.append(tile)
		add_child(tile)
	set_state(state_);

func set_selected(isSel : bool):
	isSelected = isSel
	print("is selected",isSelected)

func was_clicked(isSel: bool):
	if (isSel):
		set_state(Global.TileState.DISABLED);
	else:
		set_state(Global.TileState.CLICKABLE);
	# todo emit signals to combat scene about spawning in stuff

func set_state(s: Global.TileState):
	state_ = s;
	# also set for all tiles
	for tile in tiles:
		tile.set_state(s);

func _process(delta):
	if isSelected:
		global_position = lerp(global_position,get_global_mouse_position(),25*delta)
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
			wasRightClicked= true
		elif wasRightClicked:
			#rotate
			rotation_degrees += 90
			wasRightClicked=false
