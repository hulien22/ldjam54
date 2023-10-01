class_name DebateQuestion extends Node

var initial_prompt_: String;
var option1_: String;
var option2_: String;
var prompt1_: String;
var prompt2_: String;
var hint_: String;

func _init(initial_prompt: String, option1: String, option2: String, prompt1: String, prompt2: String, hint: String):
	initial_prompt_ = initial_prompt;
	option1_ = option1;
	option2_ = option2;
	prompt1_ = prompt1;
	prompt2_ = prompt2;
	hint_ = hint;
