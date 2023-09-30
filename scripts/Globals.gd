extends Node
const ART_PATH = "res://art/"
enum {L, SQUARE, RECT}
const MEMORIES = {
	"general-knowledge":{
		"art": ART_PATH + "generalknowledge.png"
	},
	"expert-knowledge":{
		"art": ART_PATH + "generalknowledge.png"
	},
	"core-memory":{
		"art": ART_PATH + "corememory.png"
	},
	"trauma":{
		"art": ART_PATH + "trauma.png"
	},
	"tactic-1":{
		"art": ART_PATH + "tactic 1.png"
	},
	"tactic-2":{
		"art": ART_PATH + "tactic 2.png"
	}
}
func get_memory(memory_id):
	return MEMORIES[memory_id]
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


