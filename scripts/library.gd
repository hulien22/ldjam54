extends Node2D

signal start_library_phase(global_posn:Vector2);
signal end_library_phase();

var title:String = "Fill your brain with knowledge!";

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = title;
	# hack to deal with current_node not being set yet..
	$Timer.timeout.connect(self.start_scene);
	$Timer.one_shot = true;
	$Timer.start(0.02);
	$Button.connect("on_pressed", self.end_scene);

func start_scene():
	emit_signal("start_library_phase", get_viewport_rect().size / 2);

func update_button(num_on_grid: int):
	if (num_on_grid >= 3):
		$Button.set_enabled(true);
	else:
		$Button.set_enabled(false);

func end_scene():
	emit_signal("end_library_phase");
