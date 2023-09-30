extends Node2D

var type
var shape
var center
var rotate

func init(newType,newShape, newCenter,newRotation):
	type=newType
	$TileImage.set_meta("id",type)
	$TileImage.texture =load(Globals.get_memory(type)["art"])
	center=newCenter
	shape=newShape
	rotate=newRotation
	
func set_rotate(newRotation):
	rotate=newRotation

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
