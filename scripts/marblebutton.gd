extends Node2D

signal on_pressed();

@export var tile_sprites:Array[Resource];
@export var scale_increase_on_hover:float = 1.1;
@export var text:String = "TEST";
@export var enabled:bool = true;

var mouse_on: bool = false;
var label_posn: Vector2;


func _ready():
	set_text(text);
	var res = tile_sprites[Global.rng.randi() % tile_sprites.size()];
	$Node2D/NinePatchRect2.texture = res;
	$Node2D/NinePatchRect3.texture = res;
	label_posn = $Node2D/Label.position;
	set_enabled(enabled);

func set_text(t:String):
	text = t;
	$Node2D/Label.text = text;

func set_enabled(e:bool):
	enabled = e;
	$Node2D/Button.disabled = !enabled;
	if enabled:
		$Node2D/NinePatchRect3.hide()
		$Node2D/NinePatchRect2.show()
		$Node2D/Label.position = label_posn;
		modulate = Color.WHITE;
	else:
		$Node2D/NinePatchRect2.hide()
		$Node2D/NinePatchRect3.show()
		$Node2D/Label.position = label_posn + $Node2D/NinePatchRect3.position - $Node2D/NinePatchRect2.position;
		modulate = Color.DIM_GRAY;

func _on_button_button_down():
	if enabled:
		$Node2D/NinePatchRect2.hide()
		$Node2D/NinePatchRect3.show()
		$Node2D/Label.position = label_posn + $Node2D/NinePatchRect3.position - $Node2D/NinePatchRect2.position;

func _on_button_button_up():
	if enabled:
		$Node2D/NinePatchRect3.hide()
		$Node2D/NinePatchRect2.show()
		$Node2D/Label.position = label_posn;
		if mouse_on:
			emit_signal("on_pressed");

func _on_button_mouse_entered():
	if enabled:
		$Node2D.scale = Vector2.ONE * scale_increase_on_hover
		mouse_on = true;

func _on_button_mouse_exited():
	$Node2D.scale = Vector2.ONE
	mouse_on = false;
	_on_button_button_up();

