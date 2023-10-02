extends CanvasItem

@export var tut_name:String = "";
@export var enabled:bool = true;

func _ready():
	if enabled && TutorialManager.add_tutorial(tut_name):
		show();
	else:
		hide();
