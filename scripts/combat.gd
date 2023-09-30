class_name Combat extends Node2D

var EnemyInfo = preload("res://scenes/enemyinfo.tscn");

# Called when the node enters the scene tree for the first time.
func _ready():
	var ei:EnemyInfo = EnemyInfo.instantiate();
	ei.position = Vector2(500, 130);
	ei.set_tactic(Global.get_random_tactic());
	add_child(ei);
