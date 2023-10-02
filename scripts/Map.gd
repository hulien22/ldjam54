extends Node

@export var length: int
@export var width: int
@export var min_width: int

@export var left_margin: int
@export var right_margin: int
@export var top_margin: int
@export var bottom_margin: int
@export var jitter_width_bias: float
@export var jitter_length_radius: float

@export var length_bias: float

signal moved_to_location(Location)

var current_location: Location
var rng = RandomNumberGenerator.new()

const location_scene = preload("res://scenes/location.tscn")

func random_location(connections: Array[Location]) -> Location.LOCATION:
	var value = rng.randi_range(1, 100)
	if value <= 30 and !connections.any(func(x): return x.location_type == Location.LOCATION.UPGRADE):
		return Location.LOCATION.UPGRADE
	elif value <= 30 and !connections.any(func(x): return x.location_type == Location.LOCATION.ORACLE):
		return Location.LOCATION.ORACLE
	elif value <= 50 and !connections.any(func(x): return x.location_type == Location.LOCATION.LIBRARY):
		return Location.LOCATION.LIBRARY
	elif value <= 70 and !connections.any(func(x): return x.location_type == Location.LOCATION.FORGE):
		return Location.LOCATION.FORGE
	else:
		return Location.LOCATION.COMBAT

func _ready():
	var total_length = get_viewport().get_visible_rect().size.x - right_margin - left_margin
	var length_offset = total_length + left_margin
	
	var total_width = get_viewport().get_visible_rect().size.y - top_margin - bottom_margin
	var center_height = total_width/2 + top_margin
	
	var boss = location_scene.instantiate()
	var empty: Array[Location]
	boss.init(Location.LOCATION.BOSS, Vector2(length_offset, center_height), false, empty)
	$MapHolder.add_child(boss)
	boss.moved_to_location.connect(_on_moved_to_location)
	
	var prev_layer: Array[Location] = [boss]
	for i in length:
		var cur_layer: Array[Location] = []
		length_offset -= total_length/(length+1)
		var rand_width = rng.randi_range(min_width+floor(width*length_bias*(length-i)/length), width-floor(width*length_bias*i/length))
		var connect_offset = len(prev_layer)/float(rand_width)
		var width_ratio = ceil(connect_offset)
		var width_offset = center_height if rand_width == 1 else top_margin
		var is_active = i == length -1
		for j in rand_width:
			var taken_types = {}
			var connections: Array[Location] = []
			for k in width_ratio:
				connections.append(prev_layer[floor(j*connect_offset)+k])
			var node = location_scene.instantiate()
			var total_radius = (float(width-rand_width+1)/width * total_width)/2 * jitter_width_bias
			node.init(random_location(connections), Vector2(length_offset + rng.randf_range(-jitter_length_radius, jitter_length_radius), width_offset + rng.randf_range(-total_radius, total_radius)), is_active, connections)
			$MapHolder.add_child(node)
			node.moved_to_location.connect(_on_moved_to_location)
			width_offset += total_width/(rand_width-1)
			cur_layer.append(node)
		prev_layer = cur_layer
			
	var start = location_scene.instantiate()
	start.init(Location.LOCATION.START, Vector2(left_margin, center_height), false, prev_layer)
	$MapHolder.add_child(start)
	start.moved_to_location.connect(_on_moved_to_location)
	
	current_location = start
	$PlayerMapMarker.position = start.position

func _on_moved_to_location(location: Location):
	for connection in current_location.connections:
		connection.activate(false)
	current_location = location
	$PlayerMapMarker.position = location.position
	moved_to_location.emit(location)
	print(location.position)

func set_enabled(enabled: bool = true):
	for connection in current_location.connections:
		connection.activate(enabled)

