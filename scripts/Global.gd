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
	if value <= 40:
		return data.words.connecting[rng.randi_range(0, len(data.words.connecting)-1)]
	elif value <= 70:
		return data.words.topics[rng.randi_range(0, len(data.words.topics)-1)]
	elif value <= 80:
		return data.words.positive[rng.randi_range(0, len(data.words.positive)-1)]
	elif value <= 90:
		return data.words.negative[rng.randi_range(0, len(data.words.negative)-1)]
	else:
		return data.words.person[rng.randi_range(0, len(data.words.person)-1)]


var debate_questions: Array[Array];

func load_debate_questions():
	for s in 3:
		debate_questions.append([])
		for d in data.debates[s]:
			assert(d.size() >= 5)
			debate_questions[s].append(DebateQuestion.new(d[0], d[1], d[2], d[3], d[4], d[5], d[6]));

func get_random_debate_question(difficulty) -> DebateQuestion:
	return debate_questions[difficulty][rng.randi() % debate_questions[difficulty].size()];

enum TileState {
	DRAGGABLE,
	BEING_DRAGGED,
	CLICKABLE,
	DISABLED,
	VIEW_ONLY,
};

enum BrainState {
	ADDING_NEW_WORDS,
	EXPANDING,
	VIEW_ONLY,
	COMBAT,
};

