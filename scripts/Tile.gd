class_name Tile extends Node2D

@export var letter: String
signal select_drag(isSel: bool)
signal clicked(isSel: bool)

var state_:Global.TileState = Global.TileState.DRAGGABLE;

# Called when the node enters the scene tree for the first time.
func _ready():
	if letter.length() > 1:
		letter=letter[0]
	$Area2D/TileText.text = letter;
	$Area2D/AnimatedSprite2D.frame = Global.rng.randi_range(0, 4);

func set_first_letter():
	$Area2D/AnimatedSprite2D.scale.x = 1.078;
	$Area2D/AnimatedSprite2D.position.x = 33;

func set_first_and_last_letter():
	$Area2D/AnimatedSprite2D.scale.x = 1;
	$Area2D/AnimatedSprite2D.position.x = 5;

func set_last_letter():
	$Area2D/AnimatedSprite2D.scale.x = 1.03;
	$Area2D/AnimatedSprite2D.position.x = -11;

func get_width():
	return $Rect.get_global_rect().size.x

func get_height():
	return $Rect.get_global_rect().size.y

func set_state(s: Global.TileState):
	state_ = s;
	match state_:
		Global.TileState.DISABLED:
			$Area2D.modulate = Color.DIM_GRAY;
		_:
			$Area2D.modulate = Color.WHITE;

func _on_button_button_down():
	match state_:
		Global.TileState.DRAGGABLE:
			emit_signal("select_drag",true)
		Global.TileState.CLICKABLE:
			emit_signal("clicked", true);
		Global.TileState.DISABLED:
			emit_signal("clicked", false);


func _on_button_button_up():
	match state_:
		Global.TileState.DRAGGABLE:
			emit_signal("select_drag",false)

func _on_button_pressed():
#	match state_:
#		Global.TileState.CLICKABLE:
#			emit_signal("clicked", true);
#		Global.TileState.DISABLED:
#			emit_signal("clicked", false);
	pass
