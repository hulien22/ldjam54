class_name Combat extends Node2D

enum COMBAT_PHASE {
	INTRO,
	PICK_SIDE,
	CONSTRUCT_ARGUMENT,
	JUDGING,
	RESULTS,
	REWARDS,
}

var difficulty_: int = 0;
var combat_phase_: COMBAT_PHASE = COMBAT_PHASE.INTRO;
var debate_question_: DebateQuestion;
var description_: String = "You encounter a farmer who seems to be pondering something.";
var prompt_: String;
var result_scores: Array;

# this will compose the argument.
var word_tiles: Array = [];

signal start_combat_phase(global_posn:Vector2);
signal end_combat_phase();
signal end_scene()

func init(topic: DebateQuestion):
	#difficulty_ = difficulty;
	combat_phase_ = COMBAT_PHASE.INTRO;
	debate_question_ = topic #Global.get_random_debate_question()
#	description_ = get_random_desc_for_difficulty(difficulty_);

# Called when the node enters the scene tree for the first time.
func _ready():
	# TODO REMOVE
	#init(0);
	
	assert(combat_phase_ == COMBAT_PHASE.INTRO);
	start_phase();

func start_phase():
	match combat_phase_:
		COMBAT_PHASE.INTRO:
			$IntroBox/Label.text = description_;
			$IntroBox/Button.pressed.connect(self._move_to_next_phase);
			$IntroBox.show();
		COMBAT_PHASE.PICK_SIDE:
			$IntroBox.hide();
			$PickSideBox/Label.text = debate_question_.initial_prompt_;
			$PickSideBox/Button1.text = debate_question_.prompt1_;
			$PickSideBox/Button2.text = debate_question_.prompt2_;
			$PickSideBox/Button1.pressed.connect(Callable(self, "_select_prompt").bind(1));
			$PickSideBox/Button2.pressed.connect(Callable(self, "_select_prompt").bind(2));
			$PickSideBox.show();
		COMBAT_PHASE.CONSTRUCT_ARGUMENT:
			$PickSideBox.hide();
			$ConstructArgBox/Label.text = prompt_;
			#show brain with words
			var brain_posn = $ConstructArgBox.global_position + Vector2(965, 549);
			emit_signal("start_combat_phase", brain_posn);
			#enable clicking words
#			$ConstructArgBox/Brain.set_click_only()
			$ConstructArgBox/Button.pressed.connect(self._submit_debate);
			$ConstructArgBox.show();
		COMBAT_PHASE.JUDGING:
			$ConstructArgBox.hide();
			emit_signal("end_combat_phase");
			$JudgingBox/AnimationPlayer.play("wait_for_judging");
			$JudgingBox.show();
		COMBAT_PHASE.RESULTS:
			$JudgingBox.hide();
			$JudgingBox/AnimationPlayer.stop();
			# TODO animate fade/slide in one by one? and play sound
			$ResultsBox/Score1.text = str(result_scores[0]);
			$ResultsBox/Score2.text = str(result_scores[1]);
			$ResultsBox/Score3.text = str(result_scores[2]);
			$ResultsBox/ScoreTotal.text = str(avg_score());
			$ResultsBox/Button.pressed.connect(self._return_to_map);
			$ResultsBox.show();

func _move_to_next_phase():
	combat_phase_ += 1;
	start_phase();

func _select_prompt(i: int):
	if i == 1:
		prompt_ = debate_question_.prompt1_;
	else:
		prompt_ =  debate_question_.prompt2_;
	_move_to_next_phase();


func _submit_debate():
	if $ConstructArgBox/Label2.text == "":
		return; # need to submit something

	var json = JSON.stringify({
		"prompt": prompt_,
		"argument": $ConstructArgBox/Label2.text,
	});
	var headers = ["Content-Type: application/json"];
	$HTTPRequest.request_completed.connect(_on_request_completed);
	$HTTPRequest.request("https://us-central1-ldjam54.cloudfunctions.net/ldjam54", headers, HTTPClient.METHOD_POST, json);
	_move_to_next_phase();


func _on_request_completed(result, response_code, headers, body):
	if (result == HTTPRequest.Result.RESULT_SUCCESS):
		parse_results_from_response(body);
	else:
		push_error("Returned error!", result, response_code, body);
		generate_random_results();

	print(body.get_string_from_utf8())
	print(result_scores)

	_move_to_next_phase();

func generate_random_results():
	for i in 3:
		result_scores.append(Global.rng.randi() % 10 + 1);

func parse_results_from_response(body: PackedByteArray):
	# start by generating random results, will override with found values.
	generate_random_results()
	if body:
		var parsed_string = JSON.parse_string(body.get_string_from_utf8());
		if (parsed_string && typeof(parsed_string) == TYPE_ARRAY):
			for i in 3:
				if (parsed_string.size() >= i):
					# try to parse string.
					var s: String = parsed_string[i];
					s = s.lstrip("[");
					var splits: PackedStringArray = s.split(",", true, 1);
					if splits[0].is_valid_int():
						result_scores[i] = clamp(splits[0].to_int(), 1, 10);
					else:
						push_error("Error parsing string.", parsed_string);
		
		else:
			push_error("Error parsing string.", parsed_string);
	else:
		push_error("Got null body in response.");
#	push_error("DONE")
	
	# TODO special handling for "[5, The argument is unrelated to the prompt.]", "[5, The argument does not address the prompt.]"

func _return_to_map():
	end_scene.emit()

func add_word_tile(word_tile: WordTile, add: bool):
	if add:
		word_tiles.append(word_tile);
	else:
		word_tiles.erase(word_tile);
	render_argument();

func render_argument():
	var s: String = "";
	for word_tile in word_tiles:
		s += word_tile.word + " ";
	$ConstructArgBox/Label2.text = s;
	
func avg_score() -> float:
	if result_scores.size() < 3:
		return 0.0;
	return snappedf((result_scores[0] + result_scores[1] + result_scores[2]) / 3.0, 0.01);
	
