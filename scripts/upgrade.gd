class_name Upgrade extends Node2D

signal start_upgrade_phase(global_posn:Vector2);
signal end_upgrade_phase();

var num_upgrades_available:int = 3;

# Called when the node enters the scene tree for the first time.
func _ready():
	#can move to later if needed
	emit_signal("start_upgrade_phase", get_viewport_rect().size / 2);
	update_text()

func update_text():
	$Label2.text = "Unlocks remaining: " + str(num_upgrades_available);

func on_upgrade():
	num_upgrades_available -= 1;
	update_text()
	if num_upgrades_available <= 0:
		emit_signal("end_upgrade_phase");

	#TODO what if out of spots to upgrade?
