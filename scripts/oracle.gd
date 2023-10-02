extends Node2D

var prompt: String = "???";
signal leave_oracle_phase();

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label4.text = prompt;
	$Button.connect("on_pressed", self.end_scene);

func end_scene():
	emit_signal("leave_oracle_phase");

