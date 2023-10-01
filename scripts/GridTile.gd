extends Node2D

var posn: Vector2 = Vector2.ZERO
var islocked = false
var unlockedMod = Color(1,1,1,1)
var lockedMod = Color(0.3,0.3,0.3,1)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func unlock():
	$GridImg.set_modulate(unlockedMod)
	islocked=false
	
func lock():
	$GridImg.set_modulate(lockedMod)
	islocked=true
	
func isLock():
	return islocked

func get_height():
	return $Rect.get_global_rect().size.y
	
func get_width():
	return $Rect.get_global_rect().size.x

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	pass
	#Events.emit_signal("move_player_click", posn)
