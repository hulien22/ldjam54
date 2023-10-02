class_name Upgrade extends Node2D

signal start_upgrade_phase(global_posn:Vector2);
signal end_upgrade_phase();
signal leave_upgrade_phase();

var num_upgrades_available:int = 3;
var title:String = "Unlock your mind!";

# Called when the node enters the scene tree for the first time.
func _ready():
	#can move to later if needed
	emit_signal("start_upgrade_phase", get_viewport_rect().size / 2);
	$Label.text = title;
	update_text()
	$Button.connect("on_pressed", self.end_scene);

func end_scene():
	emit_signal("leave_upgrade_phase");

func update_text():
	$Label2.text = "Unlocks remaining: " + str(num_upgrades_available);

func on_upgrade():
	num_upgrades_available -= 1;
	update_text()
	if num_upgrades_available <= 0:
		emit_signal("end_upgrade_phase");
		$Button.set_text("CONTINUE");

func update_button(num_on_grid: int):
	if (num_on_grid >= 3):
		$Button.set_enabled(true);
	else:
		$Button.set_enabled(false);
