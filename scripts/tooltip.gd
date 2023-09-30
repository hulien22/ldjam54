class_name Tooltip extends Node2D


var last_time_touching: float = 0;
var last_touch_object: Object = null;
var boundary_box = null
var padding:Vector2 = Vector2(2,2);

func _process(delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		visible = false;
	
	# check if mouse is colliding with collideable object.
	# if collides then wait min time while still touching same object to start showing
	if (boundary_box):
		var mouse_posn = get_global_mouse_position();
		var border = get_viewport_rect().size - padding
		var posnx = mouse_posn.x;
		var posny = mouse_posn.y;
		if (posnx + boundary_box.size.x > border.x):
			posnx -= boundary_box.size.x
		if (posny + boundary_box.size.y > border.y):
			posny -= boundary_box.size.y
		global_position = Vector2(posnx, posny);
	
	#testing
	last_time_touching += delta;
	if last_time_touching > 5:
		last_time_touching = 0;
		visible = true;
		set_tactic(Global.get_random_tactic());

func _ready():
	visible = false;

# TODO Timer for fade in

func set_tactic(tactic: Tactic):
	$TacticTooltip/Title.text = tactic.name_;
	$TacticTooltip/Desc.text = tactic.desc_;
	$TacticTooltip/Pros.text = tactic.pro_;
	$TacticTooltip/Cons.text = tactic.con_;
	$TacticTooltip.visible = true;
	boundary_box = $TacticTooltip/ColorRect.get_global_rect();
	# hide other tooltips
