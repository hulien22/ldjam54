extends Node2D


@export var Tile: PackedScene


var memories=[]



func _ready():
	var coreMem = Tile.instantiate()
	coreMem.init("tactic-1",Global.L,Vector2(0,0),0)
	coreMem.set_global_position(Vector2(250,100))
	add_child(coreMem)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
