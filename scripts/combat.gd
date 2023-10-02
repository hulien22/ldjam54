class_name Combat extends Node2D

enum COMBAT_PHASE {
	INTRO,
	PICK_SIDE,
	CONSTRUCT_ARGUMENT,
	JUDGING,
	RESULTS,
	REWARDS,
	RETRY,
}

var difficulty_: int = 0;
var combat_phase_: COMBAT_PHASE = COMBAT_PHASE.INTRO;
var debate_question_: DebateQuestion;
var description_: String = "You encounter a farmer who seems to be pondering something.";
var prompt_: String;
var result_scores: Array;

var is_boss: bool = false;

# this will compose the argument.
var word_tiles: Array = [];

signal start_combat_phase(global_posn:Vector2, debate_question: DebateQuestion, free_words_posn:Vector2);
signal end_combat_phase();
signal end_scene(final_score: float);
signal take_damage();

func init(topic: DebateQuestion, difficulty: int):
	difficulty_ = difficulty;
	combat_phase_ = COMBAT_PHASE.INTRO;
	debate_question_ = topic #Global.get_random_debate_question()
	description_ = get_random_desc_for_difficulty(difficulty_);

# Called when the node enters the scene tree for the first time.
func _ready():
	# TODO REMOVE
	#init(0);
	if is_boss:
		$ConstructArgBox/Tutorial2.enabled = true;
	assert(combat_phase_ == COMBAT_PHASE.INTRO);
	start_phase();

func start_phase():
	match combat_phase_:
		COMBAT_PHASE.INTRO:
			$IntroBox/Label.text = description_;
			$IntroBox/Button.connect("on_pressed", self._move_to_next_phase);
			$IntroBox.show();
		COMBAT_PHASE.PICK_SIDE:
			$IntroBox.hide();
			$PickSideBox/Label.text = "Pick a side: " + debate_question_.initial_prompt_;
			$PickSideBox/Button1.text = debate_question_.option1_;
			$PickSideBox/Button2.text = debate_question_.option2_;
			$PickSideBox/Button1.pressed.connect(Callable(self, "_select_prompt").bind(1));
			$PickSideBox/Button2.pressed.connect(Callable(self, "_select_prompt").bind(2));
			$PickSideBox.show();
		COMBAT_PHASE.CONSTRUCT_ARGUMENT:
			$PickSideBox.hide();
			$ConstructArgBox/Label.text = prompt_;
			#show brain with words
			var brain_posn = $ConstructArgBox.global_position + Vector2(965, 549);
			emit_signal("start_combat_phase", brain_posn, debate_question_, Vector2(1890, 330));
			#enable clicking words
#			$ConstructArgBox/Brain.set_click_only()
			word_tiles.clear();
			render_argument();
			if !$ConstructArgBox/Button.is_connected("on_pressed", self._submit_debate):
				$ConstructArgBox/Button.connect("on_pressed", self._submit_debate);
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
			$ResultsBox/Node2D/Score1.text = str(result_scores[0]);
			$ResultsBox/Node2D2/Score2.text = str(result_scores[1]);
			$ResultsBox/Node2D3/Score3.text = str(result_scores[2]);
			$ResultsBox/Node2D4/ScoreTotal.text = str(avg_score());
			if !$ResultsBox/Button.is_connected("on_pressed", self._after_results):
				$ResultsBox/Button.connect("on_pressed", self._after_results);
			
#			$ResultsBox/Button.set_enabled(false);
			$ResultsBox/AnimationPlayer.play("showresults");

			$ResultsBox.show();
		COMBAT_PHASE.RETRY:
			$ResultsBox.hide();
			if !$RetryBox/Button.is_connected("on_pressed", self._try_rephrase):
				$RetryBox/Button.connect("on_pressed", self._try_rephrase);
			$RetryBox.show();

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


func _after_results():
	if avg_score() < 5.0:
		AudioPlayer.play_fail()
	else:
		AudioPlayer.play_success()
		
	if is_boss && avg_score() < 5.0:
		# try again
		emit_signal("take_damage");
		combat_phase_ = COMBAT_PHASE.RETRY;
		start_phase();
	else:
		# really need this on a delay for game overs..
		if avg_score() < 5.0:
			emit_signal("take_damage");
		end_scene.emit(avg_score());

func _try_rephrase():
	combat_phase_ = COMBAT_PHASE.CONSTRUCT_ARGUMENT;
	start_phase();
	$RetryBox.hide();

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
	if s == "":
		$ConstructArgBox/Button.set_enabled(false);
	else:
		$ConstructArgBox/Button.set_enabled(true);

func avg_score() -> float:
	if result_scores.size() < 3:
		return 0.0;
	return snappedf((result_scores[0] + result_scores[1] + result_scores[2]) / 3.0, 0.01);


var rng = RandomNumberGenerator.new()
func get_random_desc_for_difficulty(difficulty : int):
	if is_boss:
		return ["You stumble into your old school teacher. \n\n\"I heard you're trying to become a philosopher?\" \n\n\"Show me what you have learned\"", 
				"You find yourself face to face with a pensive of philosophers. \n\nThey turn towards you while pensively stroking their beards. \n\n\"You've done well to make it this far.. \" \n\n\"But if you want to make it to Olympus, you'll have to make it through us first!\"", 
				"As you climb up the last steps of Olympus, you enter into a large temple. \n\nA massive form apparates in front of you. \n\n\"I am Zeus, King of Gods, ruler of Olympus.\"\n\n\"You have proven your worth, now it is time for your final test!\""][difficulty];
	var value = rng.randi_range(0, 2)
	match difficulty: #lol at this #j: I lol-ed
		0:
			return ["You encounter a farmer who seems to be pondering something.",
			"A soldier stops you to ask a question.",
			"You see a small child who seems curious."][value]
		1:
			return ["You encounter a ship captain who seems to be pondering something.",
			"A renowned philosopher wishes to discuss something with you.",
			"You are approached by a travelling merchant."][value]
		2:
			return ["You encounter a titan who seems to be pondering something.",
			"A demigod seems to be vying for your attention.",
			"You see an olympian seated in the thinker pose."][value]
