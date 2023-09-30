class_name EnemyInfo extends Node2D

var tactic_: Tactic;

#func _init():
#	$Hint1.text = "???";
#	$Hint2.text = "???";
#	$Hint3.text = "???";

func set_tactic(tactic:Tactic):
	tactic_ = tactic;
	# generate three random hints from the hints list
	var nums_chosen: Dictionary = {}
	for i in min(tactic_.hints_.size(), 3):
		while true:
			var n = Global.rng.randi_range(0, tactic_.hints_.size() - 1);
			if nums_chosen.has(n):
				continue;
			nums_chosen[n] = true;
			match i:
				0:
					$hint1.set_hint(tactic_.hints_[n]);
				1:
					$hint2.set_hint(tactic_.hints_[n]);
				2:
					$hint3.set_hint(tactic_.hints_[n]);
			break;
	
	if (tactic_.hints_.size() < 2):
		$hint2.visible = false;
		$hint3.visible = false;
	elif (tactic_.hints_.size() < 3):
		$hint3.visible = false;

