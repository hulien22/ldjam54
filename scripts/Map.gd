extends Node

@export var length: int
@export var width: int

@export var left_margin: int
@export var right_margin: int
@export var top_margin: int
@export var bottom_margin: int

@export var length_bias: float

var current_location: Location
var rng = RandomNumberGenerator.new()

const location_scene = preload("res://scenes/location.tscn")

func random_location() -> Location.LOCATION:
	var value = rng.randi_range(1, 100)
	if value <= 30:
		return Location.LOCATION.COMBAT
	elif value <= 40:
		return Location.LOCATION.LIBRARY
	elif value <= 50:
		return Location.LOCATION.RECRUIT
	elif value <= 70:
		return Location.LOCATION.RELAX
	elif value <= 80:
		return Location.LOCATION.THERAPY
	else:
		return Location.LOCATION.TRAINING

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
		var rand_width = rng.randi_range(1+floor(width*length_bias*(length-i)/length), width-floor(width*length_bias*i/length))
		var connect_offset = len(prev_layer)/float(rand_width)
		var width_ratio = ceil(connect_offset)
		var width_offset = center_height if rand_width == 1 else top_margin
		var is_active = i == length -1
		for j in rand_width:
			var connections: Array[Location] = []
			for k in width_ratio:
				connections.append(prev_layer[floor(j*connect_offset)+k])
			var node = location_scene.instantiate()
			node.init(random_location(),Vector2(length_offset, width_offset), is_active, connections)
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
	print(location.position)
