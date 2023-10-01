extends Node

@export var words_file: Resource

var rng = RandomNumberGenerator.new()
var data

func _ready():
	var file = FileAccess.open(words_file.resource_path, FileAccess.READ)
	data = JSON.parse_string(file.get_as_text())
	print(data.words.positive)
	print(get_word())
	print(get_word())
	print(get_word())
	print(get_word())
	
func get_word() -> String:
	var value = rng.randi_range(1, 100)
	if value <= 50:
		return data.words.connecting[rng.randi_range(0, len(data.words.connecting)-1)]
	elif value <= 60:
		return data.words.positive[rng.randi_range(0, len(data.words.positive)-1)]
	elif value <= 70:
		return data.words.negative[rng.randi_range(0, len(data.words.negative)-1)]
	else:
		return data.words.person[rng.randi_range(0, len(data.words.person)-1)]
