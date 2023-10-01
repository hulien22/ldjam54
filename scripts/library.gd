extends Node2D

signal start_library_phase(global_posn:Vector2);
signal end_library_phase();

# Called when the node enters the scene tree for the first time.
func _ready():
	#can move to later if needed
	emit_signal("start_library_phase", get_viewport_rect().size / 2);


