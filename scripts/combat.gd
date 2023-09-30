class_name Combat extends Node2D

var EnemyInfo = preload("res://scenes/enemyinfo.tscn");

var num_tactics_: int;
var enemy_infos_: Array;
const offsets: Array = [[0], [-100,100], [-200,0,200]]

func set_num_tactics(n:int):
	num_tactics_ = n;
	for i in n:
		enemy_infos_.append(EnemyInfo.instantiate());
		enemy_infos_.back().position = Vector2(500 + offsets[n-1][i], 130);
		enemy_infos_.back().set_tactic(Global.get_random_tactic());
		add_child(enemy_infos_.back());
	

# Called when the node enters the scene tree for the first time.
func _ready():
	set_num_tactics(3);
