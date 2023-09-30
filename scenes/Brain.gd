extends Node2D


@export var Tile: PackedScene


var memories=[]
var memory_held=null
var memory_offset=Vector2()
var last_position = Vector2()

func _ready():
	var core_mem = Tile.instantiate()
	core_mem.init("tactic-2",Globals.L,Vector2(0,0),0)
	core_mem.set_global_position(Vector2(250,100))
	memories.append(core_mem)
	add_child(core_mem)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var cursor_pos = get_global_mouse_position()
	if Input.is_action_just_pressed("inv_grab"):
		grab(cursor_pos)
	if Input.is_action_just_released("inv_grab"):
		release(cursor_pos)
	if memory_held != null:
		memory_held.rect_global_position = cursor_pos + memory_offset

func grab(cursor_pos):
	memory_held = get_memory_under_pos(cursor_pos)
	if memory_held != null:
		# or last_position = cursor_pos
		last_position = memory_held.rect_global_position
		memory_offset = memory_held.rect_global_position - cursor_pos
		move_child(memory_held, get_child_count())
		
func get_memory_under_pos(pos):
	for memory in memories:
		if memory.get_global_rect().has_point(pos):
			return memory
	return null
	
func release(cursor_pos):
	if memory_held == null:
		return
	elif !insert_memory(memory_held):
		#return memory to last position
		memory_held.rect_global_position = last_position
		memory_held = null
	else:
		memory_held= null
		
func insert_memory(memory):
	pass
	
func add_memory():
	pass
