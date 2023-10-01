extends Node2D

signal start_forge_phase();
signal end_forge_phase(global_posn:Vector2, word: String);

var can_type: bool = true;

# Called when the node enters the scene tree for the first time.
func _ready():
	$WordTile.set_word("");
	$DoneButton.pressed.connect(self.check_word);
	emit_signal("start_forge_phase");
	can_type = true;


# Called every frame. 'delta' is the elapsed time since the previous frame.
var word:String = "";
var keys:String = "abcdefghijklmnopqrstuvwxyz";
func _process(delta):
	if (can_type):
		for char in keys:
			if Input.is_action_just_pressed("key" + char):
				if word.length() < 16:
					word += char;
					$WordTile.set_word(word);
				else:
					print_debug("WORD IS TOO LONG");
		
		if Input.is_action_just_pressed("keybspace"):
			word = word.erase(word.length() - 1, 1);
			$WordTile.set_word(word);
		#TODO also move word tile to be centered

func check_word():
	if word.length() > 0:
		can_type = false;
		emit_signal("end_forge_phase", get_viewport_rect().size / 2, word);
		$WordTile.hide();
		$DoneButton.disabled = true;
		$DoneButton.hide();
