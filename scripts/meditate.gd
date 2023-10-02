extends Node2D

signal leave_meditate_phase();

# Called when the node enters the scene tree for the first time.
func _ready():
	$Button.connect("on_pressed", self.end_scene);

func end_scene():
	emit_signal("leave_meditate_phase");

