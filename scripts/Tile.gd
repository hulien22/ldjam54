extends Node2D

@export var letter: String
signal select_drag(isSel: bool)
# Called when the node enters the scene tree for the first time.
func _ready():
	if letter.length() > 1:
		letter=letter[0]
	$Area2D/TileText.add_text(letter) # Replace with function body.
func get_width():
	return $Rect.get_global_rect().size.x
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("inv_grab"):
		print("grab")
		emit_signal("select_drag",true)
	if Input.is_action_just_released("inv_grab"):
		print("release")
		emit_signal("select_drag",true)
