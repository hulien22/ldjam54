class_name Library extends Node2D

signal start_library_phase(global_posn:Vector2);
signal end_library_phase();

enum LibraryType {
	REGULAR,
	FIRST_ROOM,
	UPGRADE,
};

var title:String = "Fill your brain with knowledge!";
var type: LibraryType = LibraryType.REGULAR;

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = title;
	$Button.connect("on_pressed", self.end_scene);
	$Button.set_enabled(false);#fix double noise
	emit_signal("start_library_phase", get_viewport_rect().size / 2);
	
	if type == LibraryType.FIRST_ROOM:
		#Show drag and drop and rotate help 
		$StartTutorial.show();
	else:
		$StartTutorial.hide();

func update_button(num_on_grid: int):
	if (num_on_grid >= 3):
		$Button.set_enabled(true);
	else:
		$Button.set_enabled(false);

func end_scene():
	emit_signal("end_library_phase");
