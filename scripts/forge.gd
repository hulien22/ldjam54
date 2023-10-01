extends Node2D

signal start_forge_phase(global_posn:Vector2);
signal end_forge_phase();

# Called when the node enters the scene tree for the first time.
func _ready():
	$WordTile.set_word("");
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
var word:String = "";
var keys:String = "abcdefghijklmnopqrstuvwxyz";
func _process(delta):
	for char in keys:
		if Input.is_action_just_pressed("key" + char):
			word += char;
			$WordTile.set_word(word);
	
	if Input.is_action_just_pressed("keybspace"):
		word = word.erase(word.length() - 1, 1);
		$WordTile.set_word(word);
		
