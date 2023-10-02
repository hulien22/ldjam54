extends Node2D

var posn: Vector2 = Vector2.ZERO
var islocked = true
var unlockedMod = Color.hex(0xf9ff57ff); #Color(1,1,1,1)
var lockedMod = Color.hex(0xff003bff); #Color(0.3,0.3,0.3,1)
signal select_tile_click(posn: Vector2)

# Called when the node enters the scene tree for the first time.
func _ready():
	if islocked:
		lock();
	else:
		unlock();

func unlock():
	$GridImg.set_modulate(unlockedMod)
	$Button.disabled = true;
	islocked=false

func lock():
	$GridImg.set_modulate(lockedMod)
	islocked=true
	
func isLocked():
	return islocked

func get_height():
	return $Rect.get_global_rect().size.y
	
func get_width():
	return $Rect.get_global_rect().size.x


func _on_button_pressed():
	emit_signal("select_tile_click", posn)
	$Plus.hide();


func _on_button_mouse_entered():
	if isLocked():
		$Plus.show();
	else:
		$Plus.hide();

func _on_button_mouse_exited():
	$Plus.hide();
