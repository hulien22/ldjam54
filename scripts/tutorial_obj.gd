extends CanvasItem

@export var tut_name:String = "";

func _ready():
	if TutorialManager.add_tutorial(tut_name):
		show();
	else:
		hide();
