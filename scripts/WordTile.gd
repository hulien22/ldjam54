class_name WordTile extends Node2D

enum Direction {
	RIGHT, DOWN
}

@export var word: String
@export var spread: float = 0
@export var tileScale: float=0.1
@export var tileScene: PackedScene

signal was_picked_up(word_tile: WordTile);
signal was_dropped(word_tile: WordTile);
signal was_clicked(word_tile: WordTile, selected:bool);


var tiles= []

var direction: Direction = Direction.RIGHT;

# TODO refactor to a TileState
var isSelected: bool = false
var wasRightClicked: bool = false

# global position and rotation of where we were picked up from, return here in case drop is invalid
var picked_up_posn: Vector2;
var picked_up_rotation: float;

const NOT_ON_GRID: Vector2 = Vector2(-1,-1);
var grid_posn: Vector2 = NOT_ON_GRID;

var state_:Global.TileState = Global.TileState.DRAGGABLE;

func _ready():
	set_word(word);
	set_state(state_);

func set_word(w: String):
	#erase all previous letters first
	#loop backwards to deal with deletion issues
	for i in tiles.size() :
		tiles[i].queue_free();
	tiles.clear();

	word = w;
	for i in len(word):
		var char = word[i]
		var tile = tileScene.instantiate()
		if (len(word) == 1):
			tile.set_first_and_last_letter();
		elif (i == 0):
			tile.set_first_letter();
		elif (i == len(word) - 1):
			tile.set_last_letter();
		tile.scale = Vector2(tileScale,tileScale)
		tile.letter = char
		tile.connect("select_drag", set_selected);
		tile.connect("clicked", set_clicked);
		tile.position = Vector2(i*tile.get_width()*tileScale+i*spread,0);
		tile.set_state(state_);
		tiles.append(tile);
		add_child(tile);
	
	var rand_grey = Global.rng.randi_range(200,255);
	modulate = Color8(rand_grey, rand_grey, rand_grey);
#	modulate = Color(word.hash() | 0x000000ff);


func on_grid():
	return grid_posn != NOT_ON_GRID;

func set_selected(isSel : bool):
	isSelected = isSel
	if isSel:
		picked_up_posn = global_position;
		picked_up_rotation = rotation;
		emit_signal("was_picked_up", self);
	else:
		emit_signal("was_dropped", self);
		
	print("is selected",isSelected)

func return_to_prev_loc():
	global_position = picked_up_posn;
	rotation = picked_up_rotation;
	if (rotation == 0):
		direction = Direction.RIGHT;
	else:
		direction = Direction.DOWN;

func set_clicked(isSel: bool):
	print("CLICKED ", word, " ", isSel);
	if (isSel):
		set_state(Global.TileState.DISABLED);
	else:
		set_state(Global.TileState.CLICKABLE);
	# todo emit signals to combat scene about spawning in stuff
	emit_signal("was_clicked", self, isSel);

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
			if direction == Direction.RIGHT:
				rotation_degrees = 90;
				direction = Direction.DOWN;
			else:
				rotation_degrees = 0;
				direction = Direction.RIGHT;
				
			wasRightClicked=false
