extends Node

#@export var words_file: Resource
var words_file: Resource = preload("res://text/words.json");

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var data

func _ready():
	var file = FileAccess.open(words_file.resource_path, FileAccess.READ)
	data = JSON.parse_string(file.get_as_text())
	load_debate_questions();
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


var debate_questions: Array;

func load_debate_questions():
	for d in data.debates:
		assert(d.size() >= 4)
		debate_questions.append(DebateQuestion.new(d[0], d[1], d[2], d[3], d[4], "HINT"));

func get_random_debate_question() -> DebateQuestion:
	return debate_questions[rng.randi() % debate_questions.size()];

