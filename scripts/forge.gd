extends Node2D

signal start_forge_phase();
signal end_forge_phase(global_posn:Vector2, word: String);
signal leave_forge_phase();

var can_type: bool = true;

# Called when the node enters the scene tree for the first time.
func _ready():
	$WordTile.set_word("");
	
	$Button.connect("on_pressed", self.check_word);
	emit_signal("start_forge_phase");
	can_type = true;
	$Button.set_enabled(false);


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
					if word.length() == 1:
						$Button.set_enabled(true);
				else:
					print_debug("WORD IS TOO LONG");
		
		if Input.is_action_just_pressed("keybspace"):
			word = word.erase(word.length() - 1, 1);
			$WordTile.set_word(word);
			if word.length() == 0:
				$Button.set_enabled(false);
		#TODO also move word tile to be centered

func check_word():
	if word.length() > 0:
		can_type = false;
		emit_signal("end_forge_phase", get_viewport_rect().size / 2, word);
		$WordTile.hide();
		$Button.set_text("CONTINUE");
		$Button.connect("on_pressed", self.end_scene);

func update_button(num_on_grid: int):
	if (num_on_grid >= 3):
		$Button.set_enabled(true);
	else:
		$Button.set_enabled(false);

func end_scene():
	emit_signal("leave_forge_phase");
