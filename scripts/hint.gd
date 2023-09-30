class_name Hint extends Node2D

var hint_text_:String;

func _ready():
	$Label.text = "???";
	$Button.pressed.connect(self.show_hint);

func set_hint(hint: String):
	hint_text_ = hint;

func show_hint():
	$Label.text = hint_text_;
	$Button.visible = false;
