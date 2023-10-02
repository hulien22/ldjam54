extends Button

@export var parent: Node2D;
@export var grow_scale: float = 1.1;

# Called when the node enters the scene tree for the first time.
func _ready():
	mouse_entered.connect(self._on_enter);
	mouse_exited.connect(self._on_exit);
	assert(parent != null);

func _on_enter():
	parent.scale = Vector2.ONE * grow_scale;

func _on_exit():
	parent.scale = Vector2.ONE;
