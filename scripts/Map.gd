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

func random_location() -> Location.LOCATION:
	var value = rng.randi_range(1, 100)
	if value <= 30:
		return Location.LOCATION.COMBAT
	elif value <= 40:
		return Location.LOCATION.ORACLE
	elif value <= 50:
		return Location.LOCATION.LIBRARY
	elif value <= 70:
		return Location.LOCATION.FORGE
	else:
		return Location.LOCATION.UPGRADE

func _ready():
	var total_length = get_viewport().get_visible_rect().size.x - right_margin - left_margin
	var length_offset = total_length + left_margin
	
	var total_width = get_viewport().get_visible_rect().size.y - top_margin - bottom_margin
	var center_height = total_width/2 + top_margin
	
	var boss = location_scene.instantiate()
	var empty: Array[Location]
	boss.init(Location.LOCATION.BOSS, Vector2(length_offset, center_height), false, empty)
	add_child(boss)
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
			var connections: Array[Location] = []
			for k in width_ratio:
				connections.append(prev_layer[floor(j*connect_offset)+k])
			var node = location_scene.instantiate()
			var total_radius = (float(width-rand_width+1)/width * total_width)/2 * jitter_width_bias
			node.init(random_location(), Vector2(length_offset + rng.randf_range(-jitter_length_radius, jitter_length_radius), width_offset + rng.randf_range(-total_radius, total_radius)), is_active, connections)
			add_child(node)
			node.moved_to_location.connect(_on_moved_to_location)
			width_offset += total_width/(rand_width-1)
			cur_layer.append(node)
		prev_layer = cur_layer
			
	var start = location_scene.instantiate()
	start.init(Location.LOCATION.START, Vector2(left_margin, center_height), false, prev_layer)
	add_child(start)
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
