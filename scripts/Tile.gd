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
func get_height():
	return $Rect.get_global_rect().size.y
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_button_button_down():
	emit_signal("select_drag",true)


func _on_button_button_up():
	emit_signal("select_drag",false)
